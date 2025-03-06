local AendirCore = exports['aendir-core']:GetCoreObject()

-- Çekme Sistemi
local impoundLots = {
    {x = 409.825, y = -1623.759, z = 29.291},
    {x = 1623.011, y = 3788.669, z = 34.705},
    {x = -64.593, y = -1281.633, z = 29.244},
    {x = 1577.768, y = 3604.505, z = 35.433},
    {x = -273.001, y = -955.954, z = 31.223},
    {x = 431.223, y = -1016.177, z = 28.562},
    {x = 1245.190, y = 2732.933, z = 37.901},
    {x = -458.679, y = -356.481, z = 34.244},
    {x = -1282.54, y = -1115.322, z = 6.99},
    {x = 17.597, y = -1096.362, z = 26.677}
}

-- Çekme Alanı Blip'leri
CreateThread(function()
    for _, lot in ipairs(impoundLots) do
        local blip = AddBlipForCoord(lot.x, lot.y, lot.z)
        SetBlipSprite(blip, 67)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Çekme Alanı')
        EndTextCommandSetBlipName(blip)
    end
end)

-- Çekme Alanı Marker'ları
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, lot in ipairs(impoundLots) do
            local distance = #(coords - vector3(lot.x, lot.y, lot.z))
            
            if distance < 10.0 then
                DrawMarker(1, lot.x, lot.y, lot.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 3.0 then
                    AendirCore.Functions.ShowHelpText('~INPUT_CONTEXT~ Çekme Alanı Menüsü')
                    
                    if IsControlJustPressed(0, 38) then -- E tuşu
                        OpenImpoundMenu()
                    end
                end
            end
        end
    end
end)

-- Çekme Alanı Menüsü
function OpenImpoundMenu()
    TriggerServerEvent('aendir:server:GetImpoundedVehicles')
end

-- Çekilen Araç Listesi
RegisterNetEvent('aendir:client:ShowImpoundedVehicles', function(vehicles)
    local options = {}
    
    for _, vehicle in ipairs(vehicles) do
        table.insert(options, {
            title = string.format('%s - %s', vehicle.model, vehicle.plate),
            description = string.format('Çekme Ücreti: $%d | Yakıt: %.1f%% | Hasar: %.1f%%', 
                vehicle.impoundFee,
                vehicle.fuel,
                vehicle.damage),
            onSelect = function()
                TriggerServerEvent('aendir:server:RetrieveImpoundedVehicle', vehicle.plate)
            end
        })
    end
    
    if #options == 0 then
        AendirCore.Functions.ShowNotification('Çekme alanında araç yok', 'info')
        return
    end
    
    lib.registerContext({
        id = 'vehicle_impound_menu',
        title = 'Çekme Alanı Menüsü',
        options = options
    })
    
    lib.showContext('vehicle_impound_menu')
end)

-- Araç Çekme
RegisterNetEvent('aendir:client:RetrieveVehicle', function(vehicleData)
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
    
    AendirCore.Functions.ShowNotification('Aracınız çekildi', 'success')
end)

-- Araç Çekme Durumu Senkronizasyonu
RegisterNetEvent('aendir:client:SyncImpoundStatus', function(plate, impounded, coords, heading, fuel, bodyHealth, engineHealth)
    local vehicle = GetVehicleByPlate(plate)
    if DoesEntityExist(vehicle) then
        if impounded then
            SetEntityCoords(vehicle, coords.x, coords.y, coords.z)
            SetEntityHeading(vehicle, heading)
            SetVehicleFuelLevel(vehicle, fuel)
            SetVehicleBodyHealth(vehicle, bodyHealth)
            SetVehicleEngineHealth(vehicle, engineHealth)
        end
    end
end)

-- Araç Çekme Bildirimleri
RegisterNetEvent('aendir:client:ImpoundNotification', function(message, type)
    AendirCore.Functions.ShowNotification(message, type)
end) 