Container = {}
Container.Create = {}
Container.id = 0

local __instance = {
    __index = Container,
    __type = 'Container'
}

function Container.New(ContainerName, ...)
    local self = setmetatable({}, __instance)
    self.contain = { name = ContainerName, values = {...} }
    local values = table.pack(...)

    for i = 1, values.n do
        table.insert(self.contain, values[i])
    end

    Container.id = Container.id + 1
    local TableUID = Container.id
    Container.Create[TableUID] = self.contain
    return self.contain, TableUID
end

function Container:delete(TableUniqueId)
    local seed = Container.Create[TableUniqueId]
    if seed then
        for k in pairs(seed) do
            seed[k] = nil
        end
        Container.Create[TableUniqueId] = nil
    end
end

function Container:GetTableUniqueIdByName(ContainerName)
    for uid, Container in pairs(Container.Create) do
        if Container.name == ContainerName then
            return uid
        end
    end
    return nil
end

function Container:insert(TableUniqueId, key, value)
    local seed = Container.Create[TableUniqueId]
    if seed then
        seed[key] = value
    end
end

function Container:remove(TableUniqueId, key)
    local seed = Container.Create[TableUniqueId]
    if seed and seed[key] then
        seed[key] = nil
    end
end

function Container:clear(TableUniqueId)
    local seed = Container.Create[TableUniqueId]
    table.wipe(seed)
end

function Container:update(TableUniqueId, key, newValue)
    local seed = Container.Create[TableUniqueId]
    if seed and seed[key] then
        seed[key] = newValue
    end
end

function Container:exists(TableUniqueId, key)
    local seed = Container.Create[TableUniqueId]
    return seed and seed[key] ~= nil
end

function Container:get(TableUniqueId, key)
    local seed = Container.Create[TableUniqueId]
    if seed then
        return seed[key]
    end
    return nil
end

if DEV then
    function Container:__debug(table)
        for key, value in pairs(table) do
            print(key, value)
        end

    end
end

setmetatable(Container, {
    __call = function(self, ...)
        return Container.New(...)
    end
})

-- Exemple d'utilisation
-- local myTable, TableUID = Container.New("myTable", 1, 2, 3)
-- local myTable2 = Container.New("myTable2")
-- print("Before insert: ")
-- Container:__debug(Container.Create[TableUID])
-- --
-- Container:insert(TableUID, "newKey", "newValue")
-- print("After insert: ")
-- Container:__debug(Container.Create[TableUID])
-- --
-- Container:remove(TableUID, "newKey")
-- print("After remove: ")
-- Container:__debug(Container.Create[TableUID])
-- local id = Container:GetTableUniqueIdByName("myTable")
-- print("id de table1 : ", id)
-- --
-- local id = Container:GetTableUniqueIdByName("myTable2")
-- print("id de table2 : ", id)
-- --
-- Container:delete(TableUID)
-- print("After delete: ", Container.Create[TableUID])
--