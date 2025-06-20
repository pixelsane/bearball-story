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
  self.physics.velocity.z = self.physics.velocity.z + self.physics.acceleration.z * dt
end function

ball.applyDrag = function(dt)
  dragCoefficient = self.drag
  vel = self.physics.velocity
  dragX = -vel.x * dragCoefficient
  dragY = -vel.y * dragCoefficient
  dragZ = -vel.z * dragCoefficient

  self.physics.acceleration.x = self.physics.acceleration.x + dragX / self.mass
  self.physics.acceleration.y = self.physics.acceleration.y + dragY / self.mass
  self.physics.acceleration.z = self.physics.acceleration.z + dragZ / self.mass
end function

// apply pitch break as a baseline for acceleration
// this allows the ball to follow an expected trajectory modelled after the pitch type
ball.applyPitchBreak = function(dt)
  self.physics.acceleration.x = self.physics.pitchBreak.x
  self.physics.acceleration.y = self.physics.pitchBreak.y
  self.physics.acceleration.z = self.physics.pitchBreak.z + self.gravity
end function

ball.calculateSpin = function
  x = self.physics.spin.z * self.physics.spinFactor
  y = 0
  z = -abs(self.physics.spin.x) * self.physics.spinFactor
  return {"x": x, "y": y, "z": z}
end function

ball.setBreak = function
  self.physics.pitchBreak = self.calculateSpin
end function

ball.update = function(dt)
  self.setBreak
  self.applyPitchBreak dt
  self.applyDrag dt
  self.velocityUpdate dt
  // updates position on final calculation
  self.positionUpdate dt
end function

standardBaseball = new ball
standardBaseball.mass = 0.145
standardBaseball.gravity = -9.8
standardBaseball.drag = 0.05
standardBaseball.spinFactor = 0.0001
