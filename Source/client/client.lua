ESX              = nil
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
local tag = GetCurrentResourceName()..":"
local isDead = false
-- 

regEvent = function(name, handler)
	return RegisterNetEvent(tag..name), AddEventHandler(tag..name, handler)
end

regEventESX = function(name, handler)
	return RegisterNetEvent(name), AddEventHandler(name, handler)
end

-- Npc Spawn --
loadAndPlayAnimation = function(animeDict, animeName,send)
	if animeDict == nil then send(true) return end
	RequestAnimDict(animeDict)
	while not HasAnimDictLoaded(animeDict) do
		Wait(0)
	end
	send(animeDict, animeName)
end

Citizen.CreateThread(function()
	for k,v in pairs(Vehicle.ListShop) do
		if v.showType.type == 'npc' then
			local ped = GetHashKey(v.showType.ped.model)
			RequestModel(ped)
			while not HasModelLoaded(ped) do
				Wait(1)
			end
			local npc = CreatePed(4, ped, v.coords.x, v.coords.y, v.coords.z-1.0, v.coords.w, false, false)
			SetBlockingOfNonTemporaryEvents(npc, true)
			SetPedDiesWhenInjured(npc, false)
			SetPedCanPlayAmbientAnims(npc, true)
			SetPedCanRagdollFromPlayerImpact(npc, false)
			SetEntityInvincible(npc, true)
			PlaceObjectOnGroundProperly(npc)
			Wait(800)
			FreezeEntityPosition(npc, true)
			loadAndPlayAnimation(v.showType.ped.animation.dict, v.showType.ped.animation.name, function(dict, name)
				TaskPlayAnim(npc, dict, name, 8.0, 8.0, -1, 1, 0, 0, 0, 0)
			end)
		end
	end
end)
-- End Npc Spawn --

-- Blip --
Citizen.CreateThread(function()
	for k,v in pairs(Vehicle.ListShop) do
		if v.blip.show then
			blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
			SetBlipSprite(blip, v.blip.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, v.blip.scale)
			SetBlipColour(blip, v.blip.color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.blip.name)
			EndTextCommandSetBlipName(blip)
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
	
	SetCam = function(self,idx)
		local shop = Vehicle.ListShop[idx]
		local target = nil
		if not DoesCamExist(self.cam) then
			self.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
			target = vector3(shop.coords.x, shop.coords.y, shop.coords.z) - vector3(0, 0, 1.0)
		end
		if target == nil then
			target = vector3(shop.coords.x, shop.coords.y, shop.coords.z) - vector3(0, 0, 1.0)
		end
		SetCamActive(self.cam, true)
		RenderScriptCams(true, true, 500, true, true)
		self.isCameraActive = true
		SetCamRot(self.cam, 0.0, 0.0, 270.0, true)
		SetCamCoord(self.cam, shop.showCoords.x, shop.showCoords.y, shop.showCoords.z)
		PointCamAtCoord(self.cam, target.x, target.y, target.z)
		SetEntityVisible(PlayerPedId(), 0)	
		SetEntityHeading(PlayerPedId(), 90.0)
	end,
	
	detoryCam = function(self)
		self.isCameraActive = false
		SetCamActive(self.cam, false)
		RenderScriptCams(false, true, 500, true, true)
		self.cam = nil
		ResetEntityAlpha(PlayerPedId())
	end,
	
	SendDataToNui = function(self,idx)
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
		-- SetEntityCoords(PlayerPedId(),  GetEntityCoords(PlayerPedId()))
		SetEntityVisible(PlayerPedId(), 1)
		SetNuiFocus(self.ui, self.ui)
		DisplayRadar(1)
	end
}

checkMyJob = function(job)
	if #job < 1 then return true end
	for i=1,#job do
		if job[i] == ESX.PlayerData.job.name then
			return true
		end
	end
	return false
end

Draw3DText = function(label,coords,myCoords)
	RegisterFontFile(Setting.fontName)
	local fontId  = RegisterFontId(Setting.fontName) or 1
	local px, py, pz = table.unpack(GetGameplayCamCoord())
	local dist = GetDistanceBetweenCoords(px, py, pz, coords.x, coords.y, coords.z, 1)
	local scale = (1 / dist) * 20
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov
	SetTextScale(0.035 * scale , 0.035 * scale)
	SetTextFont(fontId)
	SetTextProportional(1)
	local opc = math.floor(255/#(coords-myCoords)*4)
	SetTextColour(255, 255, 255, opc > 255 and 255 or opc)
	SetTextDropshadow(15, 1, 1, 1, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString('~y~( ... )~s~\n[~g~NPC~s~] '.. label)
	SetDrawOrigin(coords.x, coords.y, coords.z + 1.05, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end


-- End Function --

-- NUI Callback --
RegisterNUICallback("CloseShop", function(data, cb)
	state:detoryCam()
	state:resetPlayerEntity()
	cb("ok")
end)

-- End NUI Callback --


-- Main --
ThreadActive = function()
	while true do
		local sleep = 1000
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		for k,v in pairs(Vehicle.ListShop) do
			local coords = vector3(v.coords.x, v.coords.y, v.coords.z)
			local myDistanceCoord = #(playerCoords - coords)
			if myDistanceCoord <= v.DrawText3D.distance and v.DrawText3D.enable and not state.ui then
				sleep = 0
				Draw3DText(v.shopName, coords, playerCoords)
			end
			if myDistanceCoord <= 1.5 and not state.ui then
				sleep = 0
				if IsControlJustPressed(0, Default.keybind.openShop) and checkMyJob(v.requireJob)then
					state:SetCam(k)
					state:SendDataToNui(k)
				else
					ESX.ShowNotification("คุณไม่มีสิทธิ์เข้าใช้งานร้าน")
				end

			end
		end
		Wait(sleep)
	end
end

CreateThread(ThreadActive)

-- End Main --
