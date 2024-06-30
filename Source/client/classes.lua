local statsCache = {}

function calculateStats(vehicle)
  local info = {}

  local model = GetEntityModel(vehicle)

  if statsCache[model] then return statsCache[model] end

  local isMotorCycle = IsThisModelABike(model) or (GetVehicleClass(vehicle) == 8)
  local isBoat = IsThisModelABoat(model) or tonumber(model) == -1706603682 or (GetVehicleClass(vehicle) == 14)
  local fInitialDriveMaxFlatVel = getFieldFromHandling(vehicle, "fInitialDriveMaxFlatVel")
  local fInitialDriveForce = getFieldFromHandling(vehicle, "fInitialDriveForce")
  local fClutchChangeRateScaleUpShift = getFieldFromHandling(vehicle, "fClutchChangeRateScaleUpShift")
  local nInitialDriveGears = getFieldFromHandling(vehicle, "nInitialDriveGears")
  local fDriveBiasFront = getFieldFromHandling(vehicle, "fDriveBiasFront")
  local fInitialDragCoeff = getFieldFromHandling(vehicle, "fInitialDragCoeff")
  local fTractionCurveMax = getFieldFromHandling(vehicle, "fTractionCurveMax")
  local fTractionCurveMin = getFieldFromHandling(vehicle, "fTractionCurveMin")
  local fLowSpeedTractionLossMult = getFieldFromHandling(vehicle, "fLowSpeedTractionLossMult")
  local fSuspensionReboundDamp = getFieldFromHandling(vehicle, "fSuspensionReboundDamp")
  local fSuspensionReboundComp = 0.0
  local fAntiRollBarForce = getFieldFromHandling(vehicle, "fAntiRollBarForce")
  local fBrakeForce = getFieldFromHandling(vehicle, "fBrakeForce")
  local drivetrainMod = 0.0
  local force = fInitialDriveForce
	if fInitialDriveForce > 0 and fInitialDriveForce < 1 then
		force = force * 1.1
	end
	local accel = (fInitialDriveMaxFlatVel * force) / 10
	local speed = ((fInitialDriveMaxFlatVel / fInitialDragCoeff) * (fTractionCurveMax + fTractionCurveMin)) / 40
	if isMotorCycle then
		speed = speed * 2
	end
	local handling = (fTractionCurveMax + fSuspensionReboundDamp) * fTractionCurveMin
	if isMotorCycle then
		handling = handling / 2
	end
	local braking = ((fTractionCurveMin / fInitialDragCoeff) * fBrakeForce) * 7

  
  if fDriveBiasFront > 0.5 then
      --fwd
      drivetrainMod = 1.0-fDriveBiasFront
  else
      --rwd
      drivetrainMod = fDriveBiasFront
  end

  local score = {
      accel = 0.0,
      speed = 0.0,
      handling = 0.0,
      braking = 0.0,
      drivetrain = 0.0,
  }

  score.drivetrain = fDriveBiasFront

  local force = fInitialDriveForce
  if fInitialDriveForce > 0 and fInitialDriveForce < 1 then
      force = (force + drivetrainMod*0.15) * 1.1
  end

  -- SPEED -- 
  local speedScore = ((fInitialDriveMaxFlatVel / fInitialDragCoeff) * (fTractionCurveMax + fTractionCurveMin)) / 40
--  score.speed = speedScore
  
  local spid = math.ceil(fInitialDriveMaxFlatVel * 1.3)
  score.speed = (spid / 300) * 10

  -- ACCELERATION -- 
  local accelScore = (fInitialDriveMaxFlatVel * force + (fClutchChangeRateScaleUpShift*0.7)) / 10
  score.accel = accelScore

  -- HANDLING -- 
  local lowSpeedTraction = 1.0
  if fLowSpeedTractionLossMult >= 1.0 then
      lowSpeedTraction = lowSpeedTraction + (fLowSpeedTractionLossMult-lowSpeedTraction)*0.15
  else
      lowSpeedTraction = lowSpeedTraction - (lowSpeedTraction - fLowSpeedTractionLossMult)*0.15
  end
  local handlingScore = (fTractionCurveMax + (fSuspensionReboundDamp+fSuspensionReboundComp+fAntiRollBarForce)/3) * (fTractionCurveMin/lowSpeedTraction) + drivetrainMod
  score.handling = handlingScore

  -- BRAKING -- 
  local brakingScore = ((fTractionCurveMin / fTractionCurveMax ) * fBrakeForce) * 7
  score.braking = brakingScore
  if isBoat or not tonumber(score.braking) then
    score.braking = 0.0
  end

  local info = {}
  info['acceleration'] = score.accel
  info['handling'] = score.handling
  info['speed'] = score.speed
  info['braking'] = score.braking
  info['typecar'] = GetVehicleType(vehicle)
  statsCache[model] = {info = info}
  return statsCache[model]
end

function getFieldFromHandling(vehicle, field)
  return GetVehicleHandlingFloat(vehicle, 'CHandlingData', field)
end