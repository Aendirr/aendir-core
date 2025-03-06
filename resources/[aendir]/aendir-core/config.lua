Config = {}

-- Genel Ayarlar
Config.Debug = false
Config.Language = 'tr'
Config.DefaultSpawn = vector4(0.0, 0.0, 0.0, 0.0)

-- Para Ayarları
Config.StartingCash = 1000
Config.StartingBank = 5000
Config.PaycheckInterval = 30 -- dakika
Config.PaycheckAmount = 500

-- Karakter Ayarları
Config.MaxCharacters = 5
Config.StartingJob = 'unemployed'
Config.StartingGang = 'none'

-- Araç Ayarları
Config.CarWashPrice = 100
Config.FuelPrice = 10
Config.RepairPrice = 500

-- Mülk Ayarları
Config.MaxProperties = 3
Config.PropertyTax = 0.1 -- %10
Config.PropertyInterval = 24 -- saat

-- İşletme Ayarları
Config.MaxBusinesses = 2
Config.BusinessTax = 0.2 -- %20
Config.BusinessInterval = 24 -- saat

-- Silah Ayarları
Config.WeaponDamageMultiplier = 1.0
Config.WeaponRecoilMultiplier = 1.0

-- Hava Durumu Ayarları
Config.WeatherInterval = 30 -- dakika
Config.WeatherTypes = {
    'CLEAR',
    'EXTRASUNNY',
    'CLOUDS',
    'OVERCAST',
    'RAIN',
    'THUNDER',
    'CLEARING',
    'SMOG',
    'FOGGY'
}

-- Bildirim Ayarları
Config.NotificationDuration = 5000 -- ms
Config.NotificationPosition = 'top-right'

-- İlerleme Çubuğu Ayarları
Config.ProgressBarPosition = 'bottom'
Config.ProgressBarColor = '#4CAF50'

-- Komut Ayarları
Config.Commands = {
    -- Admin Komutları
    ['addmoney'] = 'admin',
    ['removemoney'] = 'admin',
    ['setjob'] = 'admin',
    ['setgang'] = 'admin',
    ['giveweapon'] = 'admin',
    ['removeweapon'] = 'admin',
    ['car'] = 'admin',
    ['dv'] = 'admin',
    ['tp'] = 'admin',
    ['setweather'] = 'admin',
    ['freeze'] = 'admin',
    ['unfreeze'] = 'admin',
    ['kick'] = 'admin',
    ['ban'] = 'admin',
    ['unban'] = 'admin',
    
    -- Oyuncu Komutları
    ['id'] = 'user',
    ['report'] = 'user',
    ['me'] = 'user',
    ['do'] = 'user',
    ['ooc'] = 'user',
    ['help'] = 'user'
}

-- Tuş Ayarları
Config.Keys = {
    ['F1'] = 'menu',
    ['F2'] = 'inventory',
    ['F3'] = 'emotes',
    ['F6'] = 'job',
    ['F7'] = 'gang',
    ['K'] = 'phone',
    ['L'] = 'vehicle',
    ['U'] = 'lock'
}

-- Veritabanı Ayarları
Config.Database = {
    -- Oyuncu Tablosu
    players = {
        table = 'players',
        columns = {
            id = 'id',
            identifier = 'identifier',
            license = 'license',
            name = 'name',
            money = 'money',
            bank = 'bank',
            job = 'job',
            job_grade = 'job_grade',
            gang = 'gang',
            gang_grade = 'gang_grade'
        }
    },
    
    -- Karakter Tablosu
    characters = {
        table = 'characters',
        columns = {
            id = 'id',
            identifier = 'identifier',
            slot = 'slot',
            firstname = 'firstname',
            lastname = 'lastname',
            dateofbirth = 'dateofbirth',
            gender = 'gender',
            height = 'height',
            skin = 'skin'
        }
    },
    
    -- Araç Tablosu
    vehicles = {
        table = 'vehicles',
        columns = {
            id = 'id',
            identifier = 'identifier',
            plate = 'plate',
            model = 'model',
            stored = 'stored',
            garage = 'garage',
            fuel = 'fuel',
            engine = 'engine',
            body = 'body'
        }
    },
    
    -- Mülk Tablosu
    properties = {
        table = 'properties',
        columns = {
            id = 'id',
            identifier = 'identifier',
            name = 'name',
            price = 'price',
            rented = 'rented',
            rentprice = 'rentprice',
            entrance = 'entrance',
            garage = 'garage'
        }
    },
    
    -- İşletme Tablosu
    businesses = {
        table = 'businesses',
        columns = {
            id = 'id',
            identifier = 'identifier',
            name = 'name',
            type = 'type',
            price = 'price',
            funds = 'funds',
            employees = 'employees'
        }
    }
}

return Config 