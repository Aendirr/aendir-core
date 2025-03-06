-- Araçlar
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Araç Oluşturma
RegisterNetEvent('aendir:server:CreateVehicle', function(data)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        data.citizenid = player.citizenid
        AendirCore.Functions.CreateVehicle(data)
        TriggerClientEvent('aendir:client:Notify', source, 'Araç oluşturuldu!', 'success')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Araç Silme
RegisterNetEvent('aendir:server:DeleteVehicle', function(plate)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local vehicle = AendirCore.Functions.GetVehicle(plate)
        if vehicle and vehicle.citizenid == player.citizenid then
            AendirCore.Functions.DeleteVehicle(plate)
            TriggerClientEvent('aendir:client:Notify', source, 'Araç silindi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu araca erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Araç Güncelleme
RegisterNetEvent('aendir:server:UpdateVehicle', function(plate, data)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local vehicle = AendirCore.Functions.GetVehicle(plate)
        if vehicle and vehicle.citizenid == player.citizenid then
            AendirCore.Functions.UpdateVehicle(plate, data)
            TriggerClientEvent('aendir:client:Notify', source, 'Araç güncellendi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu araca erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Araç Çıkarma
RegisterNetEvent('aendir:server:SpawnVehicle', function(plate)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local vehicle = AendirCore.Functions.GetVehicle(plate)
        if vehicle and vehicle.citizenid == player.citizenid then
            if vehicle.stored then
                vehicle.stored = false
                AendirCore.Functions.UpdateVehicle(plate, vehicle)
                TriggerClientEvent('aendir:client:SpawnVehicle', source, vehicle)
                TriggerClientEvent('aendir:client:Notify', source, 'Araç çıkarıldı!', 'success')
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Bu araç zaten dışarıda!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu araca erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Araç Garaja Koyma
RegisterNetEvent('aendir:server:StoreVehicle', function(plate)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local vehicle = AendirCore.Functions.GetVehicle(plate)
        if vehicle and vehicle.citizenid == player.citizenid then
            if not vehicle.stored then
                vehicle.stored = true
                AendirCore.Functions.UpdateVehicle(plate, vehicle)
                TriggerClientEvent('aendir:client:DeleteVehicle', source, plate)
                TriggerClientEvent('aendir:client:Notify', source, 'Araç garaja koyuldu!', 'success')
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Bu araç zaten garajda!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu araca erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Araç Satma
RegisterNetEvent('aendir:server:SellVehicle', function(plate, target)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local vehicle = AendirCore.Functions.GetVehicle(plate)
        if vehicle and vehicle.citizenid == player.citizenid then
            local targetPlayer = AendirCore.Functions.GetPlayer(target)
            if targetPlayer then
                vehicle.citizenid = targetPlayer.citizenid
                AendirCore.Functions.UpdateVehicle(plate, vehicle)
                TriggerClientEvent('aendir:client:Notify', source, 'Araç satıldı!', 'success')
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Alıcı bulunamadı!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu araca erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Araç Sigorta
RegisterNetEvent('aendir:server:InsureVehicle', function(plate)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local vehicle = AendirCore.Functions.GetVehicle(plate)
        if vehicle and vehicle.citizenid == player.citizenid then
            if AendirCore.Functions.RemoveMoney(license, 'bank', Config.InsurancePrice) then
                vehicle.insured = true
                AendirCore.Functions.UpdateVehicle(plate, vehicle)
                TriggerClientEvent('aendir:client:Notify', source, 'Araç sigortalandı!', 'success')
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz para!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu araca erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Araç Modifiye
RegisterNetEvent('aendir:server:ModifyVehicle', function(plate, mods)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local vehicle = AendirCore.Functions.GetVehicle(plate)
        if vehicle and vehicle.citizenid == player.citizenid then
            if AendirCore.Functions.RemoveMoney(license, 'bank', Config.ModificationPrice) then
                vehicle.mods = mods
                AendirCore.Functions.UpdateVehicle(plate, vehicle)
                TriggerClientEvent('aendir:client:ApplyMods', source, plate, mods)
                TriggerClientEvent('aendir:client:Notify', source, 'Araç modifiye edildi!', 'success')
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz para!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu araca erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end) 