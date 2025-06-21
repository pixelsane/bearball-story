import "json"
import "listUtil"
import "spriteControllers"
import "bg"

newAnimation = @spriteControllers.newAnimation
Animated = @spriteControllers.Animated

dataDir = "./data/"
assetsDir = "./assets/"
ext = ".json"

frameListKeys = ["idle", "pitch", "swing"]
roster = {"players" : {}}

parsePlayerData = function(dataName)
	filename = dataDir + dataName + ext
	jsonFile = file.open(filename)
	parsed = json.parse(jsonFile.read)
	jsonFile.close
  return parsed
end function

//Extern
roster.getPlayerById = function(id)
	return self.players[id]
end function

roster.loadPlayerData = function(id, name)
	if id == null or name == null then
		pprint "loadPlayerData call has incomplete parameters"
		exit
	end if
	
  playerData = parsePlayerData(name)
  sprDir = playerData.spriteDirectory
  
	newPlayer = new Animated
	newPlayer.id = id
  newPlayer.battingStance = playerData.battingStance
  newPlayer.strikezoneWidth = playerData.strikeZone.width
  newPlayer.strikezoneHeight = playerData.strikeZone.height
  for animKey in playerData.animKeys
    frameListRaw = playerData.frameLists[animKey]
    animStack = []
    for fileName in frameListRaw
      filePath = sprDir + fileName
      animStack.push(file.loadImage(filePath))
    end for

    newPlayer[animKey] = newAnimation(animStack)
  end for

  self.players[id] = newPlayer
end function

// Animation Methods
roster.animate = function(id, animKey, loop = false)
  spr = self.players[id]
  spr[animKey].loop = loop
  spr.curAnim = spr[animKey]
end function


// Position Methods

roster.toMound = function(id)
  spr = self.players[id]
	spr.x = MOUND_X
	spr.y = MOUND_Y
	spr.scale = MOUND_SCALE
end function

roster.toSecond = function(id)
  spr = self.players[id]
	spr.x = SECONDBASE_X
	spr.y = SECONDBASE_Y
	spr.scale = INFIELD_SCALE
end function

roster.toBat = function(id)
  spr = self.players[id]
  spr.x = PLATE_X
  spr.y = PLATE_Y
  spr.scale = BATTER_SCALE
end function

roster.toDisp = function(id, disp)
  spr = self.players[id]
  disp.sprites.push spr
end function
