import "player"
import "bg"

clear
display(5).clear
display(7).mode = displayMode.sprite
display(6).mode = displayMode.pixel
display(4).mode = displayMode.sprite

// Globals
pr = new player.roster
ballpark = new bg.ballpark
ballpark.disp = display(7)
spriteDisplay = display(4)

// preload
display(6).clear
ballpark.load(0, "bearstadium")
pr.loadPlayerData(0, "bear")
pr.loadPlayerData(1, "bear")

// init
bear = pr.getPlayerById(0)
bearSpr = bear.sprite
bearSpr.curAnim = bear.anims.idle

bear2 = pr.getPlayerById(1)
bear2Spr = bear2.sprite
bear2Spr.curAnim = bear2.anims.idle

toMound(bearSpr)
toSecond(bear2Spr)
//toPlate(pandaSpr)

ballpark.display 0
spriteDisplay.sprites.push bear2Spr
spriteDisplay.sprites.push bearSpr
  
displayStrikeZone = function(w, h, disp, x = 480, y = 210)	
	originX = x - w / 2
	originY = y - h / 2
	opacityValue = 190
	horizontalImg = file.loadImage("./assets/strikezone/bottomCorner,png")
	
	topCornerLeft = new Sprite
	topCornerLeft.image = file.loadImage("./assets/strikezone/topCorner.png")
	topCornerLeft.x = originX
	topCornerLeft.y = originY + h
	topCornerLeft.tint = color.rgba(255,255, 255, opacityValue)
	topCornerLeft.scale = 2
	
	topCornerRight = new Sprite
	topCornerRight.image = file.loadImage("./assets/strikezone/topCorner.png")
	topCornerRight.x = originX + w
	topCornerRight.y = originY + h
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
	bottomCornerRight.x = originX + w
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
//displayStrikeZone(140, 160, spriteDisplay)
displayStrikeZoneOf 0, spriteDisplay

lastTime = time
while not key.pressed("escape")
	dt = time - lastTime
	lastTime = time
	bearSpr.update dt
	bear2Spr.update dt
	yield
end while