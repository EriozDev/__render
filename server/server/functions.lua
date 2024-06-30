__RENDER = {}
local serverCallbacks = {}

function __RENDER.EmitClient(eventName, target, ...)
    TriggerClient(eventName, target, ...)
    IO.DEBUG('[^6DEBUG^0 => EmitClient => ', eventName)
end

function __RENDER.getAccountUniqueIdByLicense(license)
    local query = "SELECT account_id FROM render_accounts WHERE license = @license"
    local params = { ['@license'] = license }

    local result = MySQL.Sync.fetchAll(query, params)

    if result and result[1] then
        return result[1].account_id
    else
        return nil
    end
end

---@param eventName string
---@param callback function
function __RENDER.RegisterServerCallback(eventName, callback)
    serverCallbacks[eventName] = callback
end

RegisterNetEvent("__render:triggerServerCallback", function(eventName, requestId, invoker, ...)
    if not serverCallbacks[eventName] then
        return print(("[^1ERROR^7] Server Callback not registered, name: ^5%s^7, invoker resource: ^5%s^7"):format(eventName, invoker))
    end

    local source = source

    serverCallbacks[eventName](source, function(...)
        TriggerClientEvent("__render:serverCallback", source, requestId, invoker, ...)
    end, ...)
end)
