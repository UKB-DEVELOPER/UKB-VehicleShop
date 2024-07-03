Quries = {}

Quries.isPlateAvailable = function(plate)
    local isPass

    local data = MySQL.query.await('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate})
    if data[1] then
        isPass = false
    else
        isPass = true
    end

    while isPass == nil do
        Wait(0)
    end

    return isPass

end

Quries.BuyVehicleSuccessfully = function(xPlayer, plate, props, type, job, cb)
    local identifier = xPlayer.getIdentifier()
    local result = MySQL.insert.await('INSERT INTO `owned_vehicles` (owner, plate, vehicle, type, job, stored) VALUES (?, ?, ?, ? ,?, ?)',{
        identifier, plate, json.encode(props), type, job, 0
    })
    if result then
        cb(true)
    else
        cb(false)
    end

end
