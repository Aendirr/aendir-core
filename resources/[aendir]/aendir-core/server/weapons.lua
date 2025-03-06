-- Silahlar
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Silah Oluşturma
RegisterNetEvent('aendir:server:CreateWeapon', function(data)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        AendirCore.Functions.AddItem(player.citizenid, data.name, 1, {
            serie = AendirCore.Functions.GenerateSerialNumber(),
            attachments = data.attachments or {}
        })
        TriggerClientEvent('aendir:client:Notify', source, 'Silah oluşturuldu!', 'success')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Silah Silme
RegisterNetEvent('aendir:server:DeleteWeapon', function(serie)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        for i, v in ipairs(player.items) do
            if v.info and v.info.serie == serie then
                AendirCore.Functions.RemoveItem(player.citizenid, v.name, 1)
                TriggerClientEvent('aendir:client:Notify', source, 'Silah silindi!', 'success')
                return
            end
        end
        TriggerClientEvent('aendir:client:Notify', source, 'Silah bulunamadı!', 'error')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Silah Güncelleme
RegisterNetEvent('aendir:server:UpdateWeapon', function(serie, data)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        for i, v in ipairs(player.items) do
            if v.info and v.info.serie == serie then
                v.info = data
                AendirCore.Functions.UpdatePlayer(player.citizenid, player)
                TriggerClientEvent('aendir:client:Notify', source, 'Silah güncellendi!', 'success')
                return
            end
        end
        TriggerClientEvent('aendir:client:Notify', source, 'Silah bulunamadı!', 'error')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Silah Kullanma
RegisterNetEvent('aendir:server:UseWeapon', function(serie)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        for i, v in ipairs(player.items) do
            if v.info and v.info.serie == serie then
                if Config.Weapons[v.name] then
                    TriggerClientEvent('aendir:client:GiveWeapon', source, v.name, v.info)
                    TriggerClientEvent('aendir:client:Notify', source, 'Silah kullanıldı!', 'success')
                else
                    TriggerClientEvent('aendir:client:Notify', source, 'Bu silah kullanılamaz!', 'error')
                end
                return
            end
        end
        TriggerClientEvent('aendir:client:Notify', source, 'Silah bulunamadı!', 'error')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Silah Transfer
RegisterNetEvent('aendir:server:TransferWeapon', function(serie, target)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local targetPlayer = AendirCore.Functions.GetPlayer(target)
        if targetPlayer then
            for i, v in ipairs(player.items) do
                if v.info and v.info.serie == serie then
                    if AendirCore.Functions.RemoveItem(player.citizenid, v.name, 1) then
                        AendirCore.Functions.AddItem(targetPlayer.citizenid, v.name, 1, v.info)
                        TriggerClientEvent('aendir:client:Notify', source, 'Silah transfer edildi!', 'success')
                    else
                        TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz silah!', 'error')
                    end
                    return
                end
            end
            TriggerClientEvent('aendir:client:Notify', source, 'Silah bulunamadı!', 'error')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Alıcı bulunamadı!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Silah Satma
RegisterNetEvent('aendir:server:SellWeapon', function(serie)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        for i, v in ipairs(player.items) do
            if v.info and v.info.serie == serie then
                if Config.Weapons[v.name] and Config.Weapons[v.name].price then
                    local price = Config.Weapons[v.name].price
                    if AendirCore.Functions.RemoveItem(player.citizenid, v.name, 1) then
                        AendirCore.Functions.AddMoney(player.citizenid, 'cash', price)
                        TriggerClientEvent('aendir:client:Notify', source, 'Silah satıldı: $' .. price, 'success')
                    else
                        TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz silah!', 'error')
                    end
                else
                    TriggerClientEvent('aendir:client:Notify', source, 'Bu silah satılamaz!', 'error')
                end
                return
            end
        end
        TriggerClientEvent('aendir:client:Notify', source, 'Silah bulunamadı!', 'error')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Silah Satın Alma
RegisterNetEvent('aendir:server:BuyWeapon', function(weapon)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        if Config.Weapons[weapon] and Config.Weapons[weapon].price then
            local price = Config.Weapons[weapon].price
            if AendirCore.Functions.RemoveMoney(player.citizenid, 'cash', price) then
                AendirCore.Functions.AddItem(player.citizenid, weapon, 1, {
                    serie = AendirCore.Functions.GenerateSerialNumber(),
                    attachments = {}
                })
                TriggerClientEvent('aendir:client:Notify', source, 'Silah satın alındı: $' .. price, 'success')
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz para!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu silah satın alınamaz!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Silah Mermi
RegisterNetEvent('aendir:server:AddAmmo', function(weapon, amount)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        if Config.Weapons[weapon] and Config.Weapons[weapon].ammo then
            local ammo = Config.Weapons[weapon].ammo
            if AendirCore.Functions.RemoveItem(player.citizenid, ammo, amount) then
                TriggerClientEvent('aendir:client:AddAmmo', source, weapon, amount)
                TriggerClientEvent('aendir:client:Notify', source, 'Mermi eklendi!', 'success')
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz mermi!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu silah için mermi bulunamadı!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end) 