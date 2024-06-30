SCRIPT.WARN('ac = {}')

local modules = {
    modules1 = 'DEV',
    modules2 = 'admins',
<<<<<<< HEAD
    modules3 = 'ac',
    modules4 = 'bans'
=======
    modules3 = 'ac'
>>>>>>> bdd3a02dc81b251237b231bcfd502317da9c0479
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
