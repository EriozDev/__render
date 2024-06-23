local modules = {
    modules1 = 'DEV',
    modules2 = 'ac'
}

for key, value in pairs(modules) do
    SCRIPT.INFO('Modules ' .. value .. ' has been Started')
end

RegisterCommand('pos', function(source, args, rawCommand)
    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped)
    print(pedPos)
end)
