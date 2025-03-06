fx_version 'cerulean'
game 'gta5'

author 'Aendir'
description 'Aendir Inventory System'
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

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/app.js',
    'html/img/items/*.png',
    'html/img/items/items.json'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'

dependencies {
    'ox_lib',
    'oxmysql',
    'aendir-core'
} 