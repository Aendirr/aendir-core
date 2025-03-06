Config = {}

-- Discord Webhook Ayarları
Config.Discord = {
    Webhook = "", -- Discord webhook URL'si
    Title = "Aendir Core Logs",
    Color = 3447003 -- Mavi renk kodu
}

-- Bildirim Ayarları
Config.Notifications = {
    Position = "top-right",
    Duration = 5000,
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
        Sprite = 1,
        Color = 1,
        Scale = 0.8,
        ShortRange = true
    }
}

-- Marker Ayarları
Config.Markers = {
    Default = {
        Type = 1,
        Size = vector3(1.0, 1.0, 1.0),
        Color = vector3(255, 255, 255),
        BobUpAndDown = false,
        FaceCamera = false,
        Rotate = false,
        DrawDistance = 10.0
    }
}

-- Veritabanı Ayarları
Config.Database = {
    Tables = {
        players = "players",
        vehicles = "vehicles",
        items = "items",
        logs = "logs"
    }
}

-- Oyuncu Ayarları
Config.Player = {
    MaxWeight = 120000,
    DefaultJob = "unemployed",
    DefaultGang = "none",
    StartingMoney = {
        cash = 5000,
        bank = 10000
    },
    MaxItems = 50,
    MaxItemStack = 100
}

-- Araç Ayarları
Config.Vehicles = {
    MaxFuel = 100.0,
    FuelConsumption = 0.1,
    RepairCost = 1000,
    InsuranceCost = 5000,
    ImpoundCost = 1000,
    MaxDamage = 1000.0,
    MaxEngineHealth = 1000.0,
    MaxBodyHealth = 1000.0
}

-- Eşya Ayarları
Config.Items = {
    MaxStack = 100,
    UseableItems = {
        ["phone"] = true,
        ["radio"] = true,
        ["water"] = true,
        ["food"] = true
    },
    Categories = {
        ["weapons"] = "Silahlar",
        ["ammo"] = "Mermiler",
        ["food"] = "Yiyecekler",
        ["drink"] = "İçecekler",
        ["medical"] = "Medikal",
        ["tools"] = "Aletler",
        ["misc"] = "Diğer"
    }
}

-- Meslek Ayarları
Config.Jobs = {
    ["unemployed"] = {
        label = "İşsiz",
        grades = {
            ["0"] = {
                name = "İşsiz",
                payment = 0
            }
        }
    },
    ["police"] = {
        label = "Polis",
        grades = {
            ["0"] = {
                name = "Stajyer",
                payment = 2000
            },
            ["1"] = {
                name = "Polis Memuru",
                payment = 3000
            },
            ["2"] = {
                name = "Detektif",
                payment = 4000
            },
            ["3"] = {
                name = "Sergeant",
                payment = 5000
            },
            ["4"] = {
                name = "Lieutenant",
                payment = 6000
            },
            ["5"] = {
                name = "Chief",
                payment = 7000
            }
        }
    }
}

-- Çete Ayarları
Config.Gangs = {
    ["none"] = {
        label = "Çetesiz",
        grades = {
            ["0"] = {
                name = "Çetesiz",
                payment = 0
            }
        }
    }
}

-- Karakter Ayarları
Config.Character = {
    MaxCharacters = 4,
    MinNameLength = 3,
    MaxNameLength = 20,
    AllowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
    StartingAppearance = {
        model = "mp_m_freemode_01",
        components = {},
        props = {}
    }
}

return Config 