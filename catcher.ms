ballSprite = new Sprite
strikeMarker = new Sprite

ballSprite.x = -800
ballSprite.y = -800
ballSprite.scale = 1

strikeMarker.x = -800
strikeMarker.y = -800
strikeMarker.scale = 1

catcherPOV = function(worldPos)
	distance = worldPos.y + 1
	perspective = 1.0 / distance
	
	catcherX = worldPos.x
	catcherY = worldPos.z
	catcherZ = perspective
	
	return {"x": catcherX, "y": catcherY, "z": catcherZ}
end function

// refactor to its own class later -- just a proof of concept
pitchRecorded = false
pitchRecord = {}

// get from world not here coords
showPitchLanding = function
	pitch = pitchRecord
	strikeMarker.x = pitchRecord.x
	strikeMarker.y = pitchRecord.y
	strikeMarker.scale = 1.5
	strikeMarker.tint = color.rgba(255,255,255,255)
end function

moveBallSprite = function(movement)
	if ballSprite.scale >= 2 or ballSprite.scale <= 0 then
		ballSprite.x = -1000
		ballSprite.y = -1000
		ballSprite.scale = -1
		showPitchLanding
		return
	end if
	
	if ball.position.y <= -0.5 and not(pitchRecorded) then
		pitchRecord.x = ballSprite.x
		pitchRecord.y = ballSprite.y
		pitchRecord.scale = ballSprite.scale
		pitchRecorded = true
	end if
	
	cpov = catcherPOV(movement)
	
	ballSprite.x += cpov.x
	ballSprite.y += cpov.y
	ballSprite.scale = cpov.z
end function

ballSprite.image = file.loadImage("./assets/ball/baseball.png")
strikeMarker.image = file.loadImage("./assets/ball/strikeMarker.png")

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

// get actual pos and w,h from worldCoord then translate px
displayStrikeZone = function(w, h, disp, x = 480, y = 210)	
	opacityValue = 190
	originX = x - w / 2
	originY = y - h / 2
	fullWidth = originX + w
	fullHeight = originY + h
	
	horizontalImg = file.loadImage("./assets/strikezone/bottomCorner.png")
	
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


// init
ballpark.display 0, display(7)
pr.animate 0, "idle"
pr.animate 1, "idle", true
pr.animate 2, "idlebat", true

// rewrite to coords

pr.toDisp 0, spriteDisplay
pr.toDisp 1, spriteDisplay
pr.toDisp 2, spriteDisplay
spriteDisplay.sprites.push strikeMarker
spriteDisplay.sprites.push ballSprite

batCursor.batterID = 2
batCursor.enable "righty", spriteDisplay

//displayStrikeZoneOf 2, spriteDisplay

debug = {}
debug.trackTL = function(str)
	text.row = 25
	text.clear
	text.print str
end function

sampleLoop = function
	lastTime = time
	pitcher = pr.getPlayerById(0)
	
	while not key.pressed("escape")	
		dt = time - lastTime
		lastTime = time
		// slow down dt for more pronounced pitches
		// faster for realism
		batCursor.update dt
		ball.update dt * 0.5
		moveBallSprite(ball.position)
		pr.getPlayerById(0).update dt
		pr.getPlayerById(1).update dt
		pr.getPlayerById(2).update dt
		
		pitchReleased = pitcher.curAnim.curFrame >= 8
		pitchBeforeRelease = pitcher.curAnim.curFrame == 7
		
		if pitchBeforeRelease then
			ballSprite.x = pitcher.x
			ballSprite.y = pitcher.y
			ballSprite.scale = 0.0001
		else if pitchReleased then
			ballSprite.rotation += ball.spin.z * 50
			ball.setPitch pitchExamples.cyclone
		end if
		
		yield
	end while
end function
