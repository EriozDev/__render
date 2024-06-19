Utils = {}
player = {}

function Utils.log(msg)
    print('[__render log] => ', msg)
end

function player:getPlayerName(player)
    return GetPlayerName(player)
end

function player:getPlayerPing(player)
    return GetPlayerPing(player)
end

function player:getIdentifier(player)
    local identifier = GetPlayerIdentifierByType(player, 'license')
    return identifier
end
