__RENDER = {}

function __RENDER.EmitServer(eventName, ...)
    TriggerServerEvent(eventName, ...)
    SCRIPT.DEBUG('[^6DEBUG^0 => EmitServer => ', eventName)
end
