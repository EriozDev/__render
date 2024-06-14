fx_version 'bodacious'
games { 'gta5' }
description '__RENDER PROJECT'
author 'CFX SHOP'

lua54 'yes'

client_script {
	'client/*.lua',
}

            
server_scripts {
'@mysql-async/lib/MySQL.lua',
'server/*.lua',
}