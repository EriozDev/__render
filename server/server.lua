Utils = {}
Utils.Player = {}

function Utils.log(msg)
    print('[__render log] => ', msg)
end

function Utils.Player.getPlayerName(player)
    return GetPlayerName(player)
end

function Utils.Player.getPlayerPing(player)
    return GetPlayerPing(player)
end

function Utils.Player.GetIdentifier(source)
    local identifiers = GetIdentifiers(source)
    return identifiers[1]
end

function Utils.GetTimestamp()
    return os.time()
end

