Config = {}

-- Envanter Ayarları
Config.MaxWeight = 50.0 -- Maksimum ağırlık (kg)
Config.MaxSlots = 50 -- Maksimum slot sayısı
Config.DefaultWeight = 0.0 -- Varsayılan ağırlık (kg)

-- Eşya Ayarları
Config.Items = {
    phone = {
        label = "Telefon",
        weight = 0.5,
        usable = true,
        type = "item"
    },
    radio = {
        label = "Telsiz",
        weight = 0.3,
        usable = true,
        type = "item"
    },
    clock = {
        label = "Saat",
        weight = 0.1,
        usable = false,
        type = "item"
    },
    money = {
        label = "Para",
        weight = 0.0,
        usable = false,
        type = "item"
    },
    water = {
        label = "Su",
        weight = 0.5,
        usable = true,
        type = "item"
    },
    food = {
        label = "Yiyecek",
        weight = 0.3,
        usable = true,
        type = "item"
    },
    drug = {
        label = "Uyuşturucu",
        weight = 0.1,
        usable = true,
        type = "item"
    },
    armor = {
        label = "Zırh",
        weight = 2.0,
        usable = true,
        type = "item"
    },
    weapon_pistol = {
        label = "Tabanca",
        weight = 1.0,
        usable = true,
        type = "weapon"
    },
    weapon_smg = {
        label = "SMG",
        weight = 2.0,
        usable = true,
        type = "weapon"
    },
    weapon_rifle = {
        label = "Tüfek",
        weight = 3.0,
        usable = true,
        type = "weapon"
    }
}

-- Silah Ayarları
Config.Weapons = {
    weapon_pistol = {
        model = "WEAPON_PISTOL",
        ammo = 12,
        damage = 25
    },
    weapon_smg = {
        model = "WEAPON_SMG",
        ammo = 30,
        damage = 20
    },
    weapon_rifle = {
        model = "WEAPON_CARBINERIFLE",
        ammo = 30,
        damage = 35
    }
}

-- Bildirim Ayarları
Config.Notifications = {
    duration = 3000, -- Bildirim süresi (ms)
    position = "top-right", -- Bildirim pozisyonu
    types = {
        success = {
            color = "#4CAF50",
            icon = "check-circle"
        },
        error = {
            color = "#f44336",
            icon = "times-circle"
        },
        warning = {
            color = "#ff9800",
            icon = "exclamation-circle"
        },
        info = {
            color = "#2196F3",
            icon = "info-circle"
        }
    }
}

-- İlerleme Çubuğu Ayarları
Config.ProgressBar = {
    duration = 2000, -- Varsayılan süre (ms)
    position = "center", -- Pozisyon
    text = "İşlem yapılıyor..." -- Varsayılan metin
}

-- Veritabanı Ayarları
Config.Database = {
    table = "player_inventory", -- Envanter tablosu
    columns = {
        id = "id",
        identifier = "identifier",
        items = "items",
        weight = "weight"
    }
}

-- Komut Ayarları
Config.Commands = {
    inventory = "inventory", -- Envanter açma komutu
    giveitem = "giveitem", -- Eşya verme komutu
    removeitem = "removeitem" -- Eşya silme komutu
}

-- Tuş Ayarları
Config.Keys = {
    inventory = "TAB", -- Envanter açma tuşu
    close = "ESCAPE" -- Kapatma tuşu
}

return Config 