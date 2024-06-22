RegisterNetEvent('__render:onJoin')
AddEventHandler('__render:onJoin', function()
    local player = source
    local playerName = GetPlayerName(player)
    local license = GetIdentifierByType(player, 'license')
    local discordId = GetIdentifierByType(player, 'discord')
    local group = 'user'
    local position = GetEntityCoords(GetPlayerPed(player))

    print("Player Loaded: ", playerName)
    print("License: ", license)
    print("Discord ID: ", discordId)
    print("Group: ", group)
    print("Position: ", position)

    MySQL.Async.fetchAll('SELECT * FROM render_accounts WHERE license = @license', {
        ['@license'] = license
    }, function(result)
        if result[1] then
            local dbPlayer = result[1]
            if dbPlayer.name ~= playerName or dbPlayer.player_group ~= group or dbPlayer.pos_x ~= position.x or dbPlayer.pos_y ~= position.y or dbPlayer.pos_z ~= position.z then
                MySQL.Async.execute(
                    'UPDATE render_accounts SET name = @name, player_group = @group, pos_x = @pos_x, pos_y = @pos_y, pos_z = @pos_z WHERE license = @license',
                    {
                        ['@name'] = playerName,
                        ['@group'] = group,
                        ['@pos_x'] = position.x,
                        ['@pos_y'] = position.y,
                        ['@pos_z'] = position.z,
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
                    ['@group'] = group,
                    ['@date'] = os.date('%Y-%m-%d'),
                    ['@time'] = os.date('%H:%M:%S'),
                    ['@pos_x'] = position.x,
                    ['@pos_y'] = position.y,
                    ['@pos_z'] = position.z
                })
        end
    end)
end)
