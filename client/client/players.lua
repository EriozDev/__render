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

Citizen.CreateThread(function()
    while true do
        while not FrameWork.PlayerLoaded do
            Citizen.Wait(100)
        end

        local playerPed = PlayerPedId()

        if playerPed and playerPed ~= -1 then
            __RENDER.SpawnPlayer('np_n_freemode_01', CONFIG.DefaultCoords, 0.0)
        end
    end
end)

RegisterNetEvent('receivePlayerPosition')
AddEventHandler('receivePlayerPosition', function(pos_x, pos_y, pos_z)
    if pos_x and pos_y and pos_z then
        FrameWork.PlayerData.Position = vector3(pos_x, pos_y, pos_z)
    else
        print("Could not retrieve position from the database.")
    end
end)

AddEventHandler('playerSpawned', function()
    if FrameWork.PlayerData.Position then
        SetEntityCoords(PlayerPedId(), FrameWork.PlayerData.Position)
    else
        print("No position data available.")
    end
end)
