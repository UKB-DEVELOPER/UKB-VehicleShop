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

Call.Create("checkPrice", function(source, cb, shopId , data , modelName , vehicleData)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local typeMoney = data.typeMoney == 'cash' and 'money' or data.typeMoney
    local priceUI = data.price
    local typeVehicle = Vehicle.ListShop[shopId].typeVehicle
    local job = nil
    while job == nil do
        for i=1, #Vehicle.ListShop[shopId].requireJob do
            if xPlayer.job.name == Vehicle.ListShop[shopId].requireJob[i] then
                if Vehicle.ListShop[shopId].requireJob[i] == 'unemployed' then
                    job = ''
                    break
                else
                    job = xPlayer.job.name
                end
                -- job = xPlayer.job.name == 'unemployed' and '' or xPlayer.job.name
            end
        end
        Wait(0)
    end
    getPriceVehicle(modelName, function(result)
        local price
        if not result then cb(false) return end
        if typeMoney == 'bank' then
            price = result[1].price + (result[1].price * Default.Vat)
            if tonumber(priceUI) ~= tonumber(price) then
                print('Hack Bro')
                cb(false)
                return
            end
            if xPlayer.getAccount(typeMoney).money < price then
                print('Hack Bro')
                cb(false)
                return
            end
        elseif typeMoney == 'money' then
            price = result[1].price
            if tonumber(priceUI) ~= tonumber(price) then
                print('Hack Bro')
                cb(false)
                return
            end
            if xPlayer.getAccount(typeMoney).money < price then
                print('Hack Bro')
                cb(false)
                return
            end
        end
        if price ~= nil then
            Quries.BuyVehicleSuccessfully(xPlayer, vehicleData.plate, vehicleData, typeVehicle, job, function(res)
                if res then
                    xPlayer.removeAccountMoney(typeMoney, price)
                    cb(true)
                else
                    print('Hack Bro')
                    return
                    cb(false)
                end
            end)
        end
    end)
end)

Call.Create('GeneratePlate', function(source, cb)
    CheckGeneratePlate(function(plate)
        if not plate then
            cb(false)
        end
        cb(plate)
    end)
end)

Call.Create('getDataVehicles', function(source, cb, data)
    local result = MySQL.query.await('SELECT * From `ukb_vehicles`', {})
    if result then
        cb(result)
    else
        cb(false)
    end
end)

--]--

--[@ Function

SetRouting = function(source, miti , cb)
    local _source = source
    SetPlayerRoutingBucket(_source, miti)
    cb(true)
end

--[ @ GeneratePlate ]
local numset = {} -- [0-9]
local charset = {} -- [A-Z]
for c = 48, 57  do table.insert(numset, string.char(c)) end
for c = 65, 90  do table.insert(charset, string.char(c)) end

randomNumber = function(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.time())
    return randomNumber(length - 1) .. numset[math.random(1, #numset)]
end

randomString = function(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.time())
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end

CheckGeneratePlate = function(cb)
    local plate = nil
    while plate == nil do
        Wait(0)
        plate = Functions.GeneratePlate()
    end

    cb(plate)

end

--

getPriceVehicle = function(modelName,cb)
    local result = MySQL.query.await('SELECT price From `ukb_vehicles` Where model = ? LIMIT 1', {
        modelName
    })
    if result then
        cb(result)
    else
        cb(false)
    end
end



-- ] --


