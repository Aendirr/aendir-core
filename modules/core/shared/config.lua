Config = {}

-- Sunucu Ayarları
Config.ServerName = 'Aendir Roleplay'
Config.ServerDescription = 'Türkiye\'nin En İyi Roleplay Sunucusu'
Config.ServerWebsite = 'www.aendir.com'
Config.ServerDiscord = 'discord.gg/aendir'
Config.ServerTeamspeak = 'ts.aendir.com'

-- Karakter Ayarları
Config.Character = {
    maxCharacters = 3,
    startingMoney = {
        cash = 5000,
        bank = 10000
    },
    startingItems = {
        {name = 'phone', amount = 1},
        {name = 'water', amount = 5},
        {name = 'bread', amount = 5}
    }
}

-- Whitelist Ayarları
Config.Whitelist = {
    enabled = true,
    discordRequired = true,
    teamspeakRequired = true,
    minimumAge = 16,
    applications = {
        enabled = true,
        channel = 'whitelist-basvuru',
        staffChannel = 'whitelist-onay'
    }
}

-- Banka Ayarları
Config.Banking = {
    defaultBank = 'Pacific Standard',
    banks = {
        {
            name = 'Pacific Standard',
            coords = vector3(248.85, 222.86, 106.29),
            blip = {
                sprite = 108,
                color = 2,
                scale = 0.7
            }
        },
        {
            name = 'Legion Square',
            coords = vector3(149.9, -1040.46, 29.37),
            blip = {
                sprite = 108,
                color = 2,
                scale = 0.7
            }
        }
    },
    atmModels = {
        'prop_atm_01',
        'prop_atm_02',
        'prop_atm_03',
        'prop_fleeca_atm'
    }
}

-- Araç Ayarları
Config.Vehicles = {
    defaultGarage = 'Legion Square',
    garages = {
        {
            name = 'Legion Square',
            coords = vector3(215.124, -805.377, 30.815),
            spawn = vector4(231.124, -805.377, 30.815, 160.0),
            blip = {
                sprite = 357,
                color = 3,
                scale = 0.7
            }
        }
    },
    impound = {
        coords = vector3(409.0, -1623.0, 29.3),
        spawn = vector4(409.0, -1623.0, 29.3, 230.0)
    }
}

-- Ev Ayarları
Config.Housing = {
    enabled = true,
    maxHouses = 1,
    houseTypes = {
        apartment = {
            label = 'Daire',
            price = 500000,
            storage = 100
        },
        house = {
            label = 'Ev',
            price = 1000000,
            storage = 200
        },
        mansion = {
            label = 'Malikane',
            price = 2000000,
            storage = 500
        }
    }
}

-- Envanter Ayarları
Config.Inventory = {
    maxWeight = 50,
    maxSlots = 50,
    itemTypes = {
        weapon = {
            label = 'Silah',
            weight = 2.0
        },
        food = {
            label = 'Yiyecek',
            weight = 0.5
        },
        drink = {
            label = 'İçecek',
            weight = 0.5
        },
        medical = {
            label = 'Medikal',
            weight = 0.3
        },
        misc = {
            label = 'Diğer',
            weight = 1.0
        }
    }
}

-- Animasyon Ayarları
Config.Animations = {
    dicts = {
        ['cellphone@'] = {
            ['cellphone_text_read_base'] = {
                flag = 49,
                duration = -1
            }
        }
    }
}

-- Bildirim Ayarları
Config.Notifications = {
    position = 'top-right',
    duration = 5000,
    types = {
        success = {
            color = '#4CAF50',
            icon = 'check'
        },
        error = {
            color = '#F44336',
            icon = 'times'
        },
        info = {
            color = '#2196F3',
            icon = 'info'
        },
        warning = {
            color = '#FFC107',
            icon = 'exclamation'
        }
    }
}

-- Komut Ayarları
Config.Commands = {
    admin = {
        enabled = true,
        prefix = 'a',
        commands = {
            ['kick'] = {
                label = 'Oyuncu At',
                usage = '[id] [sebep]',
                permission = 'admin.kick'
            },
            ['ban'] = {
                label = 'Oyuncu Yasakla',
                usage = '[id] [süre] [sebep]',
                permission = 'admin.ban'
            },
            ['unban'] = {
                label = 'Yasağı Kaldır',
                usage = '[steam]',
                permission = 'admin.unban'
            },
            ['noclip'] = {
                label = 'Noclip',
                usage = '',
                permission = 'admin.noclip'
            },
            ['godmode'] = {
                label = 'God Mode',
                usage = '',
                permission = 'admin.godmode'
            }
        }
    }
} 