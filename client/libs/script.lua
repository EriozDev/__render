SCRIPT = {}

local __instance = {
    __index = SCRIPT,
    __type = 'script'
}

function SCRIPT.DEBUG(msg)
    print('[^6DEBUG^0] => ', msg)
end

function SCRIPT.ERROR(ErrorMsg)
    print('[^1ERROR^0] => ', ErrorMsg)
end