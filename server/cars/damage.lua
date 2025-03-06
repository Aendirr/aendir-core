local QBCore = exports['qb-core']:GetCoreObject()

-- Tamir İşlemi
RegisterNetEvent('aendir:server:RepairVehicle', function(plate, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            -- Para Kontrolü
            if Player.PlayerData.money['bank'] >= price then
                -- Para Kesme
                Player.Functions.RemoveMoney('bank', price)
                
                -- Hasar Güncelleme
                MySQL.update('UPDATE vehicles SET properties = ? WHERE plate = ?',
                    {json.encode({body = 1000.0, engine = 1000.0}), plate})
                
                -- Bildirim
                TriggerClientEvent('QBCore:Notify', src, 'Araç tamir edildi!', 'success')
                
                -- Log
                TriggerEvent('aendir:server:LogVehicleRepair', {
                    player = Player.PlayerData.citizenid,
                    plate = plate,
                    price = price
                })
            else
                TriggerClientEvent('QBCore:Notify', src, 'Yeterli paranız yok!', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'Bu araç size ait değil!', 'error')
        end
    end)
end)

-- Tamir Logları
RegisterNetEvent('aendir:server:LogVehicleRepair', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Discord Webhook
    local webhook = Config.Logs.VehicleWebhook
    local message = string.format("**Araç Tamir Logu**\nOyuncu: %s\nPlaka: %s\nFiyat: $%s",
        Player.PlayerData.citizenid,
        data.plate,
        data.price
    )
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Aendir Logs",
        content = message
    }), { ['Content-Type'] = 'application/json' })
    
    -- Veritabanı Log
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)',
        {'vehicle', Player.PlayerData.citizenid, 'repair', json.encode(data)})
end)

-- Hasar Güncelleme
RegisterNetEvent('aendir:server:UpdateVehicleDamage', function(plate, bodyHealth, engineHealth)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            local vehicle = result[1]
            local properties = json.decode(vehicle.properties)
            properties.body = bodyHealth
            properties.engine = engineHealth
            
            -- Hasar Kaydetme
            MySQL.update('UPDATE vehicles SET properties = ? WHERE plate = ?',
                {json.encode(properties), plate})
        end
    end)
end)

-- Sigorta İşlemleri
RegisterNetEvent('aendir:server:ClaimInsurance', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            local vehicle = result[1]
            
            -- Sigorta Kontrolü
            if vehicle.insured then
                -- Hasar Güncelleme
                MySQL.update('UPDATE vehicles SET properties = ? WHERE plate = ?',
                    {json.encode({body = 1000.0, engine = 1000.0}), plate})
                
                -- Bildirim
                TriggerClientEvent('QBCore:Notify', src, 'Sigorta talebi onaylandı!', 'success')
                
                -- Log
                TriggerEvent('aendir:server:LogInsuranceClaim', {
                    player = Player.PlayerData.citizenid,
                    plate = plate
                })
            else
                TriggerClientEvent('QBCore:Notify', src, 'Bu araç sigortalı değil!', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'Bu araç size ait değil!', 'error')
        end
    end)
end)

-- Sigorta Logları
RegisterNetEvent('aendir:server:LogInsuranceClaim', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Discord Webhook
    local webhook = Config.Logs.VehicleWebhook
    local message = string.format("**Sigorta Talebi Logu**\nOyuncu: %s\nPlaka: %s",
        Player.PlayerData.citizenid,
        data.plate
    )
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Aendir Logs",
        content = message
    }), { ['Content-Type'] = 'application/json' })
    
    -- Veritabanı Log
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)',
        {'vehicle', Player.PlayerData.citizenid, 'insurance_claim', json.encode(data)})
end) 