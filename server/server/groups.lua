local players = {}

Player = {}
Player.__index = Player

function Player.new(source)
    local self = setmetatable({}, Player)
    self.source = source
    self.Data = {
        Group = "user"
    }
    return self
end

function __RENDER.getPlayerBySource(source)
    return players[source]
end


function __RENDER.HavePermission(joueur, requiredGroup)
    local playerGroup = player:getGroup(joueur)
    
    if not playerGroup then
        return false
    end
    
    local playerRank, requiredRank

    for key, group in pairs(CONFIG.Group) do
        if group == playerGroup then
            playerRank = key
        end
        if group == requiredGroup then
            requiredRank = key
        end
    end

    if playerRank and requiredRank and playerRank >= requiredRank then
        return true
    else
        return false
    end
end

function updatePlayerGroupInDB(license, group)
    local validGroup = false
    for key, value in pairs(CONFIG.Group) do
        if value == group then
            validGroup = true
            break
        end
    end

    if not validGroup then
        print(("Invalid group specified: %s"):format(group))
        return
    end

    MySQL.Async.execute(
        'UPDATE render_accounts SET player_group = @group WHERE license = @license',
        {
            ['@group'] = group,
            ['@license'] = license
        },
        function(rowsChanged)
            print(("Updated group for license %s to %s"):format(license, group))
        end
    )
end

RegisterCommand('setgroup', function(source, args)
    if __RENDER.HavePermission(source, 'owner') then
        local group = args[1]
        local i = player:getIdentifier(source)
        if group then
            updatePlayerGroupInDB(i, group)
        end
    else
        print('The command setgroup required a permission owner for use !')
    end
end)

RegisterNetEvent('updateGroupDB')
AddEventHandler('updateGroupDB', function(group)
    local license = player:getIdentifier(source)
    updatePlayerGroupInDB(license, group)
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local player = Player.new(source)
    players[source] = player
end)
