globals.vector3 = function(x = 0, y = 0, z = 0)
  return {"x": x, "y": y, "z": z}
end function

globals.MPHtoMS = function(num)
  return num * 0.44704
end function

globals.DEGtoRAD = function(degrees)
  return degrees * pi / 180
end function

globals.RPMtoRADS = function(rpm)
  return rpm * pi / 30
end function

phys = function
  // magCoeff, it is hard to decide what best fits the game
  // but going for way too high of realism doesn't make it better since most pitches look the same
  // obviously player will have the choice but here's a guidline
  // 0.0001 = Realism, 0.0005 = MLB, 0.0008 = Visible breaking balls, 0.001 = Barely visible fastball variants, 0.008 = Anime, and higher is arcade
  return {"mass": 0.145, "airDensity": 1.225, "gravity": 9.81, "radius": 0.037, "dragCoeff": 0.3, "magCoeff": 0.0005, "circumference": 0.229}
end function

newBall = function
  return {"releasePoint": vector3, "position": vector3, "velocity": vector3, "acceleration": vector3, "forces": vector3, "spin": vector3, "spinRate": 0, "trajectory": [], "phys": phys, "time": 0, "updateCount": 0}
end function

ball = newBall

ball.reset = function
  blank = newBall
  self.position = blank.position
  self.velocity = blank.velocity
  self.acceleration = blank.acceleration
  self.trajectory = blank.trajectory
  self.phys = blank.phys
  self.time = 0
  self.updateCount = 0
end function

ball.rotateSpinAxis = function(dt, pr)
  // Only enable this for heavier style motions
  // precessionRate: Realistic would be ~0.1, anime is ~2.0
  precessionRate = pr
  angle = self.time * precessionRate

  cos_a = cos(angle)
  sin_a = sin(angle)

  newSpinX = self.spin.x * cos_a - self.spin.z * sin_a
  newSpinZ = self.spin.x * sin_a + self.spin.z * cos_a

  self.spin.x = newSpinX
  self.spin.z = newSpinZ
end function

ball.initAccel = function
  self.acceleration.x = self.forces.x / self.phys.mass
  self.acceleration.y = self.forces.y / self.phys.mass
  self.acceleration.z = self.forces.z / self.phys.mass
end function

ball.calculateForces = function
  // Formula: sqrt x² + y² + z²
  vel = self.velocity
  speed = sqrt(vel.x ^ 2 + vel.y ^ 2 + vel.z ^ 2)
  isStatic = speed == 0

  if isStatic then
    return vector3(0,0,0)
  end if
  
  velDir = vector3(
    self.velocity.x / speed,
    self.velocity.y / speed,
    self.velocity.z / speed)

  gravity = vector3
  gravity.z = -self.phys.gravity * self.phys.mass

  dragForce = 0.5 * self.phys.airDensity * (speed ^ 2) * (pi * self.phys.radius ^ 2) * self.phys.dragCoeff

  drag = vector3(
    -dragForce * velDir.x, 
    -dragForce * velDir.y, 
    -dragForce * velDir.z)

  circulation = self.spinRate * self.phys.circumference
  magCoeff = self.phys.airDensity * circulation * self.phys.magCoeff

  magnus = vector3(
    magCoeff * (self.spin.y * velDir.z - self.spin.z * velDir.y),
    magCoeff * (self.spin.y * velDir.x - self.spin.x * velDir.z),
    magCoeff * (self.spin.x * velDir.y - self.spin.y * velDir.x))

  return vector3(
    gravity.x + drag.x + magnus.x,
    gravity.y + drag.y + magnus.y,
    gravity.z + drag.z + magnus.z)
end function

ball.applySpinDecay = function(dt)
  decayRate = 0.99
  decayFactor = decayRate ^ dt

  self.spinRate *= decayFactor
  self.spin.x *= decayFactor
  self.spin.y *= decayFactor  
  self.spin.z *= decayFactor
end function

ball.initForces = function
  self.forces = self.calculateForces
end function

ball.updateVel = function(dt)
  self.velocity.x += self.acceleration.x * dt
  self.velocity.y += self.acceleration.y * dt
  self.velocity.z += self.acceleration.z * dt
end function

ball.updatePos = function(dt)
  self.position.x += self.velocity.x * dt
  self.position.y += self.velocity.y * dt
  self.position.z += self.velocity.z * dt

end function

ball.setPitch = function(pitch)
  self.reset
  self.position = pitch.position
  self.velocity = pitch.velocity
  self.spin = pitch.spin
  self.spinRate = pitch.spinRate
end function

ball.setHit = function
  // this is different because hits makes the ball go up
end function

ball.setThrow = function

end function

ball.update = function(dt, pr = 2.0)
  self.time += dt

  self.rotateSpinAxis dt, pr
  self.initForces
  self.initAccel
  self.updateVel dt
  self.updatePos dt
  self.applySpinDecay dt

  updateCount = self.updateCount
  if updateCount % 4 == 0 then  // Every 4th update at 60fps = 15fps trajectory
    self.trajectory.push self.position
  end if
  self.updateCount += 1
end function

globals.makePitchToTarget = function(releasePoint, targetPos, mph, rpm, spin)
  dx = targetPos.x - releasePoint.x
  dy = targetPos.y - releasePoint.y  
  dz = targetPos.z - releasePoint.z

  distance = sqrt(dx^2 + dy^2 + dz^2)
  horizontalDistance = sqrt(dx^2 + dz^2)
  angle = atan(dy, horizontalDistance)

  speedMS = MPHtoMS(mph)

  velocity = vector3(
    speedMS * (dx / distance),
    speedMS * (dy / distance),
    speedMS * (dz / distance))

  spinRate = RPMtoRADS(rpm)

  pitch = {"releasePoint": releasePoint, "position": releasePoint, "velocity": velocity, "spin": spin, "spinRate": spinRate}
  return pitch
end function
