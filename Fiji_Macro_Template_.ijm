/*
 * Macro template script
 * 
 * See acknowledging Monash Micro Imaging in your research:
 * https://platforms.monash.edu/mmi/index.php?option=com_content&view=article&id=124&Itemid=244
 * 
 * To run this macro:
 * 1. Open Fiji's script editor (File > New > Script; or use the keyboard shortcut "[")
 * 2. Open the macro file (can also drag and drop .ijm files to open in Fiji)
 * 3. Click the "Run" button from the script editor, or use the keyboard shortcut Control+R
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix
#@ String(label = "Nuclei channel", choices={"1	", "2	", "3	"}, value="2	", style="radioButtonHorizontal") nucleiChannel

//setBatchMode(true);
run("Bio-Formats Macro Extensions");
timestamp = createTimeStamp();	
processFolder(input);
print("Finished processing all files.")


// ADD YOUR CODE TO THIS FUNCTION
function processImage(id) {
	selectImage(id);
	imageTitle = getTitle();
	// Do your image analysis
	// YOUR CODE HERE
	// Save outputs / processed images
	// YOUR CODE HERE
	cleanup();
}

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

// function to process each image series in the file
function processFile(input, output, file) {
	filename = input + File.separator + file;
	print("Processing: " + filename);
	Ext.setId(filename);
	Ext.getSeriesCount(seriesCount);
	for (i = 1; i <= seriesCount; i++) {
		print("Reading in image series " + d2s(i, 0) + " with BioFormats...");
		imageSeries = "series_" + toString(i);
		run("Bio-Formats Importer",
			"open=[" + filename + "] " +
			"color_mode=Default " +
			"rois_import=[ROI manager] " +
			"view=Hyperstack " +
			"stack_order=XYCZT " +
			"use_virtual_stack " +
			imageSeries);
		id = getImageID();
		processImage(id);
		run("Collect Garbage");
	}
}

function beginLogFile(output) {
	print("\\Clear");
	timestamp = createTimeStamp();
	print("Timestamp: " + timestamp);
	print("Processing all " + suffix + " files found in location: " + input);
	print("Output file location: " + output);
	saveAs("Text", output + File.separator + "Log_" + timestamp + ".txt");
	return timestamp;
}

function cleanup() {
	selectWindow("Log"); // Save logfile
	save(output + File.separator + "Log_" + timestamp + ".txt");
	close("*"); // Close all image windows
	run("Collect Garbage");
}

function createTimeStamp() {
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	date = "" + dayOfMonth + "-" + month + "-" + year;
	time = "" + hour + "h" + minute + "m" + second + "sec";
	timestamp = date + "_" + time;
	return timestamp;
}

function stripWhitespace(str) {
	str = replace(str, "\\t", ""); // strip tabs
	str = replace(str, " ", ""); // strip spaces
	return str;
}

// Close all image AND non-image windows (except Log window)
function closeAll() {
	close("*");
	list = getList("window.titles"); 
	for (i=0; i<list.length; i++) {
		winame = list[i];
		if (winame != "Log") {
			selectWindow(winame); 
			run("Close"); 
		}
	}
}

function saveAllOpenImages(output) {
	while (nImages>0) { 
		selectImage(nImages); 
		print("Saving: " + output + File.separator + getTitle() + ".tif");
		save(output + File.separator + getTitle() + ".tif");
		//close(); //optional close image
	}
}
