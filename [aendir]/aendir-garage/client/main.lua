local QBCore = exports['qb-core']:GetCoreObject()
local currentVehicle = nil

-- Blip Oluşturma
CreateThread(function()
    -- Garaj Blipleri
    for _, garage in pairs(Config.Garages) do
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
    
    -- Çekme Blipi
    local impoundBlip = AddBlipForCoord(Config.Impound.coords.x, Config.Impound.coords.y, Config.Impound.coords.z)
    SetBlipSprite(impoundBlip, Config.Impound.blip.sprite)
    SetBlipDisplay(impoundBlip, 4)
    SetBlipScale(impoundBlip, Config.Impound.blip.scale)
    SetBlipColour(impoundBlip, Config.Impound.blip.color)
    SetBlipAsShortRange(impoundBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Impound.blip.label)
    EndTextCommandSetBlipName(impoundBlip)
end)

-- Garaj Menüsü
function OpenGarageMenu(garage)
    QBCore.Functions.TriggerCallback('aendir:server:GetPlayerVehicles', function(vehicles)
        local elements = {}
        
        for _, vehicle in pairs(vehicles) do
            local status = vehicle.stored and "Garajda" or "Dışarıda"
            local damage = vehicle.damage and "Hasar Var" or "Sağlam"
            
            table.insert(elements, {
                title = vehicle.plate,
                description = string.format("Durum: %s | %s", status, damage),
                event = "aendir:client:GarageAction",
                args = {
                    vehicle = vehicle,
                    garage = garage
                }
            })
        end
        
        lib.registerContext({
            id = 'garage_menu',
            title = garage.name,
            options = elements
        })
        
        lib.showContext('garage_menu')
    end)
end

-- Garaj İşlemleri
RegisterNetEvent('aendir:client:GarageAction', function(data)
    local vehicle = data.vehicle
    local garage = data.garage
    
    if vehicle.stored then
        -- Araç Çıkarma
        QBCore.Functions.TriggerCallback('aendir:server:GetVehicle', function(success)
            if success then
                local model = GetHashKey(vehicle.model)
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Wait(0)
                end
                
                local veh = CreateVehicle(model, garage.spawn.x, garage.spawn.y, garage.spawn.z, garage.spawn.w, true, false)
                SetEntityAsMissionEntity(veh, true, true)
                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, garage.spawn.w)
                SetVehicleEngineOn(veh, false, true, true)
                SetVehicleOnGroundProperly(veh)
                SetModelAsNoLongerNeeded(model)
                
                if vehicle.properties then
                    QBCore.Functions.SetVehicleProperties(veh, vehicle.properties)
                end
                
                QBCore.Functions.Notify('Aracınız çıkarıldı!', 'success')
            else
                QBCore.Functions.Notify('Bir hata oluştu!', 'error')
            end
        end, vehicle.plate)
    else
        -- Araç Park Etme
        local playerPed = PlayerPedId()
        local veh = GetVehiclePedIsIn(playerPed, false)
        
        if veh ~= 0 then
            local plate = GetVehicleNumberPlateText(veh)
            
            if plate == vehicle.plate then
                local props = QBCore.Functions.GetVehicleProperties(veh)
                
                QBCore.Functions.TriggerCallback('aendir:server:StoreVehicle', function(success)
                    if success then
                        DeleteEntity(veh)
                        QBCore.Functions.Notify('Aracınız park edildi!', 'success')
                    else
                        QBCore.Functions.Notify('Bir hata oluştu!', 'error')
                    end
                end, plate, props)
            else
                QBCore.Functions.Notify('Bu araç size ait değil!', 'error')
            end
        else
            QBCore.Functions.Notify('Bir araçta olmalısınız!', 'error')
        end
    end
end)

-- Çekme Menüsü
function OpenImpoundMenu()
    QBCore.Functions.TriggerCallback('aendir:server:GetImpoundedVehicles', function(vehicles)
        local elements = {}
        
        for _, vehicle in pairs(vehicles) do
            table.insert(elements, {
                title = vehicle.plate,
                description = string.format("Çekme Ücreti: $%d", Config.Impound.price),
                event = "aendir:client:ImpoundAction",
                args = {
                    vehicle = vehicle
                }
            })
        end
        
        lib.registerContext({
            id = 'impound_menu',
            title = 'Araç Çekme',
            options = elements
        })
        
        lib.showContext('impound_menu')
    end)
end

-- Çekme İşlemi
RegisterNetEvent('aendir:client:ImpoundAction', function(data)
    local vehicle = data.vehicle
    
    QBCore.Functions.TriggerCallback('aendir:server:ImpoundVehicle', function(success)
        if success then
            local model = GetHashKey(vehicle.model)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            
            local veh = CreateVehicle(model, Config.Impound.spawn.x, Config.Impound.spawn.y, Config.Impound.spawn.z, Config.Impound.spawn.w, true, false)
            SetEntityAsMissionEntity(veh, true, true)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, Config.Impound.spawn.w)
            SetVehicleEngineOn(veh, false, true, true)
            SetVehicleOnGroundProperly(veh)
            SetModelAsNoLongerNeeded(model)
            
            if vehicle.properties then
                QBCore.Functions.SetVehicleProperties(veh, vehicle.properties)
            end
            
            QBCore.Functions.Notify('Aracınız çekildi!', 'success')
        else
            QBCore.Functions.Notify('Yeterli paranız yok!', 'error')
        end
    end, vehicle.plate)
end)

-- Garaj Menüsünü Aç
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        -- Garaj Kontrolü
        for _, garage in pairs(Config.Garages) do
            local distance = #(coords - garage.coords)
            
            if distance < 10.0 then
                DrawMarker(1, garage.coords.x, garage.coords.y, garage.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 2.0 then
                    if IsControlJustPressed(0, 38) then -- E tuşu
                        OpenGarageMenu(garage)
                    end
                end
            end
        end
        
        -- Çekme Kontrolü
        local impoundDistance = #(coords - Config.Impound.coords)
        
        if impoundDistance < 10.0 then
            DrawMarker(1, Config.Impound.coords.x, Config.Impound.coords.y, Config.Impound.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
            
            if impoundDistance < 2.0 then
                if IsControlJustPressed(0, 38) then -- E tuşu
                    OpenImpoundMenu()
                end
            end
        end
    end
end) 