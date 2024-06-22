local isSessionStarted = false

Citizen.CreateThread(function()
    while not NetworkIsSessionStarted() do
        Citizen.Wait(100)
    end

    isSessionStarted = true
    TriggerServerEvent('__render:onJoin')
end)
