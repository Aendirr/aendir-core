fx_version 'cerulean'
game 'gta5'

author 'Aendir'
description 'Aendir Core - Ana Sistem'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/core.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/core.lua'
}

files {
    'sql/*.sql'
}

lua54 'yes'

dependency 'ox_lib'
dependency 'oxmysql' 