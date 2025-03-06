local AendirCore = exports['aendir-core']:GetCoreObject()

-- Blip Oluşturma
CreateThread(function()
    -- Garaj Blipleri
    for _, garage in ipairs(Config.Vehicles.Garages) do
        local blip = AddBlipForCoord(garage.coords.x, garage.coords.y, garage.coords.z)
        SetBlipSprite(blip, garage.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, garage.blip.scale)
        SetBlipColour(blip, garage.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(garage.blip.label)
        EndTextCommandSetBlipName(blip)
    end
    
    -- Çekme Blibi
    local impound = Config.Vehicles.Impound
    local blip = AddBlipForCoord(impound.coords.x, impound.coords.y, impound.coords.z)
    SetBlipSprite(blip, impound.blip.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, impound.blip.scale)
    SetBlipColour(blip, impound.blip.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(impound.blip.label)
    EndTextCommandSetBlipName(blip)
    
    -- Modifiye Blipleri
    for _, modshop in ipairs(Config.Vehicles.ModShops) do
        local blip = AddBlipForCoord(modshop.coords.x, modshop.coords.y, modshop.coords.z)
        SetBlipSprite(blip, modshop.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, modshop.blip.scale)
        SetBlipColour(blip, modshop.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(modshop.blip.label)
        EndTextCommandSetBlipName(blip)
    end
    
    -- Yakıt İstasyonu Blipleri
    for _, station in ipairs(Config.Vehicles.FuelStations) do
        local blip = AddBlipForCoord(station.coords.x, station.coords.y, station.coords.z)
        SetBlipSprite(blip, station.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, station.blip.scale)
        SetBlipColour(blip, station.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(station.blip.label)
        EndTextCommandSetBlipName(blip)
    end
    
    -- Tamir Blipleri
    for _, repair in ipairs(Config.Vehicles.RepairShops) do
        local blip = AddBlipForCoord(repair.coords.x, repair.coords.y, repair.coords.z)
        SetBlipSprite(blip, repair.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, repair.blip.scale)
        SetBlipColour(blip, repair.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(repair.blip.label)
        EndTextCommandSetBlipName(blip)
    end
    
    -- Sigorta Blipleri
    for _, insurance in ipairs(Config.Vehicles.InsuranceOffices) do
        local blip = AddBlipForCoord(insurance.coords.x, insurance.coords.y, insurance.coords.z)
        SetBlipSprite(blip, insurance.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, insurance.blip.scale)
        SetBlipColour(blip, insurance.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(insurance.blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Marker Çizimi
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        -- Garaj Markerları
        for _, garage in ipairs(Config.Vehicles.Garages) do
            if #(coords - garage.coords) < Config.Markers.Default.drawDistance then
                DrawMarker(
                    Config.Markers.Default.type,
                    garage.coords.x, garage.coords.y, garage.coords.z - 1.0,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    Config.Markers.Default.size.x, Config.Markers.Default.size.y, Config.Markers.Default.size.z,
                    Config.Markers.Default.color.x, Config.Markers.Default.color.y, Config.Markers.Default.color.z, 100,
                    false, true, 2, false, nil, nil, false
                )
            end
        end
        
        -- Çekme Markerı
        local impound = Config.Vehicles.Impound
        if #(coords - impound.coords) < Config.Markers.Default.drawDistance then
            DrawMarker(
                Config.Markers.Default.type,
                impound.coords.x, impound.coords.y, impound.coords.z - 1.0,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                Config.Markers.Default.size.x, Config.Markers.Default.size.y, Config.Markers.Default.size.z,
                Config.Markers.Default.color.x, Config.Markers.Default.color.y, Config.Markers.Default.color.z, 100,
                false, true, 2, false, nil, nil, false
            )
        end
        
        -- Modifiye Markerları
        for _, modshop in ipairs(Config.Vehicles.ModShops) do
            if #(coords - modshop.coords) < Config.Markers.Default.drawDistance then
                DrawMarker(
                    Config.Markers.Default.type,
                    modshop.coords.x, modshop.coords.y, modshop.coords.z - 1.0,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    Config.Markers.Default.size.x, Config.Markers.Default.size.y, Config.Markers.Default.size.z,
                    Config.Markers.Default.color.x, Config.Markers.Default.color.y, Config.Markers.Default.color.z, 100,
                    false, true, 2, false, nil, nil, false
                )
            end
        end
        
        -- Yakıt İstasyonu Markerları
        for _, station in ipairs(Config.Vehicles.FuelStations) do
            if #(coords - station.coords) < Config.Markers.Default.drawDistance then
                DrawMarker(
                    Config.Markers.Default.type,
                    station.coords.x, station.coords.y, station.coords.z - 1.0,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    Config.Markers.Default.size.x, Config.Markers.Default.size.y, Config.Markers.Default.size.z,
                    Config.Markers.Default.color.x, Config.Markers.Default.color.y, Config.Markers.Default.color.z, 100,
                    false, true, 2, false, nil, nil, false
                )
            end
        end
        
        -- Tamir Markerları
        for _, repair in ipairs(Config.Vehicles.RepairShops) do
            if #(coords - repair.coords) < Config.Markers.Default.drawDistance then
                DrawMarker(
                    Config.Markers.Default.type,
                    repair.coords.x, repair.coords.y, repair.coords.z - 1.0,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    Config.Markers.Default.size.x, Config.Markers.Default.size.y, Config.Markers.Default.size.z,
                    Config.Markers.Default.color.x, Config.Markers.Default.color.y, Config.Markers.Default.color.z, 100,
                    false, true, 2, false, nil, nil, false
                )
            end
        end
        
        -- Sigorta Markerları
        for _, insurance in ipairs(Config.Vehicles.InsuranceOffices) do
            if #(coords - insurance.coords) < Config.Markers.Default.drawDistance then
                DrawMarker(
                    Config.Markers.Default.type,
                    insurance.coords.x, insurance.coords.y, insurance.coords.z - 1.0,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    Config.Markers.Default.size.x, Config.Markers.Default.size.y, Config.Markers.Default.size.z,
                    Config.Markers.Default.color.x, Config.Markers.Default.color.y, Config.Markers.Default.color.z, 100,
                    false, true, 2, false, nil, nil, false
                )
            end
        end
    end
end) 