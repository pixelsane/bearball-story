// MLB PITCH ARSENAL - Complete Library
// Based on actual big league pitch data and characteristics

releasePoint = vector3(478, 140, 500)
strikeZoneCenter = vector3(480, 34, 496)
strikeZoneHigh = vector3(480, 34, 493)
strikeZoneLow = vector3(480, 34, 485)
strikeZoneOutside = vector3(467.3, 34, 493)
strikeZoneInside = vector3(478, 34, 493)

// Four-Seam Fastball (Rising Fastball)
fourSeamFastball = makePitchToTarget(
  releasePoint, strikeZoneCenter, 
  96, 2350, vector3(0, 0, 1))  // Pure backspin

// Two-Seam Fastball (Running Fastball)
twoSeamFastball = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  93, 2100, vector3(0.3, 0, 0.95))  // Arm-side run

// Sinker (Heavy Sinker)
sinker = makePitchToTarget(
  releasePoint, strikeZoneLow,
  92, 2000, vector3(0.4, 0, 0.9))  // Drops and tails

// Cutter (Cut Fastball)
cutter = makePitchToTarget(
  releasePoint, strikeZoneInside,
  91, 2250, vector3(0.8, 0, 0.6))  // Late glove-side break

// Split-Finger Fastball (Splitter)
splitter = makePitchToTarget(
  releasePoint, strikeZoneLow,
  86, 1400, vector3(0, 0, -0.2))  // Tumbling action

// 12-6 Curveball (Overhand Curve)
curveball12to6 = makePitchToTarget(
  releasePoint, strikeZoneLow,
  79, 2650, vector3(0, 0, -1))  // Pure topspin

// 11-5 Curveball (Traditional Curve)
curveball11to5 = makePitchToTarget(
  releasePoint, strikeZoneLow,
  77, 2500, vector3(0.2, 0, -0.98))  // Slight horizontal break

// Knuckle Curve
knuckleCurve = makePitchToTarget(
  releasePoint, strikeZoneLow,
  81, 2800, vector3(0, 0, -1))  // High spin, sharp break

// Power Curveball (Hard Curve)
powerCurveball = makePitchToTarget(
  releasePoint, strikeZoneLow,
  84, 2400, vector3(0.15, 0, -0.99))  // Harder thrown curve

// Slider (Traditional)
slider = makePitchToTarget(
  releasePoint, strikeZoneOutside,
  85, 2400, vector3(0.7, 0, -0.7))  // Diagonal break

// Sweeper (Horizontal Slider)
sweeper = makePitchToTarget(
  releasePoint, strikeZoneOutside,
  83, 2600, vector3(0.95, 0, -0.3))  // More horizontal movement

// Slurve (Slider-Curve Hybrid)
slurve = makePitchToTarget(
  releasePoint, strikeZoneOutside,
  81, 2300, vector3(0.5, 0, -0.87))  // Between slider and curve

// Circle Changeup
circleChangeup = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  83, 1700, vector3(0, 0, 0.8))  // Reduced backspin

// Palmball
palmball = makePitchToTarget(
  releasePoint, strikeZoneLow,
  79, 1200, vector3(0.1, 0, 0.3))  // Very low spin

// Straight Changeup
straightChangeup = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  84, 1800, vector3(0, 0, 0.9))  // Mostly backspin, reduced

// Forkball
forkball = makePitchToTarget(
  releasePoint, strikeZoneLow,
  82, 1100, vector3(0, 0, -0.1))  // Slight tumble

// Vulcan Changeup
vulcanChangeup = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  81, 1600, vector3(-0.2, 0, 0.8))  // Slight fade

// Knuckleball
knuckleball = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  68, 50, vector3(0.1, 0.1, 0.1))  // Minimal spin

// Screwball (Reverse Curve)
screwball = makePitchToTarget(
  releasePoint, strikeZoneInside,
  78, 2200, vector3(-0.7, 0, -0.7))  // Opposite of slider

// Eephus Pitch (Super Slow)
eephus = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  55, 800, vector3(0, 0, 0.5))  // Very slow with arc

// Gyroball (Bullet Spin)
gyroball = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  87, 2100, vector3(0, 1, 0))  // Spin around flight axis

// Cutter Slider Hybrid (Modern hard slider)
cutterSlider = makePitchToTarget(
  releasePoint, strikeZoneOutside,
  88, 2500, vector3(0.85, 0, -0.5))  // Between cutter and slider

// Rising Four-Seam (High Spin)
risingFourSeam = makePitchToTarget(
  releasePoint, strikeZoneHigh,
  98, 2800, vector3(0, 0, 1))  // Maximum backspin

// Sinker Slider (Hybrid)
sinkerSlider = makePitchToTarget(
  releasePoint, strikeZoneLow,
  89, 2200, vector3(0.6, 0, 0.8))  // Sinking with side movement

// Power Changeup
powerChangeup = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  87, 1900, vector3(0, 0, 0.85))  // Harder changeup

// Spike Curveball
spikeCurveball = makePitchToTarget(
  releasePoint, strikeZoneLow,
  76, 2900, vector3(0, 0, -1))  // Extreme topspin

// "Subway Slider" (Jacob deGrom style)
subwaySlider = makePitchToTarget(
  releasePoint, strikeZoneOutside,
  91, 2650, vector3(0.8, 0, -0.6))  // Hard slider

// "Curveball" (Clayton Kershaw style)
kershawCurve = makePitchToTarget(
  releasePoint, strikeZoneLow,
  75, 2750, vector3(0.1, 0, -0.995))  // Sharp 12-6 break

// "Splitter" (Masahiro Tanaka style)
tanakaSplitter = makePitchToTarget(
  releasePoint, strikeZoneLow,
  85, 1300, vector3(0, 0, -0.15))  // Late drop

// "Changeup" (Felix Hernandez style)
felixChangeup = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  82, 1650, vector3(-0.3, 0, 0.8))  // Arm-side fade

// "Slider" (Chris Sale style)
saleSlider = makePitchToTarget(
  releasePoint, strikeZoneOutside,
  84, 2550, vector3(0.75, 0, -0.65))  // Sharp break

// "Knuckle Curve" (Zito style)
zitoKnuckleCurve = makePitchToTarget(
  releasePoint, strikeZoneLow,
  73, 3100, vector3(0, 0, -1))  // Ultra slow, high spin

// "Rising Fastball" (Chapman style)
chapmanFastball = makePitchToTarget(
  releasePoint, strikeZoneHigh,
  103, 2600, vector3(0, 0, 1))  // Maximum velocity

// "Sinker" (Britton style)
brittonSinker = makePitchToTarget(
  releasePoint, strikeZoneLow,
  96, 2100, vector3(0.5, 0, 0.87))  // Hard sinker

// Shuuto (Japanese Sinker)
shuuto = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  88, 2000, vector3(0.6, 0, 0.8))  // Arm-side movement

// Gyro Slider
gyroSlider = makePitchToTarget(
  releasePoint, strikeZoneOutside,
  86, 2300, vector3(0.3, 0.95, -0.1))  // Bullet spin with break

// Shoot Ball (International)
shootBall = makePitchToTarget(
  releasePoint, strikeZoneInside,
  90, 2150, vector3(-0.4, 0, 0.9))  // Reverse arm-side run

// Waste Pitch (Out of Zone)
wastePitch = makePitchToTarget(
  releasePoint, vector3(0.5, -1, -10),
  88, 2300, vector3(0.7, 0, -0.7))  // Slider in dirt

// Challenge Fastball (High Strike)
challengeFastball = makePitchToTarget(
  releasePoint, strikeZoneHigh,
  97, 2400, vector3(0, 0, 1))  // High four-seam

// Get-Me-Over Curveball (Strike 1)
getMeOverCurve = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  78, 2400, vector3(0, 0, -1))  // Curveball for strike

// Backdoor Slider (Starts outside, breaks in)
backdoorSlider = makePitchToTarget(
  releasePoint, vector3(0.3, 0, -10),
  84, 2450, vector3(-0.7, 0, -0.7))  // Reverse slider movement

// Frontdoor Curve (Starts inside, breaks to strike)
frontdoorCurve = makePitchToTarget(
  releasePoint, vector3(-0.8, 0.2, -10),
  76, 2500, vector3(0.3, 0, -0.95))  // Curves into zone

// Inverted Slider (Backwards slider)
invertedSlider = makePitchToTarget(
  releasePoint, strikeZoneInside,
  86, 2350, vector3(-0.7, 0, -0.7))  // Opposite break

// Slow Curve (Looping curve)
slowCurve = makePitchToTarget(
  releasePoint, strikeZoneLow,
  68, 2100, vector3(0, 0, -1))  // Very slow curve

// Hard Changeup (Firm changeup)
hardChangeup = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  89, 2000, vector3(0, 0, 0.9))  // Changeup with fastball speed

// Slutter (Slider-Cutter hybrid)
slutter = makePitchToTarget(
  releasePoint, strikeZoneOutside,
  89, 2400, vector3(0.9, 0, -0.4))  // Modern hybrid pitch

// Sweeping Curve
sweepingCurve = makePitchToTarget(
  releasePoint, strikeZoneOutside,
  79, 2400, vector3(0.8, 0, -0.6))  // More horizontal curve

// Power Sinker
powerSinker = makePitchToTarget(
  releasePoint, strikeZoneLow,
  95, 2200, vector3(0.4, 0, 0.9))  // High-velocity sinker

// Spitball (Illegal but historical)
spitball = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  83, 900, vector3(0.2, 0.3, 0.1))  // Erratic movement

// Submarine Fastball
submarineFastball = makePitchToTarget(
  releasePoint, strikeZoneCenter,
  88, 2100, vector3(0, 0, 1.2))  // Rising action from low arm

// Emeball (Doctored ball)
emeball = makePitchToTarget(
  releasePoint, strikeZoneOutside,
  81, 1100, vector3(0.4, 0.2, -0.3))  // Unpredictable break

cyclone = makePitchToTarget(
  releasePoint, strikeZoneLow,
  80, 20000, vector3(0, 0, 0.0))  // Extreme rotation

// Power Pitcher Arsenal
powerArsenal = [chapmanFastball, subwaySlider, powerChangeup]

// Finesse Pitcher Arsenal
finesseArsenal = [twoSeamFastball, circleChangeup, curveball12to6, cutter]

// Strikeout Sequence
strikeoutCombo = [challengeFastball, kershawCurve, saleSlider]

// Ground Ball Sequence
groundBallCombo = [sinker, brittonSinker, shuuto]

// Complete Starter Arsenal
starterArsenal = [fourSeamFastball, twoSeamFastball, slider, circleChangeup, curveball12to6]

// Closer Arsenal
closerArsenal = [risingFourSeam, cutter, splitter]
