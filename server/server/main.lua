FrameWork.db = {}

DEV = CONFIG.DEVMOD

function FrameWork.db.getAllLicenses(callback)
    MySQL.Async.fetchAll('SELECT license FROM render_accounts', {}, function(result)
        local licenses = {}
        for i=1, #result, 1 do
            table.insert(licenses, result[i].license)
        end
        if callback then
            callback(licenses)
        end
    end)
end

if DEV then
    FrameWork.db.getAllLicenses(function(licenses)
        for _, license in ipairs(licenses) do
            print('(^6DEBUG^0) => (^3Player^0) => Loaded => ', license)
        end
    end)
end
