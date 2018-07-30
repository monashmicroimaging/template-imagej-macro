https://imagej.net/Script_Parameters

#@ Integer(label="An integer!", value=15) someInt
#@ String(label="Please enter your name", description="Your name") name
#@ String(label="What mythical monster would you like to unleash?",choices={"Kraken","Cyclops","Medusa","Fluffy bunny"}) monsterChoice
#@ File(label="Select a file") myFile
#@ File(label="Select a directory", style="directory") myFolder
#@File[] listOfPaths(label="select files or folders", style="both")

