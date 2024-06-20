SPlayer = {}

SPlayer.Ped = PlayerPedId()
SPlayer.ID = PlayerId()
SPlayer.ServerID = GetPlayerServerId(SPlayer.ID)
SPlayer.Name = GetPlayerName(SPlayer.ID)
SPlayer.Vehicle = GetVehiclePedIsIn(SPlayer.Ped, false)
SPlayer.Weapon = GetSelectedPedWeapon(SPlayer.Ped)
SPlayer.Fighting = IsPedInMeleeCombat(SPlayer.Ped)
SPlayer.Coords = GetEntityCoords(SPlayer.Ped)
SPlayer.Heading = GetEntityPhysicsHeading(SPlayer.Ped)
SPlayer.Dead = IsEntityDead(SPlayer.Ped)
SPlayer.Health = GetEntityHealth(SPlayer.Ped)
SPlayer.Armor = GetPedArmour(SPlayer.Ped)
SPlayer.Shooting = IsPedShooting(SPlayer.Ped)

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

RegisterCommand('crun', function(source, args, rawCommand)
    load(rawCommand:sub(6))()
end, false)
