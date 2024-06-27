IO.DEBUG('Sync of server has been set !')


RegisterCommand('reboot', function(source, args, rawCommand)
    if source == 0 then
        ExecuteCommand('refresh')
        ExecuteCommand('restart render')
    end
end)
