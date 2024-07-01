IO.WARN('bans = {}')

bans = {}

function bans:__debug(callback)
    MySQL.Async.fetchAll('SELECT accountid FROM render_bans', {}, function(result)
        local account_id = {}
        for i = 1, #result, 1 do
            table.insert(account_id, result[i].accountid)
        end
        if callback then
            callback(account_id)
        end
    end)
end

if DEV then
    bans:__debug(function(account_id)
        for _, accountid in ipairs(account_id) do
            print('(^6DEBUG^0) => (^3Bans^0) => Loaded => ', accountid)
        end
    end)
end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function Logs(name, message, color)
    if message == nil or message == '' then
        return false
    end

    local embeds = {
        {
            ['title'] = message,
            ['type'] = 'rich',
            ['color'] = color,
            ['footer'] = {
                ['text'] = 'render_bans'
            }
        }
    }

    PerformHttpRequest(logs, function() end, 'POST', json.encode({ username = name, embeds = embeds }),
        { ['Content-Type'] = 'application/json' })
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local _source = source
    local license, playerip = 'N/A', 'N/A'
    license = player:getIdentifier(_source)
    --playerip = GetPlayerEndpoint(_source)

    if not license then
        setKickReason('Identifier invalid !')
        CancelEvent()
    end

    deferrals.defer()
    Citizen.Wait(0)
    deferrals.update(('Vérification de %s en cours...'):format(playerName))
    Citizen.Wait(0)

    IsBanned(license, function(isBanned, banData)
        if isBanned then
            if tonumber(banData.permanent) == 1 then
                deferrals.done(('Vous êtes banni de %s\nRaison : %s\nTemps Restant : Indéterminée\nAuteur : %s\nBanID : %s')
                :format(
                    CONFIG.ServerName, banData.reason, banData.sourceName, banData.banid))
            else
                if tonumber(banData.expiration) > os.time() then
                    local timeRemaining = tonumber(banData.expiration) - os.time()
                    deferrals.done(('Vous êtes banni de %s\nRaison : %s\nTemps Restant : %s\nAuteur : %s\nBanID : %s')
                    :format(
                        CONFIG.ServerName, banData.reason, SexyTime(timeRemaining), banData.sourceName, banData.banid))
                else
                    DeleteBan(license)
                    deferrals.done()
                end
            end
        else
            deferrals.done()
        end
    end)
end)

function generateBanID()
    local charset = "0123456789abcdefghijklmnopqrstuvwxyz"
    local length = 24
    local banID = ""

    for i = 1, length do
        local randIndex = math.random(1, #charset)
        banID = banID .. charset:sub(randIndex, randIndex)
    end

    return banID
end

RegisterServerEvent('BanSql:ICheatClient')
AddEventHandler('BanSql:ICheatClient', function(reason)
    local _source = source
    local licenseid, playerip, accountid = 'N/A', 'N/A', 'N/A'

    if reason == nil then
        reason = 'Cheat'
    end

    if _source then
        local name = GetPlayerName(_source)

        if name then
            accountid = player:getAccountId(_source)
            licenseid = player:getIdentifier(_source)
            --playerip = GetPlayerEndpoint(_source)

            if not accountid then
                accountid = 'N/A'
            end

            AddBan(_source, licenseid, accountid, name, 'Anti-Cheat', 0, reason, 1)
            DropPlayer(_source,
                ('Vous êtes banni de %s\nRaison : %s\nTemps Restant : Indéterminée\nAuteur : Anti-Cheat'):format(
                    CONFIG.ServerName, reason))
        end
    else
        print('BanSql Error : Anti-Cheat have received invalid id.')
    end
end)

AddEventHandler('BanSql:ICheatServer', function(target, reason)
    local licenseid, playerip, accountid = 'N/A', 'N/A', 'N/A'

    if reason == nil then
        reason = 'Cheat'
    end

    if target then
        local name = GetPlayerName(target)

        if name then
            accountid = player:getAccountId(target)
            licenseid = player:getIdentifier(target)

            if not accountid then
                accountid = 'N/A'
            end

            AddBan(target, licenseid, accountid, name, 'Anti-Cheat', 0, reason, 1)
            DropPlayer(target,
                ('Vous êtes banni de %s\nRaison : %s\nTemps Restant : Indéterminée\nAuteur : Anti-Cheat'):format(
                    CONFIG.ServerName, reason))
        end
    else
        print('BanSql Error : Anti-Cheat have received invalid id.')
    end
end)

function SexyTime(seconds)
    local days = seconds / 86400
    local hours = (days - math.floor(days)) * 24
    local minutes = (hours - math.floor(hours)) * 60
    seconds = (minutes - math.floor(minutes)) * 60
    return ('%s jours %s heures %s minutes %s secondes'):format(math.floor(days), math.floor(hours), math.floor(minutes),
        math.floor(seconds))
end

function SendMessage(source, message)
    if source ~= 0 then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1BanInfo ', message } })
    else
        print(('SqlBan: %s'):format(message))
    end
end

function AddBan(source, banid, licenseid, accountid, targetName, sourceName, time, reason, permanent)
    time = time * 3600
    local timeat = os.time()
    local expiration = time + timeat

    MySQL.Async.execute(
        'INSERT INTO render_bans (banid, licenseid, accountid, targetName, sourceName, reason, timeat, expiration, permanent) VALUES (@banid, @licenseid, @accountid, @targetName, @sourceName, @reason, @timeat, @expiration, @permanent)',
        {
            ['@banid'] = banid,
            ['@licenseid'] = licenseid,
            ['@accountid'] = accountid,
            ['@targetName'] = targetName,
            ['@sourceName'] = sourceName,
            ['@reason'] = reason,
            ['@timeat'] = timeat,
            ['@expiration'] = expiration,
            ['@permanent'] = permanent
        }, function()
            MySQL.Async.execute(
                'INSERT INTO render_bans_history (banid, licenseid, accountid, targetName, sourceName, reason, timeat, expiration, permanent) VALUES (@banid, @licenseid, @accountid, @targetName, @sourceName, @reason, @timeat, @expiration, @permanent)',
                {
                    ['@banid'] = banid,
                    ['@licenseid'] = licenseid,
                    ['@accountid'] = accountid,
                    ['@targetName'] = targetName,
                    ['@sourceName'] = sourceName,
                    ['@reason'] = reason,
                    ['@timeat'] = timeat,
                    ['@expiration'] = expiration,
                    ['@permanent'] = permanent
                })

            if permanent == 0 then
                SendMessage(source,
                    (('Vous avez banni %s / Durée : %s / Raison : %s'):format(targetName, SexyTime(time), reason)))
            else
                SendMessage(source,
                    (('Vous avez banni %s / Durée : Indéterminée / Raison : %s'):format(targetName, reason)))
            end
        end)
end

function DeleteBan(banid, cb)
    MySQL.Async.execute('DELETE FROM render_bans WHERE banid = @banid', {
        ['@banid'] = banid
    }, function()
        if cb then
            cb()
        end
    end)
end

function IsBanned(license, cb)
    MySQL.Async.fetchAll('SELECT * FROM render_bans WHERE licenseid = @license', {
        ['@license'] = license
    }, function(result)
        if #result > 0 then
            cb(true, result[1])
        else
            cb(false, result[1])
        end
    end)
end

RegisterCommand('ban', function(source, args, user)
    local licenseid = 'N/A'
    local target = tonumber(args[1])
    local expiration = tonumber(args[2])
    local reason = table.concat(args, ' ', 3)
    local banid = generateBanID()
    local groups = player:getGroup(source)

    if groups == 'mod' or groups == 'admin' or groups == 'superadmin' or groups == 'owner' then
        if target and target > 0 then
            local sourceName = GetPlayerName(source)
            local targetName = GetPlayerName(target)

            if targetName then
                if expiration and expiration <= 336 then
                    licenseid = player:getIdentifier(target)
                    local accountid = player:getAccountId(target)

                    if not licenseid then
                        licenseid = 'N/A'
                    end

                    if reason == '' then
                        reason = ''
                    end

                    if expiration > 0 then
                        AddBan(source, banid, licenseid, accountid, targetName, sourceName, expiration, reason, 0)
                        DropPlayer(target,
                            ('Vous êtes banni de %s\nRaison : %s\nTemps Restant : %s\nAuteur : %s\nBanID : %s')
                            :format(
                                CONFIG.ServerName,
                                reason, SexyTime(expiration * 3600), sourceName, banid))
                    else
                        AddBan(source, banid, licenseid, accountid, targetName, sourceName, expiration, reason, 1)
                        DropPlayer(target,
                            ('Vous êtes banni de %s\nRaison : %s\nTemps Restant : Indéterminée\nAuteur : %s\nBanID : %s')
                            :format(
                                CONFIG.ServerName, reason, sourceName, banid))
                    end
                else
                    SendMessage(source, 'Time Invalid')
                end
            else
                SendMessage(source, 'ID Invalid')
            end
        else
            SendMessage(source, 'ID Invalid')
        end
    end
end)

RegisterCommand('banoffline', function(source, args, user)
    local accountid = tostring(args[1])
    local expiration = tonumber(args[2])
    local reason = table.concat(args, ' ', 3)
    local sourceName = GetPlayerName(source)
    local banid = generateBanID()
    local groups = player:getGroup(source)

    if groups == 'mod' or groups == 'admin' or groups == 'superadmin' or groups == 'owner' then
        if expiration then
            if accountid then
                MySQL.Async.fetchAll('SELECT * FROM render_accounts WHERE account_id = @account_id', {
                    ['@account_id'] = accountid
                }, function(data)
                    if data[1] then
                        if expiration and expiration <= 336 then
                            if reason == '' then
                                reason = ''
                            end

                            if expiration > 0 then
                                AddBan(source, banid, data[1].license, data[1].account_id, data[1].name, sourceName,
                                    expiration,
                                    reason, 0)
                            else
                                AddBan(source, banid, data[1].license, data[1].account_id, data[1].name, sourceName,
                                    expiration,
                                    reason, 1)
                            end
                        else
                            SendMessage(source, 'Time Invalid')
                        end
                    else
                        SendMessage(source, 'ID Invalid')
                    end
                end)
            else
                SendMessage(source, 'Name Invalid')
            end
        else
            SendMessage(source, 'Time Invalid')
        end
    end
end)

RegisterCommand('unban', function(source, args, user)
    local source = source
    local groups = player:getGroup(source)

    if groups == 'mod' or groups == 'admin' or groups == 'superadmin' or groups == 'owner' then
        local sourceName = GetPlayerName(source)
        local banid = table.concat(args, ' ')

        if banid then
            MySQL.Async.fetchAll('SELECT * FROM render_bans WHERE banid LIKE @banid', {
                ['@banid'] = ('%' .. banid .. '%')
            }, function(data)
                if data[1] then
                    DeleteBan(data[1].banid, function()
                        SendMessage(source, ('%s a été déban'):format(data[1].targetName))
                    end)
                else
                    SendMessage(source, "Name invalide !")
                end
            end)
        else
            SendMessage(source, "Error")
		end
	end
end)