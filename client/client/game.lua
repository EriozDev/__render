GAME = {}

function GAME.GetObjects()
    return GetGamePool('CObject')
end

function GAME.GetVehicles()
    return GetGamePool('CVehicle')
end

function GAME.GetPeds(onlyOtherPeds)
    if onlyOtherPeds then
        local peds = GetGamePool('CPed')
        local playerPedId = PlayerPedId()

        for i = 1, #peds do
            if peds[i] == playerPedId then
                table.remove(peds, i)
                break
            end
        end

        return peds
    end

    return GetGamePool('CPed')
end

function GAME.GetPlayers(onlyOtherPlayers, returnKeyValue, returnPeds)
    local players, myPlayer = {}, PlayerId()
    local active = GetActivePlayers()

    for i = 1, #active do
        local currentPlayer = active[i]
        local ped = GetPlayerPed(currentPlayer)

        if DoesEntityExist(ped) and ((onlyOtherPlayers and currentPlayer ~= myPlayer) or not onlyOtherPlayers) then
            if returnKeyValue then
                players[currentPlayer] = ped
            else
                players[#players + 1] = returnPeds and ped or currentPlayer
            end
        end
    end

    return players
end

function GAME.GetClosestEntity(entities, coords, modelFilter, filterFn, playerEntities)
    local entitiesLen = #entities
    local closestEntity, closestEntityDistance = -1, -1
    coords = coords or GetEntityCoords(PlayerPedId())

    if modelFilter then
        local fillteredEntities, fillteredEntitiesLen = {}, 0

        for i = 1, entitiesLen do
            if modelFilter[GetEntityModel(entities[i])] then
                fillteredEntitiesLen = fillteredEntitiesLen + 1
                fillteredEntities[fillteredEntitiesLen] = entities[i]
            end
        end

        entities = fillteredEntities
        entitiesLen = fillteredEntitiesLen
    end

    if filterFn then
        local fillteredEntities, fillteredEntitiesLen = {}, 0

        for i = 1, entitiesLen do
            if filterFn(entities[i]) then
                fillteredEntitiesLen = fillteredEntitiesLen + 1
                fillteredEntities[fillteredEntitiesLen] = entities[i]
            end
        end

        entities = fillteredEntities
        entitiesLen = fillteredEntitiesLen
    end

    for i = 1, entitiesLen do
        local distance = #(coords - GetEntityCoords(entities[i]))

        if closestEntityDistance == -1 or distance < closestEntityDistance then
            closestEntity, closestEntityDistance = entities[i], distance
        end
    end

    if playerEntities then
        closestEntity = NetworkGetPlayerIndexFromPed(closestEntity)
    end

    return closestEntity, closestEntityDistance
end

function GAME.GetClosestObject(coords, modelFilter)
    return GAME.GetClosestEntity(GAME.GetObjects(), false, coords, modelFilter)
end

function GAME.GetClosestPed(coords, modelFilter, filterFn)
    return GAME.GetClosestEntity(GAME.GetPeds(true), coords, modelFilter, filterFn, false)
end

function GAME.GetClosestPlayer(coords)
    return GAME.GetClosestEntity(GAME.GetPlayers(), true, coords, nil)
end

function GAME.GetClosestVehicle(coords, modelFilter)
    return GAME.GetClosestEntity(GAME.GetVehicles(), false, coords, modelFilter)
end

function GAME.SetEntityScale(entity, scale)
    lastFromMatrix = {}
    Citizen.CreateThread(function()
        while true do
            Wait(0)
            if (not DoesEntityExist(entity)) then
                goto continue
            end

            local forward, right, up, at = GetEntityMatrix(entity)
            if lastFromMatrix[1] == forward and lastFromMatrix[2] == right and lastFromMatrix[3] == up and lastFromMatrix[4] == at then
                goto continue
            end

            forward, right, up = forward * scale, right * scale, up * scale
            local minDims, maxDims = GetModelDimensions(GetEntityModel(entity))
            local dim = maxDims - minDims
            local defaultHeightAbove = dim.z / 2
            at = at + vector3(0.0, 0.0, defaultHeightAbove * (scale - 1.0))

            print(entity)
            SetEntityMatrix(entity, forward, right, up, at)

            lastFromMatrix[1] = forward
            lastFromMatrix[2] = right
            lastFromMatrix[3] = up
            lastFromMatrix[4] = at

            ::continue::
        end
    end)
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

function GAME.showAdvancedNotification(title, subtitle, message, icon, iconType)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    SetNotificationMessage(icon, icon, false, iconType, title, subtitle)
    DrawNotification(false, true)
end

function GAME.ShowHelpNotification(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
