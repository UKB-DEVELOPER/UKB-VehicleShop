Quries =  {}

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


-- Quris.BuyVehicleSuccessfully = function(xPlayer, model, plate, props, type, job, cb)
--     local identifier = xPlayer.getIdentifier()
--     local result = MySQL.insert.await('INSERT INTO `owned_vehicles` (owner, plate, type, vehicle, stored) VALUES (?, ?, ?, ? ,?)', {
--         identifier, plate, type, json.encode(props), 0
--     })
    
-- end