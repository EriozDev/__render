fx_version 'bodacious'
games { 'gta5' }
description '__RENDER PROJECT'
author 'Erioz'

lua54 'yes'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/client/*.lua',
    'client/libs/*.lua',
    'modules/dev/dev_cl.lua'
}


server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/libs/*.lua',
    'server/server/*.lua',
    'modules/dev/dev_sv.lua'
}
