local QBCore = exports['qb-core']:GetCoreObject()

-- Eşya Kontrolü
QBCore.Functions.CreateCallback('aendir:server:CheckItem', function(source, cb, item)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if not Player then return cb(false) end
    
    local hasItem = Player.Functions.GetItemByName(item)
    cb(hasItem ~= nil)
end)

-- Takip Cihazı Takma
RegisterNetEvent('aendir:server:InstallTracker', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            -- Eşya Kontrolü
            local hasItem = Player.Functions.GetItemByName('tracker')
            if hasItem then
                -- Eşya Silme
                Player.Functions.RemoveItem('tracker', 1)
                
                -- Takip Cihazı Takma
                MySQL.update('UPDATE vehicles SET tracker = 1 WHERE plate = ?',
                    {plate})
                
                -- Bildirim
                TriggerClientEvent('QBCore:Notify', src, 'Takip cihazı takıldı!', 'success')
                
                -- Log
                TriggerEvent('aendir:server:LogTrackerInstall', {
                    player = Player.PlayerData.citizenid,
                    plate = plate
                })
            else
                TriggerClientEvent('QBCore:Notify', src, 'Takip cihazınız yok!', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'Bu araç size ait değil!', 'error')
        end
    end)
end)

-- Takip Cihazı Çıkarma
RegisterNetEvent('aendir:server:RemoveTracker', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            -- Takip Cihazı Çıkarma
            MySQL.update('UPDATE vehicles SET tracker = 0 WHERE plate = ?',
                {plate})
            
            -- Eşya Ekleme
            Player.Functions.AddItem('tracker', 1)
            
            -- Bildirim
            TriggerClientEvent('QBCore:Notify', src, 'Takip cihazı çıkarıldı!', 'success')
            
            -- Log
            TriggerEvent('aendir:server:LogTrackerRemove', {
                player = Player.PlayerData.citizenid,
                plate = plate
            })
        else
            TriggerClientEvent('QBCore:Notify', src, 'Bu araç size ait değil!', 'error')
        end
    end)
end)

-- Takip Cihazı Takma Logları
RegisterNetEvent('aendir:server:LogTrackerInstall', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Discord Webhook
    local webhook = Config.Logs.VehicleWebhook
    local message = string.format("**Takip Cihazı Takma Logu**\nOyuncu: %s\nPlaka: %s",
        Player.PlayerData.citizenid,
        data.plate
    )
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Aendir Logs",
        content = message
    }), { ['Content-Type'] = 'application/json' })
    
    -- Veritabanı Log
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)',
        {'vehicle', Player.PlayerData.citizenid, 'tracker_install', json.encode(data)})
end)

-- Takip Cihazı Çıkarma Logları
RegisterNetEvent('aendir:server:LogTrackerRemove', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Discord Webhook
    local webhook = Config.Logs.VehicleWebhook
    local message = string.format("**Takip Cihazı Çıkarma Logu**\nOyuncu: %s\nPlaka: %s",
        Player.PlayerData.citizenid,
        data.plate
    )
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Aendir Logs",
        content = message
    }), { ['Content-Type'] = 'application/json' })
    
    -- Veritabanı Log
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)',
        {'vehicle', Player.PlayerData.citizenid, 'tracker_remove', json.encode(data)})
end)

-- Takip Sistemi Başlatma
RegisterNetEvent('aendir:server:StartTracking', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] and result[1].tracker == 1 then
            -- Takip Başlatma
            TriggerClientEvent('aendir:client:StartTracking', src, plate)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Bu araçta takip cihazı yok!', 'error')
        end
    end)
end)

-- Takip Sistemi Durdurma
RegisterNetEvent('aendir:server:StopTracking', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] and result[1].tracker == 1 then
            -- Takip Durdurma
            TriggerClientEvent('aendir:client:StopTracking', src, plate)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Bu araçta takip cihazı yok!', 'error')
        end
    end)
end) 