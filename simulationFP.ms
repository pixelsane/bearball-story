// This is an FP rewrite for simulation.ms, because I hate OOP. I flew too close to the sun and I got burned.
// I am like Icarus frfr
// never give up on FP even if you become a game dev T_T (NEVER GIVE UP!)

globals.magnusLift = function(rpm, vel, liftFactor = 0.5)
  spinRate = rpm * 2 * pi / 60
  lift = -(spinRate / vel) * liftFactor
  return lift
end function

addVectorsThenDt = function(map1, map2, dt)
  x = map1.x + map2.x * dt
  y = map1.y + map2.y * dt
  z = map1.z + map2.z * dt
  return {"x": x, "y": y, "z": z}
end function

applyPitchBreak = function(pitch)
  x = pitch.pitchbreak.x
  y = pitch.pitchbreak.y
  z = pitch.pitchbreak.y + pitch.gravity
  return {"x": x, "y": y, "z": z}
end function

applyDrag = function(pitch, acceleration)
  dragFactor = pitch.drag / pitch.mass
  x = acceleration.x - pitch.velocity.x * dragFactor
  y = acceleration.y - pitch.velocity.y * dragFactor
  z = acceleration.z - pitch.velocity.z * dragFactor
  return {"x": x, "y": y, "z": z}
end function

updateVelocity = function(velocity, acceleration, dt)
  return addVectorsThenDt(velocity, acceleration, dt)
end function

updatePosition = function(position, velocity, dt)
  return addVectorsThenDt(position, velocity, dt)
end function

globals.makePitch = function(velocity, pitchbreak)
  // These are default values milady
  defaultPos = {"x": 0, "y": 0, "z": 0}
  gravity = -9.8
  mass = 0.145
  drag = 0.05

  // Since everything is immutable i don't think i need {}, but I am just adding it to make a statement lol
  pos = defaultPos + {}
  acceleration = defaultPos + {}
  velocity = defaultPos + {}
  return {"pos": pos, "acceleration": acceleration, "velocity": velocity, "pitchbreak": pitchbreak, "gravity": gravity, "mass": mass, "drag": drag}
end function

globals.updatePitch = function(pitch, dt)
  gravity = pitch.gravity
  mass = pitch.mass
  drag = pitch.drag

  accelerationInitial = applyPitchbreak(pitch)
  acceleration = applyDrag(pitch, accelerationInitial)
  velocity = updateVelocity(pitch.velocity, acceleration, dt)
  pos = updatePosition(pitch.pos, velocity, dt)
  pitchbreak = pitch.pitchbreak
  
  return {"pos": pos, "acceleration": acceleration, "velocity": velocity, "pitchbreak": pitchbreak, "gravity": gravity, "mass": mass, "drag": drag}
end function
