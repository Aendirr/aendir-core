local AendirCore = exports['aendir-core']:GetCoreObject()

-- Araç Listesi Getirme
function GetPlayerVehicles(citizenid)
    return AendirCore.Functions.GetData('vehicles', {owner = citizenid})
end

function GetImpoundedVehicles(citizenid)
    return AendirCore.Functions.GetData('vehicles', {owner = citizenid, impounded = true})
end

-- Araç Tamir
function RepairVehicle(plate, citizenid)
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = citizenid})
    if not vehicle then return false end
    
    if AendirCore.Functions.RemoveMoney(citizenid, Config.Vehicles.Prices.repair, 'bank') then
        AendirCore.Functions.UpdateData('vehicles', {
            damage = json.encode({body = 1000.0, engine = 1000.0})
        }, {plate = plate})
        
        AendirCore.Functions.LogAction('vehicle', citizenid, 'repair', {plate = plate})
        return true
    end
    
    return false
end

-- Araç Yakıt
function RefuelVehicle(plate, citizenid, amount)
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = citizenid})
    if not vehicle then return false end
    
    if AendirCore.Functions.RemoveMoney(citizenid, Config.Vehicles.Prices.refuel * amount, 'bank') then
        local newFuel = math.min(vehicle.fuel + amount, Config.Vehicles.MaxFuel)
        AendirCore.Functions.UpdateData('vehicles', {
            fuel = newFuel
        }, {plate = plate})
        
        AendirCore.Functions.LogAction('vehicle', citizenid, 'refuel', {plate = plate, amount = amount})
        return true
    end
    
    return false
end

-- Araç Kapı Kontrolü
function ToggleVehicleDoors(plate, citizenid, door)
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = citizenid})
    if not vehicle then return false end
    
    local vehicleEntity = AendirCore.Functions.GetVehicleByPlate(plate)
    if not vehicleEntity then return false end
    
    local doorAngle = GetVehicleDoorAngleRatio(vehicleEntity, door)
    if doorAngle > 0.0 then
        SetVehicleDoorShut(vehicleEntity, door, false)
    else
        SetVehicleDoorOpen(vehicleEntity, door, false, false)
    end
    
    return true
end

-- Araç Takip Sistemi
function ToggleVehicleTracker(plate, citizenid)
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = citizenid})
    if not vehicle then return false end
    
    AendirCore.Functions.UpdateData('vehicles', {
        tracker = not vehicle.tracker
    }, {plate = plate})
    
    AendirCore.Functions.LogAction('vehicle', citizenid, 'tracker', {plate = plate, enabled = not vehicle.tracker})
    return true
end

-- Araç Sigorta Sistemi
function InsureVehicle(plate, citizenid)
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = citizenid})
    if not vehicle then return false end
    
    if vehicle.insured then return false end
    
    if AendirCore.Functions.RemoveMoney(citizenid, Config.Vehicles.Prices.insurance, 'bank') then
        AendirCore.Functions.UpdateData('vehicles', {
            insured = true
        }, {plate = plate})
        
        AendirCore.Functions.LogAction('vehicle', citizenid, 'insure', {plate = plate})
        return true
    end
    
    return false
end

-- Araç Çekme Sistemi
function RetrieveImpoundedVehicle(plate, citizenid)
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = citizenid})
    if not vehicle then return false end
    
    if not vehicle.impounded then return false end
    
    if AendirCore.Functions.RemoveMoney(citizenid, Config.Vehicles.Prices.impound, 'bank') then
        AendirCore.Functions.UpdateData('vehicles', {
            impounded = false
        }, {plate = plate})
        
        AendirCore.Functions.LogAction('vehicle', citizenid, 'retrieve', {plate = plate})
        return true
    end
    
    return false
end

-- Araç Modifiye Sistemi
function ApplyModification(plate, citizenid, category)
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = citizenid})
    if not vehicle then return false end
    
    local price = Config.Vehicles.Prices.modshop[category]
    if not price then return false end
    
    if AendirCore.Functions.RemoveMoney(citizenid, price, 'bank') then
        local properties = json.decode(vehicle.properties)
        properties.mods = properties.mods or {}
        properties.mods[category] = (properties.mods[category] or 0) + 1
        
        AendirCore.Functions.UpdateData('vehicles', {
            properties = json.encode(properties)
        }, {plate = plate})
        
        AendirCore.Functions.LogAction('vehicle', citizenid, 'modify', {plate = plate, category = category})
        return true
    end
    
    return false
end

-- Eventler
RegisterNetEvent('aendir:server:GetPlayerVehicles', function()
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local vehicles = GetPlayerVehicles(Player.PlayerData.citizenid)
    TriggerClientEvent('aendir:client:OpenGarageMenu', src, vehicles)
end)

RegisterNetEvent('aendir:server:GetImpoundedVehicles', function()
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local vehicles = GetImpoundedVehicles(Player.PlayerData.citizenid)
    TriggerClientEvent('aendir:client:OpenImpoundMenu', src, vehicles)
end)

RegisterNetEvent('aendir:server:RepairVehicle', function(plate)
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if RepairVehicle(plate, Player.PlayerData.citizenid) then
        TriggerClientEvent('aendir:client:ShowNotification', src, 'Araç tamir edildi', 'success')
    else
        TriggerClientEvent('aendir:client:ShowNotification', src, 'Yeterli paranız yok!', 'error')
    end
end)

RegisterNetEvent('aendir:server:RefuelVehicle', function(plate, amount)
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if RefuelVehicle(plate, Player.PlayerData.citizenid, amount) then
        TriggerClientEvent('aendir:client:ShowNotification', src, 'Yakıt dolduruldu', 'success')
    else
        TriggerClientEvent('aendir:client:ShowNotification', src, 'Yeterli paranız yok!', 'error')
    end
end)

RegisterNetEvent('aendir:server:ToggleVehicleDoors', function(plate, door)
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if ToggleVehicleDoors(plate, Player.PlayerData.citizenid, door) then
        TriggerClientEvent('aendir:client:ShowNotification', src, 'Kapı durumu değiştirildi', 'success')
    else
        TriggerClientEvent('aendir:client:ShowNotification', src, 'Bir hata oluştu!', 'error')
    end
end)

RegisterNetEvent('aendir:server:ToggleVehicleTracker', function(plate)
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if ToggleVehicleTracker(plate, Player.PlayerData.citizenid) then
        TriggerClientEvent('aendir:client:ShowNotification', src, 'Takip cihazı durumu değiştirildi', 'success')
    else
        TriggerClientEvent('aendir:client:ShowNotification', src, 'Bir hata oluştu!', 'error')
    end
end) 