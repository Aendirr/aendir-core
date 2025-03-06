local AendirCore = exports['aendir-core']:GetCoreObject()

-- Takip Sistemi
local trackedVehicles = {}
local updateInterval = 1000 -- 1 saniye

-- Takip Menüsü
function OpenTrackerMenu()
    local elements = {}
    
    for plate, data in pairs(trackedVehicles) do
        table.insert(elements, {
            label = string.format('Plaka: %s | Durum: %s', plate, data.active and 'Aktif' or 'Pasif'),
            value = plate
        })
    end
    
    if #elements == 0 then
        AendirCore.Functions.ShowNotification('Takip edilen araç yok', 'info')
        return
    end
    
    lib.registerContext({
        id = 'vehicle_tracker_menu',
        title = 'Araç Takip Sistemi',
        options = elements
    })
    
    lib.showContext('vehicle_tracker_menu')
end

-- Takip Menüsü Seçenekleri
lib.callback.register('aendir:client:TrackerMenuSelect', function(plate)
    if trackedVehicles[plate] then
        trackedVehicles[plate].active = not trackedVehicles[plate].active
        
        if trackedVehicles[plate].active then
            AendirCore.Functions.ShowNotification('Araç takibi başlatıldı: ' .. plate, 'success')
        else
            AendirCore.Functions.ShowNotification('Araç takibi durduruldu: ' .. plate, 'error')
        end
    end
end)

-- Takip Blip'leri
CreateThread(function()
    while true do
        Wait(updateInterval)
        
        for plate, data in pairs(trackedVehicles) do
            if data.active then
                local vehicle = GetVehicleByPlate(plate)
                if DoesEntityExist(vehicle) then
                    local coords = GetEntityCoords(vehicle)
                    
                    if not data.blip then
                        data.blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                        SetBlipSprite(data.blip, 1)
                        SetBlipDisplay(data.blip, 4)
                        SetBlipScale(data.blip, 0.8)
                        SetBlipColour(data.blip, 1)
                        SetBlipAsShortRange(data.blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString('Takip: ' .. plate)
                        EndTextCommandSetBlipName(data.blip)
                    else
                        SetBlipCoords(data.blip, coords.x, coords.y, coords.z)
                    end
                end
            end
        end
    end
end)

-- Takip Komutları
RegisterCommand('tracker', function()
    OpenTrackerMenu()
end)

RegisterCommand('track', function(source, args)
    if not args[1] then
        AendirCore.Functions.ShowNotification('Plaka belirtmelisiniz', 'error')
        return
    end
    
    local plate = args[1]
    local vehicle = GetVehicleByPlate(plate)
    
    if DoesEntityExist(vehicle) then
        if not trackedVehicles[plate] then
            trackedVehicles[plate] = {
                active = true,
                blip = nil
            }
            AendirCore.Functions.ShowNotification('Araç takibi başlatıldı: ' .. plate, 'success')
        else
            AendirCore.Functions.ShowNotification('Bu araç zaten takip ediliyor', 'error')
        end
    else
        AendirCore.Functions.ShowNotification('Araç bulunamadı', 'error')
    end
end)

RegisterCommand('untrack', function(source, args)
    if not args[1] then
        AendirCore.Functions.ShowNotification('Plaka belirtmelisiniz', 'error')
        return
    end
    
    local plate = args[1]
    
    if trackedVehicles[plate] then
        if trackedVehicles[plate].blip then
            RemoveBlip(trackedVehicles[plate].blip)
        end
        trackedVehicles[plate] = nil
        AendirCore.Functions.ShowNotification('Araç takibi durduruldu: ' .. plate, 'success')
    else
        AendirCore.Functions.ShowNotification('Bu araç takip edilmiyor', 'error')
    end
end)

-- Takip Durumu Senkronizasyonu
RegisterNetEvent('aendir:client:SyncVehicleTracker', function(plate, active)
    if active then
        if not trackedVehicles[plate] then
            trackedVehicles[plate] = {
                active = true,
                blip = nil
            }
        end
    else
        if trackedVehicles[plate] then
            if trackedVehicles[plate].blip then
                RemoveBlip(trackedVehicles[plate].blip)
            end
            trackedVehicles[plate] = nil
        end
    end
end)