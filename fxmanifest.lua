fx_version 'bodacious'
games { 'gta5' }
description '__RENDER PROJECT'
author 'Erioz'

lua54 'yes'

shared_scripts {
    '@shadow/config.lua',
    'modules/admins/config.lua',
    'config.lua'
}

client_scripts {
    '@shadow/client/cl_antitriggers.lua',
    'client/client/*.lua',
    'client/libs/*.lua',
    'modules/DEV/dev_cl.lua',
    'modules/admins/client.lua',
    'modules/admins/staffmenu.lua',
    "shared/libs/RageUI/client/RMenu.lua",
    "shared/libs/RageUI/client/menu/RageUI.lua",
    "shared/libs/RageUI/client/menu/Menu.lua",
    "shared/libs/RageUI/client/menu/MenuController.lua",
    "shared/libs/RageUI/client/components/*.lua",
    "shared/libs/RageUI/client/menu/elements/*.lua",
    "shared/libs/RageUI/client/menu/items/*.lua",
    "shared/libs/RageUI/client/menu/panels/*.lua",
    "shared/libs/RageUI/client/menu/windows/*.lua",
    -- 'shared/libs/mysql-async/mysql-async-client.js'
}


server_scripts {
    '@shadow/server/antitrigger_shared.lua',
    '@shadow/server/_antitriggers.lua',
    '@shadow/server/funcs.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/libs/*.lua',
    'server/server/*.lua',
    'modules/DEV/dev_sv.lua',
    'modules/admins/server.lua',
    'modules/admins/staffmenu_sv.lua'
    -- 'shared/libs/mysql-async/mysql-async.js',
    -- 'shared/libs/mysql-async/lib/MySQL.lua'
}

-- ui_page('shared/libs/mysql-async/ui/index.html')

-- files({
-- 	'shared/libs/mysql-async/ui/index.html',
-- 	'shared/libs/mysql-async/ui/app.js',
-- 	'shared/libs/mysql-async/ui/app.css',
-- 	'shared/libs/mysql-async/ui/fonts/*'
-- })
