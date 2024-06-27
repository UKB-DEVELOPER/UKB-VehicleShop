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
		action = "isDead"
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

    SetCam = function(self, idx)
        local shop = Vehicle.ListShop[idx]
        self.showCoordsVehicle = shop.showCoords
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
            ImageCarPath = Default.ImageCarPath
        })
        SetNuiFocus(self.ui, self.ui)
    end,

    resetPlayerEntity = function(self)
        self.ui = false
        SetEntityCoords(PlayerPedId(), self.lastCoords)
        SetEntityVisible(PlayerPedId(), 1)
        SetNuiFocus(self.ui, self.ui)
        DisplayRadar(1)
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


    showVehicle = function(self)
		self:deleteLastCar()

        local model = (type(self.vehicleUI.model) == 'number' and self.vehicleUI.model or GetHashKey(self.vehicleUI.model))

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

        RequestCollisionAtCoord(
			self.showCoordsVehicle.x,
			self.showCoordsVehicle.y,
			self.showCoordsVehicle.z
		)

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

    end,

	setVehicleColor = function(self, data)
		if self.vehicle and DoesEntityExist(self.vehicle) then
			if data.type == 'primary' then
				SetVehicleCustomPrimaryColour(self.vehicle, data.r, data.g, data.b)
			elseif data.type == 'secondary' then
				SetVehicleCustomSecondaryColour(self.vehicle, data.r, data.g, data.b)
			end
		end
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
    RegisterFontFile(Setting.fontName)
    local fontId = RegisterFontId(Setting.fontName) or 1
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
    AddTextComponentString('~y~( ... )~s~\n[~g~NPC~s~] ' .. label)
    SetDrawOrigin(coords.x, coords.y, coords.z + 1.05, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

-- End Function --

-- NUI Callback --
RegisterNUICallback("CloseShop", function(data, cb)
    state:detoryCam()
    state:resetPlayerEntity()
    state:deleteLastCar()
    state.showCoordsVehicle = nil
    cb("ok")
end)

RegisterNUICallback("showVehicle", function(data, cb)
    state.vehicleUI = data
    state:showVehicle()
    cb("ok")
end)

RegisterNUICallback("setVehicleRotationRight", function(data, cb)
	if state.vehicle and DoesEntityExist(state.vehicle) then
        SetEntityRotation(state.vehicle, GetEntityRotation(state.vehicle) + vector3(0,0,5), false, false, 2, false)
    end
	cb(true)
end)

RegisterNUICallback("setVehicleRotationLeft", function(data, cb)
	if state.vehicle and DoesEntityExist(state.vehicle) then
        SetEntityRotation(state.vehicle, GetEntityRotation(state.vehicle) - vector3(0,0,5), false, false, 2, false)
    end
	cb(true)
end)

RegisterNUICallback("setVehicleColor", function(data, cb)
	if state.vehicle and DoesEntityExist(state.vehicle) then
		state:setVehicleColor(data)
	end
	cb(true)
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
                Draw3DText(v.shopName, coords, playerCoords)
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
    Wait(500)
    CreateThread(ThreadActive)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end
    if state.ui then
        state:detoryCam()
        state:resetPlayerEntity()
        state:deleteLastCar()
    end

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
