-- Marker'lar
local Markers = {
    -- Marker Tipleri
    Types = {
        -- Garajlar
        Garages = {
            {coords = vector3(-273.0, -955.0, 31.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 0, g = 255, b = 0, a = 100}},
            {coords = vector3(-73.0, -2004.0, 18.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 0, g = 255, b = 0, a = 100}},
            {coords = vector3(214.0, -809.0, 31.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 0, g = 255, b = 0, a = 100}},
            {coords = vector3(56.0, 876.0, 212.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 0, g = 255, b = 0, a = 100}},
            {coords = vector3(597.0, 90.0, 93.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 0, g = 255, b = 0, a = 100}}
        },
        
        -- Çekilmiş Araçlar
        Impound = {
            {coords = vector3(409.0, -1623.0, 29.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 255, g = 0, b = 0, a = 100}}
        },
        
        -- Modifiye
        ModShops = {
            {coords = vector3(-347.0, -133.0, 39.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 0, g = 0, b = 255, a = 100}},
            {coords = vector3(-1155.0, -2007.0, 13.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 0, g = 0, b = 255, a = 100}},
            {coords = vector3(731.0, -1088.0, 22.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 0, g = 0, b = 255, a = 100}}
        },
        
        -- Benzin İstasyonları
        FuelStations = {
            {coords = vector3(-48.0, -1757.0, 29.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 255, g = 255, b = 0, a = 100}},
            {coords = vector3(-724.0, -935.0, 19.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 255, g = 255, b = 0, a = 100}},
            {coords = vector3(-70.0, -1761.0, 29.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 255, g = 255, b = 0, a = 100}}
        },
        
        -- Tamirhaneler
        RepairShops = {
            {coords = vector3(-347.0, -133.0, 39.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 255, g = 165, b = 0, a = 100}},
            {coords = vector3(-1155.0, -2007.0, 13.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 255, g = 165, b = 0, a = 100}},
            {coords = vector3(731.0, -1088.0, 22.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 255, g = 165, b = 0, a = 100}}
        },
        
        -- Sigorta Ofisleri
        InsuranceOffices = {
            {coords = vector3(-273.0, -955.0, 31.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 0, g = 255, b = 255, a = 100}},
            {coords = vector3(-73.0, -2004.0, 18.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 0, g = 255, b = 255, a = 100}},
            {coords = vector3(214.0, -809.0, 31.0), type = 1, size = vector3(1.5, 1.5, 1.0), color = {r = 0, g = 255, b = 255, a = 100}}
        }
    },
    
    -- Marker Ayarları
    Settings = {
        -- Çizim Mesafesi
        DrawDistance = 10.0,
        
        -- Animasyon
        Animation = {
            Enabled = true,
            Duration = 500 -- Milisaniye
        }
    }
}

-- Marker Çizme
function AendirCore.Functions.DrawMarker(coords, type, size, color)
    DrawMarker(type, coords.x, coords.y, coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size.x, size.y, size.z, color.r, color.g, color.b, color.a, false, true, 2, false, nil, nil, false)
end

-- Marker Olayları
RegisterNetEvent('aendir:client:DrawMarker', function(coords, type, size, color)
    AendirCore.Functions.DrawMarker(coords, type, size, color)
end)

-- Marker Komutları
RegisterCommand('drawmarker', function(source, args)
    if args[1] and args[2] and args[3] and args[4] and args[5] and args[6] and args[7] then
        local coords = vector3(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
        local type = tonumber(args[4])
        local size = vector3(tonumber(args[5]), tonumber(args[6]), tonumber(args[7]))
        local color = {r = tonumber(args[8]) or 255, g = tonumber(args[9]) or 255, b = tonumber(args[10]) or 255, a = tonumber(args[11]) or 100}
        
        AendirCore.Functions.DrawMarker(coords, type, size, color)
    else
        AendirCore.Functions.Notify('Koordinat, tip, boyut ve renk belirtmelisiniz!', 'error')
    end
end)

-- Marker Menüsü
RegisterCommand('markermenu', function()
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
        id = 'marker_menu',
        title = 'Marker Menüsü',
        options = elements
    })
    
    lib.showContext('marker_menu')
end)

-- Marker Menü Seçimi
lib.registerCallback('aendir:client:MarkerMenuSelect', function(data)
    local type = data.value
    local markers = {}
    
    if type == 'garages' then
        for k, v in pairs(Markers.Types.Garages) do
            table.insert(markers, v)
        end
    elseif type == 'impound' then
        for k, v in pairs(Markers.Types.Impound) do
            table.insert(markers, v)
        end
    elseif type == 'modshops' then
        for k, v in pairs(Markers.Types.ModShops) do
            table.insert(markers, v)
        end
    elseif type == 'fuelstations' then
        for k, v in pairs(Markers.Types.FuelStations) do
            table.insert(markers, v)
        end
    elseif type == 'repairshops' then
        for k, v in pairs(Markers.Types.RepairShops) do
            table.insert(markers, v)
        end
    elseif type == 'insuranceoffices' then
        for k, v in pairs(Markers.Types.InsuranceOffices) do
            table.insert(markers, v)
        end
    end
    
    -- Marker'ları Çizme
    SetTimeout(300000, function()
        for k, v in pairs(markers) do
            AendirCore.Functions.DrawMarker(v.coords, v.type, v.size, v.color)
        end
    end)
end)

-- Marker Döngüsü
CreateThread(function()
    while true do
        Wait(0)
        
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        -- Garajlar
        for k, v in pairs(Markers.Types.Garages) do
            local distance = #(playerCoords - v.coords)
            if distance < Markers.Settings.DrawDistance then
                AendirCore.Functions.DrawMarker(v.coords, v.type, v.size, v.color)
            end
        end
        
        -- Çekilmiş Araçlar
        for k, v in pairs(Markers.Types.Impound) do
            local distance = #(playerCoords - v.coords)
            if distance < Markers.Settings.DrawDistance then
                AendirCore.Functions.DrawMarker(v.coords, v.type, v.size, v.color)
            end
        end
        
        -- Modifiye
        for k, v in pairs(Markers.Types.ModShops) do
            local distance = #(playerCoords - v.coords)
            if distance < Markers.Settings.DrawDistance then
                AendirCore.Functions.DrawMarker(v.coords, v.type, v.size, v.color)
            end
        end
        
        -- Benzin İstasyonları
        for k, v in pairs(Markers.Types.FuelStations) do
            local distance = #(playerCoords - v.coords)
            if distance < Markers.Settings.DrawDistance then
                AendirCore.Functions.DrawMarker(v.coords, v.type, v.size, v.color)
            end
        end
        
        -- Tamirhaneler
        for k, v in pairs(Markers.Types.RepairShops) do
            local distance = #(playerCoords - v.coords)
            if distance < Markers.Settings.DrawDistance then
                AendirCore.Functions.DrawMarker(v.coords, v.type, v.size, v.color)
            end
        end
        
        -- Sigorta Ofisleri
        for k, v in pairs(Markers.Types.InsuranceOffices) do
            local distance = #(playerCoords - v.coords)
            if distance < Markers.Settings.DrawDistance then
                AendirCore.Functions.DrawMarker(v.coords, v.type, v.size, v.color)
            end
        end
    end
end) 