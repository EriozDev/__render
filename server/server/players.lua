function getPlayerPositionFromDB(license)
    local result = MySQL.Sync.fetchAll('SELECT pos_x, pos_y, pos_z FROM render_accounts WHERE license = @license', {
        ['@license'] = license
    })

    if result[1] then
        if result[1].pos_x == 0 and result[1].pos_y == 0 and result[1].pos_z == 0 then
            return CONFIG.DefaultCoords.x, CONFIG.DefaultCoords.y, CONFIG.DefaultCoords.z
        end
        return result[1].pos_x, result[1].pos_y, result[1].pos_z
    else
        print("No player found with license: " .. license)
        return nil, nil, nil
    end
end


RegisterNetEvent('__render:onJoin')
AddEventHandler('__render:onJoin', function()
    local joueur = source
    local playerName = GetPlayerName(joueur)
    local license = GetPlayerIdentifierByType(joueur, 'license')
    local discordId = GetPlayerIdentifierByType(joueur, 'discord')
    local groupBase = 'user'
    local groupPlayer = player:getGroup(joueur)

    local posX, posY, posZ = getPlayerPositionFromDB(license)

    print("Player Loaded: ", playerName)
    print("License: ", license)
    print("Discord ID: ", discordId)
    print("Group: ", groupPlayer)
    print("Position: ", posX, posY, posZ)

    MySQL.Async.fetchAll('SELECT * FROM render_accounts WHERE license = @license', {
        ['@license'] = license
    }, function(result)
        if result[1] then
            local dbPlayer = result[1]
            if dbPlayer.name ~= playerName or dbPlayer.pos_x ~= posX or dbPlayer.pos_y ~= posY or dbPlayer.pos_z ~= posZ then
                MySQL.Async.execute(
                    'UPDATE render_accounts SET name = @name, pos_x = @pos_x, pos_y = @pos_y, pos_z = @pos_z WHERE license = @license',
                    {
                        ['@name'] = playerName,
                        ['@pos_x'] = posX,
                        ['@pos_y'] = posY,
                        ['@pos_z'] = posZ,
                        ['@license'] = license
                    })
            end
        else
            MySQL.Async.execute(
                'INSERT INTO render_accounts (account_id, name, license, discord, player_group, date_connected, time_connected, pos_x, pos_y, pos_z) VALUES (@account_id, @name, @license, @discord, @group, @date, @time, @pos_x, @pos_y, @pos_z)',
                {
                    ['@account_id'] = FrameWork.managers.generateAccountId(),
                    ['@name'] = playerName,
                    ['@license'] = license,
                    ['@discord'] = discordId,
                    ['@group'] = groupBase,
                    ['@date'] = os.date('%Y-%m-%d'),
                    ['@time'] = os.date('%H:%M:%S'),
                    ['@pos_x'] = posX,
                    ['@pos_y'] = posY,
                    ['@pos_z'] = posZ
                })
        end
    end)
end)

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    local source = source
    local license = GetPlayerIdentifierByType(source, 'license')

    deferrals.defer()

    MySQL.Async.fetchAll('SELECT * FROM render_accounts WHERE license = @license', {
        ['@license'] = license
    }, function(result)
        if result[1] then
            local spawnPos = getPlayerPositionFromDB(license)
            deferrals.update('Spawning player at position...')
            deferrals.done()

            TriggerClientEvent('playerSpawn', source, spawnPos)
        else
            deferrals.done('Failed to retrieve player data.')
        end
    end)
end)


function SaveOrUpdatePlayerPosition(position)
    local license = GetPlayerIdentifierByType(source, 'license')
    if not license then
        return
    end

    MySQL.Async.fetchAll('SELECT * FROM render_accounts WHERE license = @license', {
        ['@license'] = license
    }, function(result)
        if result and result[1] then
            MySQL.Async.execute(
                'UPDATE render_accounts SET pos_x = @pos_x, pos_y = @pos_y, pos_z = @pos_z WHERE license = @license',
                {
                    ['@pos_x'] = position.x,
                    ['@pos_y'] = position.y,
                    ['@pos_z'] = position.z,
                    ['@license'] = license
                },
                function(rowsChanged)
                    if rowsChanged > 0 then
                        print(("Position updated for license %s to x: %s, y: %s, z: %s"):format(license, position.x, position.y, position.z))
                    else
                        print(("No position update needed for license %s"):format(license))
                    end
                end
            )
        else
            print(("Player with license %s not found in database. Cannot update position."):format(license))
        end
    end)
end

RegisterNetEvent('__render:position')
AddEventHandler('__render:position', function (pos)
    SaveOrUpdatePlayerPosition(pos)
end)

