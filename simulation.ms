globals.vector3 = function(x = 0, y = 0, z = 0)
  return {"x": x, "y": y, "z": z}
end function

globals.MPHtoMS = function(num)
  return num * 0.447042667
end function

globals.DEGtoRAD = function(degrees)
  return degrees * pi / 180
end function

globals.RPMtoRADS = function(rpm)
  return rpm * pi / 30
end function

phys = function
  // maybe return conversion methods from here later or another func
  return {"mass": 0.145, "airDensity": 1.225, "gravity": 9.81, "radius": 0.037, "dragCoeff": 0.3}
end function

newBall = function
  return {"releasePoint": vector3, "position": vector3, "velocity": vector3, "acceleration": vector3, "forces": vector3, "spin": vector3, "spinRate": 0, "trajectory": [], "phys": phys}
end function

ball = newBall

ball.reset = function
  blank = newBall
  self.position = blank.position
  self.velocity = blank.velocity
  self.acceleration = blank.acceleration
  self.position = blank.position
  self.trajectory = blank.trajectory
  self.phys = blank.phys
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
  gravity.y = -self.phys.gravity * self.phys.mass

  dragForce = 0.5 * self.phys.airDensity * (speed ^ 2) * (pi * self.phys.radius ^ 2) ^ self.phys.dragCoeff
  
  drag = vector3(
    -dragForce * velDir.x, 
    -dragForce * velDir.y, 
    -dragForce * velDir.z)

  magnus = vector3 // TBA

  return vector3(
    gravity.x + drag.x + magnus.x,
    gravity.y + drag.y + magnus.y,
    gravity.z + drag.z + magnus.z)
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

ball.update = function(dt)
  self.initForces
  self.initAccel
  self.updateVel dt
  self.updatePos dt
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

globals.makePitch = function(releasePoint, targetPos, mph, rpm, spin, angle = -2)
  anyNull = releasePoint == null or mph == null or rpm == null or spin == null or angle == null
  if anyNull then
    pprint "WARNING: Pitch invalid, missing params"
  end if
  // calculate and convert speeds from imperial since the sim calculates with m/s
  // angle == -1 is a slight downward angle
  speedMS = MPHtoMS(mph)
  angle = DEGtoRAD(angle)
  position = releasePoint

  velocity = vector3(
    0,
    speedMS * sin(angle),
    -speedMS * cos(angle))

  // not used yet
  // conversion from rp/m to rad/s
  spinRate = RPMtoRADS(rpm)

  // this returns a pitch config providing all necessary values to inject into the ball
  pitch = {"releasePoint": releasePoint, "position": position, "velocity": velocity, "spin": spin, "spinRate": spinRate}
  return pitch
end function

// SAMPLE PITCHES -- NOT FOR REAL GAMEPLAY, just templates

releasePoint = vector3
// Four-seam Fastball - high velocity, backspin
fourSeamFB = makePitch(releasePoint, 95, 2300, vector3(0, 0.9, 0.1), -2)

// Two-seam Fastball - slightly slower, less spin, some side movement
twoSeamFB = makePitch(releasePoint, 93, 2100, vector3(0.2, 0.8, 0.2), -2)

// Changeup - much slower, reduced backspin
changeup = makePitch(releasePoint, 82, 1700, vector3(0.1, 0.6, 0.3), -1)

// Curveball - slow, heavy topspin
curveball = makePitch(releasePoint, 78, 2800, vector3(0.3, -0.7, 0.6), 0)

// Slider - moderate speed, side spin dominant
slider = makePitch(releasePoint, 85, 2400, vector3(0.8, 0.2, 0.5), -1)

// Cutter - fastball speed, late breaking action
cutter = makePitch(releasePoint, 90, 2200, vector3(0.6, 0.7, 0.3), -2)

// Sinker - fastball speed, heavy sink
sinker = makePitch(releasePoint, 92, 2000, vector3(0.4, 0.3, 0.8), -1)

// Knuckleball - very slow, almost no spin
knuckleball = makePitch(releasePoint, 68, 50, vector3(0.3, 0.3, 0.3), 0)

// Split-finger Fastball - moderate speed, tumbling action
splitter = makePitch(releasePoint, 84, 1500, vector3(0.2, 0.4, 0.9), -3)

// Sweeping Slider - modern slider with more horizontal break
sweepSlider = makePitch(releasePoint, 83, 2600, vector3(0.9, 0.1, 0.4), -1)

// Power Curveball - harder curve with more spin
powerCurve = makePitch(releasePoint, 82, 3000, vector3(0.2, -0.8, 0.5), 1)

// Screwball - rare pitch, reverse breaking
screwball = makePitch(releasePoint, 79, 2100, vector3(-0.7, 0.5, 0.5), -1)
