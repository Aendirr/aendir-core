Config = {}

-- Meslek Kategorileri
Config.JobCategories = {
    public = {
        label = 'Kamu Hizmetleri',
        jobs = {
            police = {
                label = 'Polis',
                grades = {
                    {name = 'stajyer', label = 'Stajyer Polis', salary = 5000},
                    {name = 'police', label = 'Polis', salary = 7500},
                    {name = 'sergeant', label = 'Başkomiser', salary = 10000},
                    {name = 'lieutenant', label = 'Komiser', salary = 12500},
                    {name = 'chief', label = 'Emniyet Müdürü', salary = 15000}
                },
                locations = {
                    duty = vector3(441.8, -983.1, 30.7),
                    spawn = vector4(442.8, -983.1, 30.7, 90.0)
                }
            },
            ambulance = {
                label = 'Sağlık',
                grades = {
                    {name = 'intern', label = 'Stajyer Doktor', salary = 5000},
                    {name = 'doctor', label = 'Doktor', salary = 7500},
                    {name = 'surgeon', label = 'Cerrahi Uzmanı', salary = 10000},
                    {name = 'chief', label = 'Başhekim', salary = 12500}
                },
                locations = {
                    duty = vector3(306.8, -595.3, 43.3),
                    spawn = vector4(307.8, -595.3, 43.3, 90.0)
                }
            },
            mechanic = {
                label = 'Mekanik',
                grades = {
                    {name = 'apprentice', label = 'Çırak', salary = 4000},
                    {name = 'mechanic', label = 'Mekanik', salary = 6000},
                    {name = 'master', label = 'Usta', salary = 8000},
                    {name = 'boss', label = 'Patron', salary = 10000}
                },
                locations = {
                    duty = vector3(-347.4, -133.0, 39.0),
                    spawn = vector4(-348.4, -133.0, 39.0, 90.0)
                }
            }
        }
    },
    private = {
        label = 'Özel Sektör',
        jobs = {
            realtor = {
                label = 'Emlakçı',
                grades = {
                    {name = 'agent', label = 'Emlak Danışmanı', salary = 4500},
                    {name = 'broker', label = 'Emlakçı', salary = 6500},
                    {name = 'manager', label = 'Müdür', salary = 8500},
                    {name = 'boss', label = 'Patron', salary = 11000}
                },
                locations = {
                    duty = vector3(-132.4, -638.8, 168.8),
                    spawn = vector4(-133.4, -638.8, 168.8, 90.0)
                }
            },
            lawyer = {
                label = 'Avukat',
                grades = {
                    {name = 'intern', label = 'Stajyer Avukat', salary = 6000},
                    {name = 'lawyer', label = 'Avukat', salary = 8000},
                    {name = 'partner', label = 'Ortak', salary = 10000},
                    {name = 'boss', label = 'Patron', salary = 12000}
                },
                locations = {
                    duty = vector3(-190.4, -1343.1, 31.1),
                    spawn = vector4(-191.4, -1343.1, 31.1, 90.0)
                }
            },
            taxi = {
                label = 'Taksici',
                grades = {
                    {name = 'driver', label = 'Şoför', salary = 4000},
                    {name = 'manager', label = 'Müdür', salary = 6000},
                    {name = 'boss', label = 'Patron', salary = 8000}
                },
                locations = {
                    duty = vector3(903.3, -170.7, 74.1),
                    spawn = vector4(904.3, -170.7, 74.1, 90.0)
                }
            }
        }
    },
    criminal = {
        label = 'Yasadışı İşler',
        jobs = {
            mafia = {
                label = 'Mafya',
                grades = {
                    {name = 'recruit', label = 'Acemi', salary = 5000},
                    {name = 'member', label = 'Üye', salary = 7500},
                    {name = 'capo', label = 'Capo', salary = 10000},
                    {name = 'boss', label = 'Patron', salary = 15000}
                },
                locations = {
                    duty = vector3(-1520.4, -419.3, 42.1),
                    spawn = vector4(-1521.4, -419.3, 42.1, 90.0)
                }
            },
            cartel = {
                label = 'Kartel',
                grades = {
                    {name = 'recruit', label = 'Acemi', salary = 5000},
                    {name = 'member', label = 'Üye', salary = 7500},
                    {name = 'lieutenant', label = 'Teğmen', salary = 10000},
                    {name = 'boss', label = 'Patron', salary = 15000}
                },
                locations = {
                    duty = vector3(1391.7, 3605.8, 34.9),
                    spawn = vector4(1392.7, 3605.8, 34.9, 90.0)
                }
            }
        }
    }
}

-- Meslek Özellikleri
Config.JobFeatures = {
    duty = {
        enabled = true,
        command = 'duty',
        key = 'F6'
    },
    uniforms = {
        enabled = true,
        command = 'uniform'
    },
    vehicles = {
        enabled = true,
        command = 'vehicle'
    },
    inventory = {
        enabled = true,
        command = 'inventory'
    }
}

-- Meslek İzinleri
Config.JobPermissions = {
    police = {
        canArrest = true,
        canFine = true,
        canImpound = true,
        canSearch = true
    },
    ambulance = {
        canHeal = true,
        canRevive = true,
        canTreat = true
    },
    mechanic = {
        canRepair = true,
        canImpound = true,
        canModify = true
    }
}

-- Meslek Ödülleri
Config.JobRewards = {
    police = {
        arrest = 1000,
        fine = 500
    },
    ambulance = {
        heal = 500,
        revive = 1000
    },
    mechanic = {
        repair = 800,
        mod = 1200
    }
} 