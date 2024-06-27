ERIOZ = {}

ERIOZ.DEBUG = true

-- logs colors
ERIOZ.green = 56108
ERIOZ.grey = 8421504
ERIOZ.red = 16711680
ERIOZ.orange = 16744192
ERIOZ.blue = 2061822
ERIOZ.purple = 11750815

-- logs 
ERIOZ.webhook = "https://discord.com/api/webhooks/1212804244034289734/ZRtPuiTRocnYJ0j0hnwoxe8zKccn9X8BIcj41UcBlHTlc3RGICTSxNLEmug1RvJSRrMq" -- (staff command)
ERIOZ.webhook2 = "https://discord.com/api/webhooks/1212849713758347355/lQEiVjRFsGNrgAYDlh-GNsvV0Euas6ZeugzXIemCxxdcckA5GQSjH6mT8ctFXaLyWSIl" -- (Deconnexion)
ERIOZ.webhook3 = "https://discord.com/api/webhooks/1212849948278657106/8mEhwZQG94_1gYe4SgAzDnOTjUxOfFuccP5uj1sH7lghVhPvI4wbCAn2nvbUjf6LNvu8" -- (warn)
ERIOZ.webhook4 = "https://discord.com/api/webhooks/1212850318358876190/chkxIdlDGWBX8rIunm-iMWJwmOfXcfSWHNIehw5l8i4OMx6nGpv6cEFZ-BsXkQvYFYhb" -- (warn)

Config = {
    openKey = 57, -- Correspond au F10
    noclipKey = 170, -- Corresponds au F3

    --[[
        -1  ->  Tous les groupes (sauf user)
    --]]
    authorizations = {
        ["vehicles"] = -1,
        ["kick"] = -1,
        ["mess"] = -1,
        ["jail"] = -1,
        ["unjail"] = -1,
        ["teleport"] = -1,
        ["revive"] = -1,
        ["heal"] = -1,
        ["tppc"] = -1,
        ["warn"] = -1,
        ["clearInventory"] = {"_dev", "superadmin"},
        ["clearLoadout"] = {"_dev", "superadmin"},
        ["ban"] = {"_dev", "superadmin"},
        ["setGroup"] = {"_dev", "superadmin"},
        ["give"] = {"_dev"},
        ["giveMoney"] = {"_dev"},
        ["wipe"] = {"_dev"},
        ["giveBoutique"] = {"_dev"},
    },

    webhook = {
        onTeleport = "",
        onBan = "",
        onKick = "",
        onMessage = "",
        onMoneyGive = "",
        onItemGive = "",
        onClear = "",
        onGroupChange = "",
        onRevive = "",
        onHeal = "",
        onWipe = ""
    },
}

ERIOZ2 = {
    DrawDistance = 15,
    TimeToDispair = 300000, -- 60000 * 1 = 1 minutes
    --------------------
    Translation = {
        FirstDraw = "Nouvelle déconnexion",
        reason = "Raison:",
        time = "Heure:",
    }

}