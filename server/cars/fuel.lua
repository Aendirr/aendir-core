local QBCore = exports['qb-core']:GetCoreObject()

-- Araç Sahipliği Kontrolü
QBCore.Functions.CreateCallback('aendir:server:CheckVehicleOwnership', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if not Player then return cb(false) end
    
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        cb(result[1] ~= nil)
    end)
end)

-- Yakıt Doldurma
RegisterNetEvent('aendir:server:RefuelVehicle', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            local vehicle = result[1]
            local price = 1000 -- Sabit yakıt fiyatı
            
            -- Para Kontrolü
            if Player.PlayerData.money['bank'] >= price then
                -- Para Kesme
                Player.Functions.RemoveMoney('bank', price)
                
                -- Yakıt Güncelleme
                MySQL.update('UPDATE vehicles SET properties = ? WHERE plate = ?',
                    {json.encode({fuel = 100.0}), plate})
                
                -- Bildirim
                TriggerClientEvent('QBCore:Notify', src, 'Yakıt dolduruldu!', 'success')
                
                -- Log
                TriggerEvent('aendir:server:LogVehicleRefuel', {
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

-- Yakıt Doldurma Logları
RegisterNetEvent('aendir:server:LogVehicleRefuel', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Discord Webhook
    local webhook = Config.Logs.VehicleWebhook
    local message = string.format("**Yakıt Doldurma Logu**\nOyuncu: %s\nPlaka: %s\nFiyat: $%s",
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
        {'vehicle', Player.PlayerData.citizenid, 'refuel', json.encode(data)})
end)

-- Yakıt Durumu Güncelleme
RegisterNetEvent('aendir:server:UpdateVehicleFuel', function(plate, fuel)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            local vehicle = result[1]
            local properties = json.decode(vehicle.properties)
            properties.fuel = fuel
            
            -- Yakıt Güncelleme
            MySQL.update('UPDATE vehicles SET properties = ? WHERE plate = ?',
                {json.encode(properties), plate})
        end
    end)
end)