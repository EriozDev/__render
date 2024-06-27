RegisterNetEvent('__render:onJoin')
AddEventHandler('__render:onJoin', function()
    local joueur = source
    local accountid = player:getAccountId(joueur)
    local license = GetPlayerIdentifierByType(joueur, 'license')
    local name = GetPlayerName(joueur)

    MySQL.Async.fetchAll('SELECT * FROM render_money WHERE license = @license', {
        ['@license'] = license
    }, function(result)
        if result[1] then
            local dbPlayer = result[1]
            if dbPlayer.name ~= name then
                MySQL.Async.execute(
                    'UPDATE render_money SET name = @name WHERE license = @license',
                    {
                        ['@name'] = name
                    })
            end
        else
            MySQL.Async.execute(
                'INSERT INTO render_money (account_id, license, name, bank, cash, dirty) VALUES (@account_id, @license, @name, @bank, @cash, @dirty)',
                {
                    ['@account_id'] = accountid,
                    ['@license'] = license,
                    ['@name'] = name,
                    ['@bank'] = CONFIG.DefaultMonneyBank,
                    ['@cash'] = CONFIG.DefaultMonneyCash,
                    ['@dirty'] = CONFIG.DefaultMonneyDirty
                })
        end
    end)
end)

RegisterCommand('givemoney', function(source, args, rawCommand)
    local _src = source
    local type = args[1]
    local newMoney = tonumber(args[2])
    if type == 'bank' or type == 'cash' or type == 'dirtycash' then
        if type == 'bank' then
            player:addMoneyBank(_src, newMoney)
        elseif type == 'cash' then
            player:addMoneyCash(_src, newMoney)
        elseif type == 'dirtycash' then
            player:addMoneyDirty(_src, newMoney)
        end
    end
end)
