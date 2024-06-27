IO.WARN('admins = {}')

local savedCoords = {}

__RENDER.RegisterServerCallback('__render:checkgroup', function(group, cb)
    local source = source
    local group = player:getGroup(source)
    if group ~= nil then
        cb(group)
    end
    cb(nil)
end)
