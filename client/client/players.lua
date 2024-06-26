FrameWork = {}
FrameWork.PlayerData = {}
FrameWork.PlayerLoaded = false

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if NetworkIsSessionStarted() then
            TriggerServerEvent('__render:onJoin')
            return
        end
    end
end)

RegisterNetEvent('playerSpawn')
AddEventHandler('playerSpawn', function(spawnPos)
    local ped = PlayerPedId()
    SetEntityCoordsNoOffset(ped, spawnPos.x, spawnPos.y, spawnPos.z, false, false, false, true)
    NetworkResurrectLocalPlayer(spawnPos.x, spawnPos.y, spawnPos.z, true, true, false)
    SetPlayerInvincible(ped, false)
    TriggerEvent('playerSpawned', spawnPos.x, spawnPos.y, spawnPos.z)
end)


Citizen.CreateThread(function()
    while true do
        Wait(10000)
        local pos = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('__render:position', pos)
    end
end)
