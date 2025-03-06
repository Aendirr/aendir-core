fx_version 'cerulean'
game 'gta5'

author 'Aendir'
description 'Aendir Core Framework'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    'client/main.lua',
    'client/vehicles.lua',
    'client/housing.lua',
    'client/jobs.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/vehicles.lua',
    'server/housing.lua',
    'server/jobs.lua'
}

dependencies {
    'ox_lib',
    'oxmysql'
}

lua54 'yes'
