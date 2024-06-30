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
