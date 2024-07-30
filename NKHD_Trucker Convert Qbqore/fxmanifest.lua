fx_version 'cerulean'
game 'gta5'

author 'Niknock HD'
description 'NKHD Trucker'

version '1.1.5'

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Updated to use oxmysql
    'server.lua',
    'update.lua'
}

shared_scripts {
    '@qb-core/imports.lua', -- Updated to use qb-core
    'config.lua'
}

ui_page 'trucker_menu.html'

files {
    'trucker_menu.html'
}
