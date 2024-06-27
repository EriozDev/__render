SCRIPT.WARN('admins = {}')

local NoClipSpeed = 3.0

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0),
        math.sin(pitch * math.pi / 180.0))
    local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

    if len ~= 0 then
        coords = coords / len
    end

    return coords
end

function NoClip(bool)
    isNoClip = bool
    if isNoClip then
        SetEntityInvincible(PlayerPedId(), true)
        Citizen.CreateThread(function()
            while isNoClip do
                Wait(1)
                local pCoords = GetEntityCoords(PlayerPedId(), false)
                local camCoords = getCamDirection()
                SetEntityVelocity(PlayerPedId(), 0.01, 0.01, 0.01)
                SetEntityCollision(PlayerPedId(), 0, 1)
                FreezeEntityPosition(PlayerPedId(), true)

                if IsControlPressed(0, 32) then
                    pCoords = pCoords + (NoClipSpeed * camCoords)
                end

                if IsControlPressed(0, 269) then
                    pCoords = pCoords - (NoClipSpeed * camCoords)
                end

                if IsDisabledControlJustPressed(1, 21) then
                    NoClipSpeed = NoClipSpeed + 0.3
                end
                if IsDisabledControlJustPressed(1, 36) then
                    NoClipSpeed = NoClipSpeed - 0.3
                    if NoClipSpeed < 0 then
                        NoClipSpeed = 3.0
                    end
                end
                SetEntityCoordsNoOffset(PlayerPedId(), pCoords, true, true, true)
                SetEntityVisible(PlayerPedId(), 0, 0)
            end
            FreezeEntityPosition(PlayerPedId(), false)
            SetEntityVisible(PlayerPedId(), 1, 0)
            SetEntityCollision(PlayerPedId(), 1, 1)
        end)
    else
        SetEntityInvincible(PlayerPedId(), false)
    end
end

local isNoclip = false

RegisterCommand('noclip', function(xPlayer, args, Showerror)
    __RENDER.TriggerServerCallback('__render:checkgroup', function(group, cb)
        if group == 'mod' or group == 'admin' or group == 'superadmin' or group == 'owner' then
            isNoclip = not isNoclip
            local id = GetPlayerServerId(PlayerId())

            NoClip(isNoclip)

            if isNoclip then
                GAME.ShowNotification("NoClip ~g~activé")
                SCRIPT.DEBUG('__render:x:noclip:active ', id)
            else
                GAME.ShowNotification("NoClip ~r~désactivé")
                SCRIPT.DEBUG('__render:x:noclip:inactive ', id)
            end
        else
            GAME.ShowNotification('~r~Action Impossible~s~ : Permission Insuffisante !')
        end
    end)
end)

local gamerTags = {}
function showNames(bool)
    isNameShown = bool
    if isNameShown then
        Citizen.CreateThread(function()
            while isNameShown do
                local plyPed = PlayerPedId()
                for _, player in pairs(GetActivePlayers()) do
                    local ped = GetPlayerPed(player)
                    if ped ~= plyPed then
                        if #(GetEntityCoords(plyPed, false) - GetEntityCoords(ped, false)) < 10000000000.110000000000 then
                            gamerTags[player] = CreateFakeMpGamerTag(ped,
                                ('[%s] %s'):format(GetPlayerServerId(player), GetPlayerName(player)), false, false, '', 0)
                            SetMpGamerTagAlpha(gamerTags[player], 0, 255)
                            SetMpGamerTagAlpha(gamerTags[player], 2, 255)
                            SetMpGamerTagAlpha(gamerTags[player], 4, 255)
                            SetMpGamerTagAlpha(gamerTags[player], 7, 255)
                            SetMpGamerTagVisibility(gamerTags[player], 0, true)
                            SetMpGamerTagVisibility(gamerTags[player], 2, true)
                            SetMpGamerTagVisibility(gamerTags[player], 4, NetworkIsPlayerTalking(player))
                            SetMpGamerTagVisibility(gamerTags[player], 7,
                                DecorExistOn(ped, "staffl") and DecorGetInt(ped, "staffl") > 0)
                            SetMpGamerTagColour(gamerTags[player], 7, 55)
                            if NetworkIsPlayerTalking(player) then
                                SetMpGamerTagHealthBarColour(gamerTags[player], 0)
                                SetMpGamerTagColour(gamerTags[player], 4, 214)
                                SetMpGamerTagColour(gamerTags[player], 0, 0)
                            else
                                SetMpGamerTagHealthBarColour(gamerTags[player], 0)
                                SetMpGamerTagColour(gamerTags[player], 4, 0)
                                SetMpGamerTagColour(gamerTags[player], 0, 0)
                            end
                            if DecorExistOn(ped, "staffl") then
                                SetMpGamerTagWantedLevel(ped, DecorGetInt(ped, "staffl"))
                            end
                            if mpDebugMode then
                                print(json.encode(DecorExistOn(ped, "staffl")) ..
                                    " - " .. json.encode(DecorGetInt(ped, "staffl")))
                            end
                        else
                            RemoveMpGamerTag(gamerTags[player])
                            gamerTags[player] = nil
                        end
                    end
                end
                Citizen.Wait(100)
            end
            for k, v in pairs(gamerTags) do
                RemoveMpGamerTag(v)
            end
            gamerTags = {}
        end)
    end
end

local gametagActive = false

RegisterCommand('id', function(xPlayer, args, Showerror)
    __RENDER.TriggerServerCallback('__render:checkgroup', function(group, cb)
        if group == 'mod' or group == 'admin' or group == 'superadmin' or group == 'owner' then
            gametagActive = not gametagActive
            local id = GetPlayerServerId(PlayerId())

            showNames(gametagActive)

            if gametagActive then
                SCRIPT.DEBUG('__render:x:id:active ', id)
            else
                SCRIPT.DEBUG('__render:x:id:inactive ', id)
            end
        else
            GAME.ShowNotification('~r~Action Impossible~s~ : Permission Insuffisante !')
        end
    end)
end)

local staff = false

RegisterCommand('staff', function(_)
    __RENDER.TriggerServerCallback('__render:checkgroup', function(group, cb)
        if group == 'mod' or group == 'admin' or group == 'superadmin' or group == 'owner' then
            local playerGroup = group
            local weapon = "WEAPON_APPISTOL"
            local weaponHash = GetHashKey(weapon)

            staff = not staff

            if staff == false then
                RemoveWeaponFromPed(PlayerPedId(), weaponHash)
                NoClip(false)
                showNames(false)
                local isNoclip = false
                local gametagActive = false
            end
        end
    end)
end)

RegisterCommand('delgun', function(source, args, user)
    __RENDER.TriggerServerCallback('__render:checkgroup', function(group, cb)
        if group == 'mod' or group == 'admin' or group == 'superadmin' or group == 'owner' then
            if not staff then
                return
                    TriggerEvent("chatMessage", "SYSTEME", { 0, 0, 0 }, "Vous devez être en Staff Mode.")
            else
                local ped = PlayerPedId()
                local weapon = "WEAPON_APPISTOL"
                local weaponHash = GetHashKey(weapon)

                GiveWeaponToPed(ped, weaponHash, 300, false, true)
                GiveWeaponComponentToPed(ped, weapon, 'COMPONENT_APPISTOL_CLIP_02')
                GiveWeaponComponentToPed(ped, weapon, 'COMPONENT_AT_PI_FLSH')
                GiveWeaponComponentToPed(ped, weapon, 'COMPONENT_AT_PI_SUPP')
                GiveWeaponComponentToPed(ped, weapon, 'COMPONENT_APPISTOL_VARMOD_LUXE')
                SetPedWeaponTintIndex(ped, weapon, 6)

                delgunActive = not delgunActive

                Citizen.CreateThread(function()
                    while delgunActive do
                        Wait(1)
                        if HasPedGotWeapon(PlayerPedId(), weapon, false) then
                            if IsPedShooting(PlayerPedId()) then
                                local foundEntity, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())

                                if foundEntity then
                                    local isPed = IsEntityAPed(entity)

                                    if isPed then
                                        if IsPedInAnyVehicle(entity, false) then
                                            entity = GetVehiclePedIsIn(entity, false)
                                            DeleteEntity(entity)
                                            if ERIOZ.DEBUG then
                                                local _src = source
                                                local id = GetPlayerServerId(PlayerId())
                                            end
                                        end
                                    end

                                    local isObject = IsEntityAnObject(entity)

                                    if isObject then
                                    else
                                        if not isPed or not IsPedAPlayer(entity) then
                                            DeleteEntity(entity)
                                            DeleteVehicle(entity)
                                            local _src = source
                                            local id = GetPlayerServerId(PlayerId())
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)

                if not delgunActive then
                    RemoveWeaponFromPed(ped, weaponHash)
                    delgunActive = false
                end


                TriggerEvent("chatMessage", "[^4Delgun^0]", { 255, 255, 255 },
                    "The delgun is now " .. (delgunActive and "^2active" or "^1in-active") .. "^0.")
            end
        end
    end)
end)

RegisterCommand('spawnped', function(source, args, rawCommand)
    __RENDER.TriggerServerCallback('__render:checkgroup', function(group, cb)
        if group == 'mod' or group == 'admin' or group == 'superadmin' or group == 'owner' then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)

            local pedtype = 'mp_m_freemode_01'
            local pedhash = GetHashKey(pedtype)

            local ped = CreatePed(9, pedtype, pos.x, pos.y, pos.z, heading, true, false)
            local gamerTag <const> = CreateFakeMpGamerTag(ped, ("Ped créé par un staff"), false, false, "test", false)
            SetMpGamerTagAlpha(gamerTag, 0, 150)
            SetMpGamerTagColour(gamerTag, 0, 4)
        end
    end)
end)

RegisterNetEvent('getCoords')
AddEventHandler('getCoords', function()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('returnCoords', coords)
end)

RegisterNetEvent('__render:tp')
AddEventHandler('__render:tp', function(coords)
    print(coords)
    SetEntityCoords(PlayerPedId(), coords, false, false, false, false)
end)
