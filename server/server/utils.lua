Utils = {}

function Utils.log(msg)
    print('[__render log] => ', msg)
end

function Utils.StringForm(string)
    return ('[%u]'):format(
        string
    )
end
