__RENDER = {}

function __RENDER.EmitClient(eventName, target, ...)
    TriggerClient(eventName, target, ...)
    IO.DEBUG('[^6DEBUG^0 => EmitClient => ', eventName)
end

function __RENDER.RegisterServerSafeEvent(eventName, event)
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function(token, ...)
        local _src = source
        if token ~= CONFIG.tokenSafeEvents then
            DropPlayer(_src, 'Cheat => Attempt to exploit event => ', eventName)
            IO.DEBUG('[^3TRIGGER^0] Player => ' ..
                player:getPlayerName(_src) ..
                ' [' .. source .. '] (' ..
                player:getIdentifier(_src) .. ') => Attempt to execute trigger => ^4' .. eventName .. '^0')
            return
        end
        event(...)
    end)
end
