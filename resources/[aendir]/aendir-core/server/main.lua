-- Core
local AendirCore = {}

-- Config
Config = {
    StartingMoney = {
        Cash = 5000,
        Bank = 10000,
        Black = 0
    },
    DefaultJob = {
        Name = 'unemployed',
        Grade = 0
    },
    DefaultGang = {
        Name = 'none',
        Grade = 0
    },
    DefaultPosition = {
        X = -269.0,
        Y = -955.0,
        Z = 31.0,
        Heading = 205.0
    },
    DefaultModel = 'a_m_y_business_03',
    Characters = {
        MaxCharacters = 4,
        MinNameLength = 3,
        MaxNameLength = 20,
        AllowedCharacters = '^[%a%s]+$'
    },
    Jobs = {
        unemployed = {
            label = 'İşsiz',
            grades = {
                ['0'] = {
                    name = 'İşsiz',
                    payment = 0
                }
            }
        },
        police = {
            label = 'Polis',
            grades = {
                ['0'] = {
                    name = 'Stajyer',
                    payment = 1000
                },
                ['1'] = {
                    name = 'Polis',
                    payment = 2000
                },
                ['2'] = {
                    name = 'Çavuş',
                    payment = 3000
                },
                ['3'] = {
                    name = 'Başkomiser',
                    payment = 4000
                }
            }
        },
        ambulance = {
            label = 'Sağlık',
            grades = {
                ['0'] = {
                    name = 'Stajyer',
                    payment = 1000
                },
                ['1'] = {
                    name = 'Doktor',
                    payment = 2000
                },
                ['2'] = {
                    name = 'Başhekim',
                    payment = 3000
                }
            }
        },
        mechanic = {
            label = 'Mekanik',
            grades = {
                ['0'] = {
                    name = 'Stajyer',
                    payment = 1000
                },
                ['1'] = {
                    name = 'Mekanik',
                    payment = 2000
                },
                ['2'] = {
                    name = 'Usta',
                    payment = 3000
                }
            }
        },
        taxi = {
            label = 'Taksi',
            grades = {
                ['0'] = {
                    name = 'Şoför',
                    payment = 1000
                },
                ['1'] = {
                    name = 'Usta Şoför',
                    payment = 2000
                }
            }
        },
        realtor = {
            label = 'Emlakçı',
            grades = {
                ['0'] = {
                    name = 'Satış Temsilcisi',
                    payment = 1000
                },
                ['1'] = {
                    name = 'Emlakçı',
                    payment = 2000
                },
                ['2'] = {
                    name = 'Müdür',
                    payment = 3000
                }
            }
        }
    },
    Gangs = {
        none = {
            label = 'Çetesiz',
            grades = {
                ['0'] = {
                    name = 'Çetesiz',
                    payment = 0
                }
            }
        },
        mafia = {
            label = 'Mafya',
            grades = {
                ['0'] = {
                    name = 'Üye',
                    payment = 1000
                },
                ['1'] = {
                    name = 'Üye',
                    payment = 2000
                },
                ['2'] = {
                    name = 'Üye',
                    payment = 3000
                },
                ['3'] = {
                    name = 'Üye',
                    payment = 4000
                }
            }
        },
        cartel = {
            label = 'Kartel',
            grades = {
                ['0'] = {
                    name = 'Üye',
                    payment = 1000
                },
                ['1'] = {
                    name = 'Üye',
                    payment = 2000
                },
                ['2'] = {
                    name = 'Üye',
                    payment = 3000
                },
                ['3'] = {
                    name = 'Üye',
                    payment = 4000
                }
            }
        }
    }
}

-- Functions
AendirCore.Functions = {}

-- Exports
exports('GetCoreObject', function()
    return AendirCore
end)

-- Events
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    print('^2[Aendir Core] ^7Başlatılıyor...')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    print('^1[Aendir Core] ^7Durduruldu!')
end) 