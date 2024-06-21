__RENDER = {}

function __RENDER.EmitServer(eventName, ...)
    TriggerServerEvent(eventName, ...)
    SCRIPT.DEBUG('[^6DEBUG^0 => EmitServer => ', eventName)
end

function __RENDER.EmitSafeServer(eventName, ...)
    TriggerServerEvent(eventName, CONFIG.tokenSafeEvents, ...)
    SCRIPT.DEBUG('[^6DEBUG^0 => EmitSafeServer => ', eventName)
end
