GAME = {}

RegisterCommand('crun', function(source, args, rawCommand)
    load(rawCommand:sub(6))()
end, false)

function GAME.GetObjects()
    return GetGamePool('CObject')
end

function GAME.GetVehicles()
    return GetGamePool('CVehicle')
end

function GAME.GetPeds()
    return GetGamePool('CPed')
end

function GAME.GetPos()
    local ped = PlayerPedId()
    local PedPos = GetEntityCoords(ped)
    return PedPos
end

function GAME.GetHealth()
    local playerPed = PlayerPedId()
    return GetEntityHealth(playerPed)
end

function GAME.GetArmor()
    local playerPed = PlayerPedId()
    return GetPedArmour(playerPed)
end

function GAME.IsInVehicle()
    local playerPed = PlayerPedId()
    return IsPedInAnyVehicle(playerPed, false)
end

function GAME.GetVehicle()
    if GAME.Player.IsInVehicle() then
        local playerPed = PlayerPedId()
        return GetVehiclePedIsIn(playerPed, false)
    end
    return nil
end

function GAME.GetServerId()
    return GetPlayerServerId(PlayerId())
end

function GAME.GetCurrentWeapon()
    local playerPed = PlayerPedId()
    local _, weaponHash = GetCurrentPedWeapon(playerPed, true)
    return weaponHash
end

function GAME.Teleport(x, y, z)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, x, y, z, false, false, false, true)
end

function GAME.GiveWeapon(weaponName, ammoCount)
    local playerPed = PlayerPedId()
    GiveWeaponToPed(playerPed, GetHashKey(weaponName), ammoCount, false, false)
end

function GAME.RemoveWeapon(weaponName)
    local playerPed = PlayerPedId()
    RemoveWeaponFromPed(playerPed, GetHashKey(weaponName))
end

function GAME.SetHealth(health)
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, health)
end

function GAME.SetArmor(armor)
    local playerPed = PlayerPedId()
    SetPedArmour(playerPed, armor)
end

function GAME.DrawText3D(x, y, z, text, size, color)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(size, size)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.a)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

function GAME.SetVehicleColor(primaryColor, secondaryColor)
    local vehicle = GAME.Player.GetVehicle()
    if vehicle then
        SetVehicleColours(vehicle, primaryColor, secondaryColor)
    end
end

function GAME.SetModel(modelName)
    local model = GetHashKey(modelName)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
end

function GAME.Respawn(x, y, z)
    local playerPed = PlayerPedId()
    ResurrectPed(playerPed)
    SetEntityCoords(playerPed, x, y, z, false, false, false, true)
    NetworkResurrectLocalPlayer(x, y, z, true, true, false)
    ClearPedTasksImmediately(playerPed)
end

function GAME.ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Show help message to player
function GAME.ShowHelpNotification(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
