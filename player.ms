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
roster.animate = function(id, animKey)
  spr = self.players[id]
  spr.curAnim = spr[animKey]
end function


// Position Methods

roster.toMound = function(id)
  spr = self.players[id]
	spr.x = bg.MOUND_X
	spr.y = bg.MOUND_Y
	spr.scale = bg.MOUND_SCALE
end function

roster.toSecond = function(id)
  spr = self.players[id]
	spr.x = bg.SECONDBASE_X
	spr.y = bg.SECONDBASE_Y
	spr.scale = bg.INFIELD_SCALE
end function

roster.toBat = function(id)
  spr = self.players[id]
  spr.x = bg.PLATE_X
  spr.y = bg.PLATE_Y
  spr.scale = bg.BATTER_SCALE
end function

roster.toDisp = function(id, disp)
  spr = self.players[id]
  disp.sprites.push spr
end function
