// DO NOT MODIFY
// Shove to its own json data
SCREEN_W = 960
SCREEN_H = 640
MID_X = SCREEN_W / 2
MID_Y = SCREEN_H / 2
PLATE_X = MID_X / 1.5
PLATE_Y = MID_Y / 1.3
MOUND_X = MID_X
MOUND_Y = MID_Y + 70
SECONDBASE_X = MOUND_X
SECONDBASE_Y = MOUND_Y + 110 
INFIELD_SCALE = 1
MOUND_SCALE = 2
BATTER_SCALE = 5
BP_DIR = "./assets/ballparks/"


// Globals
ballparkProps = { "id": null, "sprite": null }
ballpark = {"pool": {}}

ballpark.load = function(id = 0, name, ext = ".png")
	image = file.loadImage(BP_DIR + name + ext)
	newBallpark = new ballparkProps
	newBallpark.name = name
	newBallpark.id = self.pool.len
	newBallpark.sprite = new Sprite
	newBallpark.sprite.image = image
	self.pool[id] = newBallpark
end function

ballpark.display = function(id, disp)
	selected = self.pool[id]
	selected.sprite.scale = 2
	selected.sprite.x = MID_X
	selected.sprite.y = MID_Y
	disp.sprites.push selected.sprite
end function
