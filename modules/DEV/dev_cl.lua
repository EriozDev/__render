SCRIPT.WARN('ac = {}')

local modules = {
    modules1 = 'DEV',
    modules2 = 'admins',
    modules3 = 'ac'
}

for key, value in pairs(modules) do
    SCRIPT.DEBUG("Modules '" .. value .. "' starting...")
    SCRIPT.INFO("Modules '" .. value .. "' Started!")
end

RegisterCommand('pos', function(source, args, rawCommand)
    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped)
    print(pedPos)
end)
