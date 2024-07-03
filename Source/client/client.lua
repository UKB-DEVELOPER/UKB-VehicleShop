ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Base.ClientEvent, function(obj)
            ESX = obj
        end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

-- variable --
local tag = GetCurrentResourceName() .. ":"
local isDead = false
local vehshop = {}
-- 

regEvent = function(name, handler)
    return RegisterNetEvent(tag .. name), AddEventHandler(tag .. name, handler)
end

regEventESX = function(name, handler)
    return RegisterNetEvent(name), AddEventHandler(name, handler)
end

-- [@ RegisterCallBack of God
Call = {}
Call.Called = {}
Call.Id = 0
Call.Connect = function(_Name, _Send, ...)
    Call.Called[Call.Id] = _Send
    TriggerServerEvent("UKB_VehicleShop", _Name, Call.Id, ...)
    Call.Id = (Call.Id < 65535) and (Call.Id + 1) or 0
end
RegisterNetEvent("UKB_VehicleShop", function(CallId, ...)
    Call.Called[CallId](...)
    Call.Called[CallId] = nil
end)

-- ]--

-- Npc Spawn --
loadAndPlayAnimation = function(animeDict, animeName, send)
    if animeDict == nil then
        send(true)
        return
    end
    RequestAnimDict(animeDict)
    while not HasAnimDictLoaded(animeDict) do
        Wait(0)
    end
    send(animeDict, animeName)
end

Citizen.CreateThread(function()
    for k, v in pairs(Vehicle.ListShop) do
        if v.showType.type == 'npc' then
            local ped = GetHashKey(v.showType.ped.model)
            RequestModel(ped)
            while not HasModelLoaded(ped) do
                Wait(1)
            end
            vehshop.npc = CreatePed(4, ped, v.coords.x, v.coords.y, v.coords.z - 1.0, v.coords.w, false, false)
            SetBlockingOfNonTemporaryEvents(vehshop.npc, true)
            SetPedDiesWhenInjured(vehshop.npc, false)
            SetPedCanPlayAmbientAnims(vehshop.npc, true)
            SetPedCanRagdollFromPlayerImpact(vehshop.npc, false)
            SetEntityInvincible(vehshop.npc, true)
            PlaceObjectOnGroundProperly(vehshop.npc)
            Wait(800)
            FreezeEntityPosition(vehshop.npc, true)
            loadAndPlayAnimation(v.showType.ped.animation.dict, v.showType.ped.animation.name, function(dict, name)
                TaskPlayAnim(vehshop.npc, dict, name, 8.0, 8.0, -1, 1, 0, 0, 0, 0)
            end)
        end
    end
end)
-- End Npc Spawn --

-- Blip --
Citizen.CreateThread(function()
    for k, v in pairs(Vehicle.ListShop) do
        if v.blip.show then
            vehshop.blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(vehshop.blip, v.blip.sprite)
            SetBlipDisplay(vehshop.blip, 4)
            SetBlipScale(vehshop.blip, v.blip.scale)
            SetBlipColour(vehshop.blip, v.blip.color)
            SetBlipAsShortRange(vehshop.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.name)
            EndTextCommandSetBlipName(vehshop.blip)
        end
    end

end)
-- End Blip --

-- Event --
regEventESX(Default.event.setJob, function(job)
    ESX.PlayerData.job = job
end)

regEventESX(Default.event.onDeath, function()
    isDead = true
    SendNUIMessage({
        action = "closeShop"
    })
end)

regEventESX(Default.event.playerSpawned, function()
    isDead = false
end)

-- End Event --

-- Function --
local state = {
    ui = false,
    cam = nil,
    isCameraActive = false,
    lastCoords = nil,
    vehicleUI = nil,
    vehicle = nil,
    showCoordsVehicle = nil,
    testDrive = nil,
    VehicleTestDrive = nil,
    spawnCoords = nil,
    plate = nil,
    shopIdx = nil,
    

    SetCam = function(self, idx)
        local shop = Vehicle.ListShop[idx]
        self.showCoordsVehicle = shop.showCoords
        self.testDrive = shop.testDrive
        self.spawnCoords = shop.spawnCoords
        self.shopIdx = idx
        local target = nil
        if not DoesCamExist(self.cam) then
            self.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        end
        SetCamActive(self.cam, true)
        RenderScriptCams(true, true, 500, true, true)
        self.isCameraActive = true
        SetCamRot(self.cam, 0.0, 0.0, 270.0, true)
        SetCamCoord(self.cam, self.showCoordsVehicle + vector3(0.7, 0.0, 0.7))
        PointCamAtCoord(self.cam, self.showCoordsVehicle + vector3(-2.0, -0.5, 0.6))
        SetEntityVisible(PlayerPedId(), 0)
        SetEntityHeading(PlayerPedId(), 90.0)
        self.lastCoords = GetEntityCoords(PlayerPedId())
    end,

    detoryCam = function(self)
        self.isCameraActive = false
        SetCamActive(self.cam, false)
        RenderScriptCams(false, true, 500, true, true)
        self.cam = nil
        ResetEntityAlpha(PlayerPedId())
    end,

    SendDataToNui = function(self, idx)
        local shop = Vehicle.ListShop[idx]
        self.ui = true
        SendNUIMessage({
            action = "openCardealer",
            vehicles = shop.vehicles,
            shopName = shop.shopName,
            SvName = Default.SvName,
            defualtColor = Default.VehicleColors
        })
        SetNuiFocus(self.ui, self.ui)
    end,

    resetPlayerEntity = function(self)
        self.ui = false
        if self.lastCoords then
            SetEntityCoords(PlayerPedId(), self.lastCoords)
        end
        SetEntityVisible(PlayerPedId(), 1)
        SetNuiFocus(self.ui, self.ui)
    end,

    deleteLastCar = function(self)
        if self.vehicle == nil then
            return
        end
        if DoesEntityExist(self.vehicle) then
            DeleteEntity(self.vehicle)
            self.vehicle = nil
        end
    end,

    deleteLastCartestDrive = function(self)
        if self.VehicleTestDrive == nil then
            return
        end
        if DoesEntityExist(self.VehicleTestDrive) then
            DeleteEntity(self.VehicleTestDrive)
            self.VehicleTestDrive = nil
        end
    end,

    showVehicle = function(self, cb)
        self:deleteLastCar()

        local model = (type(self.vehicleUI.model) == 'number' and self.vehicleUI.model or
                          GetHashKey(self.vehicleUI.model))

        requestModel(model)

        local vehicle = CreateVehicle(model, self.showCoordsVehicle - vector3(4.0, 1.0, 1.0), false, false)

        local timeout = 0
        SetEntityAsMissionEntity(vehicle, true, false)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetVehRadioStation(vehicle, 'OFF')
        SetVehicleDirtLevel(vehicle, 0.0)
        SetVehicleLights(vehicle, 2)
        EnableVehicleExhaustPops(vehicle, true)
        FreezeEntityPosition(vehicle, true)
        SetModelAsNoLongerNeeded(model)
        SetVehicleEngineOn(vehicle, false, true, true)
        SetVehicleAutoRepairDisabled(vehicle, false)

        RequestCollisionAtCoord(self.showCoordsVehicle.x, self.showCoordsVehicle.y, self.showCoordsVehicle.z)

        SetEntityHeading(vehicle, 250.0)

        while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 100 do
            Wait(0)
            timeout = timeout + 1
        end

        CreateThread(function()
            Wait(1500)
            SetVehicleEngineOn(vehicle, true, false, true)
        end)

        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

        self.vehicle = vehicle

        cb(calculateStats(self.vehicle))

    end,

    createVehicle = function(self, modelName, vehicleData, cb)
        if not self.spawnCoords then
            return
        end

        local coordSpawn
        while coordSpawn == nil do
            Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            Draw3DText("~g~ กำลังเช็คพื้นที", playerCoords, playerCoords)
            for _, coord in pairs(self.spawnCoords) do
                local isSpawnPointClear = ESX.Game.IsSpawnPointClear(coord, 10.0)
                if isSpawnPointClear then
                    coordSpawn = coord
                end
            end
        end

        RequestCollisionAtCoord(coordSpawn.x, coordSpawn.y, coordSpawn.z)

        local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
        requestModel(model)

        local xVehicle = CreateVehicle(model, coordSpawn.x, coordSpawn.y, coordSpawn.z + 0.5, true, false)

        ESX.Game.SetVehicleProperties(xVehicle, vehicleData)
        SetModelAsNoLongerNeeded(model)
        local timeout = 0
        while not HasCollisionLoadedAroundEntity(xVehicle) and timeout < 100 do
            Wait(0)
            timeout = timeout + 1
        end

        if xVehicle and DoesEntityExist(xVehicle) then
            TaskWarpPedIntoVehicle(PlayerPedId(), xVehicle, -1)
            cb(true)
        else
            cb(false)
        end

    end,

    setVehicleColor = function(self, data)
        if self.vehicle and DoesEntityExist(self.vehicle) then
            if data.type == 'primary' then
                SetVehicleCustomPrimaryColour(self.vehicle, data.r, data.g, data.b)
            elseif data.type == 'secondary' then
                SetVehicleCustomSecondaryColour(self.vehicle, data.r, data.g, data.b)
            end
        end
    end,

    testDriveVehicle = function(self)
        if not self.testDrive.enable then
            return
        end
        self:deleteLastCartestDrive()
        Call.Connect("SetRouting", function(result)
            if result then
                if not self.vehicle and not DoesEntityExist(self.vehicle) then
                    Call.Connect("SetRouting", function(result)
                    end, 0)
                    return
                end

                self.VehicleTestDrive = self.vehicle

                SetNuiFocus(0, 0)
                SetEntityVisible(PlayerPedId(), 1)
                self:detoryCam()
                FreezeEntityPosition(self.VehicleTestDrive, false)
                SetVehicleUndriveable(self.VehicleTestDrive, false)
                SetPedIntoVehicle(PlayerPedId(), self.VehicleTestDrive, -1)
                SetPedCoordsKeepVehicle(PlayerPedId(), self.testDrive.spawncoord)
                SendNUIMessage({
                    action = "StartTestDrive"
                })

                Citizen.CreateThread(function()
                    local sec = 0
                    local timeout = GetGameTimer() / 1000
                    if not self.testDrive.time then
                        return
                    end
                    while GetGameTimer() / 1000 - timeout < self.testDrive.time and
                        DoesEntityExist(self.VehicleTestDrive) and not IsEntityDead(PlayerPedId()) do
                        sec = math.floor(self.testDrive.time - (GetGameTimer() / 1000 - timeout))
                        if #(GetEntityCoords(PlayerPedId()) - self.testDrive.spawncoord) > self.testDrive.range then
                            SetPedCoordsKeepVehicle(PlayerPedId(), self.testDrive.spawncoord)
                        end
                        if GetVehiclePedIsIn(PlayerPedId(), false) == 0 and DoesEntityExist(self.VehicleTestDrive) then
                            SetPedIntoVehicle(PlayerPedId(), self.VehicleTestDrive, -1)
                        end
                        SendNUIMessage({
                            action = "updateTimerTestDrive",
                            timer = sec
                        })
                        Wait(1000)
                    end

                    SetPedCoordsKeepVehicle(PlayerPedId(), self.lastCoords)
                    FreezeEntityPosition(self.VehicleTestDrive, true)
                    SetVehicleUndriveable(self.VehicleTestDrive, true)
                    ClearPedTasksImmediately(PlayerPedId())
                    if DoesEntityExist(self.VehicleTestDrive) then
                        DeleteEntity(self.VehicleTestDrive)
                        self.VehicleTestDrive = nil
                    end
                    Call.Connect("SetRouting", function(result)
                        if result then
                            SendNUIMessage({
                                action = "closeShop"
                            })
                        end
                    end, 0)
                end)

            end
        end, Default.TestDrive.Routing)
    end,

    closeShop = function(self)
        self:detoryCam()
        self:resetPlayerEntity()
        self:deleteLastCar()
        self:deleteLastCartestDrive()
        self.showCoordsVehicle = nil
        self.testDrive = nil
        self.lastCoords = nil
        self.vehicleUI = nil
        self.spawnCoords = nil
    end,

    buyVehicleSuccessfully = function(self)
        self:detoryCam()
        self:deleteLastCar()
        self:deleteLastCartestDrive()
        self.showCoordsVehicle = nil
        self.testDrive = nil
        self.lastCoords = nil
        self.vehicleUI = nil
        self.spawnCoords = nil
        self.ui = false
        SetEntityVisible(PlayerPedId(), 1)
        SetNuiFocus(self.ui, self.ui)
    end,

    GetPlate = function(self, callback)
        Call.Connect("GeneratePlate", function(plate)
            if not plate then
                return
            end
            callback(plate)
        end)
    end
}

requestModel = function(model)
    if not HasModelLoaded(model) and IsModelInCdimage(model) then
        RequestModel(model)

        while not HasModelLoaded(model) do
            Wait(1)
        end
    end
end

checkMyJob = function(job)
    if #job < 1 then
        return true
    end
    for i = 1, #job do
        if job[i] == ESX.PlayerData.job.name then
            return true
        end
    end
    return false
end

Draw3DText = function(label, coords, myCoords)
    RegisterFontFile(Default.fontName)
    local fontId = RegisterFontId(Default.fontName) or 1
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, coords.x, coords.y, coords.z, 1)
    local scale = (1 / dist) * 20
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    SetTextScale(0.035 * scale, 0.035 * scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    local opc = math.floor(255 / #(coords - myCoords) * 4)
    SetTextColour(255, 255, 255, opc > 255 and 255 or opc)
    SetTextDropshadow(15, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString('~y~( ... )~s~\n ' .. label)
    SetDrawOrigin(coords.x, coords.y, coords.z + 1.05, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

checkMoney = function(data)
    for k, v in pairs(ESX.GetPlayerData().accounts) do
        if v.name == data then
            return v.money
        end

    end
end

-- End Function --

-- NUI Callback --
RegisterNUICallback("CloseShop", function(data, cb)
    state:closeShop()
    cb("ok")
end)

RegisterNUICallback("BuyVehicleSuccessfully", function(data, cb)
    state:buyVehicleSuccessfully()
    cb("ok")
end)

RegisterNUICallback("showVehicle", function(data, cb)
    state.vehicleUI = data
    state:showVehicle(function(stats)
        cb(stats)
    end)
end)

RegisterNUICallback("setVehicleRotationRight", function(data, cb)
    if state.vehicle and DoesEntityExist(state.vehicle) then
        SetEntityRotation(state.vehicle, GetEntityRotation(state.vehicle) + vector3(0, 0, 5), false, false, 2, false)
    end
    cb(true)
end)

RegisterNUICallback("setVehicleRotationLeft", function(data, cb)
    if state.vehicle and DoesEntityExist(state.vehicle) then
        SetEntityRotation(state.vehicle, GetEntityRotation(state.vehicle) - vector3(0, 0, 5), false, false, 2, false)
    end
    cb(true)
end)

RegisterNUICallback("setVehicleColor", function(data, cb)
    if state.vehicle and DoesEntityExist(state.vehicle) then
        state:setVehicleColor(data)
    end
    cb(true)
end)

RegisterNUICallback("testDriveVehicle", function(data, cb)
    state:testDriveVehicle()
    cb(true)
end)

RegisterNUICallback('GetMyMoney', function(data, cb)
    local cash = nil
    local bank = nil
    while cash == nil or bank == nil do
        cash = checkMoney('money') or 0
        bank = checkMoney('bank') or 0
    end
    cb({
        cash = cash,
        bank = bank,
        vat = Default.Vat or 0
    })
end)

RegisterNUICallback('BuyVehicle', function(data, cb)
    local vehicleData = ESX.Game.GetVehicleProperties(state.vehicle)
    local modelName = state.vehicleUI.model

    state:GetPlate(function(plate)
        vehicleData.plate = plate
        Call.Connect("checkPrice", function(result)
            if result then
                state:createVehicle(modelName, vehicleData, function(res)
                    if res then
                        print('Create Vehicle Successfully')
                        SendNUIMessage({
                            action = "BuyVehicleSuccessfully"
                        })
                        cb(true)
                    else
                        cb(false)
                    end
                end)
            else
                cb(false)
            end
        end, state.shopIdx, data, modelName ,vehicleData)
    end)
end)

-- End NUI Callback --

-- Main --
ThreadActive = function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for k, v in pairs(Vehicle.ListShop) do
            local coords = vector3(v.coords.x, v.coords.y, v.coords.z)
            local myDistanceCoord = #(playerCoords - coords)
            if myDistanceCoord <= v.DrawText3D.distance and v.DrawText3D.enable and not state.ui then
                sleep = 0
                Draw3DText('[~g~NPC~s~] ' .. v.shopName, coords, playerCoords)
            end
            if myDistanceCoord <= 1.5 and not state.ui then
                sleep = 0
                if IsControlJustPressed(0, Default.keybind.openShop) and checkMyJob(v.requireJob) and not isDead then
                    state:SetCam(k)
                    state:SendDataToNui(k)
                else
                    ESX.ShowNotification(
                        "คุณไม่มีสิทธิ์เข้าใช้งานร้าน")
                end

            end
        end
        Wait(sleep)
    end
end

CreateThread(function()
    while NetworkIsPlayerActive(PlayerId()) ~= 1 do
        Wait(0)
    end
    Call.Connect("getDataVehicles", function(data)
        for _, v in pairs(data) do
            for __, vehicle in pairs(Vehicle.ListShop) do
                if not vehicle.vehicles then
                    vehicle.vehicles = {}
                end
                if vehicle.Categories[v.category] then
                    table.insert(vehicle.vehicles, v)
                end
            end
        end
    end)
    Wait(500)
    CreateThread(ThreadActive)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end
    state:closeShop()
    TriggerServerEvent(tag .. 'SetRouting', 0)

    for _, v in pairs(vehshop) do
        if DoesEntityExist(vehshop.npc) then
            DeleteEntity(vehshop.npc)
            DeletePed(vehshop.npc)
        end
        if DoesBlipExist(vehshop.blip) then
            RemoveBlip(vehshop.blip)
        end
    end
end)

-- End Main --
