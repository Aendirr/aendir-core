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

return Config 