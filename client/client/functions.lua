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

RegisterNetEvent("__render:serverCallback", function(requestId, invoker, ...)
    if not serverRequests[requestId] then
        return print(("[^1ERROR^7] Server Callback with requestId ^5%s^7 Was Called by ^5%s^7 but does not exist."):format(requestId, invoker))
    end

    serverRequests[requestId](...)
    serverRequests[requestId] = nil
end)
