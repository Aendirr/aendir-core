Config = {}

Config.DefaultSpawn = vector4(195.17, -933.77, 30.69, 144.5)
Config.StartingMoney = {
    cash = 5000,
    bank = 10000
}

Config.StartingItems = {
    {name = "phone", amount = 1},
    {name = "water", amount = 5},
    {name = "bread", amount = 5}
}

Config.MaxWeight = 120000 -- 120kg
Config.MaxInventorySlots = 41

Config.EnableDebug = false
Config.EnableCommands = true

Config.Language = "tr"

-- Yeni Özellikler
Config.EnableMultiCharacter = true
Config.MaxCharacters = 3

Config.EnableWhitelist = true
Config.WhitelistGroups = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["moderator"] = true
}

Config.EnableCustomization = true
Config.EnableClothing = true
Config.EnableBarber = true

Config.EnableVehicles = true
Config.EnableGarage = true
Config.EnableFuel = true
Config.FuelPrice = 5.0

Config.EnableHousing = true
Config.EnableApartments = true
Config.EnableHouses = true

Config.EnableJobs = true
Config.EnableGangs = true
Config.EnableBusinesses = true

Config.EnablePhone = true
Config.EnableBanking = true
Config.EnableShops = true

Config.EnableCrafting = true
Config.EnableFishing = true
Config.EnableHunting = true
Config.EnableMining = true

Config.EnableSkills = true
Config.MaxSkillLevel = 100
Config.SkillXP = {
    ["strength"] = 0,
    ["stamina"] = 0,
    ["driving"] = 0,
    ["shooting"] = 0,
    ["fishing"] = 0,
    ["hunting"] = 0,
    ["mining"] = 0
}

Config.EnableAchievements = true
Config.Achievements = {
    ["first_job"] = {
        name = "İlk İş",
        description = "İlk işini al",
        reward = 1000
    },
    ["first_house"] = {
        name = "İlk Ev",
        description = "İlk evini satın al",
        reward = 5000
    }
}

Config.EnableQuests = true
Config.DailyQuests = true
Config.WeeklyQuests = true
Config.MonthlyQuests = true

Config.EnableEvents = true
Config.Events = {
    ["racing"] = true,
    ["deathmatch"] = true,
    ["survival"] = true
}

Config.EnableCustomCommands = true
Config.CustomCommands = {
    ["/help"] = "Yardım menüsünü gösterir",
    ["/stats"] = "İstatistiklerinizi gösterir",
    ["/skills"] = "Yeteneklerinizi gösterir"
}

Config.EnableNotifications = true
Config.NotificationTypes = {
    ["success"] = true,
    ["error"] = true,
    ["info"] = true,
    ["warning"] = true
}

Config.EnableSounds = true
Config.Sounds = {
    ["notification"] = "notification.ogg",
    ["achievement"] = "achievement.ogg",
    ["quest_complete"] = "quest_complete.ogg"
}

Config.EnableAnimations = true
Config.Animations = {
    ["sit"] = true,
    ["dance"] = true,
    ["emote"] = true
}

Config.EnableWeather = true
Config.EnableTime = true
Config.EnableSeasons = true

Config.EnableEconomy = true
Config.EconomySettings = {
    ["tax_rate"] = 0.1,
    ["inflation_rate"] = 0.01,
    ["min_wage"] = 100
}

-- Yeni Özellikler
Config.EnablePets = true
Config.Pets = {
    ["dog"] = {
        name = "Köpek",
        price = 5000,
        food = "dog_food",
        health = 100,
        happiness = 100
    },
    ["cat"] = {
        name = "Kedi",
        price = 3000,
        food = "cat_food",
        health = 100,
        happiness = 100
    }
}

Config.EnableFarming = true
Config.Farming = {
    ["wheat"] = {
        name = "Buğday",
        growth_time = 300, -- 5 dakika
        harvest_amount = 3,
        sell_price = 100
    },
    ["corn"] = {
        name = "Mısır",
        growth_time = 600, -- 10 dakika
        harvest_amount = 4,
        sell_price = 150
    }
}

Config.EnableFishing = true
Config.Fishing = {
    ["spots"] = {
        {coords = vector3(-1841.5, -1249.5, 8.6), radius = 50.0},
        {coords = vector3(-3426.5, 967.5, 8.6), radius = 50.0}
    },
    ["fish"] = {
        ["common_fish"] = {
            name = "Yaygın Balık",
            price = 50,
            chance = 70
        },
        ["rare_fish"] = {
            name = "Nadir Balık",
            price = 150,
            chance = 30
        }
    }
}

Config.EnableHunting = true
Config.Hunting = {
    ["animals"] = {
        ["deer"] = {
            name = "Geyik",
            model = "a_c_deer",
            meat = "deer_meat",
            price = 200
        },
        ["boar"] = {
            name = "Yaban Domuzu",
            model = "a_c_boar",
            meat = "boar_meat",
            price = 150
        }
    },
    ["zones"] = {
        {coords = vector3(-1505.5, 4887.5, 78.4), radius = 500.0},
        {coords = vector3(-275.5, 6225.5, 31.5), radius = 500.0}
    }
}

Config.EnableMining = true
Config.Mining = {
    ["rocks"] = {
        {coords = vector3(-595.5, 2091.5, 131.4), type = "stone"},
        {coords = vector3(-594.5, 2092.5, 131.4), type = "iron"},
        {coords = vector3(-593.5, 2093.5, 131.4), type = "gold"}
    },
    ["ores"] = {
        ["stone"] = {
            name = "Taş",
            price = 10,
            chance = 100
        },
        ["iron"] = {
            name = "Demir",
            price = 50,
            chance = 60
        },
        ["gold"] = {
            name = "Altın",
            price = 100,
            chance = 30
        }
    }
}

Config.EnableCrafting = true
Config.Crafting = {
    ["items"] = {
        ["weapon_parts"] = {
            name = "Silah Parçaları",
            ingredients = {
                {item = "iron", amount = 5},
                {item = "steel", amount = 3}
            },
            result = "weapon_parts",
            time = 30
        },
        ["armor"] = {
            name = "Zırh",
            ingredients = {
                {item = "steel", amount = 10},
                {item = "fabric", amount = 5}
            },
            result = "armor",
            time = 60
        }
    },
    ["stations"] = {
        {coords = vector3(1020.5, -2404.5, 30.1), type = "weapon"},
        {coords = vector3(1021.5, -2405.5, 30.1), type = "armor"}
    }
}

Config.EnablePhone = true
Config.Phone = {
    ["apps"] = {
        ["messages"] = true,
        ["contacts"] = true,
        ["bank"] = true,
        ["gps"] = true,
        ["camera"] = true
    },
    ["wallpaper"] = "default",
    ["ringtone"] = "default"
}

Config.EnableBanking = true
Config.Banking = {
    ["atms"] = {
        {coords = vector3(149.9, -1040.5, 29.4)},
        {coords = vector3(247.8, 223.0, 106.3)},
        {coords = vector3(-1212.9, -330.8, 37.8)}
    },
    ["banks"] = {
        {coords = vector3(150.2, -1040.2, 29.4), name = "Pacific Standard"},
        {coords = vector3(248.8, 222.5, 106.3), name = "Legion Square"}
    }
}

Config.EnableShops = true
Config.Shops = {
    ["general"] = {
        {coords = vector3(25.7, -1347.3, 29.5), name = "24/7 Supermarket"},
        {coords = vector3(373.8, 325.8, 103.5), name = "24/7 Supermarket"}
    },
    ["weapons"] = {
        {coords = vector3(22.0, -1107.2, 29.8), name = "Ammu-Nation"}
    },
    ["clothing"] = {
        {coords = vector3(72.3, -1399.1, 29.4), name = "Suburban"},
        {coords = vector3(-703.8, -152.3, 37.4), name = "Ponsonbys"}
    }
}

Config.EnableGarage = true
Config.Garage = {
    ["public"] = {
        {coords = vector3(273.7, -343.8, 44.9), spawn = vector4(275.2, -343.8, 44.9, 160.0)},
        {coords = vector3(-275.5, -955.8, 31.2), spawn = vector4(-275.5, -955.8, 31.2, 30.0)}
    },
    ["private"] = {
        {coords = vector3(-17.7, -1091.3, 26.7), spawn = vector4(-17.7, -1091.3, 26.7, 160.0)}
    }
}

Config.EnableFuel = true
Config.Fuel = {
    ["stations"] = {
        {coords = vector3(-724.6, -935.1, 19.2), price = 5.0},
        {coords = vector3(-2097.0, -320.2, 13.2), price = 5.0},
        {coords = vector3(-1437.6, -276.7, 46.2), price = 5.0}
    },
    ["consumption"] = {
        ["car"] = 0.1,
        ["bike"] = 0.05,
        ["helicopter"] = 0.2
    }
}

Config.EnableHousing = true
Config.Housing = {
    ["apartments"] = {
        {coords = vector3(-1447.1, -537.8, 34.7), price = 50000, name = "Del Perro"},
        {coords = vector3(-47.1, -1757.5, 29.4), price = 45000, name = "Grove Street"}
    },
    ["houses"] = {
        {coords = vector3(-14.3, -1441.2, 31.1), price = 150000, name = "Vinewood"},
        {coords = vector3(1239.8, -325.8, 69.0), price = 200000, name = "Mirror Park"}
    }
}

Config.EnableBusinesses = true
Config.Businesses = {
    ["types"] = {
        ["restaurant"] = {
            name = "Restoran",
            price = 500000,
            max_employees = 10,
            income = 5000
        },
        ["shop"] = {
            name = "Mağaza",
            price = 300000,
            max_employees = 5,
            income = 3000
        }
    },
    ["locations"] = {
        {coords = vector3(-47.5, -1757.5, 29.4), type = "shop", price = 300000},
        {coords = vector3(-1447.1, -537.8, 34.7), type = "restaurant", price = 500000}
    }
}

Config.EnableGangs = true
Config.Gangs = {
    ["types"] = {
        ["street"] = {
            name = "Sokak Çetesi",
            max_members = 10,
            territory_radius = 100.0
        },
        ["mafia"] = {
            name = "Mafya",
            max_members = 20,
            territory_radius = 200.0
        }
    },
    ["territories"] = {
        {coords = vector3(-47.5, -1757.5, 29.4), radius = 100.0},
        {coords = vector3(-1447.1, -537.8, 34.7), radius = 200.0}
    }
}

Config.EnableJobs = true
Config.Jobs = {
    police = {
        label = 'Polis',
        description = 'Şehir güvenliğini sağla',
        coords = vector3(441.8, -982.8, 30.69),
        blip = {
            sprite = 60,
            color = 29
        },
        grades = {
            [0] = {
                label = 'Stajyer',
                salary = 100
            },
            [1] = {
                label = 'Polis',
                salary = 200
            },
            [2] = {
                label = 'Detektif',
                salary = 300
            },
            [3] = {
                label = 'Sergeant',
                salary = 400
            },
            [4] = {
                label = 'Lieutenant',
                salary = 500
            },
            [5] = {
                label = 'Chief',
                salary = 600
            }
        },
        items = {
            handcuffs = {
                label = 'Kelepçe',
                max = 1
            },
            radio = {
                label = 'Telsiz',
                max = 1
            },
            badge = {
                label = 'Rozet',
                max = 1
            }
        },
        tasks = {
            {
                label = 'Devriye',
                coords = vector3(441.8, -982.8, 30.69),
                reward = 100
            },
            {
                label = 'Trafik Kontrolü',
                coords = vector3(441.8, -982.8, 30.69),
                reward = 150
            },
            {
                label = 'Suç Araştırması',
                coords = vector3(441.8, -982.8, 30.69),
                reward = 200
            }
        }
    },
    ambulance = {
        label = 'Paramedik',
        description = 'Hasta ve yaralılara yardım et',
        coords = vector3(297.4, -584.5, 43.3),
        blip = {
            sprite = 61,
            color = 2
        },
        grades = {
            [0] = {
                label = 'Stajyer',
                salary = 100
            },
            [1] = {
                label = 'Paramedik',
                salary = 200
            },
            [2] = {
                label = 'Doktor',
                salary = 300
            },
            [3] = {
                label = 'Baş Doktor',
                salary = 400
            }
        },
        items = {
            bandage = {
                label = 'Bandaj',
                max = 10
            },
            medkit = {
                label = 'Medkit',
                max = 5
            },
            radio = {
                label = 'Telsiz',
                max = 1
            }
        },
        tasks = {
            {
                label = 'Hasta Taşıma',
                coords = vector3(297.4, -584.5, 43.3),
                reward = 100
            },
            {
                label = 'İlk Yardım',
                coords = vector3(297.4, -584.5, 43.3),
                reward = 150
            },
            {
                label = 'Acil Müdahale',
                coords = vector3(297.4, -584.5, 43.3),
                reward = 200
            }
        }
    },
    mechanic = {
        label = 'Mekanik',
        description = 'Araçları tamir et',
        coords = vector3(-347.4, -133.0, 39.0),
        blip = {
            sprite = 446,
            color = 5
        },
        grades = {
            [0] = {
                label = 'Stajyer',
                salary = 100
            },
            [1] = {
                label = 'Mekanik',
                salary = 200
            },
            [2] = {
                label = 'Usta',
                salary = 300
            },
            [3] = {
                label = 'Patron',
                salary = 400
            }
        },
        items = {
            toolkit = {
                label = 'Tamir Seti',
                max = 1
            },
            parts = {
                label = 'Yedek Parça',
                max = 10
            },
            radio = {
                label = 'Telsiz',
                max = 1
            }
        },
        tasks = {
            {
                label = 'Araç Tamiri',
                coords = vector3(-347.4, -133.0, 39.0),
                reward = 100
            },
            {
                label = 'Motor Bakımı',
                coords = vector3(-347.4, -133.0, 39.0),
                reward = 150
            },
            {
                label = 'Kaporta İşleri',
                coords = vector3(-347.4, -133.0, 39.0),
                reward = 200
            }
        }
    }
}

Config.Jobs.payment_interval = 3600 -- 1 saat

Config.VehicleFeatures = {
    ["damage"] = {
        enabled = true,
        repair_cost_multiplier = 1.0,
        engine_health = 1000.0,
        body_health = 1000.0
    },
    ["modification"] = {
        enabled = true,
        max_mods = 50,
        mod_categories = {
            ["engine"] = true,
            ["brakes"] = true,
            ["transmission"] = true,
            ["suspension"] = true,
            ["armor"] = true,
            ["turbo"] = true,
            ["xenon"] = true,
            ["neon"] = true,
            ["wheels"] = true,
            ["livery"] = true
        }
    },
    ["insurance"] = {
        enabled = true,
        base_cost = 1000,
        coverage_percentage = 80,
        claim_cooldown = 3600 -- 1 saat
    },
    ["tracking"] = {
        enabled = true,
        gps_cost = 500,
        update_interval = 30 -- saniye
    }
}

Config.HousingFeatures = {
    ["furniture"] = {
        enabled = true,
        max_items = 100,
        categories = {
            ["living_room"] = true,
            ["bedroom"] = true,
            ["kitchen"] = true,
            ["bathroom"] = true,
            ["office"] = true
        }
    },
    ["utilities"] = {
        enabled = true,
        electricity_cost = 100,
        water_cost = 50,
        payment_interval = 86400 -- 24 saat
    },
    ["security"] = {
        enabled = true,
        alarm_system = true,
        security_cameras = true,
        motion_sensors = true
    },
    ["storage"] = {
        enabled = true,
        max_storage = 1000,
        safe_storage = true
    }
}

Config.JobFeatures = {
    ["police"] = {
        name = "Polis",
        grades = {
            {name = "Stajyer", payment = 1000, permissions = {"basic"}},
            {name = "Memur", payment = 2000, permissions = {"basic", "arrest"}},
            {name = "Çavuş", payment = 3000, permissions = {"basic", "arrest", "promote"}},
            {name = "Komiser", payment = 4000, permissions = {"basic", "arrest", "promote", "fire"}}
        },
        equipment = {
            ["weapons"] = true,
            ["armor"] = true,
            ["radar"] = true,
            ["cuffs"] = true
        },
        vehicles = {
            ["patrol"] = true,
            ["riot"] = true,
            ["helicopter"] = true
        }
    },
    ["ambulance"] = {
        name = "Paramedik",
        grades = {
            {name = "Stajyer", payment = 1000, permissions = {"basic"}},
            {name = "Paramedik", payment = 2000, permissions = {"basic", "heal"}},
            {name = "Doktor", payment = 3000, permissions = {"basic", "heal", "revive"}},
            {name = "Başhekim", payment = 4000, permissions = {"basic", "heal", "revive", "manage"}}
        },
        equipment = {
            ["medkit"] = true,
            ["bandage"] = true,
            ["defibrillator"] = true,
            ["stretcher"] = true
        },
        vehicles = {
            ["ambulance"] = true,
            ["helicopter"] = true
        }
    }
}

Config.EnableEconomy = true
Config.EconomySettings = {
    ["tax_rate"] = 0.1,
    ["inflation_rate"] = 0.01,
    ["min_wage"] = 100,
    ["stock_market"] = {
        enabled = true,
        update_interval = 300, -- 5 dakika
        volatility = 0.1
    },
    ["banking"] = {
        ["interest_rate"] = 0.02,
        ["loan_system"] = true,
        ["max_loan"] = 100000,
        ["loan_interest"] = 0.05
    },
    ["business"] = {
        ["tax_rate"] = 0.15,
        ["employee_salary"] = true,
        ["profit_sharing"] = true
    }
}

Config.SocialFeatures = {
    ["relationships"] = {
        enabled = true,
        max_friends = 50,
        friend_requests = true,
        relationship_status = true
    },
    ["marriage"] = {
        enabled = true,
        ceremony_cost = 5000,
        divorce_cost = 1000,
        shared_bank = true
    },
    ["family"] = {
        enabled = true,
        max_members = 10,
        family_bank = true,
        family_vehicles = true
    }
}

Config.WeatherSystem = {
    ["dynamic"] = true,
    ["seasons"] = true,
    ["temperature"] = true,
    ["effects"] = {
        ["rain"] = {
            ["visibility"] = true,
            ["slippery_roads"] = true,
            ["flooding"] = true
        },
        ["snow"] = {
            ["accumulation"] = true,
            ["slippery_roads"] = true,
            ["snowball_fights"] = true
        }
    }
}

Config.TimeSystem = {
    ["dynamic"] = true,
    ["day_length"] = 24, -- dakika
    ["night_vision"] = true,
    ["sleep_system"] = true,
    ["time_effects"] = {
        ["fatigue"] = true,
        ["hunger"] = true,
        ["thirst"] = true
    }
}

Config.HealthSystem = {
    ["realistic"] = true,
    ["body_parts"] = {
        ["head"] = true,
        ["torso"] = true,
        ["arms"] = true,
        ["legs"] = true
    },
    ["injuries"] = {
        ["bleeding"] = true,
        ["fractures"] = true,
        ["burns"] = true
    },
    ["recovery"] = {
        ["natural"] = true,
        ["medical"] = true,
        ["rehabilitation"] = true
    }
}

Config.InventorySystem = {
    ["weight"] = true,
    ["slots"] = true,
    ["categories"] = true,
    ["stacking"] = true,
    ["durability"] = true,
    ["usage"] = true,
    ["combine"] = true,
    ["split"] = true
}

Config.PhoneSystem = {
    ["apps"] = {
        ["messages"] = true,
        ["contacts"] = true,
        ["bank"] = true,
        ["gps"] = true,
        ["camera"] = true,
        ["social_media"] = true,
        ["news"] = true,
        ["weather"] = true
    },
    ["features"] = {
        ["calls"] = true,
        ["texts"] = true,
        ["photos"] = true,
        ["videos"] = true,
        ["internet"] = true,
        ["bluetooth"] = true
    },
    ["customization"] = {
        ["wallpaper"] = true,
        ["ringtone"] = true,
        ["theme"] = true,
        ["apps"] = true
    }
}

Config.PetSystem = {
    ["types"] = {
        ["dog"] = {
            name = "Köpek",
            price = 5000,
            food = "dog_food",
            health = 100,
            happiness = 100,
            training = true,
            commands = true,
            protection = true
        },
        ["cat"] = {
            name = "Kedi",
            price = 3000,
            food = "cat_food",
            health = 100,
            happiness = 100,
            training = true,
            commands = true,
            protection = true
        }
    },
    ["features"] = {
        ["training"] = true,
        ["breeding"] = true,
        ["competitions"] = true,
        ["accessories"] = true
    }
}

Config.ProductionSystem = {
    ["farming"] = {
        enabled = true,
        crops = {
            ["wheat"] = {
                name = "Buğday",
                growth_time = 300,
                harvest_amount = 3,
                sell_price = 100,
                water_requirement = 50,
                fertilizer_effect = 1.5
            }
        },
        features = {
            ["irrigation"] = true,
            ["fertilizer"] = true,
            ["pests"] = true,
            ["weather_effects"] = true
        }
    },
    ["mining"] = {
        enabled = true,
        ores = {
            ["stone"] = {
                name = "Taş",
                price = 10,
                chance = 100,
                tool_required = "pickaxe",
                durability_loss = 1
            }
        },
        features = {
            ["veins"] = true,
            ["tools"] = true,
            ["explosives"] = true,
            ["cave_system"] = true
        }
    }
}

Config.CraftingSystem = {
    ["items"] = {
        ["weapon_parts"] = {
            name = "Silah Parçaları",
            ingredients = {
                {item = "iron", amount = 5},
                {item = "steel", amount = 3}
            },
            result = "weapon_parts",
            time = 30,
            skill_required = "weapon_crafting",
            tools_required = {"hammer", "screwdriver"}
        }
    },
    ["features"] = {
        ["quality"] = true,
        ["durability"] = true,
        ["experimentation"] = true,
        ["blueprints"] = true
    }
}

Config.EventSystem = {
    ["types"] = {
        ["racing"] = {
            enabled = true,
            checkpoints = true,
            rewards = true,
            betting = true
        },
        ["deathmatch"] = {
            enabled = true,
            teams = true,
            loadouts = true,
            rewards = true
        }
    },
    ["features"] = {
        ["leaderboards"] = true,
        ["rewards"] = true,
        ["spectators"] = true,
        ["betting"] = true
    }
}

Config.NotificationSystem = {
    ["types"] = {
        ["success"] = true,
        ["error"] = true,
        ["info"] = true,
        ["warning"] = true
    },
    ["features"] = {
        ["sound"] = true,
        ["animation"] = true,
        ["duration"] = true,
        ["priority"] = true
    }
}

Config.CommandSystem = {
    ["categories"] = {
        ["general"] = true,
        ["job"] = true,
        ["vehicle"] = true,
        ["admin"] = true
    },
    ["features"] = {
        ["aliases"] = true,
        ["permissions"] = true,
        ["cooldowns"] = true,
        ["logging"] = true
    }
}

Config.PhonePrice = 5000 -- Telefon fiyatı
Config.SimCardPrice = 1000 -- SIM kart fiyatı

Config.PhoneApps = {
    {
        name = 'whatsapp',
        label = 'WhatsApp',
        icon = 'whatsapp.png',
        color = '#25D366'
    },
    {
        name = 'messages',
        label = 'Mesajlar',
        icon = 'messages.png',
        color = '#007AFF'
    },
    {
        name = 'phone',
        label = 'Telefon',
        icon = 'phone.png',
        color = '#34C759'
    },
    {
        name = 'camera',
        label = 'Kamera',
        icon = 'camera.png',
        color = '#FF3B30'
    },
    {
        name = 'twitter',
        label = 'Twitter',
        icon = 'twitter.png',
        color = '#1DA1F2'
    },
    {
        name = 'darkchat',
        label = 'DarkChat',
        icon = 'darkchat.png',
        color = '#000000'
    },
    {
        name = 'sahibinden',
        label = 'Sahibinden',
        icon = 'sahibinden.png',
        color = '#FF6B00'
    },
    {
        name = 'ikinciel',
        label = 'İkinci El',
        icon = 'ikinciel.png',
        color = '#5856D6'
    },
    {
        name = 'spotify',
        label = 'Spotify',
        icon = 'spotify.png',
        color = '#1DB954'
    },
    {
        name = 'youtube',
        label = 'YouTube',
        icon = 'youtube.png',
        color = '#FF0000'
    }
} 