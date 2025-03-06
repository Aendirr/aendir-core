local AendirCore = exports['aendir-core']:GetCoreObject()

-- HUD Değişkenleri
local showHUD = true
local showFuel = true
local showDamage = true
local showSpeed = true
local showRPM = true

-- HUD Çizimi
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(playerPed, false) and showHUD then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local coords = GetEntityCoords(vehicle)
            local speed = GetEntitySpeed(vehicle) * 3.6
            local rpm = GetVehicleCurrentRpm(vehicle)
            local fuel = GetVehicleFuelLevel(vehicle)
            local bodyHealth = GetVehicleBodyHealth(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            
            -- Yakıt Göstergesi
            if showFuel then
                DrawText2D(0.5, 0.95, string.format('Yakıt: %.1f%%', fuel), 0.4, 0.4, 255, 255, 255, 255)
            end
            
            -- Hasar Göstergesi
            if showDamage then
                DrawText2D(0.5, 0.92, string.format('Gövde: %.1f%% | Motor: %.1f%%', 
                    (bodyHealth / 1000.0) * 100, (engineHealth / 1000.0) * 100), 
                    0.4, 0.4, 255, 255, 255, 255)
            end
            
            -- Hız Göstergesi
            if showSpeed then
                DrawText2D(0.5, 0.89, string.format('Hız: %.0f km/s', speed), 
                    0.4, 0.4, 255, 255, 255, 255)
            end
            
            -- RPM Göstergesi
            if showRPM then
                DrawText2D(0.5, 0.86, string.format('RPM: %.0f%%', rpm * 100), 
                    0.4, 0.4, 255, 255, 255, 255)
            end
        end
    end
end)

-- Takip Sistemi
local trackedVehicles = {}

RegisterNetEvent('aendir:client:UpdateVehicleBlip', function(plate, coords)
    if not trackedVehicles[plate] then
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Takip: ' .. plate)
        EndTextCommandSetBlipName(blip)
        
        trackedVehicles[plate] = blip
    else
        SetBlipCoords(trackedVehicles[plate], coords.x, coords.y, coords.z)
    end
end)

RegisterNetEvent('aendir:client:RemoveVehicleBlip', function(plate)
    if trackedVehicles[plate] then
        RemoveBlip(trackedVehicles[plate])
        trackedVehicles[plate] = nil
    end
end)

-- Yardımcı Fonksiyonlar
function DrawText2D(x, y, text, scale_x, scale_y, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(scale_x, scale_y)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- HUD Kontrolleri
RegisterCommand('togglehud', function()
    showHUD = not showHUD
    AendirCore.Functions.ShowNotification(showHUD and 'HUD açıldı' or 'HUD kapatıldı', 'info')
end)

RegisterCommand('togglefuel', function()
    showFuel = not showFuel
    AendirCore.Functions.ShowNotification(showFuel and 'Yakıt göstergesi açıldı' or 'Yakıt göstergesi kapatıldı', 'info')
end)

RegisterCommand('toggledamage', function()
    showDamage = not showDamage
    AendirCore.Functions.ShowNotification(showDamage and 'Hasar göstergesi açıldı' or 'Hasar göstergesi kapatıldı', 'info')
end)

RegisterCommand('togglespeed', function()
    showSpeed = not showSpeed
    AendirCore.Functions.ShowNotification(showSpeed and 'Hız göstergesi açıldı' or 'Hız göstergesi kapatıldı', 'info')
end)

RegisterCommand('togglerpm', function()
    showRPM = not showRPM
    AendirCore.Functions.ShowNotification(showRPM and 'RPM göstergesi açıldı' or 'RPM göstergesi kapatıldı', 'info')
end) 