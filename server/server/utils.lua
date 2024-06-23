Utils = {}

function Utils.log(msg)
    print('[__render log] => ', msg)
end

function Utils.StringForm(string)
    return ('[%s]'):format(
        string
    )
end

function Utils.StringValues(string)
    return ('[Values : %s]'):format(
        string
    )
end

function Utils.StringDebug(string)
    return ('[%s = {}]'):format(
        string
    )
end
