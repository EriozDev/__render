player = {}
weapon = {}
vehicle = {}

local weaponNames = {
    [GetHashKey("WEAPON_KNIFE")] = "Knife",
    [GetHashKey("WEAPON_NIGHTSTICK")] = "Nightstick",
    [GetHashKey("WEAPON_HAMMER")] = "Hammer",
    [GetHashKey("WEAPON_BAT")] = "Bat",
    [GetHashKey("WEAPON_GOLFCLUB")] = "Golf Club",
    [GetHashKey("WEAPON_CROWBAR")] = "Crowbar",
    [GetHashKey("WEAPON_BOTTLE")] = "Bottle",
    [GetHashKey("WEAPON_DAGGER")] = "Dagger",
    [GetHashKey("WEAPON_HATCHET")] = "Hatchet",
    [GetHashKey("WEAPON_KNUCKLE")] = "Knuckle Duster",
    [GetHashKey("WEAPON_MACHETE")] = "Machete",
    [GetHashKey("WEAPON_FLASHLIGHT")] = "Flashlight",
    [GetHashKey("WEAPON_SWITCHBLADE")] = "Switchblade",
    [GetHashKey("WEAPON_BATTLEAXE")] = "Battle Axe",
    [GetHashKey("WEAPON_POOLCUE")] = "Pool Cue",
    [GetHashKey("WEAPON_PIPEWRENCH")] = "Pipe Wrench",
    [GetHashKey("WEAPON_STONE_HATCHET")] = "Stone Hatchet",
    [GetHashKey("WEAPON_PISTOL")] = "Pistol",
    [GetHashKey("WEAPON_PISTOL_MK2")] = "Pistol Mk II",
    [GetHashKey("WEAPON_COMBATPISTOL")] = "Combat Pistol",
    [GetHashKey("WEAPON_APPISTOL")] = "AP Pistol",
    [GetHashKey("WEAPON_STUNGUN")] = "Stun Gun",
    [GetHashKey("WEAPON_PISTOL50")] = "Pistol .50",
    [GetHashKey("WEAPON_SNSPISTOL")] = "SNS Pistol",
    [GetHashKey("WEAPON_SNSPISTOL_MK2")] = "SNS Pistol Mk II",
    [GetHashKey("WEAPON_HEAVYPISTOL")] = "Heavy Pistol",
    [GetHashKey("WEAPON_VINTAGEPISTOL")] = "Vintage Pistol",
    [GetHashKey("WEAPON_FLAREGUN")] = "Flare Gun",
    [GetHashKey("WEAPON_MARKSMANPISTOL")] = "Marksman Pistol",
    [GetHashKey("WEAPON_REVOLVER")] = "Heavy Revolver",
    [GetHashKey("WEAPON_REVOLVER_MK2")] = "Heavy Revolver Mk II",
    [GetHashKey("WEAPON_DOUBLEACTION")] = "Double Action Revolver",
    [GetHashKey("WEAPON_RAYPISTOL")] = "Up-n-Atomizer",
    [GetHashKey("WEAPON_CERAMICPISTOL")] = "Ceramic Pistol",
    [GetHashKey("WEAPON_NAVYREVOLVER")] = "Navy Revolver",
    [GetHashKey("WEAPON_MICROSMG")] = "Micro SMG",
    [GetHashKey("WEAPON_SMG")] = "SMG",
    [GetHashKey("WEAPON_SMG_MK2")] = "SMG Mk II",
    [GetHashKey("WEAPON_ASSAULTSMG")] = "Assault SMG",
    [GetHashKey("WEAPON_COMBATPDW")] = "Combat PDW",
    [GetHashKey("WEAPON_MACHINEPISTOL")] = "Machine Pistol",
    [GetHashKey("WEAPON_MINISMG")] = "Mini SMG",
    [GetHashKey("WEAPON_RAYCARBINE")] = "Unholy Hellbringer",
    [GetHashKey("WEAPON_PUMPSHOTGUN")] = "Pump Shotgun",
    [GetHashKey("WEAPON_PUMPSHOTGUN_MK2")] = "Pump Shotgun Mk II",
    [GetHashKey("WEAPON_SAWNOFFSHOTGUN")] = "Sawed-Off Shotgun",
    [GetHashKey("WEAPON_ASSAULTSHOTGUN")] = "Assault Shotgun",
    [GetHashKey("WEAPON_BULLPUPSHOTGUN")] = "Bullpup Shotgun",
    [GetHashKey("WEAPON_MUSKET")] = "Musket",
    [GetHashKey("WEAPON_HEAVYSHOTGUN")] = "Heavy Shotgun",
    [GetHashKey("WEAPON_DBSHOTGUN")] = "Double Barrel Shotgun",
    [GetHashKey("WEAPON_AUTOSHOTGUN")] = "Sweeper Shotgun",
    [GetHashKey("WEAPON_ASSAULTRIFLE")] = "Assault Rifle",
    [GetHashKey("WEAPON_ASSAULTRIFLE_MK2")] = "Assault Rifle Mk II",
    [GetHashKey("WEAPON_CARBINERIFLE")] = "Carbine Rifle",
    [GetHashKey("WEAPON_CARBINERIFLE_MK2")] = "Carbine Rifle Mk II",
    [GetHashKey("WEAPON_ADVANCEDRIFLE")] = "Advanced Rifle",
    [GetHashKey("WEAPON_SPECIALCARBINE")] = "Special Carbine",
    [GetHashKey("WEAPON_SPECIALCARBINE_MK2")] = "Special Carbine Mk II",
    [GetHashKey("WEAPON_BULLPUPRIFLE")] = "Bullpup Rifle",
    [GetHashKey("WEAPON_BULLPUPRIFLE_MK2")] = "Bullpup Rifle Mk II",
    [GetHashKey("WEAPON_COMPACTRIFLE")] = "Compact Rifle",
    [GetHashKey("WEAPON_MG")] = "MG",
    [GetHashKey("WEAPON_COMBATMG")] = "Combat MG",
    [GetHashKey("WEAPON_COMBATMG_MK2")] = "Combat MG Mk II",
    [GetHashKey("WEAPON_GUSENBERG")] = "Gusenberg Sweeper",
    [GetHashKey("WEAPON_SNIPERRIFLE")] = "Sniper Rifle",
    [GetHashKey("WEAPON_HEAVYSNIPER")] = "Heavy Sniper",
    [GetHashKey("WEAPON_HEAVYSNIPER_MK2")] = "Heavy Sniper Mk II",
    [GetHashKey("WEAPON_MARKSMANRIFLE")] = "Marksman Rifle",
    [GetHashKey("WEAPON_MARKSMANRIFLE_MK2")] = "Marksman Rifle Mk II",
    [GetHashKey("WEAPON_RPG")] = "RPG",
    [GetHashKey("WEAPON_GRENADELAUNCHER")] = "Grenade Launcher",
    [GetHashKey("WEAPON_GRENADELAUNCHER_SMOKE")] = "Grenade Launcher Smoke",
    [GetHashKey("WEAPON_MINIGUN")] = "Minigun",
    [GetHashKey("WEAPON_FIREWORK")] = "Firework Launcher",
    [GetHashKey("WEAPON_RAILGUN")] = "Railgun",
    [GetHashKey("WEAPON_HOMINGLAUNCHER")] = "Homing Launcher",
    [GetHashKey("WEAPON_COMPACTLAUNCHER")] = "Compact Grenade Launcher",
    [GetHashKey("WEAPON_RAYMINIGUN")] = "Widowmaker",
    [GetHashKey("WEAPON_GRENADE")] = "Grenade",
    [GetHashKey("WEAPON_BZGAS")] = "BZ Gas",
    [GetHashKey("WEAPON_MOLOTOV")] = "Molotov",
    [GetHashKey("WEAPON_STICKYBOMB")] = "Sticky Bomb",
    [GetHashKey("WEAPON_PROXMINE")] = "Proximity Mine",
    [GetHashKey("WEAPON_SNOWBALL")] = "Snowball",
    [GetHashKey("WEAPON_PIPEBOMB")] = "Pipe Bomb",
    [GetHashKey("WEAPON_BALL")] = "Ball",
    [GetHashKey("WEAPON_SMOKEGRENADE")] = "Tear Gas",
    [GetHashKey("WEAPON_FLARE")] = "Flare",
    [GetHashKey("WEAPON_PETROLCAN")] = "Jerry Can",
    [GetHashKey("GADGET_PARACHUTE")] = "Parachute",
    [GetHashKey("WEAPON_FIREEXTINGUISHER")] = "Fire Extinguisher"
}

function player:getPlayerName(player)
    return GetPlayerName(player)
end

function player:getPlayerPing(player)
    return GetPlayerPing(player)
end

function player:getIdentifier(player)
    local identifier = GetPlayerIdentifierByType(player, 'license')
    return identifier
end

function player:getIdentifierType(player, type)
    local id = GetPlayerIdentifierByType(player, type)
    return id
end

function player:kick(p, r)
    if r == nil or r == '' then
        r = 'Raison non définie'
    end
    DropPlayer(p, r)
end

function player:getGroup(p)
    local i = GetPlayerIdentifierByType(p, 'license')
    MySQL.Async.fetchAll('SELECT * FROM render_accounts WHERE license = @license', {
        ['@license'] = i
    }, function(result)
        if result[1] then
            local dbPlayer = result[1]
            return dbPlayer.player_group
        end
    end)
end

function weapon:getName()
    local _src = source
    local ped = GetPlayerPed(_src)
    local weaponHash = GetSelectedPedWeapon(ped)

    local weaponName = weaponNames[weaponHash]

    if weaponName then
        return weaponName
    else
        return "Unknown Weapon"
    end
end

function vehicle:delete(v)
    if v and source ~= nil then
        DeleteEntity(v)
    end
end
