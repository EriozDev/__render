Pplayers = {}

Pplayers.__index = Pplayers
Pplayers.playerTable = {}

-- Define Player class
Player = {}
Player.__index = Player

function Player.new(source, UserID)
    local self = setmetatable({}, Player)
    self.source = source
    self.UserID = UserID
    self.Data = {
        Group = "user"
    }
    return self
end

-- Function to create a new player and add to playerTable
function Pplayers:AddPlayer(source, UserID)
    local player = Player.new(source, UserID)
    self.playerTable[source] = player
    return player
end

function Pplayers:RemovePlayer(source)
    self.playerTable[source] = nil
end

-- Function to get player by source
function __RENDER.getPlayerBySource(source)
    return Pplayers.playerTable[source]
end

function __RENDER.GetPlayers()
    local players = {}
    for source, player in pairs(Pplayers.playerTable) do
        table.insert(players, source)
    end
    return players
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
        print('The command setgroup requires owner permission to use!')
    end
end)

RegisterNetEvent('updateGroupDB')
AddEventHandler('updateGroupDB', function(group)
    local license = player:getIdentifier(source)
    updatePlayerGroupInDB(license, group)
end)

AddEventHandler('__render:onJoin', function ()
    local src = source
    local userID = GetPlayerIdentifier(src, 'license') -- Assuming license as UserID
    Pplayers:AddPlayer(src, userID)
    print('The player ' .. tostring(src) .. ' has been added to the players table with the player instance')
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    Pplayers:RemovePlayer(src)
    print('The player ' .. tostring(src) .. ' has been removed from the players table')
end)
