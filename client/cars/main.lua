local QBCore = exports['qb-core']:GetCoreObject()
local currentVehicle = nil
local isLocked = false
local isEngineRunning = false

-- Araç Kontrolleri
CreateThread(function()
    while true do
        Wait(0)
        
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local plate = GetVehicleNumberPlateText(vehicle)
            
            -- Motor Kontrolü (M tuşu)
            if IsControlJustPressed(0, 244) then -- M tuşu
                ToggleEngine(vehicle, plate)
            end
            
            -- Kilit Kontrolü (U tuşu)
            if IsControlJustPressed(0, 303) then -- U tuşu
                ToggleLock(vehicle, plate)
            end
        end
    end
end)

-- Motor Kontrolü
function ToggleEngine(vehicle, plate)
    QBCore.Functions.TriggerCallback('aendir:server:CheckVehicleOwnership', function(owned)
        if owned then
            isEngineRunning = not isEngineRunning
            SetVehicleEngineOn(vehicle, isEngineRunning, false, true)
            
            if isEngineRunning then
                QBCore.Functions.Notify('Motor çalıştırıldı!', 'success')
            else
                QBCore.Functions.Notify('Motor durduruldu!', 'error')
            end
        else
            QBCore.Functions.Notify('Bu araç size ait değil!', 'error')
        end
    end, plate)
end

-- Kilit Kontrolü
function ToggleLock(vehicle, plate)
    QBCore.Functions.TriggerCallback('aendir:server:CheckVehicleOwnership', function(owned)
        if owned then
            isLocked = not isLocked
            SetVehicleDoorsLocked(vehicle, isLocked and 2 or 1)
            
            if isLocked then
                QBCore.Functions.Notify('Araç kilitlendi!', 'success')
            else
                QBCore.Functions.Notify('Araç kilitleri açıldı!', 'success')
            end
        else
            QBCore.Functions.Notify('Bu araç size ait değil!', 'error')
        end
    end, plate)
end

-- Hasar Sistemi
CreateThread(function()
    while true do
        Wait(1000)
        
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local plate = GetVehicleNumberPlateText(vehicle)
            
            -- Hasar Kontrolü
            local bodyHealth = GetVehicleBodyHealth(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            
            -- Hasar Kaydetme
            if bodyHealth < 1000.0 or engineHealth < 1000.0 then
                TriggerServerEvent('aendir:server:UpdateVehicleDamage', plate, bodyHealth, engineHealth)
            end
            
            -- Motor Durumu
            if engineHealth < 300.0 then
                SetVehicleEngineOn(vehicle, false, true, true)
                QBCore.Functions.Notify('Motor arızası!', 'error')
            end
        end
    end
end)

-- Yakıt Sistemi
CreateThread(function()
    while true do
        Wait(1000)
        
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local plate = GetVehicleNumberPlateText(vehicle)
            
            -- Yakıt Tüketimi
            local fuel = GetVehicleFuelLevel(vehicle)
            local speed = GetEntitySpeed(vehicle)
            local consumption = 0.0
            
            if speed > 0 then
                consumption = speed * 0.0001
            end
            
            local newFuel = fuel - consumption
            
            if newFuel < 0 then
                newFuel = 0
            end
            
            SetVehicleFuelLevel(vehicle, newFuel)
            
            -- Yakıt Kaydetme
            TriggerServerEvent('aendir:server:UpdateVehicleFuel', plate, newFuel)
            
            -- Yakıt Bittiğinde
            if newFuel <= 0 then
                SetVehicleEngineOn(vehicle, false, true, true)
                QBCore.Functions.Notify('Yakıtınız bitti!', 'error')
            end
        end
    end
end)

-- Takip Sistemi
CreateThread(function()
    while true do
        Wait(1000)
        
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local plate = GetVehicleNumberPlateText(vehicle)
            
            -- Takip Cihazı Kontrolü
            QBCore.Functions.TriggerCallback('aendir:server:CheckVehicleTracker', function(hasTracker)
                if hasTracker then
                    TriggerServerEvent('aendir:server:StartTracking', plate)
                end
            end, plate)
        end
    end
end)

-- Sigorta Talebi
RegisterNetEvent('aendir:client:ClaimInsurance', function(plate)
    TriggerServerEvent('aendir:server:ClaimInsurance', plate)
end)

-- Araç Çekme
RegisterNetEvent('aendir:client:ImpoundVehicle', function(plate)
    TriggerServerEvent('aendir:server:ImpoundVehicle', plate)
end)

-- Araç Satma
RegisterNetEvent('aendir:client:SellVehicle', function(plate)
    TriggerServerEvent('aendir:server:SellVehicle', plate)
end)

-- Modifiye Uygulama
RegisterNetEvent('aendir:client:ApplyModification', function(data)
    TriggerServerEvent('aendir:server:ApplyModification', data)
end) 