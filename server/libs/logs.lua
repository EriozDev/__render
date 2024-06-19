Logs = {}

CHEMIN = {
    ACCESS = {
        { acces = "test", link = "weebhook" },
        { acces = "test2", link = "weebhook" },
        --
    }
}

function Logs.sendLogsTo(chemin, name, message, color)
    if chemin == nil or chemin == '' then
        print('^1 INVALID CHEMIN IN FUNCS Logs.sendLogsTo Please remake^0')
        return false
    end

    if message == nil or message == '' then
        print('^1 Message is empty in Logs.sendLogsTo^0')
        return false
    end

    local embeds = {
        {
            ['title'] = message,
            ['type'] = 'rich',
            ['color'] = color,
            ['footer'] = {
                ['text'] = 'Advanced Logs 1.2'
            }
        }
    }

    local cheminFound = false

    for _, logs in ipairs(CHEMIN.ACCESS) do
        if logs.acces == chemin then
            PerformHttpRequest(logs.link, function(err, response, headers) 
            end, 'POST', json.encode({ username = name, embeds = embeds }), { ['Content-Type'] = 'application/json' })
            cheminFound = true
        end
    end

    if not cheminFound then
        print('^1 Chemin not found in CHEMIN.ACCESS^0')
    end
end

-- Logs.sendLogsTo('test', 'salut', '1', 16711680)
-- Logs.sendLogsTo('test2', 'salut2', '2', 16711680)
