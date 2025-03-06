Config = {}

Config.Debug = false

Config.Database = {
    Tables = {
        vehicles = [[
            CREATE TABLE IF NOT EXISTS vehicles (
                id INT AUTO_INCREMENT PRIMARY KEY,
                plate VARCHAR(8) NOT NULL,
                owner VARCHAR(50) NOT NULL,
                model VARCHAR(50) NOT NULL,
                stored TINYINT(1) DEFAULT 0,
                impounded TINYINT(1) DEFAULT 0,
                insured TINYINT(1) DEFAULT 0,
                tracker TINYINT(1) DEFAULT 0,
                fuel FLOAT DEFAULT 100.0,
                damage JSON,
                properties JSON,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        ]],
        logs = [[
            CREATE TABLE IF NOT EXISTS logs (
                id INT AUTO_INCREMENT PRIMARY KEY,
                type VARCHAR(50) NOT NULL,
                identifier VARCHAR(50) NOT NULL,
                action VARCHAR(50) NOT NULL,
                details JSON,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ]]
    }
}

Config.Discord = {
    Webhook = "WEBHOOK_URL",
    Color = 16711680,
    Title = "Aendir Core Logs"
}

Config.Notifications = {
    Position = "top-right",
    Duration = 5000
}

Config.ProgressBar = {
    Position = "bottom",
    Duration = 5000
}

-- Araç Sistemi Konfigürasyonları
Config.Vehicles = {
    ModShops = {
        {
            name = "LS Customs",
            coords = vector3(-347.291, -133.0, 39.009),
            blip = {
                sprite = 446,
                color = 5,
                scale = 0.7,
                label = "LS Customs"
            },
            categories = {
                {name = "Spoiler", id = 0},
                {name = "Tamponlar", id = 1},
                {name = "Yan Paneller", id = 2},
                {name = "Egzoz", id = 3},
                {name = "Kafes", id = 4},
                {name = "Radyatör", id = 5},
                {name = "Çamurluk", id = 6},
                {name = "Kaput", id = 7},
                {name = "Çatı", id = 8},
                {name = "Motor", id = 9},
                {name = "Frenler", id = 10},
                {name = "Transmisyon", id = 11},
                {name = "Korna", id = 12},
                {name = "Süspansiyon", id = 13},
                {name = "Zırh", id = 14},
                {name = "Turbo", id = 15},
                {name = "Xenon", id = 16},
                {name = "Tekerlekler", id = 17},
                {name = "Renk", id = 18},
                {name = "Aksesuarlar", id = 19},
                {name = "Plaka", id = 20},
                {name = "Neon", id = 21},
                {name = "Cam", id = 22},
                {name = "Livery", id = 23},
                {name = "Extra", id = 24}
            }
        }
    },
    Garages = {
        {
            name = "Legion Square",
            coords = vector3(215.124, -810.377, 30.733),
            spawn = vector4(215.124, -810.377, 30.733, 144.5),
            blip = {
                sprite = 357,
                color = 3,
                scale = 0.7,
                label = "Legion Square Garaj"
            }
        },
        {
            name = "Pillbox",
            coords = vector3(273.666, -344.155, 44.919),
            spawn = vector4(273.666, -344.155, 44.919, 161.5),
            blip = {
                sprite = 357,
                color = 3,
                scale = 0.7,
                label = "Pillbox Garaj"
            }
        },
        {
            name = "LSPD",
            coords = vector3(458.956, -1017.212, 28.562),
            spawn = vector4(458.956, -1017.212, 28.562, 90.5),
            blip = {
                sprite = 357,
                color = 3,
                scale = 0.7,
                label = "LSPD Garaj"
            }
        }
    },
    FuelStations = {
        {
            name = "LTD",
            coords = vector3(-48.519, -1757.514, 29.421),
            blip = {
                sprite = 361,
                color = 1,
                scale = 0.7,
                label = "LTD Yakıt"
            }
        }
    },
    RepairShops = {
        {
            name = "LS Customs",
            coords = vector3(-347.291, -133.0, 39.009),
            blip = {
                sprite = 446,
                color = 5,
                scale = 0.7,
                label = "LS Customs"
            }
        }
    },
    Impound = {
        coords = vector3(409.0, -1623.0, 29.3),
        spawn = vector4(409.0, -1623.0, 29.3, 230.5),
        blip = {
            sprite = 67,
            color = 1,
            scale = 0.7,
            label = "Araç Çekme"
        },
        price = 1000
    },
    Prices = {
        modshop = {
            spoiler = 1000,
            bumper = 800,
            sideSkirt = 600,
            exhaust = 700,
            rollcage = 900,
            radiator = 500,
            fender = 400,
            hood = 800,
            roof = 600,
            engine = 2000,
            brakes = 1000,
            transmission = 1500,
            horn = 300,
            suspension = 1000,
            armor = 2000,
            turbo = 3000,
            xenon = 500,
            wheels = 800,
            color = 1000,
            accessories = 500,
            plate = 300,
            neon = 1500,
            window = 400,
            livery = 1000,
            extra = 300
        },
        repair = 1000,
        insurance = 5000,
        fuel = 1000,
        tracker = 5000
    },
    FuelConsumption = 0.0001,
    TrackerItem = 'tracker',
    TrackerBlip = {
        sprite = 161,
        color = 1,
        scale = 0.7,
        label = "Takip Edilen Araç"
    }
} 