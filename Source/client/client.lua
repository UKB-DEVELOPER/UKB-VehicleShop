ESX              = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
	PlayerData = ESX.GetPlayerData()
end)

local ResourceName = GetCurrentResourceName()

RegisterCommand('openV', function(source, args, rawCommand)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = true,
		resource = ResourceName
	})
end, false)

RegisterNUICallback('CloseUI', function(data, cb)
	SetNuiFocus(false, false)
	print(json.encode(data))
	cb("ok")
end)
