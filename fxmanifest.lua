fx_version 'bodacious'
games { 'gta5' }
description '__RENDER PROJECT'
author 'Erioz'

lua54 'yes'

client_script {
	'client/client/*.lua',
	'client/libs/*.lua',
}

            
server_scripts {
'@mysql-async/lib/MySQL.lua',
'server/libs/*.lua',
'server/server/*.lua',
}