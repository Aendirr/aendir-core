fx_version 'cerulean'
game 'gta5'

author 'Aendir'
description 'Aendir Core - Araç Yakıt Sistemi'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

lua54 'yes' 