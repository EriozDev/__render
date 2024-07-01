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

RegisterCommand('account', function(source, args, rawCommand)
    local source = source
    local groups = player:getGroup(source)
    if groups == 'owner' then
        if #args > 0 then
            local account = args[1]
            MySQL.Async.fetchAll('SELECT * FROM render_accounts WHERE account_id = @account', {
                ['@account'] = account
            }, function(result)
                if result[1] then
                    local dbPlayer = result[1]
                    local name = dbPlayer.name
                    local group = dbPlayer.player_group
                    local a = dbPlayer.account_id
                    TriggerClientEvent('chatMessage', source, "SYSTEME", { 0, 0, 0 },
                        "AccountID : " .. a .. " Name : " .. name .. ' Group : ' .. group)
                else
                    TriggerClientEvent('chatMessage', source, "SYSTEME", { 0, 0, 0 }, "AccountID Incorrect")
                end
            end)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEME", { 0, 0, 0 }, "AccountID Incorrect")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEME", { 0, 0, 0 }, "Permission Insuffisante !")
    end
end)

