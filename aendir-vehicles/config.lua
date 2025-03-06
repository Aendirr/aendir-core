Config = {}

-- Araç Ayarları
Config.Vehicles = {
    -- Genel Ayarlar
    MaxFuel = 100.0,
    FuelConsumption = 0.1,
    MaxBodyHealth = 1000.0,
    MaxEngineHealth = 1000.0,
    MinHealth = 100.0,
    
    -- Ücretler
    Prices = {
        modshop = {
            engine = 5000,
            brakes = 3000,
            transmission = 4000,
            suspension = 3000,
            armor = 5000,
            turbo = 10000,
            xenon = 2000,
            horn = 1000,
            plate = 1000,
            neon = 3000,
            wheels = 2000,
            window = 1000,
            livery = 2000,
            extras = 1000
        },
        repair = 1000,
        refuel = 100,
        insurance = 5000,
        impound = 2000
    },
    
    -- Garajlar
    Garages = {
        {
            name = "Merkez Garaj",
            coords = vector3(-273.0, -955.0, 31.0),
            spawn = vector4(-275.0, -955.0, 31.0, 30.0),
            blip = {
                sprite = 357,
                color = 3,
                scale = 0.8,
                label = "Merkez Garaj"
            }
        },
        {
            name = "Sandy Garaj",
            coords = vector3(1737.0, 3711.0, 34.0),
            spawn = vector4(1737.0, 3711.0, 34.0, 21.0),
            blip = {
                sprite = 357,
                color = 3,
                scale = 0.8,
                label = "Sandy Garaj"
            }
        },
        {
            name = "Paleto Garaj",
            coords = vector3(-458.0, -1127.0, 8.0),
            spawn = vector4(-458.0, -1127.0, 8.0, 30.0),
            blip = {
                sprite = 357,
                color = 3,
                scale = 0.8,
                label = "Paleto Garaj"
            }
        }
    },
    
    -- Çekme Noktaları
    Impound = {
        coords = vector3(409.0, -1623.0, 29.0),
        spawn = vector4(409.0, -1623.0, 29.0, 230.0),
        blip = {
            sprite = 524,
            color = 1,
            scale = 0.8,
            label = "Araç Çekme"
        }
    },
    
    -- Modifiye Dükkanları
    ModShops = {
        {
            name = "LS Customs",
            coords = vector3(-347.0, -133.0, 39.0),
            blip = {
                sprite = 446,
                color = 5,
                scale = 0.8,
                label = "LS Customs"
            }
        },
        {
            name = "Benny's",
            coords = vector3(-205.0, -1313.0, 31.0),
            blip = {
                sprite = 446,
                color = 5,
                scale = 0.8,
                label = "Benny's"
            }
        }
    },
    
    -- Yakıt İstasyonları
    FuelStations = {
        {
            name = "Merkez İstasyon",
            coords = vector3(-724.0, -935.0, 19.0),
            blip = {
                sprite = 361,
                color = 1,
                scale = 0.8,
                label = "Yakıt İstasyonu"
            }
        },
        {
            name = "Sandy İstasyon",
            coords = vector3(1039.0, 2671.0, 39.0),
            blip = {
                sprite = 361,
                color = 1,
                scale = 0.8,
                label = "Yakıt İstasyonu"
            }
        },
        {
            name = "Paleto İstasyon",
            coords = vector3(-70.0, -1761.0, 30.0),
            blip = {
                sprite = 361,
                color = 1,
                scale = 0.8,
                label = "Yakıt İstasyonu"
            }
        }
    },
    
    -- Tamir Noktaları
    RepairShops = {
        {
            name = "Merkez Tamir",
            coords = vector3(-347.0, -133.0, 39.0),
            blip = {
                sprite = 446,
                color = 5,
                scale = 0.8,
                label = "Tamir Dükkanı"
            }
        },
        {
            name = "Sandy Tamir",
            coords = vector3(1174.0, 2640.0, 37.0),
            blip = {
                sprite = 446,
                color = 5,
                scale = 0.8,
                label = "Tamir Dükkanı"
            }
        }
    },
    
    -- Sigorta Ofisleri
    InsuranceOffices = {
        {
            name = "Merkez Sigorta",
            coords = vector3(-273.0, -955.0, 31.0),
            blip = {
                sprite = 498,
                color = 2,
                scale = 0.8,
                label = "Sigorta Ofisi"
            }
        }
    },
    
    -- Araç Kategorileri
    Categories = {
        compacts = "Kompakt",
        sedans = "Sedan",
        suvs = "SUV",
        coupes = "Kupa",
        muscle = "Muscle",
        sports = "Spor",
        sportsclassics = "Klasik Spor",
        super = "Süper",
        motorcycles = "Motosiklet",
        offroad = "Off-Road",
        industrial = "Endüstriyel",
        utility = "Utility",
        vans = "Van",
        cycles = "Bisiklet",
        boats = "Tekne",
        helicopters = "Helikopter",
        planes = "Uçak",
        service = "Servis",
        emergency = "Acil Durum",
        military = "Askeri",
        commercial = "Ticari",
        trains = "Tren"
    },
    
    -- Araç Özellikleri
    Properties = {
        -- Modifiye Kategorileri
        modEngine = 11,
        modBrakes = 12,
        modTransmission = 13,
        modSuspension = 15,
        modArmor = 16,
        modTurbo = 18,
        modXenon = 22,
        modHorn = 14,
        modPlate = 25,
        modNeon = 27,
        modWheels = 23,
        modWindow = 46,
        modLivery = 48,
        modExtras = 14
    }
}

-- Bildirim Ayarları
Config.Notifications = {
    Position = "top-right",
    Duration = 3000,
    Types = {
        success = {
            icon = "check-circle",
            color = "#4CAF50"
        },
        error = {
            icon = "times-circle",
            color = "#F44336"
        },
        info = {
            icon = "info-circle",
            color = "#2196F3"
        },
        warning = {
            icon = "exclamation-circle",
            color = "#FFC107"
        }
    }
}

-- Progress Bar Ayarları
Config.ProgressBar = {
    Position = "bottom",
    Duration = 5000,
    UseAnimation = true
}

-- Blip Ayarları
Config.Blips = {
    Default = {
        sprite = 1,
        color = 1,
        scale = 0.8,
        shortRange = true
    }
}

-- Marker Ayarları
Config.Markers = {
    Default = {
        type = 1,
        size = vector3(1.0, 1.0, 1.0),
        color = vector3(255, 255, 255),
        drawDistance = 10.0
    }
}

-- Yakıt Sistemi
Config.FuelSystem = {
    ConsumptionRate = 0.1, -- Yakıt tüketim oranı
    RefuelCost = 5, -- Yakıt maliyeti
    WarningLevel = 10.0, -- Yakıt uyarı seviyesi
    MaxFuel = 100.0 -- Maksimum yakıt
}

-- Hasar Sistemi
Config.DamageSystem = {
    RepairCost = 100, -- Tamir maliyeti
    WarningLevel = 500.0, -- Hasar uyarı seviyesi
    EngineFailureLevel = 300.0, -- Motor arıza seviyesi
    MaxHealth = 1000.0 -- Maksimum sağlık
}

-- Modifikasyon Sistemi
Config.ModificationCategories = {
    engine = {
        name = 'Motor',
        modType = 11,
        maxLevel = 3,
        cost = 1000
    },
    brakes = {
        name = 'Frenler',
        modType = 12,
        maxLevel = 2,
        cost = 800
    },
    transmission = {
        name = 'Şanzıman',
        modType = 13,
        maxLevel = 2,
        cost = 800
    },
    suspension = {
        name = 'Süspansiyon',
        modType = 15,
        maxLevel = 3,
        cost = 1000
    },
    turbo = {
        name = 'Turbo',
        modType = 18,
        maxLevel = 1,
        cost = 2000
    },
    cosmetics = {
        name = 'Görünüm',
        modType = 0,
        maxLevel = 5,
        cost = 500
    }
}

-- Sigorta Sistemi
Config.InsuranceSystem = {
    Cost = 5000, -- Sigorta maliyeti
    Coverage = 0.8, -- Sigorta kapsamı (%)
    Duration = 7, -- Sigorta süresi (gün)
    CancelFee = 1000 -- İptal ücreti
}

-- Çekme Sistemi
Config.ImpoundSystem = {
    BaseFee = 1000, -- Temel çekme ücreti
    DamageMultiplier = 0.1, -- Hasar çarpanı
    MaxFee = 5000, -- Maksimum çekme ücreti
    Duration = 24 -- Çekme süresi (saat)
}

-- Takip Sistemi
Config.TrackerSystem = {
    UpdateInterval = 1000, -- Güncelleme aralığı (ms)
    MaxTrackedVehicles = 5, -- Maksimum takip edilebilir araç sayısı
    Cost = 1000 -- Takip cihazı maliyeti
}

-- Garaj Sistemi
Config.GarageSystem = {
    MaxVehicles = 10, -- Maksimum araç sayısı
    SpawnDistance = 5.0, -- Spawn mesafesi
    SpawnHeading = 0.0 -- Spawn yönü
}

-- Bildirim Sistemi
Config.NotificationSystem = {
    Duration = 5000, -- Bildirim süresi (ms)
    Position = 'top-right', -- Bildirim pozisyonu
    Types = {
        success = {
            color = '#00ff00',
            icon = 'check'
        },
        error = {
            color = '#ff0000',
            icon = 'times'
        },
        info = {
            color = '#00ffff',
            icon = 'info'
        },
        warning = {
            color = '#ffff00',
            icon = 'exclamation'
        }
    }
}

-- Marker Sistemi
Config.MarkerSystem = {
    Type = 1, -- Marker tipi
    Size = vector3(3.0, 3.0, 1.0), -- Marker boyutu
    Color = vector4(255, 255, 255, 100), -- Marker rengi
    DrawDistance = 10.0 -- Çizim mesafesi
}

-- Blip Sistemi
Config.BlipSystem = {
    Scale = 0.8, -- Blip ölçeği
    ShortRange = true, -- Kısa menzil
    Colors = {
        garage = 3,
        fuel = 1,
        repair = 5,
        mod = 5,
        insurance = 2,
        impound = 1
    }
}

return Config 