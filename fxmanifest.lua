fx_version 'cerulean'
game 'gta5'

author 'Aendir'
description 'Aendir Core Framework - Gerçekçi Hayat Simülasyonu'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    -- Ana Modüller
    'client/main.lua',
    'client/vehicles.lua',
    'client/housing.lua',
    'client/jobs.lua',
    
    -- Hırsızlık Sistemi
    'client/heist/*.lua',
    
    -- Araç Sistemi
    'client/cars/*.lua',
    
    -- Meslek Sistemleri
    'client/jobs/police/*.lua',
    'client/jobs/ambulance/*.lua',
    'client/jobs/mechanic/*.lua',
    'client/jobs/taxi/*.lua',
    'client/jobs/restaurant/*.lua',
    'client/jobs/fishing/*.lua',
    'client/jobs/hunting/*.lua',
    'client/jobs/mining/*.lua',
    'client/jobs/farming/*.lua',
    'client/jobs/construction/*.lua',
    'client/jobs/warehouse/*.lua',
    'client/jobs/delivery/*.lua',
    'client/jobs/security/*.lua',
    'client/jobs/barber/*.lua',
    'client/jobs/tattoo/*.lua',
    'client/jobs/realestate/*.lua',
    'client/jobs/lawyer/*.lua',
    'client/jobs/bank/*.lua',
    'client/jobs/casino/*.lua',
    'client/jobs/racing/*.lua',
    
    -- Sosyal Sistemler
    'client/social/*.lua',
    
    -- Ev Sistemleri
    'client/housing/*.lua',
    
    -- Envanter Sistemi
    'client/inventory/*.lua',
    
    -- Animasyon Sistemi
    'client/animations/*.lua',
    
    -- Telefon Sistemi
    'client/phone/*.lua',
    
    -- Banka Sistemi
    'client/bank/*.lua',
    
    -- Market Sistemi
    'client/shops/*.lua',
    
    -- Üretim Sistemi
    'client/crafting/*.lua',
    
    -- Hava Durumu Sistemi
    'client/weather/*.lua',
    
    -- Zaman Sistemi
    'client/time/*.lua',
    
    -- Yetenek Sistemi
    'client/skills/*.lua',
    
    -- Başarı Sistemi
    'client/achievements/*.lua',
    
    -- Görev Sistemi
    'client/quests/*.lua',
    
    -- Log Sistemi
    'client/logs/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    
    -- Ana Modüller
    'server/main.lua',
    'server/vehicles.lua',
    'server/housing.lua',
    'server/jobs.lua',
    
    -- Hırsızlık Sistemi
    'server/heist/*.lua',
    
    -- Araç Sistemi
    'server/cars/*.lua',
    
    -- Meslek Sistemleri
    'server/jobs/police/*.lua',
    'server/jobs/ambulance/*.lua',
    'server/jobs/mechanic/*.lua',
    'server/jobs/taxi/*.lua',
    'server/jobs/restaurant/*.lua',
    'server/jobs/fishing/*.lua',
    'server/jobs/hunting/*.lua',
    'server/jobs/mining/*.lua',
    'server/jobs/farming/*.lua',
    'server/jobs/construction/*.lua',
    'server/jobs/warehouse/*.lua',
    'server/jobs/delivery/*.lua',
    'server/jobs/security/*.lua',
    'server/jobs/barber/*.lua',
    'server/jobs/tattoo/*.lua',
    'server/jobs/realestate/*.lua',
    'server/jobs/lawyer/*.lua',
    'server/jobs/bank/*.lua',
    'server/jobs/casino/*.lua',
    'server/jobs/racing/*.lua',
    
    -- Sosyal Sistemler
    'server/social/*.lua',
    
    -- Ev Sistemleri
    'server/housing/*.lua',
    
    -- Envanter Sistemi
    'server/inventory/*.lua',
    
    -- Telefon Sistemi
    'server/phone/*.lua',
    
    -- Banka Sistemi
    'server/bank/*.lua',
    
    -- Market Sistemi
    'server/shops/*.lua',
    
    -- Üretim Sistemi
    'server/crafting/*.lua',
    
    -- Hava Durumu Sistemi
    'server/weather/*.lua',
    
    -- Zaman Sistemi
    'server/time/*.lua',
    
    -- Yetenek Sistemi
    'server/skills/*.lua',
    
    -- Başarı Sistemi
    'server/achievements/*.lua',
    
    -- Görev Sistemi
    'server/quests/*.lua',
    
    -- Log Sistemi
    'server/logs/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/*.png'
}

dependencies {
    'ox_lib',
    'oxmysql'
}

lua54 'yes'
