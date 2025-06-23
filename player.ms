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
 
	newPlayer = {}
  newPlayer.top = new Animated
  newPlayer.catcher = new Animated
	newPlayer.id = id
  newPlayer.worldPos = {"x": 0, "y": 0, "z": 1}
  newPlayer.battingStance = playerData.battingStance
  newPlayer.strikezoneWidth = playerData.strikeZone.width
  newPlayer.strikezoneHeight = playerData.strikeZone.height

  // add top animations
  icon = file.loadImage(playerData.icon)

  // add catcher POV animation
  // expand this to a general func later then imperatively call
  // to work with other angles
  for animKey in playerData.animKeys
    frameListRaw = playerData.frameLists[animKey]
    animStack = []
    for fileName in frameListRaw
      filePath = sprDir + fileName
      animStack.push(file.loadImage(filePath))
    end for

    newPlayer.top[animKey] = newAnimation([icon])
    newPlayer.catcher[animKey] = newAnimation(animStack)
  end for

  self.players[id] = newPlayer
end function

// Animation Methods
roster.animate = function(id, pov, animKey, loop = false)
  spr = self.players[id][pov]
  spr[animKey].loop = loop
  spr.curAnim = spr[animKey]
end function

roster.getWorldPos = function(id)
  target = self.players[id]
  return target.worldPos
end function

// Position Methods -- only mutate worldPos, renderer takes care of translation
roster.setPosition = function(id, wp, offsetX = 0, offsetY = 0, offsetZ = 0)
  isInvalid = wp.x == null or wp.y == null or wp.z == null
  if isInvalid then
    pprint "Invalid position passed to setPoisition for PlayerID: " + id
    exit
  end if
  target = self.players[id]
  newWorldPos = wp + {}
  newWorldPos.x += offsetX
  newWorldPos.y += offsetY
  newWorldPos.z += offsetZ

  target.worldPos = newWorldPos
end function

roster.update = function(id, dt)
  // add other angles here later
  self.players[id]["top"].update dt
  self.players[id]["catcher"].update dt
end function

roster.place = function(id, pov)
  worldPos = self.players[id].worldPos
  spr = self.players[id][pov]
  if pov == "top" then
    spr.x = worldPos.x
    spr.y = worldPos.y
    spr.scale = worldPos.z
  else if pov == "catcher" then
    spr.x = (worldPos.x * 8) - 3360
    spr.y =  ((worldPos.y - worldPos.z) * 1.8) + 175
    spr.scale = (1 / worldPos.y) * 300
    
  end if
end function

roster.display = function(id, pov, disp)
  spr = self.players[id][pov]
  disp.sprites.push spr
end function
