// DO NOT MODIFY
// Shove to its own json data
globals.SCREEN_W = 960
globals.SCREEN_H = 640
globals.MID_X = SCREEN_W / 2
globals.MID_Y = SCREEN_H / 2
globals.PLATE_X = MID_X / 1.5
globals.PLATE_Y = MID_Y / 1.3
globals.MOUND_X = MID_X
globals.MOUND_Y = MID_Y + 70
globals.SECONDBASE_X = MOUND_X
globals.SECONDBASE_Y = MOUND_Y + 110 
globals.INFIELD_SCALE = 1
globals.MOUND_SCALE = 2
globals.BATTER_SCALE = 5
globals.BP_DIR = "./assets/ballparks/"


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
