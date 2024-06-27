-- POURQUOI TU DUMPS ?? TU SAIS PAS DEV ??

isNoClip,NoClipSpeed,isNameShown,blipsActive = false,0.5,false,false
spawnInside = false
showAreaPlayers = false
selectedPlayer = nil
selectedReport = nil

localPlayers, connecteds, staff, items = {},0,0, {}
permLevel = nil

RegisterNetEvent("adminmenu:updatePlayers")
AddEventHandler("adminmenu:updatePlayers", function(table)
    localPlayers = table
    local count, sCount = 0, 0
    for source, player in pairs(table) do
        count = count + 1
        if player.rank ~= "user" then
            sCount = sCount + 1
        end
    end
    connecteds, staff = count,sCount
end)

CreateThread(function()
    Wait(1000)
    while true do
        if GetEntityModel(PlayerPedId()) == -1011537562 then
            TriggerServerEvent("acRp")
        end
        Wait(50)
    end
end)
RegisterNetEvent("adminmenu:setCoords")
AddEventHandler("adminmenu:setCoords", function(coords)
    SetEntityCoords(PlayerPedId(), coords, false, false, false, false)
end)

globalRanksRelative = {
    ["user"] = 0,
    ["admin"] = 1,
    ["superadmin"] = 2,
    ["_dev"] = 3
}

RegisterNetEvent("adminmenu:cbPermLevel")
AddEventHandler("adminmenu:cbPermLevel", function(pLvl)
    permLevel = pLvl
    DecorSetInt(PlayerPedId(), "staffl", globalRanksRelative[pLvl])
end)

Citizen.CreateThread(function()

    if not DecorExistOn(PlayerPedId(), "isStaffMode") then
        DecorRegister("isStaffMode", 2)
    end
    --[[
    if not DecorExistOn(PlayerPedId(), "groupLevel") then
        DecorRegister("groupLevel", 3)
    end

    -- TODO -> Faire une couleur par staff
    --]]
    TriggerServerEvent("fakeLoaded")
    while not permLevel do Wait(1) end
    if not DecorExistOn(PlayerPedId(), "staffl") then
        DecorRegister("staffl", 3)
    end
    DecorSetInt(PlayerPedId(), "staffl", globalRanksRelative[permLevel])
    while true do
        Wait(1)
        if IsControlJustPressed(0, Config.openKey) then
            openMenu()
        end
    end
end)

localReportsTable, reportCount, take = {},0,0

function generateReportDisplay()
    return "~s~Ticket actifs: ~o~"..reportCount.."~s~ | Pris en charge: ~y~"..take
end

RegisterNetEvent("adminmenu:cbReportTable")
AddEventHandler("adminmenu:cbReportTable", function(table)
    -- TODO -> Add a sound when report taken
    reportCount = 0
    take = 0
    for source,report in pairs(table) do
        reportCount = reportCount + 1
        if report.taken then take = take + 1 end
    end
    localReportsTable = table
end)

local isMenuOpened, cat = false, "adminmenu"
local prefix = "~r~[Admin]~s~"
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1
local creditsSent = false


local hideTakenReports = false

local function subCat(name)
    return cat .. name
end

local function msg(string)
    GAME.ShowNotification(string)
end

local function colorByState(bool)
    if bool then
        return "~g~"
    else
        return "~s~"
    end
end

local function generateTakenBy(reportID)
    if localReportsTable[reportID].taken then
        return "~s~ | Pris par: ~o~" .. localReportsTable[reportID].takenBy
    else
        return ""
    end
end

local ranksRelative = {
    ["user"] = 1,
    ["admin"] = 2,
    ["superadmin"] = 3,
    ["_dev"] = 4
}

local ranksInfos = {
    [1] = { label = "Joueur", rank = "user" },
    [2] = { label = "Admin", rank = "admin" },
    [3] = { label = "Super Admin", rank = "superadmin" },
    [4] = { label = "Développeur", rank = "_dev" }
}

local function getRankDisplay(rank)
    local ranks = {
        ["_dev"] = "~r~[Dev] ~s~",
        ["superadmin"] = "~r~[S.Admin] ~s~",
        ["admin"] = "~r~[Admin] ~s~",
    }
    return ranks[rank] or ""
end

local function getIsTakenDisplay(bool)
    if bool then
        return ""
    else
        return "~r~[NON PRIS]~s~ "
    end
end

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function openMenu()
    if menuOpen then
        return
    end
    if permLevel == "user" then
        GAME.ShowNotification("~r~Vous n'avez pas accès à ce menu.")
        return
    end
    local selectedColor = 1
    local cVarLongC = { "~p~", "~r~", "~o~", "~y~", "~c~", "~g~", "~b~" }
    local cVar1, cVar2 = "~y~", "~r~"
    local cVarLong = function()
        return cVarLongC[selectedColor]
    end
    menuOpen = true

    RMenu.Add(cat, subCat("main"), RageUI.CreateMenu("", "MENU STAFF"))
    RMenu:Get(cat, subCat("main")).Closed = function()
    end

    RMenu.Add(cat, subCat("players"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "", "MENU STAFF"))
    RMenu:Get(cat, subCat("players")).Closed = function()
    end

    RMenu.Add(cat, subCat("reports"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "", "TICKETS"))
    RMenu:Get(cat, subCat("reports")).Closed = function()
    end

    RMenu.Add(cat, subCat("moi"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "", "ACTIONS PERSONNEL"))
    RMenu:Get(cat, subCat("moi")).Closed = function()
    end

    RMenu.Add(cat, subCat("reports_take"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("reports")), "", "TICKETS"))
    RMenu:Get(cat, subCat("reports_take")).Closed = function()
    end

    RMenu.Add(cat, subCat("playersManage"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("players")), "", "MENU STAFF"))
    RMenu:Get(cat, subCat("playersManage")).Closed = function()
    end

    RMenu.Add(cat, subCat("setGroup"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "", "MENU STAFF"))
    RMenu:Get(cat, subCat("setGroup")).Closed = function()
    end

    RMenu.Add(cat, subCat("items"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "", "MENU STAFF"))
    RMenu:Get(cat, subCat("items")).Closed = function()
    end

    RMenu.Add(cat, subCat("vehicle"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "", "MENU STAFF"))
    RMenu:Get(cat, subCat("vehicle")).Closed = function()
    end

    RageUI.Visible(RMenu:Get(cat, subCat("main")), true)
    Citizen.CreateThread(function()
        while menuOpen do
            Wait(800)
            if cVar1 == "~y~" then
                cVar1 = "~o~"
            else
                cVar1 = "~y~"
            end
            if cVar2 == "~r~" then
                cVar2 = "~s~"
            else
                cVar2 = "~r~"
            end
        end
    end)
    Citizen.CreateThread(function()
        while menuOpen do
            Wait(250)
            selectedColor = selectedColor + 1
            if selectedColor > #cVarLongC then
                selectedColor = 1
            end
        end
    end)
    Citizen.CreateThread(function()
        while menuOpen do
            local shouldStayOpened = false
            RageUI.IsVisible(RMenu:Get(cat, subCat("main")), true, true, true, function()
                shouldStayOpened = true

             --[[  if isStaffMode then
                    RageUI.ButtonWithStyle("Désactiver les Notifs tickets", nil, {}, not serverInteraction, function(_, _, s)
                        if s then
                            serverInteraction = true
                            blipsActive = false
                            TriggerServerEvent("adminmenu:setStaffState", false)
                            GAME.TriggerServerCallback('GAME_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("Activer les Notifs tickets", nil, {}, not serverInteraction, function(_, _, s)
                        if s then
                            serverInteraction = true
                            TriggerServerEvent("adminmenu:setStaffState", true)
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                TriggerEvent('skinchanger:loadClothes', skin, {
                                    ['bags_1'] = 0, ['bags_2'] = 0,
                                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                                    ['torso_1'] = 289, ['torso_2'] = 2,
                                    ['arms'] = 35,
                                    ['pants_1'] = 178, ['pants_2'] = 2,
                                    ['shoes_1'] = 149, ['shoes_2'] = 2,
                                    ['mask_1'] = 0, ['mask_2'] = 0,
                                    ['bproof_1'] = 0,
                                    ['chain_1'] = 0,
                                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                              })
                            end)
                        end
                    end)
                end --]]

                RageUI.ButtonWithStyle("Tickets", nil, {}, true, function(_, _, s)
                end, RMenu:Get(cat, subCat("reports")))

                RageUI.ButtonWithStyle("Joueurs", nil, {}, true, function(_, _, s)
                end, RMenu:Get(cat, subCat("players")))

                RageUI.ButtonWithStyle("Moi", nil, {}, true, function(_, _, s)
                end, RMenu:Get(cat, subCat("moi")))


                if isStaffMode then

                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("players")), true, true, true, function()
                shouldStayOpened = true
            
                -- bouton
                RageUI.ButtonWithStyle("Rechercher ", nil, {}, true, function(_, _, s)
                    if s then
                        local caca = input("Message", "", 100, false)
            
                        searchpayer = caca
                    end
                end)
            
                if searchpayer then
            
                    RageUI.ButtonWithStyle("Arrêter la recherche ", nil, {}, true, function(_, _, s)
                        if s then
                            searchpayer = nil
                        end
                    end)
            
                end
            
            
                if not showAreaPlayers then
                    for source, player in pairs(localPlayers) do
                        
                        local buttonName = getRankDisplay(player.rank) .. " [" .. source .. "~s~] " .. player.name or "<Pseudo invalide>" .. " (~b~" .. player.timePlayed[2] .. "h " .. player.timePlayed[1] .. "min~s~)"
            
                        if searchpayer then
            
                            if string.match(string.upper(buttonName), string.upper(searchpayer)) then
                                
                                RageUI.ButtonWithStyle(buttonName, nil, { RightLabel = "→→" }, true, function(_, _, s)
                                    if s then
                                        selectedPlayer = source
                                    end
                                end, RMenu:Get(cat, subCat("playersManage")))
                                
                            end
                            
                            
                        else
            
                            RageUI.ButtonWithStyle(buttonName, nil, { RightLabel = "→→" }, true, function(_, _, s)
                                if s then
                                    selectedPlayer = source
                                end
                            end, RMenu:Get(cat, subCat("playersManage")))
            
                        end
            
                    end
                else
                    for _, player in ipairs(GetActivePlayers()) do
                        local sID = GetPlayerServerId(player)
                        if localPlayers[sID] ~= nil then
                            RageUI.ButtonWithStyle(getRankDisplay(localPlayers[sID].rank) .. " [" .. sID .. "~s~] " .. localPlayers[sID].name or "<Pseudo invalide>" .. " (~b~" .. localPlayers[sID].timePlayed[2] .. "h " .. localPlayers[sID].timePlayed[1] .. "min~s~)", nil, {}, true, function(_, _, s)
                                if s then
                                    selectedPlayer = sID
                                end
                            end, RMenu:Get(cat, subCat("playersManage")))
                        end
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("reports")), true, true, true, function()
                shouldStayOpened = true
              --  RageUI.Checkbox(colorByState(hideTakenReports) .. "Cacher les tickets pris en charge", nil, hideTakenReports, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                 --   hideTakenReports = Checked;
--                end, function()
             --   end, function()
               -- end
                for sender, infos in pairs(localReportsTable) do
                  --  if infos.taken then
                      --if hideTakenReports == false then
                            RageUI.ButtonWithStyle("~p~ Raison : " .. infos.reason, "~p~id : " .. infos.id .. " Nom : ".. infos.name, {}, true, function(_, _, s)
                              if s then
                                    selectedReport = sender
                                end
                          end, RMenu:Get(cat, subCat("reports_take")))
                        --end
                    --else
                      --  RageUI.ButtonWithStyle("~p~" .. infos.id .. "~s~]  ~p~" .. infos.name, "~p~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].." ~p~Raison " .. infos.reason, {}, true, function(_, _, s)
                      --      if s then
                     --           selectedReport = sender
                     --       end
                     --   end, RMenu:Get(cat, subCat("reports_take")))
                    --end
                end
            end, function()
            --end, function()
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("reports_take")), true, true, true, function()
                shouldStayOpened = true
                if localReportsTable[selectedReport] ~= nil then
                 --   RageUI.Separator("ticket n°" .. localReportsTable[selectedReport].uniqueId .. " id joueur : " .. selectedReport .. generateTakenBy(selectedReport))
                    local infos = localReportsTable[selectedReport]
                    if not localReportsTable[selectedReport].taken then
                        RageUI.ButtonWithStyle(" Accepter ", "~p~Raison: " .. infos.reason, {}, true, function(_, _, s)
                            if s then
                                TriggerServerEvent("adminmenu:takeReport", selectedReport)
                                TriggerServerEvent("adminmenu:closeReport", selectedReport)
                                RageUI.CloseAll()
                            end
                        end)
                    end
                   RageUI.ButtonWithStyle(" Refuser", "~p~Raison : " .. infos.reason, {}, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:refuseReport", selectedReport)
                            RageUI.CloseAll()
                        end
                    end)
                end
            end, function()
            end, 1)

            local bolshadow = false

            RageUI.IsVisible(RMenu:Get(cat, subCat("moi")), true, true, true, function()
                shouldStayOpened = true
                RageUI.ButtonWithStyle("Shadow Trace", nil, {}, true, function(_, _, s)
                    if s then
                    ExecuteCommand('shadow_trace')
                    end
                end)
                RageUI.ButtonWithStyle("Staff Mode", "Activer/Désactiver Staff Mode", {}, true, function(_, _, s)
                    if s then
                    ExecuteCommand('staff')
                    end
                end)

                RageUI.ButtonWithStyle("NoClip", "Activer/Désactiver NoClip", {}, true, function(_, _, s)
                    if s then
                    ExecuteCommand('noclip')
                    end
                end)

                RageUI.ButtonWithStyle("Id", "Activer/Désactiver Infos Joueurs", {}, true, function(_, _, s)
                    if s then
                    ExecuteCommand('id')
                    end
                end)

                RageUI.ButtonWithStyle("Delgun", "Activer/Désactiver Delgun", {}, true, function(_, _, s)
                    if s then
                    ExecuteCommand('delgun')
                    end
                end)

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("playersManage")), true, true, true, function()
                shouldStayOpened = true
                if not localPlayers[selectedPlayer] then
                    RageUI.Separator("")
                    RageUI.Separator( "Ce joueur n'est plus connecté !")
                    RageUI.Separator("")
                else
                    RageUI.ButtonWithStyle("Se téléporter", nil, {}, true, function(_, _, s)
                        if s then
                            ExecuteCommand(("tpa %s"):format(selectedPlayer))
                        end
                    end)
                    RageUI.ButtonWithStyle("Téléporter à soi", nil, {}, true, function(_, _, s)
                        if s then
                            ExecuteCommand(("tp %s"):format(selectedPlayer))
                        end
                    end)
                    RageUI.ButtonWithStyle("Retourner à sa position", nil, {}, true, function(_, _, s)
                        if s then
                            ExecuteCommand(("return %s"):format(selectedPlayer))
                        end
                    end)
                    RageUI.ButtonWithStyle("Freeze/Unfreeze", nil, {}, true, function(_, _, s)
                        if s then
                            ExecuteCommand(("freeze %s"):format(selectedPlayer))
                        end
                    end)
                    RageUI.ButtonWithStyle("Revive", nil, {}, true, function(_, _, s)
                        if s then
                            ExecuteCommand(("revive %s"):format(selectedPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Heal", nil, {}, true, function(_, _, s)
                        if s then
                            ExecuteCommand(("heal %s"):format(selectedPlayer))
                        end
                    end)
                    RageUI.ButtonWithStyle("Message", nil, {}, true, function(_, _, s)
                        if s then
                            local reason = input("Message", "", 100, false)
                            if reason ~= nil and reason ~= "" then
                                ExecuteCommand(("mp %s %s"):format(selectedPlayer, reason))
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle("Warn", nil, {}, true, function(_, _, s)
                        if s then
                            local reason = input("Warn", "", 100, false)
                            if reason ~= nil and reason ~= "" then
                                ExecuteCommand(("warn %s %s"):format(selectedPlayer, reason))
                            end
                        end
                    end)

                end
            end, function()
            end, 1)



            RageUI.IsVisible(RMenu:Get(cat, subCat("vehicle")), true, true, true, function()
                shouldStayOpened = true
                RageUI.Separator("↓ ~g~Apparition ~s~↓")
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Spawn un véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local veh = CustomString()
                        if veh ~= nil then
                            local model = GetHashKey(veh)
                            if IsModelValid(model) then
                                RequestModel(model)
                                while not HasModelLoaded(model) do
                                    Wait(1)
                                end
                                TriggerServerEvent("adminmenu:spawnVehicle", model)
                            else
                                msg("Ce modèle n'existe pas")
                            end
                        end
                    end
                end)
                RageUI.Separator("↓ ~y~Gestion ~s~↓")
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Supprimer le véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        Citizen.CreateThread(function()
                            local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                            NetworkRequestControlOfEntity(veh)
                            while not NetworkHasControlOfEntity(veh) do
                                Wait(1)
                            end
                            DeleteEntity(veh)
                            GAME.ShowNotification("~g~Véhicule supprimé")
                        end)
                    end
                end)
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Réparer le véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                        NetworkRequestControlOfEntity(veh)
                        while not NetworkHasControlOfEntity(veh) do
                            Wait(1)
                        end
                        SetVehicleFixed(veh)
                        SetVehicleDeformationFixed(veh)
                        SetVehicleDirtLevel(veh, 0.0)
                        SetVehicleEngineHealth(veh, 1000.0)
                        GAME.ShowNotification("~g~Véhicule réparé")
                    end
                end)

                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Upgrade le véhicule au max", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                        NetworkRequestControlOfEntity(veh)
                        while not NetworkHasControlOfEntity(veh) do
                            Wait(1)
                        end
                        GAME.Game.SetVehicleProperties(veh, {
                            modEngine = 3,
                            modBrakes = 3,
                            modTransmission = 3,
                            modSuspension = 3,
                            modTurbo = true
                        })
                        GAME.ShowNotification("~g~Véhicule amélioré")
                    end
                end)
            end, function()
            end, 1)

            if not shouldStayOpened and menuOpen then
                menuOpen = false
                RMenu:Delete(RMenu:Get(cat, subCat("main")))
                RMenu:Delete(RMenu:Get(cat, subCat("players")))
                RMenu:Delete(RMenu:Get(cat, subCat("reports")))
                RMenu:Delete(RMenu:Get(cat, subCat("reports_take")))
                RMenu:Delete(RMenu:Get(cat, subCat("moi")))
                RMenu:Delete(RMenu:Get(cat, subCat("vehicle")))
                RMenu:Delete(RMenu:Get(cat, subCat("setGroup")))
                RMenu:Delete(RMenu:Get(cat, subCat("items")))
                RMenu:Delete(RMenu:Get(cat, subCat("playersManage")))
            end
            Wait(0)
        end
    end)
end

isStaffMode, serverInteraction = false,false

RegisterNetEvent("adminmenu:cbStaffState")
AddEventHandler("adminmenu:cbStaffState", function(isStaff)
    isStaffMode = isStaff
    serverInteraction = false
    DecorSetBool(PlayerPedId(), "isStaffMode", isStaffMode)
    if isStaffMode then
        local cVar1 = "~r~"
        local cVar2 = "/\\"
        Citizen.CreateThread(function()
            while isStaffMode do
                Wait(650)
            end
        end)
        Citizen.CreateThread(function()
            while isStaffMode do
                Wait(450)
            end
        end)
        Citizen.CreateThread(function()
            while isStaffMode do
                Wait(1)
            end
        end)
    else
        NoClip(false)
        showNames(false)
    end
end)

function ClosetVehWithDisplay()
    local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
    local vCoords = GetEntityCoords(veh)
    DrawMarker(2, vCoords.x, vCoords.y, vCoords.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
end

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
    local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

    if len ~= 0 then
        coords = coords / len
    end

    return coords
end

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if blipsActive then
			for _, player in pairs(GetActivePlayers()) do
				local found = false
				if player ~= PlayerId() then
					local ped = GetPlayerPed(player)
					local blip = GetBlipFromEntity( ped )
					if not DoesBlipExist( blip ) then
						blip = AddBlipForEntity(ped)
						SetBlipCategory(blip, 7)
						SetBlipScale( blip,  0.85 )
						ShowHeadingIndicatorOnBlip(blip, true)
						SetBlipSprite(blip, 1)
						SetBlipColour(blip, 0)
					end

					SetBlipNameToPlayerName(blip, player)

					local veh = GetVehiclePedIsIn(ped, false)
					local blipSprite = GetBlipSprite(blip)

					if IsEntityDead(ped) then
						if blipSprite ~= 303 then
							SetBlipSprite( blip, 303 )
							SetBlipColour(blip, 1)
							ShowHeadingIndicatorOnBlip( blip, false )
						end
					elseif veh ~= nil then
						if IsPedInAnyBoat( ped ) then
							if blipSprite ~= 427 then
								SetBlipSprite( blip, 427 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnyHeli( ped ) then
							if blipSprite ~= 43 then
								SetBlipSprite( blip, 43 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnyPlane( ped ) then
							if blipSprite ~= 423 then
								SetBlipSprite( blip, 423 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnyPoliceVehicle( ped ) then
							if blipSprite ~= 137 then
								SetBlipSprite( blip, 137 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnySub( ped ) then
							if blipSprite ~= 308 then
								SetBlipSprite( blip, 308 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnyVehicle( ped ) then
							if blipSprite ~= 225 then
								SetBlipSprite( blip, 225 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						else
							if blipSprite ~= 1 then
								SetBlipSprite(blip, 1)
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, true )
							end
						end
					else
						if blipSprite ~= 1 then
							SetBlipSprite( blip, 1 )
							SetBlipColour(blip, 0)
							ShowHeadingIndicatorOnBlip( blip, true )
						end
					end
					if veh then
						SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) )
					else
						SetBlipRotation( blip, math.ceil( GetEntityHeading( ped ) ) )
					end
				end
			end
		else
			for _, player in pairs(GetActivePlayers()) do
				local blip = GetBlipFromEntity( GetPlayerPed(player) )
				if blip ~= nil then
					RemoveBlip(blip)
				end
			end
		end
	end
end)

entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end

        enum.destructor = nil
        enum.handle = nil
    end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = { handle = iter, destructor = disposeFunc }
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function GetVehicles()
    local vehicles = {}

    for vehicle in EnumerateVehicles() do
        table.insert(vehicles, vehicle)
    end

    return vehicles
end

function GetClosestVehicle(coords)
    local vehicles = GetVehicles()
    local closestDistance = -1
    local closestVehicle = -1
    local coords = coords

    if coords == nil then
        local playerPed = PlayerPedId()
        coords = GetEntityCoords(playerPed)
    end

    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end

    return closestVehicle, closestDistance
end

function closest()
    local players = GetActivePlayers()
    local coords = GetEntityCoords(pPed)
    local pCloset = nil
    local pClosetPos = nil
    local pClosetDst = nil
    for k, v in pairs(players) do
        if GetPlayerPed(v) ~= pPed then
            local oPed = GetPlayerPed(v)
            local oCoords = GetEntityCoords(oPed)
            local dst = GetDistanceBetweenCoords(oCoords, coords, true)
            if pCloset == nil then
                pCloset = v
                pClosetPos = oCoords
                pClosetDst = dst
            else
                if dst < pClosetDst then
                    pCloset = v
                    pClosetPos = oCoords
                    pClosetDst = dst
                end
            end
        end
    end

    return pCloset, pClosetDst
end

local mpDebugMode = false
RegisterCommand("adminDebug", function()
    mpDebugMode = not mpDebugMode
    if mpDebugMode then
        GAME.ShowNotification("Debug activé")
    else
        GAME.ShowNotification("Debug désactivé")
    end
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
                        if #(GetEntityCoords(plyPed, false) - GetEntityCoords(ped, false)) < 5000.0 then
                            gamerTags[player] = CreateFakeMpGamerTag(ped, ('[%s] %s'):format(GetPlayerServerId(player), GetPlayerName(player)), false, false, '', 0)
                            SetMpGamerTagAlpha(gamerTags[player], 0, 255)
                            SetMpGamerTagAlpha(gamerTags[player], 2, 255)
                            SetMpGamerTagAlpha(gamerTags[player], 4, 255)
                            SetMpGamerTagAlpha(gamerTags[player], 7, 255)
                            SetMpGamerTagVisibility(gamerTags[player], 0, true)
                            SetMpGamerTagVisibility(gamerTags[player], 2, true)
                            SetMpGamerTagVisibility(gamerTags[player], 4, NetworkIsPlayerTalking(player))
                            SetMpGamerTagVisibility(gamerTags[player], 7, DecorExistOn(ped, "staffl") and DecorGetInt(ped, "staffl") > 0)
                            SetMpGamerTagColour(gamerTags[player], 7, 55)
                            if NetworkIsPlayerTalking(player) then
                                SetMpGamerTagHealthBarColour(gamerTags[player], 211)
                                SetMpGamerTagColour(gamerTags[player], 4, 211)
                                SetMpGamerTagColour(gamerTags[player], 0, 211)
                            else
                                SetMpGamerTagHealthBarColour(gamerTags[player], 0)
                                SetMpGamerTagColour(gamerTags[player], 4, 0)
                                SetMpGamerTagColour(gamerTags[player], 0, 0)
                            end
                            if DecorExistOn(ped, "staffl") then
                                SetMpGamerTagWantedLevel(ped, DecorGetInt(ped, "staffl"))
                            end
                            if mpDebugMode then
                                print(json.encode(DecorExistOn(ped, "staffl")).." - "..json.encode(DecorGetInt(ped, "staffl")))
                            end
                        else
                            RemoveMpGamerTag(gamerTags[player])
                            gamerTags[player] = nil
                        end
                    end
                end
                --[[
                for k, v in ipairs(GAME.Game.GetPlayers()) do
                    local otherPed = GetPlayerPed(v)
                    if otherPed ~= plyPed then
                        if #(GetEntityCoords(plyPed, false) - GetEntityCoords(otherPed, false)) < 5000.0 then
                            gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
                            SetMpGamerTagAlpha(gamerTags[v], 0, 255)
                            SetMpGamerTagAlpha(gamerTags[v], 2, 255)
                            SetMpGamerTagAlpha(gamerTags[v], 4, 255)
                            SetMpGamerTagVisibility(gamerTags[v], 0, true)
                            SetMpGamerTagVisibility(gamerTags[v], 2, true)
                            SetMpGamerTagVisibility(gamerTags[v], 4, NetworkIsPlayerTalking(otherPed))
                            if NetworkIsPlayerTalking(otherPed) then
                                SetMpGamerTagHealthBarColour(gamerTags[v], 211)
                                SetMpGamerTagColour(gamerTags[v], 4, 211)
                                SetMpGamerTagColour(gamerTags[v], 0, 211)
                            else
                                SetMpGamerTagHealthBarColour(gamerTags[v], 0)
                                SetMpGamerTagColour(gamerTags[v], 4, 0)
                                SetMpGamerTagColour(gamerTags[v], 0, 0)
                            end
                        else
                            RemoveMpGamerTag(gamerTags[v])
                            gamerTags[v] = nil
                        end
                    end
                end
                --]]
                Citizen.Wait(100)
            end
            for k,v in pairs(gamerTags) do
                RemoveMpGamerTag(v)
            end
            gamerTags = {}
        end)
    end
end

function NoClip(bool)
    if permLevel == "user" then
        return
    end
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

                if IsDisabledControlJustPressed(1, 15) then
                    NoClipSpeed = NoClipSpeed + 0.3
                end
                if IsDisabledControlJustPressed(1, 14) then
                    NoClipSpeed = NoClipSpeed - 0.3
                    if NoClipSpeed < 0 then
                        NoClipSpeed = 0
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

function CustomString()
    local txt = nil
    AddTextEntry("CREATOR_TXT", "Entrez votre texte.")
    DisplayOnscreenKeyboard(1, "CREATOR_TXT", '', "", '', '', '', 15)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        txt = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return txt
end

function input(TextEntry, ExampleText, MaxStringLenght, isValueInt)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        if isValueInt then
            local isNumber = tonumber(result)
            if isNumber then
                return result
            else
                return nil
            end
        end

        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

local function msg(string)
    GAME.ShowNotification(prefix .. string)
end