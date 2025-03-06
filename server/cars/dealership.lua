local QBCore = exports['qb-core']:GetCoreObject()

-- Araç Satın Alma
RegisterNetEvent('aendir:server:BuyVehicle', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Para Kontrolü
    if Player.PlayerData.money['bank'] >= data.price then
        -- Para Kesme
        Player.Functions.RemoveMoney('bank', data.price)
        
        -- Araç Plakası Oluşturma
        local plate = GeneratePlate()
        
        -- Araç Veritabanına Kaydetme
        MySQL.insert('INSERT INTO vehicles (owner, plate, model, stored, position, properties) VALUES (?, ?, ?, ?, ?, ?)',
            {
                Player.PlayerData.citizenid,
                plate,
                data.model,
                true,
                json.encode({x = 0, y = 0, z = 0, w = 0}),
                json.encode({
                    fuel = 100.0,
                    body = 1000.0,
                    engine = 1000.0,
                    mods = {}
                })
            }
        )
        
        -- Bildirim
        TriggerClientEvent('QBCore:Notify', src, 'Araç başarıyla satın alındı! Plaka: ' .. plate, 'success')
        
        -- Log
        TriggerEvent('aendir:server:LogVehiclePurchase', {
            player = Player.PlayerData.citizenid,
            model = data.model,
            price = data.price,
            plate = plate
        })
    else
        TriggerClientEvent('QBCore:Notify', src, 'Yeterli paranız yok!', 'error')
    end
end)

-- Plaka Oluşturma
function GeneratePlate()
    local plate = ""
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    for i = 1, 8 do
        local rand = math.random(1, #chars)
        plate = plate .. string.sub(chars, rand, rand)
    end
    
    return plate
end

-- Araç Satın Alma Logları
RegisterNetEvent('aendir:server:LogVehiclePurchase', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Discord Webhook
    local webhook = Config.Logs.VehicleWebhook
    local message = string.format("**Araç Satın Alma Logu**\nOyuncu: %s\nModel: %s\nFiyat: $%s\nPlaka: %s",
        Player.PlayerData.citizenid,
        data.model,
        data.price,
        data.plate
    )
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Aendir Logs",
        content = message
    }), { ['Content-Type'] = 'application/json' })
    
    -- Veritabanı Log
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)',
        {'vehicle', Player.PlayerData.citizenid, 'purchase', json.encode(data)})
end)

-- Araç Satma
RegisterNetEvent('aendir:server:SellVehicle', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            local vehicle = result[1]
            local price = math.floor(vehicle.price * 0.7) -- %70 geri ödeme
            
            -- Para Ekleme
            Player.Functions.AddMoney('bank', price)
            
            -- Araç Silme
            MySQL.query('DELETE FROM vehicles WHERE plate = ?', {plate})
            
            -- Bildirim
            TriggerClientEvent('QBCore:Notify', src, 'Araç başarıyla satıldı! Kazanç: $' .. price, 'success')
            
            -- Log
            TriggerEvent('aendir:server:LogVehicleSale', {
                player = Player.PlayerData.citizenid,
                model = vehicle.model,
                price = price,
                plate = plate
            })
        else
            TriggerClientEvent('QBCore:Notify', src, 'Bu araç size ait değil!', 'error')
        end
    end)
end)

-- Araç Satış Logları
RegisterNetEvent('aendir:server:LogVehicleSale', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Discord Webhook
    local webhook = Config.Logs.VehicleWebhook
    local message = string.format("**Araç Satış Logu**\nOyuncu: %s\nModel: %s\nKazanç: $%s\nPlaka: %s",
        Player.PlayerData.citizenid,
        data.model,
        data.price,
        data.plate
    )
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Aendir Logs",
        content = message
    }), { ['Content-Type'] = 'application/json' })
    
    -- Veritabanı Log
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)',
        {'vehicle', Player.PlayerData.citizenid, 'sale', json.encode(data)})
end) 