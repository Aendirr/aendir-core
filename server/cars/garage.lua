local QBCore = exports['qb-core']:GetCoreObject()

-- Oyuncu Araçlarını Getirme
QBCore.Functions.CreateCallback('aendir:server:GetPlayerVehicles', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if not Player then return cb({}) end
    
    MySQL.query('SELECT * FROM vehicles WHERE owner = ?', {Player.PlayerData.citizenid}, function(result)
        cb(result)
    end)
end)

-- Araç Durumu Güncelleme
RegisterNetEvent('aendir:server:UpdateVehicleStatus', function(plate, stored)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            -- Durum Güncelleme
            MySQL.update('UPDATE vehicles SET stored = ? WHERE plate = ?',
                {stored, plate})
            
            -- Log
            TriggerEvent('aendir:server:LogVehicleStatus', {
                player = Player.PlayerData.citizenid,
                plate = plate,
                stored = stored
            })
        else
            TriggerClientEvent('QBCore:Notify', src, 'Bu araç size ait değil!', 'error')
        end
    end)
end)

-- Araç Durumu Logları
RegisterNetEvent('aendir:server:LogVehicleStatus', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Discord Webhook
    local webhook = Config.Logs.VehicleWebhook
    local message = string.format("**Araç Durumu Logu**\nOyuncu: %s\nPlaka: %s\nDurum: %s",
        Player.PlayerData.citizenid,
        data.plate,
        data.stored and "Garajda" or "Dışarıda"
    )
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Aendir Logs",
        content = message
    }), { ['Content-Type'] = 'application/json' })
    
    -- Veritabanı Log
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)',
        {'vehicle', Player.PlayerData.citizenid, 'status', json.encode(data)})
end)

-- Araç Sigorta
RegisterNetEvent('aendir:server:InsureVehicle', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            local vehicle = result[1]
            local price = math.floor(vehicle.price * 0.1) -- Sigorta fiyatı araç fiyatının %10'u
            
            -- Para Kontrolü
            if Player.PlayerData.money['bank'] >= price then
                -- Para Kesme
                Player.Functions.RemoveMoney('bank', price)
                
                -- Sigorta Güncelleme
                MySQL.update('UPDATE vehicles SET insured = 1 WHERE plate = ?',
                    {plate})
                
                -- Bildirim
                TriggerClientEvent('QBCore:Notify', src, 'Araç sigortalandı!', 'success')
                
                -- Log
                TriggerEvent('aendir:server:LogVehicleInsurance', {
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

-- Araç Sigorta Logları
RegisterNetEvent('aendir:server:LogVehicleInsurance', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Discord Webhook
    local webhook = Config.Logs.VehicleWebhook
    local message = string.format("**Araç Sigorta Logu**\nOyuncu: %s\nPlaka: %s\nFiyat: $%s",
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
        {'vehicle', Player.PlayerData.citizenid, 'insurance', json.encode(data)})
end)

-- Araç Çekme
RegisterNetEvent('aendir:server:ImpoundVehicle', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            local vehicle = result[1]
            local price = math.floor(vehicle.price * 0.05) -- Çekme fiyatı araç fiyatının %5'i
            
            -- Para Kontrolü
            if Player.PlayerData.money['bank'] >= price then
                -- Para Kesme
                Player.Functions.RemoveMoney('bank', price)
                
                -- Araç Durumu Güncelleme
                MySQL.update('UPDATE vehicles SET stored = 1 WHERE plate = ?',
                    {plate})
                
                -- Bildirim
                TriggerClientEvent('QBCore:Notify', src, 'Aracınız çekildi!', 'success')
                
                -- Log
                TriggerEvent('aendir:server:LogVehicleImpound', {
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

-- Araç Çekme Logları
RegisterNetEvent('aendir:server:LogVehicleImpound', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Discord Webhook
    local webhook = Config.Logs.VehicleWebhook
    local message = string.format("**Araç Çekme Logu**\nOyuncu: %s\nPlaka: %s\nFiyat: $%s",
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
        {'vehicle', Player.PlayerData.citizenid, 'impound', json.encode(data)})
end) 