CONTAINER = {}
CONTAINER.Create = {}
CONTAINER.id = 0

local __instance = {
    __index = CONTAINER,
    __type = 'container'
}

function CONTAINER:new(containerName, ...)
    local self = setmetatable({}, __instance)
    self.contain = { name = containerName, values = {...} }
    local values = table.pack(...)

    for i = 1, values.n do
        table.insert(self.contain, values[i])
    end

    CONTAINER.id = CONTAINER.id + 1
    local TableUID = CONTAINER.id
    CONTAINER.Create[TableUID] = self.contain
    return self.contain, TableUID
end

function CONTAINER:delete(TableUniqueId)
    local seed = CONTAINER.Create[TableUniqueId]
    if seed then
        for k in pairs(seed) do
            seed[k] = nil
        end
        CONTAINER.Create[TableUniqueId] = nil
    end
end

function CONTAINER:GetTableUniqueIdByName(containerName)
    for uid, container in pairs(CONTAINER.Create) do
        if container.name == containerName then
            return uid
        end
    end
    return nil
end

function CONTAINER:insert(TableUniqueId, key, value)
    local seed = CONTAINER.Create[TableUniqueId]
    if seed then
        seed[key] = value
    end
end

function CONTAINER:remove(TableUniqueId, key)
    local seed = CONTAINER.Create[TableUniqueId]
    if seed and seed[key] then
        seed[key] = nil
    end
end

function CONTAINER:clear(TableUniqueId)
    local seed = CONTAINER.Create[TableUniqueId]
    if seed then
        for k in pairs(seed) do
            seed[k] = nil
        end
    end
end

function CONTAINER:update(TableUniqueId, key, newValue)
    local seed = CONTAINER.Create[TableUniqueId]
    if seed and seed[key] then
        seed[key] = newValue
    end
end

function CONTAINER:exists(TableUniqueId, key)
    local seed = CONTAINER.Create[TableUniqueId]
    return seed and seed[key] ~= nil
end

function CONTAINER:get(TableUniqueId, key)
    local seed = CONTAINER.Create[TableUniqueId]
    if seed then
        return seed[key]
    end
    return nil
end

function CONTAINER:__debug(table)
    for key, value in pairs(table) do
        print(key, value)
    end
end

-- Exemple d'utilisation
-- local myTable, TableUID = CONTAINER:new("myTable", 1, 2, 3)
-- local myTable2 = CONTAINER:new("myTable2")
-- print("Before insert: ")
-- CONTAINER:__debug(CONTAINER.Create[TableUID])
-- --
-- CONTAINER:insert(TableUID, "newKey", "newValue")
-- print("After insert: ")
-- CONTAINER:__debug(CONTAINER.Create[TableUID])
-- --
-- CONTAINER:remove(TableUID, "newKey")
-- print("After remove: ")
-- CONTAINER:__debug(CONTAINER.Create[TableUID])
-- local id = CONTAINER:GetTableUniqueIdByName("myTable")
-- print("id de table1 : ", id)
-- --
-- local id = CONTAINER:GetTableUniqueIdByName("myTable2")
-- print("id de table2 : ", id)
-- --
-- CONTAINER:delete(TableUID)
-- print("After delete: ", CONTAINER.Create[TableUID])
--