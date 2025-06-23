import "json"
// DO NOT MODIFY
// Shove to its own json data
globals.SCREEN_W = 960
globals.SCREEN_H = 640
globals.MID_X = SCREEN_W / 2
globals.MID_Y = SCREEN_H / 2
globals.BP_DIR = "./assets/ballparks/"


// Globals
ballpark = {"pool": {}}

ballpark.load = function(id = 0, name)
  dataFile = file.open("./data/"+name+".json")
  ballparkData = json.parse(dataFile.read)
  dataFile.close

	newBallpark = {}
  topImage = file.loadImage(ballparkData.top.imageFile)
  catcherImage = file.loadImage(ballparkData.catcher.imageFile)
  positions = {
    "mound": ballparkData.mound,
    "home": ballparkData.home,
    "batterLeft": ballparkData.batterLeft,
    "batterRight": ballparkData.batterRight,
    "firstBase": ballparkData.firstBase,
    "secondBase": ballparkData.secondBase,
    "thirdBase": ballparkData.thirdBase,
    "leftField": ballparkData.leftField,
    "centerField": ballparkData.centerField,
    "rightField": ballparkData.rightField}
  backgrounds = {"top": topImage, "catcher": catcherImage}
	newBallpark.name = name
	newBallpark.id = self.pool.len
  newBallpark.backgrounds = backgrounds
  newBallpark.positions = positions
	self.pool[id] = newBallpark
end function

// Position Methods -- All methods return worldPos
ballpark.getPositions = function(id)
	return self.pool[id].positions
end function

ballpark.getPosition = function(id, posName)
  allPositions = self.getPositions(id)
  return allPositions[posName]
end function

ballpark.display = function(id, bgName, disp)
	selected = self.pool[id]
	disp.drawImage  selected.backgrounds[bgName]
end function
