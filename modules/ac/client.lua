ANTICHEAT = {}

local eventRegister = {}

function ANTICHEAT.TriggerServerSafeEvent(eventName, ...)
    local token = eventRegister[eventName]
    if not token then
        print("Token is not set, cannot trigger event")
        return
    end
    TriggerServerEvent(eventName, token, ...)
end

RegisterNetEvent('shadow:syncTokens')
AddEventHandler('shadow:syncTokens', function(tokens)
    for eventName, token in pairs(tokens) do
        eventRegister[eventName] = token
    end
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerServerEvent('shadow:requestSyncTokens')
    end
end)
