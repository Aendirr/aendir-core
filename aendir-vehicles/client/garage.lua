local AendirCore = exports['aendir-core']:GetCoreObject()

-- Garaj Sistemi
local garages = {
    {x = 213.800, y = -809.200, z = 31.014},
    {x = -275.522, y = 6225.835, z = 31.485},
    {x = 191.979, y = -3030.733, z = 5.907},
    {x = 1174.76, y = 2640.925, z = 37.754},
    {x = 1108.72, y = -778.105, z = 58.289},
    {x = 937.237, y = -970.38, z = 39.569},
    {x = 540.409, y = -183.651, z = 54.481},
    {x = -211.55, y = -1324.55, z = 31.089},
    {x = -458.679, y = -356.481, z = 34.244},
    {x = -1282.54, y = -1115.322, z = 6.99}
}

-- Garaj Blip'leri
CreateThread(function()
    for _, garage in ipairs(garages) do
        local blip = AddBlipForCoord(garage.x, garage.y, garage.z)
        SetBlipSprite(blip, 357)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 3)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Garaj')
        EndTextCommandSetBlipName(blip)
    end
end)

-- Garaj Marker'ları
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, garage in ipairs(garages) do
            local distance = #(coords - vector3(garage.x, garage.y, garage.z))
            
            if distance < 10.0 then
                DrawMarker(1, garage.x, garage.y, garage.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 3.0 then
                    AendirCore.Functions.ShowHelpText('~INPUT_CONTEXT~ Garaj Menüsü')
                    
                    if IsControlJustPressed(0, 38) then -- E tuşu
                        OpenGarageMenu()
                    end
                end
            end
        end
    end
end)

-- Garaj Menüsü
function OpenGarageMenu()
    TriggerServerEvent('aendir:server:GetPlayerVehicles')
end

-- Araç Listesi
RegisterNetEvent('aendir:client:ShowVehicleList', function(vehicles)
    local options = {}
    
    for _, vehicle in ipairs(vehicles) do
        table.insert(options, {
            title = string.format('%s - %s', vehicle.model, vehicle.plate),
            description = string.format('Durum: %s | Yakıt: %.1f%% | Hasar: %.1f%%', 
                vehicle.stored and 'Garajda' or 'Dışarıda',
                vehicle.fuel,
                vehicle.damage),
            onSelect = function()
                if vehicle.stored then
                    TriggerServerEvent('aendir:server:SpawnVehicle', vehicle.plate)
                else
                    TriggerServerEvent('aendir:server:StoreVehicle', vehicle.plate)
                end
            end
        })
    end
    
    if #options == 0 then
        AendirCore.Functions.ShowNotification('Garajınızda araç yok', 'info')
        return
    end
    
    lib.registerContext({
        id = 'vehicle_garage_menu',
        title = 'Garaj Menüsü',
        options = options
    })
    
    lib.showContext('vehicle_garage_menu')
end)

-- Araç Çıkarma
RegisterNetEvent('aendir:client:SpawnVehicle', function(vehicleData)
    local model = GetHashKey(vehicleData.model)
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    local vehicle = CreateVehicle(model, vehicleData.x, vehicleData.y, vehicleData.z, vehicleData.heading, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleNumberPlateText(vehicle, vehicleData.plate)
    SetVehicleFuelLevel(vehicle, vehicleData.fuel)
    SetVehicleBodyHealth(vehicle, vehicleData.bodyHealth)
    SetVehicleEngineHealth(vehicle, vehicleData.engineHealth)
    
    -- Modifikasyonları Uygula
    for category, modIndex in pairs(vehicleData.mods) do
        if category == 'turbo' then
            ToggleVehicleMod(vehicle, 18, modIndex == 1)
        else
            SetVehicleMod(vehicle, GetModType(category), modIndex, false)
        end
    end
    
    SetModelAsNoLongerNeeded(model)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    
    AendirCore.Functions.ShowNotification('Aracınız çıkarıldı', 'success')
end)

-- Araç Park Etme
RegisterNetEvent('aendir:client:StoreVehicle', function(plate)
    local vehicle = GetVehicleByPlate(plate)
    if DoesEntityExist(vehicle) then
        local coords = GetEntityCoords(vehicle)
        local heading = GetEntityHeading(vehicle)
        local fuel = GetVehicleFuelLevel(vehicle)
        local bodyHealth = GetVehicleBodyHealth(vehicle)
        local engineHealth = GetVehicleEngineHealth(vehicle)
        
        -- Modifikasyonları Kaydet
        local mods = {}
        for category, _ in pairs(Config.ModificationCategories) do
            if category == 'turbo' then
                mods[category] = IsToggleModOn(vehicle, 18) and 1 or 0
            else
                mods[category] = GetVehicleMod(vehicle, GetModType(category))
            end
        end
        
        TriggerServerEvent('aendir:server:StoreVehicleData', plate, coords, heading, fuel, bodyHealth, engineHealth, mods)
        DeleteEntity(vehicle)
        
        AendirCore.Functions.ShowNotification('Aracınız park edildi', 'success')
    end
end)

-- Araç Durumu Senkronizasyonu
RegisterNetEvent('aendir:client:SyncVehicleStatus', function(plate, stored, coords, heading, fuel, bodyHealth, engineHealth)
    local vehicle = GetVehicleByPlate(plate)
    if DoesEntityExist(vehicle) then
        if stored then
            SetEntityCoords(vehicle, coords.x, coords.y, coords.z)
            SetEntityHeading(vehicle, heading)
            SetVehicleFuelLevel(vehicle, fuel)
            SetVehicleBodyHealth(vehicle, bodyHealth)
            SetVehicleEngineHealth(vehicle, engineHealth)
        end
    end
end) 