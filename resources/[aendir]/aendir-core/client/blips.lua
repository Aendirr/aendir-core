-- Blip'ler
local Blips = {
    -- Blip Tipleri
    Types = {
        -- Garajlar
        Garages = {
            {name = "Garaj", coords = vector3(-273.0, -955.0, 31.0), sprite = 357, color = 3, scale = 0.7},
            {name = "Garaj", coords = vector3(-73.0, -2004.0, 18.0), sprite = 357, color = 3, scale = 0.7},
            {name = "Garaj", coords = vector3(214.0, -809.0, 31.0), sprite = 357, color = 3, scale = 0.7},
            {name = "Garaj", coords = vector3(56.0, 876.0, 212.0), sprite = 357, color = 3, scale = 0.7},
            {name = "Garaj", coords = vector3(597.0, 90.0, 93.0), sprite = 357, color = 3, scale = 0.7},
            {name = "Garaj", coords = vector3(-658.0, -854.0, 24.0), sprite = 357, color = 3, scale = 0.7},
            {name = "Garaj", coords = vector3(-817.0, -182.0, 37.0), sprite = 357, color = 3, scale = 0.7},
            {name = "Garaj", coords = vector3(-1037.0, -2738.0, 20.0), sprite = 357, color = 3, scale = 0.7},
            {name = "Garaj", coords = vector3(-1303.0, -394.0, 36.0), sprite = 357, color = 3, scale = 0.7},
            {name = "Garaj", coords = vector3(-1421.0, -457.0, 35.0), sprite = 357, color = 3, scale = 0.7}
        },
        
        -- Çekilmiş Araçlar
        Impound = {
            {name = "Çekilmiş Araçlar", coords = vector3(409.0, -1623.0, 29.0), sprite = 524, color = 1, scale = 0.7}
        },
        
        -- Modifiye
        ModShops = {
            {name = "Modifiye", coords = vector3(-347.0, -133.0, 39.0), sprite = 446, color = 5, scale = 0.7},
            {name = "Modifiye", coords = vector3(-1155.0, -2007.0, 13.0), sprite = 446, color = 5, scale = 0.7},
            {name = "Modifiye", coords = vector3(731.0, -1088.0, 22.0), sprite = 446, color = 5, scale = 0.7},
            {name = "Modifiye", coords = vector3(1175.0, 2640.0, 37.0), sprite = 446, color = 5, scale = 0.7},
            {name = "Modifiye", coords = vector3(110.0, 6626.0, 31.0), sprite = 446, color = 5, scale = 0.7}
        },
        
        -- Benzin İstasyonları
        FuelStations = {
            {name = "Benzin İstasyonu", coords = vector3(-48.0, -1757.0, 29.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(-724.0, -935.0, 19.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(-70.0, -1761.0, 29.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(1039.0, 2671.0, 39.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(1207.0, 2660.0, 37.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(2539.0, 2594.0, 37.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(2679.0, 3263.0, 55.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(2005.0, 3773.0, 32.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(1687.0, 4929.0, 42.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(1701.0, 6416.0, 32.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(179.0, 6602.0, 31.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(-94.0, 6419.0, 31.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(-2554.0, 2334.0, 33.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(-1800.0, 803.0, 138.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(-1437.0, -276.0, 46.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(-2096.0, -320.0, 13.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(-724.0, -935.0, 19.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(-526.0, -1211.0, 18.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(-70.0, -1761.0, 29.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(265.0, -1261.0, 29.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(819.0, -1028.0, 26.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(1208.0, -1402.0, 35.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(1181.0, -330.0, 69.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(620.0, 269.0, 103.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(2581.0, 362.0, 108.0), sprite = 361, color = 1, scale = 0.7},
            {name = "Benzin İstasyonu", coords = vector3(1785.0, 3330.0, 41.0), sprite = 361, color = 1, scale = 0.7}
        },
        
        -- Tamirhaneler
        RepairShops = {
            {name = "Tamirhane", coords = vector3(-347.0, -133.0, 39.0), sprite = 446, color = 5, scale = 0.7},
            {name = "Tamirhane", coords = vector3(-1155.0, -2007.0, 13.0), sprite = 446, color = 5, scale = 0.7},
            {name = "Tamirhane", coords = vector3(731.0, -1088.0, 22.0), sprite = 446, color = 5, scale = 0.7},
            {name = "Tamirhane", coords = vector3(1175.0, 2640.0, 37.0), sprite = 446, color = 5, scale = 0.7},
            {name = "Tamirhane", coords = vector3(110.0, 6626.0, 31.0), sprite = 446, color = 5, scale = 0.7}
        },
        
        -- Sigorta Ofisleri
        InsuranceOffices = {
            {name = "Sigorta Ofisi", coords = vector3(-273.0, -955.0, 31.0), sprite = 498, color = 2, scale = 0.7},
            {name = "Sigorta Ofisi", coords = vector3(-73.0, -2004.0, 18.0), sprite = 498, color = 2, scale = 0.7},
            {name = "Sigorta Ofisi", coords = vector3(214.0, -809.0, 31.0), sprite = 498, color = 2, scale = 0.7},
            {name = "Sigorta Ofisi", coords = vector3(56.0, 876.0, 212.0), sprite = 498, color = 2, scale = 0.7},
            {name = "Sigorta Ofisi", coords = vector3(597.0, 90.0, 93.0), sprite = 498, color = 2, scale = 0.7}
        }
    }
}

-- Blip Oluşturma
function AendirCore.Functions.CreateBlip(coords, sprite, color, scale, name)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    return blip
end

-- Blip Silme
function AendirCore.Functions.RemoveBlip(blip)
    if DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
end

-- Blip Olayları
RegisterNetEvent('aendir:client:CreateBlip', function(coords, sprite, color, scale, name)
    AendirCore.Functions.CreateBlip(coords, sprite, color, scale, name)
end)

RegisterNetEvent('aendir:client:RemoveBlip', function(blip)
    AendirCore.Functions.RemoveBlip(blip)
end)

-- Blip Komutları
RegisterCommand('createblip', function(source, args)
    if args[1] and args[2] and args[3] and args[4] and args[5] then
        local coords = vector3(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
        local sprite = tonumber(args[4])
        local color = tonumber(args[5])
        local scale = tonumber(args[6]) or 0.7
        local name = args[7] or "Blip"
        
        AendirCore.Functions.CreateBlip(coords, sprite, color, scale, name)
    else
        AendirCore.Functions.Notify('Koordinat, sprite, renk ve isim belirtmelisiniz!', 'error')
    end
end)

-- Blip Menüsü
RegisterCommand('blipmenu', function()
    local elements = {
        {
            label = 'Garajlar',
            value = 'garages'
        },
        {
            label = 'Çekilmiş Araçlar',
            value = 'impound'
        },
        {
            label = 'Modifiye',
            value = 'modshops'
        },
        {
            label = 'Benzin İstasyonları',
            value = 'fuelstations'
        },
        {
            label = 'Tamirhaneler',
            value = 'repairshops'
        },
        {
            label = 'Sigorta Ofisleri',
            value = 'insuranceoffices'
        }
    }
    
    lib.registerContext({
        id = 'blip_menu',
        title = 'Blip Menüsü',
        options = elements
    })
    
    lib.showContext('blip_menu')
end)

-- Blip Menü Seçimi
lib.registerCallback('aendir:client:BlipMenuSelect', function(data)
    local type = data.value
    local blips = {}
    
    if type == 'garages' then
        for k, v in pairs(Blips.Types.Garages) do
            table.insert(blips, AendirCore.Functions.CreateBlip(v.coords, v.sprite, v.color, v.scale, v.name))
        end
    elseif type == 'impound' then
        for k, v in pairs(Blips.Types.Impound) do
            table.insert(blips, AendirCore.Functions.CreateBlip(v.coords, v.sprite, v.color, v.scale, v.name))
        end
    elseif type == 'modshops' then
        for k, v in pairs(Blips.Types.ModShops) do
            table.insert(blips, AendirCore.Functions.CreateBlip(v.coords, v.sprite, v.color, v.scale, v.name))
        end
    elseif type == 'fuelstations' then
        for k, v in pairs(Blips.Types.FuelStations) do
            table.insert(blips, AendirCore.Functions.CreateBlip(v.coords, v.sprite, v.color, v.scale, v.name))
        end
    elseif type == 'repairshops' then
        for k, v in pairs(Blips.Types.RepairShops) do
            table.insert(blips, AendirCore.Functions.CreateBlip(v.coords, v.sprite, v.color, v.scale, v.name))
        end
    elseif type == 'insuranceoffices' then
        for k, v in pairs(Blips.Types.InsuranceOffices) do
            table.insert(blips, AendirCore.Functions.CreateBlip(v.coords, v.sprite, v.color, v.scale, v.name))
        end
    end
    
    -- Blip'leri Silme
    SetTimeout(300000, function()
        for k, v in pairs(blips) do
            AendirCore.Functions.RemoveBlip(v)
        end
    end)
end)

-- Blip Döngüsü
CreateThread(function()
    while true do
        Wait(1000)
        
        -- Blip Animasyonu
        if IsPauseMenuActive() then
            -- Animasyon Kodu
        end
    end
end) 