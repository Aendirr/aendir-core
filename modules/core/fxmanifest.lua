fx_version 'cerulean'
game 'gta5'

author 'Aendir'
description 'Aendir Core Systems'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    'client/main.lua',
    'client/animations.lua',
    'client/notifications.lua',
    'client/commands.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/commands.lua',
    'server/items.lua',
    'server/vehicles.lua',
    'server/housing.lua',
    'server/banking.lua',
    'server/whitelist.lua'
}

dependencies {
    'ox_lib',
    'oxmysql'
} 