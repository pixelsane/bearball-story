// the physics is simulated in a bird's eye view. 
// and the rendering will be based on it, not the other way around.
// this is meant for accuracy and extreme variation on gameplay

vector3 = {}
vector3.x = 0
vector3.y = 0
vector3.z = 0

ball = new vector3
ball.physics = {"velocity": new vector3, "acceleration": new vector3, "pitchbreak": new vector3, "gravity": 0, "mass": 0, "force": 0, "momentum": 0, "drag": 0}

ball.positionupdate = function(dt)
  self.x += self.physics.velocity.x * dt
  self.y += self.physics.velocity.y * dt
  self.z += self.physics.velocity.z * dt
end function

ball.velocityupdate = function(dt)
  self.physics.velocity.x = self.physics.velocity.x + self.physics.acceleration.x * dt
  self.physics.velocity.y = self.physics.velocity.y + self.physics.acceleration.y * dt
  self.physics.velocity.z = self.physics.velocity.z + self.physics.acceleration.z * dt
end function

ball.applydrag = function(dt)
  dragcoefficient = self.physics.drag
  vel = self.physics.velocity
  dragx = -vel.x * dragcoefficient
  dragy = -vel.y * dragcoefficient
  dragz = -vel.z * dragcoefficient

  self.physics.acceleration.x += dragx / self.physics.mass
  self.physics.acceleration.y += dragy / self.physics.mass
  self.physics.acceleration.z += dragz / self.physics.mass
end function

// apply pitch break as a baseline for acceleration
// this allows the ball to follow an expected trajectory modelled after the pitch type
ball.applyPitchbreak = function(dt)
  self.physics.acceleration.x = self.physics.pitchbreak.x
  self.physics.acceleration.y = self.physics.pitchbreak.y
  self.physics.acceleration.z = self.physics.pitchbreak.z + self.physics.gravity
end function

ball.resetAceleration = function
  self.physics.acceleration.x = 0
  self.physics.acceleration.y = 0
  self.physics.acceleration.z = 0
end function

ball.update = function(dt)
  self.resetAceleration
  self.applyPitchbreak dt
  self.applydrag dt
  self.velocityupdate dt
  // updates position on final calculation
  self.positionupdate dt
end function

// Ball templates
standardBaseball = new ball
standardBaseball.physics.mass = 0.145
standardBaseball.physics.gravity = -9.8
standardBaseball.physics.drag = 0.05


// EXAMPLE ONLY -- This is what the values should look like depending on the pitch type
fastball = new standardBaseball
fastball.physics.velocity.y = 43.5
fastball.physics.velocity.z = -1.0

slider = new standardBaseball
slider.physics.velocity.y = 34
slider.physics.velocity.z = -1.0

curveball = new standardBaseball
curveball.physics.velocity.y = 34

// Testing
test = {"pitchTime": 0, "over": false, "originalPos": null}
testPitch = function(pitchToTest, dt)
  pitchToTest.update dt
  if test.over then
    test.pitchTime = 0
    return
  end if
  if test.originalPos == null then
    test.originalPos = {"x": pitchToTest.x, "y": pitchToTest.y, "z": pitchToTest.z}
  end if
  plateY = 18.44
  // Pitch sim example
  if pitchToTest.y < plateY then
    test.pitchTime += dt
    pitchToTest.update dt
    yield
  else
    finalX = (pitchToTest.x - test.originalPos.x) * 39.3701
    finalZ = (pitchToTest.z - test.originalPos.z) * 39.3701
    pprint "ball reached the plate in " + test.pitchTime + " seconds"
    pprint "with final position x: " + pitchToTest.x + " y: " + pitchToTest.y + " z: " + pitchToTest.z
    pprint "the ball has " + finalX +" inches of horizontal movement"
    pprint "the ball has " + finalZ +" inches of vertical movement"
    test.over = true
  end if
end function
