FrameWork.db = {}
DEV = CONFIG.DEVMOD

function FrameWork.db.getAllLicenses(callback)
    MySQL.Async.fetchAll('SELECT account_id FROM render_accounts', {}, function(result)
        local account_id = {}
        for i = 1, #result, 1 do
            table.insert(account_id, result[i].account_id)
        end
        if callback then
            callback(account_id)
        end
    end)
end

if DEV then
    FrameWork.db.getAllLicenses(function(account_id)
        for _, account_id in ipairs(account_id) do
            print('(^6DEBUG^0) => (^3Player^0) => Loaded => ', account_id)
        end
    end)
end
