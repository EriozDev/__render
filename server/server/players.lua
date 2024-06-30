RegisterNetEvent('__render:onJoin')
AddEventHandler('__render:onJoin', function()
    local joueur = source
    local playerName = GetPlayerName(joueur)
    local license = GetPlayerIdentifierByType(joueur, 'license')
    local discordId = GetPlayerIdentifierByType(joueur, 'discord')
    local groupBase = 'user'
    local groupPlayer = player:getGroup(joueur)

    MySQL.Async.fetchAll('SELECT * FROM render_accounts WHERE license = @license', {
        ['@license'] = license
    }, function(result)
        if result[1] then
            local dbPlayer = result[1]
            if dbPlayer.name ~= playerName then
                MySQL.Async.execute(
                    'UPDATE render_accounts SET name = @name WHERE license = @license',
                    {
                        ['@name'] = playerName,
                        ['@license'] = license
                    })
            end
        else
            MySQL.Async.execute(
                'INSERT INTO render_accounts (account_id, name, license, discord, player_group, date_connected, time_connected) VALUES (@account_id, @name, @license, @discord, @group, @date, @time)',
                {
                    ['@account_id'] = FrameWork.managers.generateAccountId(),
                    ['@name'] = playerName,
                    ['@license'] = license,
                    ['@discord'] = discordId,
                    ['@group'] = groupBase,
                    ['@date'] = os.date('%Y-%m-%d'),
                    ['@time'] = os.date('%H:%M:%S')
                })
        end
    end)
end)

