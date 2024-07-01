ANTICHEAT = {}

AddEventHandler('explosionEvent', function(sender, data)
    if data.posX == 0.0 or data.posY == 0.0 or data.posZ == 0.0 or data.posZ == -1700.0 or (data.cameraShake == 0.0 and data.damageScale == 0.0 and data.isAudible == false and data.isInvisible == false) then
        CancelEvent()
        return
    else
        print('[^1AC^0] Joueur : [' ..
            (sender or '') ..
            '] ' .. (GetPlayerName(sender) or '') .. ' created an explosion ' .. (json.encode(data) or ''))
    end
end)


function generateToken()
    local charset = "0123456789abcdefghijklmnopqrstuvwxyz"
    local length = 128
    local token = ""

    for i = 1, length do
        local randIndex = math.random(1, #charset)
        token = token .. charset:sub(randIndex, randIndex)
    end

    return token
end

local eventRegister = {}

function ANTICHEAT.registerSafeEvent(eventName, EventFN)
    local eventToken = generateToken()
    eventRegister[eventName] = eventToken

    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function(receivedToken, ...)
        local source = source
        if receivedToken ~= eventRegister[eventName] then
            print("[^1AC^0] => [^2TRIGGER^0] => Player => ^5" ..
                GetPlayerName(source) ..
                " [" ..
                source ..
                "] (" ..
                GetPlayerIdentifierByType(source, 'license') ..
                ")^0 attempt to execute trigger => ^3" .. eventName .. "^0")

            eventRegister[eventName] = generateToken()

            TriggerClientEvent('shadow:syncTokens', -1, eventRegister)
            return
        end

        EventFN(...)
        eventRegister[eventName] = generateToken()
        TriggerClientEvent('shadow:syncTokens', -1, eventRegister)
    end)
end

RegisterNetEvent('shadow:requestSyncTokens')
AddEventHandler('shadow:requestSyncTokens', function()
    local source = source
    TriggerClientEvent('shadow:syncTokens', source, eventRegister)
end)

AddEventHandler("entityRemoved", function(e)
    if (GetEntityPopulationType(e) == 7) then
        local owner = NetworkGetFirstEntityOwner(e)
        local a = NetworkGetEntityOwner(e)

        if (owner ~= a) then
            print("[^1AC^0] => [^4DETECTIONS^0] => Player => ^5" ..
                GetPlayerName(owner) ..
                " [" ..
                owner ..
                "] (" ..
                GetPlayerIdentifierByType(owner, 'license') ..
                ")^0 attempt to remove entity => ^0")

            DropPlayer(owner, 'Cheat => Attempt to remove entity')
        end
    end
end)
