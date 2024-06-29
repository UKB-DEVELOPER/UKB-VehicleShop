ESX = nil
TriggerEvent(Base.ServerEvent, function(obj) ESX = obj end)

local tag = GetCurrentResourceName() .. ":"

regEvent = function(name, handler)
    return RegisterNetEvent(tag .. name), AddEventHandler(tag .. name, handler)
end

-- [@ RegiterCallBack of God
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

Call.Create("SetRouting", function(source, cb , miti)
    local _source = source
    SetRouting(_source, miti , function(res)
        cb(res)
    end)
end)

SetRouting = function(source, miti , cb)
    local _source = source
    SetPlayerRoutingBucket(_source, miti)
    cb(true)
end

RegisterCommand('setmiti', function(source, args)
    local _source = source
    local miti = tonumber(args[1])
    SetRouting(_source, miti , function(res)
        if res then
            print("SetRouting Success")
        end
    end)
end)
