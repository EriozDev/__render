SCRIPT = {}

function SCRIPT.DEBUG(msg)
    if msg ~= nil or msg ~= '' then
        print('[^6DEBUG^0] => ', msg)
    end
end

function SCRIPT.INFO(msg)
    if msg ~= nil or msg ~= '' then
        print('[^4INFO^0] => ', msg)
    end
end

function SCRIPT.WARN(msg)
    if msg ~= nil or msg ~= '' then
        print('[^3WARN^0] => ', msg)
    end
end

function SCRIPT.ERROR(ErrorMsg)
    if ErrorMsg ~= nil or ErrorMsg ~= '' then
        print('[^1ERROR^0] => ', ErrorMsg)
    end
end
