import "player"
import "bg"

clear
display(7).mode = displayMode.sprite
display(6).mode = displayMode.pixel
display(4).mode = displayMode.sprite

display(7).clear
display(6).clear
display(5).clear
display(4).clear

// Globals
sim = simulationFP
pr = new player.roster
ballpark = new bg.ballpark
spriteDisplay = display(4)
batCursor = {"active": false, "batterID": null, "spr": new Sprite, "swinging": false, "minX": null, "minY": null, "maxX": null, "maxY": null}

batCursor.enable = function(side, disp)
	self.spr.image = file.loadImage("./assets/batCursor/" + side + ".png")
	self.spr.scale = 2
	disp.sprites.push self.spr
end function

batCursor.checkBounds = function
	insideX = mouse.x >= self.minX and mouse.x <= self.maxX
	insideY = mouse.y >= self.minY and mouse.y <= self.maxY
	inside = insideX and insideY
	
	if inside then
		self.active = true
	else
		self.active = false	
	end if
end function

batCursor.mouseToBatCursor = function
	self.spr.x = mouse.x
	self.spr.y = mouse.y
end function

batCursor.swingEvent = function
	if mouse.button(0) and not(self.swinging) then
		self.swinging = true
		pr.animate self.batterID, "swing"
	end if
end function

batCursor.update = function(dt)
	self.checkBounds
	if not self.active then
		self.spr.x = -200
		self.spr.y = -200
		mouse.visible = true
		return
	end if
	
	mouse.visible = false
	self.mouseToBatCursor
	self.swingEvent
end function

displayStrikeZone = function(w, h, disp, x = 480, y = 210)	
	opacityValue = 190
	originX = x - w / 2
	originY = y - h / 2
	fullWidth = originX + w
	fullHeight = originY + h
	
	horizontalImg = file.loadImage("./assets/strikezone/bottomCorner,png")
	
	batCursor.minX = originX
	batCursor.maxX = fullWidth
	
	batCursor.minY = originY
	batCursor.maxY = fullHeight
	
	topCornerLeft = new Sprite
	topCornerLeft.image = file.loadImage("./assets/strikezone/topCorner.png")
	topCornerLeft.x = originX
	topCornerLeft.y = fullHeight
	topCornerLeft.tint = color.rgba(255,255, 255, opacityValue)
	topCornerLeft.scale = 2
	
	topCornerRight = new Sprite
	topCornerRight.image = file.loadImage("./assets/strikezone/topCorner.png")
	topCornerRight.x = fullWidth
	topCornerRight.y = fullHeight
	topCornerRight.tint = color.rgba(255,255, 255, opacityValue)
	topCornerRight.scale = [-2, 2]
	
	bottomCornerLeft = new Sprite
	bottomCornerLeft.image = file.loadImage("./assets/strikezone/bottomCorner.png")
	bottomCornerLeft.x = originX
	bottomCornerLeft.y = originY
	bottomCornerLeft.tint = color.rgba(255,255, 255, opacityValue)
	bottomCornerLeft.scale = 2
	
	bottomCornerRight = new Sprite
	bottomCornerRight.image = file.loadImage("./assets/strikezone/bottomCorner.png")
	bottomCornerRight.x = fullWidth
	bottomCornerRight.y = originY
	bottomCornerRight.tint = color.rgba(255,255, 255, opacityValue)
	bottomCornerRight.scale = [-2, 2]
	
	display(6).fillRect(originX, originY, w, h, color.rgba(255,255,255, 75))	
	
	disp.sprites.push topCornerLeft
	disp.sprites.push topCornerRight
	disp.sprites.push bottomCornerLeft
	disp.sprites.push bottomCornerRight
end function

displayStrikeZoneOf = function(id, disp)
	targetPlayer = pr.getPlayerById(id)
	displayStrikeZone(targetPlayer.strikezoneWidth, targetPlayer.strikezoneHeight, disp)
end function

// preload
ballpark.load(0, "bearstadium")
pr.loadPlayerData(0, "bear")
pr.loadPlayerData(1, "bear")
pr.loadPlayerData(2, "panda")

// init
ballpark.display 0, display(7)
pr.animate 0, "idle", true
pr.animate 1, "idle", true
pr.animate 2, "idlebat", true

pr.toMound 0
pr.toSecond 1
pr.toBat 2

pr.toDisp 0, spriteDisplay
pr.toDisp 1, spriteDisplay
pr.toDisp 2, spriteDisplay  

batCursor.batterID = 2
batCursor.enable "righty", spriteDisplay

displayStrikeZoneOf 2, spriteDisplay

plateY = 18.44
pitchTime = 0.0
lastTime = time

while not key.pressed("escape")
	dt = time - lastTime
	lastTime = time
	batCursor.update dt
	pr.getPlayerById(0).update dt
	pr.getPlayerById(1).update dt
	pr.getPlayerById(2).update dt
	yield
end while