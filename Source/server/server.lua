ESX = nil
TriggerEvent(Base.ServerEvent, function(obj) ESX = obj end)

local tag = GetCurrentResourceName() .. ":"

regEvent = function(name, handler)
    return RegisterNetEvent(tag .. name), AddEventHandler(tag .. name, handler)
end

-- [@ RegisterCallBack of God
Call = {}
Call.Communication = {}
Call.Output = function(_Name, _CallId, _Src, _Out, ...)
    if not Call.Communication[_Name] then return end
    Call.Communication[_Name](_Src, _Out, ...)
end
Call.Create = function(_Name, _Output)
    Call.Communication[_Name] = _Output
end
RegisterNetEvent("UKB_VehicleShop", function(_Name, _CallId, ...)
    local _Src = source
    Call.Output(_Name, _CallId, _Src, function(...)
        TriggerClientEvent("UKB_VehicleShop", _Src, _CallId, ...)
    end, ...)
end)

--]--

-- [@ Event
regEvent("SetRouting", function(miti)
    local _source = source
    SetRouting(_source, miti , function(res)
        if res then
            print('^2 UKB-VehicleShop: ReloadScript Success')
        end
    end)
end)

--]--


-- [@ CallBack

Call.Create("SetRouting", function(source, cb , miti)
    local _source = source
    SetRouting(_source, miti , function(res)
        cb(res)
    end)
end)

Call.Create("checkPrice", function(source, cb, data , vehicleData)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local typeMoney = data.typeMoney == 'cash' and 'money' or data.typeMoney
    local price = data.price

    print("Price: " .. price)

    if xPlayer.getAccount(typeMoney).money < price then
        cb(false)
        return
    end


    cb(true)

    -- ServerBuyVehicle(xPlayer, vehicleData.name, vehicleData.model, vehicleData.type, vehicleData.plate, vehicleData.props, vehicleData.netID, vehicleData.class, vehicleData.job, vehicleData.target, price, function(res)
    --     if res then
    --         xPlayer.removeAccountMoney(typeMoney, price)
    --         cb(true)
    --     else
    --         cb(false)
    --     end
    -- end)


end)

--]--

-- [@ Command
RegisterCommand('setmiti', function(source, args)
    local _source = source
    local miti = tonumber(args[1])
    SetRouting(_source, miti , function(res)
        if res then
            print("Set Routing Success")
        end
    end)
end)
-- ]

--[@ Function

SetRouting = function(source, miti , cb)
    local _source = source
    SetPlayerRoutingBucket(_source, miti)
    cb(true)
end

ServerBuyVehicle = function(xPlayer, name, model, type, plate, props, netID, class, job, target, price, cb)
    local identifier = xPlayer.getIdentifier()
    local result = MySQL.insert.await('INSERT INTO `owned_vehicles` (owner, plate, type, vehicle, stored) VALUES (?, ?, ?, ? ,?)', {
        identifier, plate, type, json.encode(props), 0
    })

    cb(true)


    
end




-- ]


