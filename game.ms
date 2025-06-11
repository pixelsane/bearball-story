import "player"
import "bg"
import "spriteControllers"

clear
display(5).clear
display(7).mode = displayMode.sprite

// Globals
pr = new player.roster
ballpark = new bg.ballpark
ballpark.disp = display(7)

// preload
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

ballpark.display 0
display(4).sprites.push bear2Spr
display(4).sprites.push bearSpr

lastTime = time
while not key.pressed("escape")
	dt = time - lastTime
	lastTime = time
	bearSpr.update dt
	bear2Spr.update dt
	yield
end while