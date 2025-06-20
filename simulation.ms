// The physics is simulated in a bird's eye view. 
// And the rendering will be based on it, not the other way around.
// This is meant for accuracy and extreme variation on gameplay

Vector3 = {"x": 0, "y": 0, "z": 0}

ball = new Vector3
ball.physics = {"velocity": new Vector3, "acceleration": new Vector3, "pitchBreak": new Vector3, "spin": new Vector3, "gravity": 0, "mass": 0, "force": 0, "momentum": 0, "drag": 0, "spinFactor": 0}

ball.positionUpdate = function(dt)
  self.x += self.physics.velocity.x * dt
  self.y += self.physics.velocity.y * dt
  self.z += self.physics.velocity.z * dt
end function

ball.velocityUpdate = function(dt)
  self.physics.velocity.x = self.physics.velocity.x + self.physics.acceleration.x * dt
  self.physics.velocity.y = self.physics.velocity.y + self.physics.acceleration.y * dt
  self.physics.velocity.z = self.physics.velocity.z + self.physics.acceleration.z * dt
end function

ball.applyDrag = function(dt)
  dragCoefficient = self.physics.drag
  vel = self.physics.velocity
  dragX = -vel.x * dragCoefficient
  dragY = -vel.y * dragCoefficient
  dragZ = -vel.z * dragCoefficient

  self.physics.acceleration.x = self.physics.acceleration.x + dragX / self.physics.mass
  self.physics.acceleration.y = self.physics.acceleration.y + dragY / self.physics.mass
  self.physics.acceleration.z = self.physics.acceleration.z + dragZ / self.physics.mass
end function

// apply pitch break as a baseline for acceleration
// this allows the ball to follow an expected trajectory modelled after the pitch type
ball.applyPitchBreak = function(dt)
  self.physics.acceleration.x = self.physics.pitchBreak.x
  self.physics.acceleration.y = self.physics.pitchBreak.y
  self.physics.acceleration.z = self.physics.pitchBreak.z + self.physics.gravity
end function

ball.setBreak = function
  self.physics.pitchBreak.x = self.physics.spin.z * self.physics.spinFactor
  self.physics.pitchBreak.y = -abs(self.physics.spin.x) * self.physics.spinFactor
end function

ball.update = function(dt)
  self.setBreak
  self.applyPitchBreak dt
  self.applyDrag dt
  self.velocityUpdate dt
  // updates position on final calculation
  self.positionUpdate dt
end function

// Ball templates
standardBaseball = new ball
standardBaseball.physics.mass = 0.145
standardBaseball.physics.gravity = -9.8
standardBaseball.physics.drag = 0.05
standardBaseball.physics.spinFactor = 0.0001


// EXAMPLE ONLY -- This is what the values should look like depending on the pitch type
fastball = new standardBaseball
fastball.physics.velocity.y = 43.5
fastball.physics.velocity.z = -1.0
fastball.physics.spin.x = -2200
fastball.physics.spin.x = 200

slider = new standardBaseball
slider.physics.velocity.y = 42.7
slider.physics.velocity.z = -1.0
slider.physics.spin.x = 1800
slider.physics.spin.z  = -2200

curveball = new standardBaseball
curveball.physics.velocity.y = 34
curveball.physics.spin.x = 2500
curveball.physics.spin.z = -500


// Testing
test = {"pitchTime": 0, "over": false, "originalPos": null}
testPitch = function(pitchToTest, dt)
  if test.over then
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
    pprint "ball reached the plate in " + test.pitchTime + " seconds"
    pprint "with final position x: " + pitchToTest.x + " y: " + pitchToTest.y
    pprint "the ball has " + finalX +" inches of horizontal movement"
    test.over = true
  end if
end function
