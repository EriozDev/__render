-- POURQUOI TU DUMPS ?? TU SAIS PAS DEV ??

SCRIPT.WARN('bans = {}')

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/unban', 'Unban un joueur', {
        { name = "banid", help = "banid du joueur banni." },
    })
    TriggerEvent('chat:addSuggestion', '/ban', 'bannir un joueur en ligne', {
        { name = "id", help = "id du joueur." },
        { name = "hour", help = "Temps en heure." },
        { name = "reason", help = "raison du joueur." }
    })
    TriggerEvent('chat:addSuggestion', '/banoffline', 'bannir un joueur hors-ligne', {
        { name = "licenseid", help = "licenseid du joueur." },
        { name = "hour", help = "Temps en heure." },
        { name = "reason", help = "raison du joueur." }
    })
end)