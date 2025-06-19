import "json"
import "listUtil"
import "spriteControllers"

newAnimation = @spriteControllers.newAnimation

dataDir = "./data/"
assetsDir = "./assets/"
ext = ".json"

frameListKeys = ["idle", "pitch", "swing"]
playerProps = { "id": null, "sprite": null, "frameLists": {}, "anims": {}}
roster = new {"players" : {}}

parsePlayerData = function(dataName)
	filename = dataDir + dataName + ext
	jsonFile = file.open(filename)
	parsed = json.parse(jsonFile.read)
	jsonFile.close
  return parsed
end function

loadFrameListImages = function(playerData)
	sprDir = playerData.spriteDirectory
	for fl in playerData.frameLists
		key = fl.key
		images = []
		for filename in fl.value
			image = file.loadImage(sprDir + filename)
			images.push image
		end for
		playerData.frameLists[key] = images
	end for
end function

getFrameLists = function(playerData)
	loadFrameListImages(playerData)
	return playerData.frameLists
end function

generateAnimations = function(playerEntity)
	for frameList in playerEntity.frameLists
		key = frameList.key
		value = frameList.value
		playerEntity.anims[key] = newAnimation(value)
	end for
end function

//Extern
roster.getPlayerById = function(id)
	return self.players[id]
end function

roster.loadPlayerData = function(id = null, name = null)
	if id == null or name == null then
		pprint "loadPlayerData call has incomplete parameters"
		exit
	end if
	
  playerData = parsePlayerData(name)
	newPlayer = new playerProps
	newPlayer.id = id
  newPlayer.strikezoneWidth = playerData.strikeZone.width
  newPlayer.strikezoneHeight = playerData.strikeZone.height
	newPlayer.sprite = new spriteControllers.Animated
	newPlayer.frameLists = getFrameLists(playerData)
	generateAnimations(newPlayer)
	
	self.players[id] = newPlayer
end function
