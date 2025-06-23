// MAIN PRIORITY!!!! COMPLETE WORLD COORDS AND DISPLAY MUST TRANSLATE FROM IT! NO MORE PIXEL MEASUREMENT

import "player"
import "bg"
import "simulation"
import "pitchExamples"

TOP = "top"
CATCHER = "catcher"

clear
display(7).mode = displayMode.pixel
display(6).mode = displayMode.pixel
display(4).mode = displayMode.sprite
display(7).clear
display(6).clear
display(5).clear
display(4).clear
bgDisplay = display(7)
spriteDisplay = display(4)

ballSprite = new Sprite
ballSprite.image = file.loadImage("./assets/ball/baseball.png")
ball = new simulation.ball
ballpark = new bg.ballpark
pr = new player.roster

// top view use world coords
setBallPosition = function(worldBall, newPos, offsetX = 0, offsetY = 0, offsetZ = 0) 
	worldBall.position.x = newPos.x + offsetX
	worldBall.position.y = newPos.y + offsetY
	worldBall.position.z = newPos.z + offsetZ
end function

placeBall = function(view, worldBall, ballSpr, zScale = 0.4)
	// use pattern matching later, if they exist, internet is so ass
	if view == TOP then
		ballSpr.x = worldBall.position.x
		ballSpr.y = worldBall.position.y
		ballSpr.rotation += worldBall.spin.z * worldBall.spinRate
		ballSpr.scale = zScale * (worldBall.position.z / 500)
	end if
end function

// preload
ballpark.load 0, "bearstadium"
pr.loadPlayerData 0, "bear"
pr.loadPlayerData 1, "bear"
pr.loadPlayerData 2, "bear"
pr.loadPlayerData 3, "bear"
pr.loadPlayerData 4, "bear"
pr.loadPlayerData 5, "bear"
pr.loadPlayerData 6, "bear"
pr.loadPlayerData 7, "bear"
pr.loadPlayerData 8, "panda"

// display stuff
ballpark.display 0, "top", bgDisplay
spriteDisplay.sprites.push ballSprite
defaultMound = ballpark.getPosition(0, "mound")
defaultFB = ballpark.getPosition(0, "firstBase")
defaultSB = ballpark.getPosition(0, "secondBase")
defaultTB = ballpark.getPosition(0, "thirdBase")
defaultLF = ballpark.getPosition(0, "leftField")
defaultCF = ballpark.getPosition(0, "centerField")
defaultRF = ballpark.getPosition(0, "rightField")
defaultHome = ballpark.getPosition(0, "home")
defaultBL = ballpark.getPosition(0, "batterLeft")
defaultBR = ballpark.getPosition(0, "batterRight")

defaultInit = function(id, view, pos, anim = "idleAnim", offsetX = 0, offsetY = 0)
	pr.display id, view, spriteDisplay
	pr.setPosition id, pos, offsetX, offsetY
	pr.animate id, view, anim
end function

defaultUpdate = function(id, view, dt = 0.1)
	pr.place id, view
	pr.update id, dt
end function

initAndLoop = function
	lastTime = time
	view = TOP
	setBallPosition ball, pr.getWorldPos(0)
	defaultInit 0, view, defaultMound
	defaultInit 1, view, defaultFB
	defaultInit 2, view, defaultSB, "idleAnim", 80
	defaultInit 3, view, defaultTB
	defaultInit 4, view, defaultLF
	defaultInit 5, view, defaultCF
	defaultInit 6, view, defaultRF
	defaultInit 7, view, defaultSB, "idleAnim", -80
	defaultInit 8, view, defaultBL
	
	ball.setPitch pitchExamples.curveball12to6
	
	while not key.pressed("escape")
		dt = time - lastTime
		lastTime = time
		playerCount = 9
		
		placeBall view, ball, ballSprite
		ball.update dt
		
		for activePlayerID in range(0, playerCount - 1)
			defaultUpdate activePlayerID, view, dt	
		end for
	end while
end function

initAndLoop