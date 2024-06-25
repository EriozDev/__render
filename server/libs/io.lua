IO = {}

function IO.DEBUG(msg)
    if msg ~= nil or msg ~= '' then
        if DEV then
            print('[^6DEBUG^0] => ', msg)
        end
    end
end

function IO.INFO(msg)
    if msg ~= nil or msg ~= '' then
        print('[^4INFO^0] => ', msg)
    end
end

function IO.WARN(msg)
    if msg ~= nil or msg ~= '' then
        print('[^3WARN^0] => ', msg)
    end
end

function IO.ERROR(ErrorMsg)
    if ErrorMsg ~= nil or ErrorMsg ~= '' then
        print('[^1ERROR^0] => ', ErrorMsg)
    end
end
