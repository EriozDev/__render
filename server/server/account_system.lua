FrameWork = {}
FrameWork.managers = {}

function FrameWork.managers.generateAccountId()
    local charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local length = 24
    local accountId = ""

    for i = 1, length do
        local randIndex = math.random(1, #charset)
        accountId = accountId .. charset:sub(randIndex, randIndex)
    end

    return accountId
end

function FrameWork.managers.generateStringBetween(min, max)
    if min ~= nil and max ~= nil then
        local number = math.random(min, max)
        if number == 0 or number == '' then return end
        return number
    end
end
