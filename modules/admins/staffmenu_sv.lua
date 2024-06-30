-- Erioz

ESX, players, items = nil, {}, {}
inService = {}

warnedPlayers = {}
blacklistedLicenses = {}

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(result)
        for k, v in pairs(result) do
            items[k] = { label = v.label, name = v.name }
        end
    end)
end)

local function getLicense(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers
        end
        return identifiers
    end
end

local function isStaff(source)
    return players[source].rank ~= "user"
end

local function isWebhookSet(val)
    return val ~= nil and val ~= ""
end

RegisterServerEvent('__render:onJoin')
AddEventHandler('__render:onJoin', function()
    local source = source
    if players[source] then
        return
    end
    TriggerClientEvent("adminmenu:cbPermLevel", source, player:getGroup(source))
    players[source] = {
        timePlayed = { 0, 0 },
        rank = player:getGroup(source),
        name = GetPlayerName(source),
        license = getLicense(source)["license"],
    }
    if players[source].rank ~= "user" then
        TriggerClientEvent("adminmenu:cbItemsList", source, items)
        TriggerClientEvent("adminmenu:cbReportTable", source, reportsTable)
        TriggerClientEvent("adminmenu:updatePlayers", source, players)
    end
end)

AddEventHandler("playerDropped", function(reason)
    local source = source
    players[source] = nil
    reportsTable[source] = nil
    updateReportsForStaff()
end)

RegisterNetEvent("adminmenu:setStaffState")
AddEventHandler("adminmenu:setStaffState", function(newVal, sneaky)
    local source = source
    TriggerClientEvent("adminmenu:cbStaffState", source, newVal)
    local byState = {
    }
    if newVal then
        inService[source] = true
    else
        inService[source] = nil
    end
    if not sneaky then
        for k,player in pairs(players) do
            if player.rank ~= "user" and inService[k] ~= nil then
                TriggerClientEvent("__render:showNotification", k, byState[newVal]:format(GetPlayerName(source)))
            end
        end
    end
end)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local _src = source
    deferrals.defer()
    deferrals.update("Vérification des warn...")
    Wait(50)
    local license = getLicense(_src)
    if warnedPlayers[license] and warnedPlayers[license] > 2 then
        deferrals.done("Vous avez 3 avertissements actif, vous ne pouvez donc pas vous connecter avant le prochain reboot")
    else
        deferrals.done()
    end
end)

-- Players updaters task
Citizen.CreateThread(function()
    while true do
        Wait(15000)
        for source, player in pairs(players) do
            if isStaff(source) then
                TriggerClientEvent("adminmenu:updatePlayers", source, players)
                TriggerClientEvent("adminmenu:cbReportTable", source, reportsTable)
            end
        end
    end
end)

RegisterServerEvent("euhtesserieuxmek")
AddEventHandler("euhtesserieuxmek", function()
    local _source = source
    TriggerEvent("BanSql:ICheatServer", _source, "Cheat")
end)

AddEventHandler("clearPedTasksEvent", function(source, data)
    local _source = source
    TriggerEvent("BanSql:ICheatServer", _source, "Cheat")
    print("Joueur : ".. GetPlayerName(_source) .." [".. _source .. "] (".. GetPlayerIdentifierByType(_source, 'license') .. ") a potentiellement un cheat d'activer !")
end)

-- Session counter task
-- TODO -> add report time elapsed
Citizen.CreateThread(function()
    while true do
        Wait(1000 * 60)
        for k, v in pairs(players) do
            players[k].timePlayed[1] = players[k].timePlayed[1] + 1
            if players[k].timePlayed[1] > 60 then
                players[k].timePlayed[1] = 0
                players[k].timePlayed[2] = players[k].timePlayed[2] + 1
            end
        end
        for k, v in pairs(reportsTable) do
            reportsTable[k].timeElapsed[1] = reportsTable[k].timeElapsed[1] + 1
            if reportsTable[k].timeElapsed[1] > 60 then
                reportsTable[k].timeElapsed[1] = 0
                reportsTable[k].timeElapsed[2] = reportsTable[k].timeElapsed[2] + 1
            end
        end
    end
end)

reportsTable = {}
reportsCount = 0

local ticket =  "https://discord.com/api/webhooks/1212804244034289734/ZRtPuiTRocnYJ0j0hnwoxe8zKccn9X8BIcj41UcBlHTlc3RGICTSxNLEmug1RvJSRrMq"

function sendToDiscord(name, message, color)
    if message == nil or message == '' then
        return false
    end

    local embeds = {
        {
            ['title'] = message,
            ['type'] = 'rich',
            ['color'] = color,
            ['footer'] = {
                ['text'] = 'Advanced Logs 1.2'
            }
        }
    }

    PerformHttpRequest(ticket, function() end, 'POST', json.encode({username = name, embeds = embeds}), {['Content-Type'] = 'application/json'})
end

RegisterNetEvent("adminmenu:takeReport")
AddEventHandler("adminmenu:takeReport", function(reportId)
    local source = source
    local xPlayer = __RENDER.getPlayerBySource(source)
    if player:getGroup(xPlayer) == "user" then
        DropPlayer(source, "Vous n'avez pas la permission de faire cela")
        return
    end
    if not reportsTable[reportId] then
        TriggerClientEvent("__render:showNotification", source, "Ce report n'est plus en attente de prise en charge")
        return
    end
    reportsTable[reportId].takenBy = GetPlayerName(source)
    reportsTable[reportId].taken = true
    if players[reportId] ~= nil then
        TriggerClientEvent("__render:showNotification", reportId, "Votre ticket a été accepter par "..GetPlayerName(source).. ".")
        sendToDiscord("Commande Staff", "Staff : " .. GetPlayerName(source) .. " [" .. source .. "] (".. GetPlayerIdentifierByType(source, 'license') ..") a pris le ticket de ".. GetPlayerName(reportId) .. "[".. reportId .. "] (".. GetPlayerIdentifierByType(reportId, 'license') .. ")", Config.purple)
    end
    notifyActiveStaff("-"..GetPlayerName(source).." a pris le ticket n°"..reportsTable[reportId].uniqueId)

	local xPlayers = __RENDER.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local xPlayer = __RENDER.getPlayerBySource(xPlayers[i])
        if player:getGroup(xPlayer) ~= "user" then
            TriggerClientEvent('__render:showNotification', source, " ".. GetPlayerName(source) .. " a pris le ticket n°"..reportsCount)
        end
    end            

    local coords = GetEntityCoords(GetPlayerPed(reportId))
    TriggerClientEvent("adminmenu:setCoords", source, coords)
    updateReportsForStaff()
end)

RegisterNetEvent("adminmenu:closeReport")
AddEventHandler("adminmenu:closeReport", function(reportId)
    local source = source
    local xPlayer = __RENDER.getPlayerBySource(source)
    if player:getGroup(xPlayer) == "user" then
        DropPlayer(source, "Vous n'avez pas la permission de faire cela")
        return
    end
    if not reportsTable[reportId] then
        TriggerClientEvent("__render:showNotification", source, "~r~[Report] ~s~Ce report n'est plus valide")
        return
    end
    if players[reportId] ~= nil then
      --  TriggerClientEvent("esx:showNotification", reportId, "Votre ticket a été fermer.")
    end
  --  notifyActiveStaff("-"..GetPlayerName(source).." a fermer le ticket n°"..reportsTable[reportId].uniqueId)
    reportsTable[reportId] = nil
    updateReportsForStaff()
end)

RegisterNetEvent("adminmenu:refuseReport")
AddEventHandler("adminmenu:refuseReport", function(reportId)
    local source = source
    local xPlayer = __RENDER.getPlayerBySource(source)
    if player:getGroup(xPlayer) == "user" then
        DropPlayer(source, "Vous n'avez pas la permission de faire cela")
        return
    end
    if not reportsTable[reportId] then
        TriggerClientEvent("__render:showNotification", source, "~r~[Report] ~s~Ce report n'est plus valide")
        return
    end
    if players[reportId] ~= nil then
        TriggerClientEvent("__render:showNotification", reportId, "Votre ticket a été refuser.")
        sendToDiscord("Commande Staff", "Staff : " .. GetPlayerName(source) .. " [" .. source .. "] (".. GetPlayerIdentifierByType(source, 'license') ..") a refuser le ticket de ".. GetPlayerName(reportId) .. "[".. reportId .. "] (".. GetPlayerIdentifierByType(reportId, 'license') .. ")", Config.purple)
    end
    notifyActiveStaff("-"..GetPlayerName(source).." a refuser le ticket n°"..reportsTable[reportId].uniqueId)

	local xPlayers = __RENDER.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local xPlayer = __RENDER.getPlayerBySource(xPlayers[i])
        if player:getGroup(xPlayer) ~= "user" then
            TriggerClientEvent('__render:showNotification', source, " ".. GetPlayerName(source) .. " a refuser le ticket n°"..reportsCount)
        end
    end            

    reportsTable[reportId] = nil
    updateReportsForStaff()
end)

function updateReportsForStaff()
    for k, player in pairs(players) do
        if player.rank ~= "user" then
            TriggerClientEvent("adminmenu:cbReportTable", k, reportsTable)
        end
    end
end

function notifyActiveStaff(message)
    for k, player in pairs(players) do
        if player.rank ~= "user" then
            if inService[k] ~= nil then
                TriggerClientEvent("__render:showNotification", k, message)
            end
        end
    end
end

RegisterCommand("report", function(source, args)
    -- TODO -> Add a sound when report sent
    if source == 0 then
        return
    end
    if reportsTable[source] ~= nil then
        TriggerClientEvent("__render:showNotification", source, "~r~Vous avez déjà un ticket actif.")
        return
    end
    reportsCount = reportsCount + 1
    reportsTable[source] = { timeElapsed = {0,0}, uniqueId = reportsCount, id = source, name = GetPlayerName(source), reason = table.concat(args, " "), taken = false, createdAt = os.date('%c'), takenBy = nil }
    notifyActiveStaff("Nouveau ticket n°" .. reportsCount)

    TriggerClientEvent("__render:showNotification", source, "Ticket envoyer avec succès, merci de patienter.")

	local xPlayers = __RENDER.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local xPlayer = __RENDER.getPlayerBySource(xPlayers[i])
        if player:getGroup(xPlayer) ~= "user" then
            TriggerClientEvent('__render:showNotification', source, "Nouveau ticket n°"..reportsCount)
        end
    end


    updateReportsForStaff()
end, false)

-- TODO -> faire un reminder si beaucoup de reports non traités

local webhookColors = {
    ["red"] = 16711680,
    ["green"] = 56108,
    ["grey"] = 8421504,
    ["orange"] = 16744192
}
local function getLicense(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers
        end
        return identifiers
    end
end

function sendWebhook(message,color,url)
    local DiscordWebHook = url
    local embeds = {
        {
            ["title"]=message,
            ["type"]="rich",
            ["color"] =webhookColors[color],
            ["footer"]=  {
                ["text"]= "Admin Menu by Pablo",
            },
        }
    }
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = "Admin Menu",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end