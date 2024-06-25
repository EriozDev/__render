SPlayer = {}

SPlayer.ID = 0
SPlayer.ServerID = 0
SPlayer.Name = 'undefined'
SPlayer.Ped = 0
SPlayer.Exist = false
SPlayer.Coords = vec3(0)
SPlayer.Heading = 0.0
SPlayer.Dead = false
SPlayer.Health = 200
SPlayer.Armor = 100
SPlayer.Shooting = false
SPlayer.Fighting = false
SPlayer.OnFoot = true
SPlayer.Weapon = 'WEAPON_UNARMED'
SPlayer.InVehicle = false
SPlayer.Vehicle = 0
SPlayer.IsDriver = false

DEV = CONFIG.DEVMOD

CreateThread(function()
    while true do
        Wait(100)
        local PlayerID = PlayerId()
        SPlayer.ID = PlayerID
        SPlayer.ServerID = GetPlayerServerId(PlayerID)
        SPlayer.Name = GetPlayerName(PlayerID)

        local PlayerPed = PlayerPedId()
        SPlayer.Ped = PlayerPed

        if PlayerPed > 0 and DoesEntityExist(PlayerPed) then
            SPlayer.Exist = true
            SPlayer.Coords = GetEntityCoords(PlayerPed)
            SPlayer.Heading = GetEntityPhysicsHeading(PlayerPed)
            SPlayer.Dead = IsEntityDead(PlayerPed)
            SPlayer.Health = GetEntityHealth(PlayerPed)
            SPlayer.Armor = GetPedArmour(PlayerPed)
            SPlayer.Shooting = IsPedShooting(PlayerPed)
            SPlayer.Fighting = IsPedInMeleeCombat(PlayerPed)
            SPlayer.OnFoot = IsPedOnFoot(PlayerPed)
            SPlayer.Weapon = GetSelectedPedWeapon(PlayerPed)

            local wasInVehicle = SPlayer.InVehicle
            local lastVehicle = SPlayer.Vehicle

            if IsPedInAnyVehicle(PlayerPed) then
                local vehicle = GetVehiclePedIsUsing(PlayerPed)

                if vehicle > 0 then
                    SPlayer.InVehicle = true
                    SPlayer.Vehicle = vehicle
                    SPlayer.IsDriver = GetPedInVehicleSeat(vehicle, -1) == PlayerPed
                else
                    SPlayer.InVehicle = false
                    SPlayer.Vehicle = 0
                    SPlayer.IsDriver = false
                end
            else
                SPlayer.InVehicle = false
                SPlayer.Vehicle = 0
                SPlayer.IsDriver = false
            end

        else
            SPlayer.Exist = false
            SPlayer.Coords = vec3(0)
            SPlayer.Heading = 0.0
            SPlayer.Health = 200
            SPlayer.Armor = 100
            SPlayer.Shooting = false
            SPlayer.Fighting = false
            SPlayer.OnFoot = true
            SPlayer.Weapon = 'WEAPON_UNARMED'
            SPlayer.InVehicle = false
            SPlayer.Vehicle = 0
            SPlayer.IsDriver = false
        end

        Wait(0)
    end
end)

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
