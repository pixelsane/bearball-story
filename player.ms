import "json"
import "listUtil"
import "spriteControllers"

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
