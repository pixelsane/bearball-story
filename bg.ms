clear
display(5).clear
// DO NOT MODIFY
SCREEN_W = 960
SCREEN_H = 640
MID_X = SCREEN_W / 2
MID_Y = SCREEN_H / 2
MOUND_X = MID_X
MOUND_Y = MID_Y + 70
SECONDBASE_X = MOUND_X
SECONDBASE_Y = MOUND_Y + 110 
INFIELD_SCALE = 1
MOUND_SCALE = 2
BATTER_SCALE = 4
BP_DIR = "./assets/ballparks/"

// Globals
ballparkProps = { "id": null, "sprite": null }
ballpark = new {"disp": null, "pool": {}}

ballpark.load = function(id = 0, name, ext = ".png")
	image = file.loadImage(BP_DIR + name + ext)
	newBallpark = new ballparkProps
	newBallpark.name = name
	newBallpark.id = self.pool.len
	newBallpark.sprite = new Sprite
	newBallpark.sprite.image = image
	self.pool[id] = newBallpark
end function

ballpark.display = function(id)
	if self.disp == null then
		pprint "No display reference assigned to (ballpark) class, please assign to ballpark.disp"
		exit
	end if
	selected = self.pool[id]
	selected.sprite.scale = 2
	selected.sprite.x = MID_X
	selected.sprite.y = MID_Y
	self.disp.sprites.push selected.sprite
end function

globals.toMound = function(spr)
	spr.x = MOUND_X
	spr.y = MOUND_Y
	spr.scale = MOUND_SCALE
end function

globals.toSecond = function(spr)
	spr.x = SECONDBASE_X
	spr.y = SECONDBASE_Y
	spr.scale = INFIELD_SCALE
end function