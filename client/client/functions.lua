__RENDER = {}

function __RENDER.EmitServer(eventName, ...)
    TriggerServerEvent(eventName, ...)
    SCRIPT.DEBUG('[^6DEBUG^0 => EmitServer => ', eventName)
end

function __RENDER.EmitSafeServer(eventName, ...)
    TriggerServerEvent(eventName, CONFIG.tokenSafeEvents, ...)
    SCRIPT.DEBUG('[^6DEBUG^0 => EmitSafeServer => ', eventName)
end

local RequestId = 0
local serverRequests = {}

---@param eventName string
---@param callback function
---@param ... any
__RENDER.TriggerServerCallback = function(eventName, callback, ...)
    serverRequests[RequestId] = callback

    TriggerServerEvent("__render:triggerServerCallback", eventName, RequestId, GetInvokingResource() or "unknown", ...)

    RequestId = RequestId + 1
end

function __RENDER.SpawnPlayer(model, coords, heading)
    Citizen.CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end

        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            Citizen.Wait(0)
        end

        local playerPed = CreatePed(4, model, coords.x, coords.y, coords.z, 0.0, true, true)

        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
        SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, true, true, true)
        SetEntityVisible(PlayerPedId(), true)

        SetEntityCollision(PlayerPedId(), true, true)
        FreezeEntityPosition(PlayerPedId(), false)
        SetPlayerInvincible(PlayerId(), false)
        ClearPedTasks(PlayerPedId())
        SetEntityVisible(PlayerPedId(), true)
        SetEntityAlpha(PlayerPedId(), 255, false)

        SetModelAsNoLongerNeeded(pedModel)

        TriggerEvent('playerSpawned', coords)

    end)
end

RegisterNetEvent("__render:serverCallback", function(requestId, invoker, ...)
    if not serverRequests[requestId] then
        return
    end

    serverRequests[requestId](...)
    serverRequests[requestId] = nil
end)
