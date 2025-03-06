fx_version 'cerulean'
game 'gta5'

author 'Aendir'
description 'Aendir Araç Sistemi'
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

dependencies {
    'aendir-core',
    'ox_lib',
    'oxmysql'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes' 