Config = {}

Config.Garages = {
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
}

Config.Impound = {
    coords = vector3(409.0, -1623.0, 29.3),
    spawn = vector4(409.0, -1623.0, 29.3, 230.5),
    blip = {
        sprite = 67,
        color = 1,
        scale = 0.7,
        label = "Araç Çekme"
    },
    price = 1000
}

Config.Insurance = {
    price = 5000,
    percentage = 0.7 -- Hasar miktarının yüzde 70'ini öder
}

Config.Debug = false 