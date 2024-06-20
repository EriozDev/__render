__RENDER = {}

function __RENDER.EmitClient(eventName, target, ...)
    TriggerClient(eventName, target, ...)
    IO.DEBUG('[^6DEBUG^0 => EmitClient => ', eventName)
end
