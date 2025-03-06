local AendirCore = exports['aendir-core']:GetCoreObject()

-- Kapı Kontrolü
local function ToggleVehicleDoor(vehicle, door)
    if DoesEntityExist(vehicle) then
        if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
            SetVehicleDoorShut(vehicle, door, false)
            AendirCore.Functions.ShowNotification('Kapı kapatıldı', 'success')
        else
            SetVehicleDoorOpen(vehicle, door, false, false)
            AendirCore.Functions.ShowNotification('Kapı açıldı', 'success')
        end
    end
end

-- Kapı Kontrolü Thread
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            
            -- Sürücü Kapısı (F)
            if IsControlJustPressed(0, 23) then -- F tuşu
                ToggleVehicleDoor(vehicle, 0)
            end
            
            -- Yolcu Kapısı (G)
            if IsControlJustPressed(0, 47) then -- G tuşu
                ToggleVehicleDoor(vehicle, 1)
            end
            
            -- Arka Sol Kapı (H)
            if IsControlJustPressed(0, 74) then -- H tuşu
                ToggleVehicleDoor(vehicle, 2)
            end
            
            -- Arka Sağ Kapı (J)
            if IsControlJustPressed(0, 73) then -- J tuşu
                ToggleVehicleDoor(vehicle, 3)
            end
            
            -- Bagaj (K)
            if IsControlJustPressed(0, 311) then -- K tuşu
                ToggleVehicleDoor(vehicle, 5)
            end
        end
    end
end)

-- Kapı Durumu Senkronizasyonu
RegisterNetEvent('aendir:client:SyncVehicleDoors', function(plate, door, state)
    local vehicle = GetVehicleByPlate(plate)
    if DoesEntityExist(vehicle) then
        if state then
            SetVehicleDoorOpen(vehicle, door, false, false)
        else
            SetVehicleDoorShut(vehicle, door, false)
        end
    end
end)

-- Yardımcı Fonksiyonlar
function GetVehicleByPlate(plate)
    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in ipairs(vehicles) do
        if GetVehicleNumberPlateText(vehicle) == plate then
            return vehicle
        end
    end
    return nil
end 