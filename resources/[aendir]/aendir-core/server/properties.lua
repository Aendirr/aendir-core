-- Mülkler
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Mülk Oluşturma
RegisterNetEvent('aendir:server:CreateProperty', function(data)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        AendirCore.Functions.CreateProperty(data)
        TriggerClientEvent('aendir:client:Notify', source, 'Mülk oluşturuldu!', 'success')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Mülk Silme
RegisterNetEvent('aendir:server:DeleteProperty', function(id)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local property = AendirCore.Functions.GetProperty(id)
        if property and property.owner == player.citizenid then
            AendirCore.Functions.DeleteProperty(id)
            TriggerClientEvent('aendir:client:Notify', source, 'Mülk silindi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu mülke erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Mülk Güncelleme
RegisterNetEvent('aendir:server:UpdateProperty', function(id, data)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local property = AendirCore.Functions.GetProperty(id)
        if property and property.owner == player.citizenid then
            AendirCore.Functions.UpdateProperty(id, data)
            TriggerClientEvent('aendir:client:Notify', source, 'Mülk güncellendi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu mülke erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Mülk Satın Alma
RegisterNetEvent('aendir:server:BuyProperty', function(id)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local property = AendirCore.Functions.GetProperty(id)
        if property and not property.owner then
            if AendirCore.Functions.RemoveMoney(license, 'bank', property.price) then
                property.owner = player.citizenid
                AendirCore.Functions.UpdateProperty(id, property)
                TriggerClientEvent('aendir:client:Notify', source, 'Mülk satın alındı!', 'success')
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz para!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu mülk zaten satılmış!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Mülk Satma
RegisterNetEvent('aendir:server:SellProperty', function(id)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local property = AendirCore.Functions.GetProperty(id)
        if property and property.owner == player.citizenid then
            AendirCore.Functions.AddMoney(license, 'bank', property.price)
            property.owner = nil
            AendirCore.Functions.UpdateProperty(id, property)
            TriggerClientEvent('aendir:client:Notify', source, 'Mülk satıldı!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu mülke erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Mülk Kiralama
RegisterNetEvent('aendir:server:RentProperty', function(id)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local property = AendirCore.Functions.GetProperty(id)
        if property and not property.owner then
            if AendirCore.Functions.RemoveMoney(license, 'bank', property.rent) then
                property.renter = player.citizenid
                AendirCore.Functions.UpdateProperty(id, property)
                TriggerClientEvent('aendir:client:Notify', source, 'Mülk kiralandı!', 'success')
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz para!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu mülk kiralanamaz!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Mülk Kira İptali
RegisterNetEvent('aendir:server:CancelRent', function(id)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local property = AendirCore.Functions.GetProperty(id)
        if property and property.renter == player.citizenid then
            property.renter = nil
            AendirCore.Functions.UpdateProperty(id, property)
            TriggerClientEvent('aendir:client:Notify', source, 'Kira iptal edildi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu mülke erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Mülk Kira Ödemesi
CreateThread(function()
    while true do
        Wait(Config.RentInterval or 3600000) -- 1 saat
        
        local properties = MySQL.query.await('SELECT * FROM properties WHERE renter IS NOT NULL')
        for _, property in ipairs(properties) do
            local player = AendirCore.Functions.GetPlayer(property.renter)
            if player then
                if AendirCore.Functions.RemoveMoney(property.renter, 'bank', property.rent) then
                    TriggerClientEvent('aendir:client:Notify', AendirCore.Functions.GetPlayerByCitizenId(property.renter), 'Kira ödendi: $' .. property.rent, 'success')
                else
                    property.renter = nil
                    AendirCore.Functions.UpdateProperty(property.id, property)
                    TriggerClientEvent('aendir:client:Notify', AendirCore.Functions.GetPlayerByCitizenId(property.renter), 'Kira ödenemediği için kira iptal edildi!', 'error')
                end
            end
        end
    end
end) 