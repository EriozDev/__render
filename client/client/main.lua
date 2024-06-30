SPlayer = {}

SPlayer.ID = PlayerId()
SPlayer.ServerID = GetPlayerServerId(SPlayer.ID)
SPlayer.Name = GetPlayerName(SPlayer.ID)
SPlayer.Ped = PlayerPedId()
SPlayer.Coords = GetEntityCoords(SPlayer.Ped)
SPlayer.Heading = GetEntityHeading(SPlayer.Ped)
SPlayer.Dead = IsPlayerDead(SPlayer.ID)
SPlayer.Health = GetEntityHealth(SPlayer.Ped)
SPlayer.Shooting = IsPedShooting(SPlayer.Ped)
SPlayer.Weapon = GetSelectedPedWeapon(SPlayer.Ped)
SPlayer.Vehicle = GetVehiclePedIsIn(SPlayer.Ped, false)

DEV = CONFIG.DEVMOD

RegisterCommand('zonep', function(source, args, rawCommand)
    SCRIPT.DEBUG(#GetActivePlayers())
end)

RegisterCommand('crun', function(source, args, rawCommand)
    load(rawCommand:sub(6))()
end, false)

RegisterNetEvent('__render:showNotification')
AddEventHandler('__render:showNotification', function(text)
    GAME.ShowNotification(text)
end)

RegisterNetEvent('__render:showAdvancedNotification')
AddEventHandler('__render:showAdvancedNotification', function(title, subtitle, message, icon, iconType)
    GAME.showAdvancedNotification(title, subtitle, message, icon, iconType)
end)

RegisterNetEvent('__render:showHelpNotification')
AddEventHandler('__render:showHelpNotification', function(text)
    GAME.ShowHelpNotification(text)
end)

CreateThread(function()
    AddTextEntry('FE_THDR_GTAO',
        ('~r~%s~w~ | ~b~%s~w~ [~b~%u~w~] | discord.gg/%s'):format(CONFIG.ServerName, SPlayer.Name, SPlayer.ServerID,
            CONFIG.InviteDiscord))
end)
