local ChoiceNotifications <const> = {}

local NOTIFICATION_TTL <const> = 1000 * 15

--- @type {notificationHandler: number, createdAt: number, onAccept: function, onDecline: function}[]
local pendingChoices <const> = {}

local threadActive

local function isNotificationDuplicated(title, subject, msg)
    local matchesCount = 0
    for i = 1, #pendingChoices do
        local choice <const> = pendingChoices[i]
        if choice.title == title and choice.subject == subject and choice.msg == msg then
            matchesCount = matchesCount + 1
        end
    end
    return matchesCount
end

local function removeNotification(choiceIndex)
    local choice <const> = pendingChoices[choiceIndex]
    if not choice then
        return
    end
    ThefeedRemoveItem(choice.notificationHandler)
    table.remove(pendingChoices, choiceIndex)
end

local function invokeThread()
    threadActive = true
    Citizen.CreateThreadNow(function()
        while threadActive do
            local choicesLen <const> = #pendingChoices
            local gameTimer <const> = GetGameTimer()
            for i = choicesLen, 1, -1 do
                local choice <const> = pendingChoices[i]
                -- TIMER
                if gameTimer > (choice.createdAt + NOTIFICATION_TTL) then
                    removeNotification(i)
                end
            end
            if choicesLen == 0 then
                threadActive = false
                break
            end
            Wait(0)
        end
    end)
end

--- @param title string
--- @param subject string
--- @param msg string
--- @param icon string
--- @param iconType number
--- @param hudColorIndex number
--- @param onAccept function
--- @param onDecline function
function ChoiceNotifications.create(title, subject, msg, icon, hudColorIndex, onAccept, onDecline)
    if not onAccept or not onDecline then
        return error("onAccept and/or onDecline undefined")
    end
    local displayedTitle = title
    local duplicationCount <const> = isNotificationDuplicated(title, subject, msg)
    if duplicationCount > 0 then
        displayedTitle = displayedTitle .. (" (#%i)"):format(duplicationCount + 1)
    end
    local message = msg .. "~n~Actions: <font color=\"#4da150\"><b>(O)</b>ui</font>~s~ / <font color=\"#eb4034\"><b>(N)</b>on</font>"
    local notificationHandler <const> = GAME.showAdvancedNotification(displayedTitle, subject, message, icon, 7)
    pendingChoices[#pendingChoices + 1] = {
        notificationHandler = notificationHandler,
        createdAt = GetGameTimer(),
        onAccept = onAccept,
        onDecline = onDecline,
        title = title,
        subject = subject,
        msg = msg
    }
    if not threadActive then
        invokeThread()
    end
end

RegisterKeyMapping("+accept_notif", "Accepter la notification", "KEYBOARD", "O")
RegisterKeyMapping("+decline_notif", "D�cliner la notification", "KEYBOARD", "N")

RegisterCommand('+accept_notif', function()
    local choiceIdx <const> = #pendingChoices
    if choiceIdx == 0 then
        return
    end
    local choice <const> = pendingChoices[choiceIdx]
    PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
    removeNotification(choiceIdx)
    choice.onAccept()
end, false)

RegisterCommand('+decline_notif', function()
    local choiceIdx <const> = #pendingChoices
    if choiceIdx == 0 then
        return
    end
    local choice <const> = pendingChoices[choiceIdx]
    PlaySoundFrontend(-1, "Click_Fail", "WEB_NAVIGATION_SOUNDS_PHONE")
    removeNotification(choiceIdx)
    choice.onDecline()
end, false)

-- exemple
-- RegisterCommand('test', function()
--     ChoiceNotifications.create("Lester Crest", "~r~Événement",
--         "Hey! Psst, j'ai une mission à te proposer, acceptes-tu ?", "CHAR_LESTER", nil, function()
--         print("accept")
--     end, function()
--     end)
-- end)
