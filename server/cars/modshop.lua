local QBCore = exports['qb-core']:GetCoreObject()

-- Modifiye Uygulama
RegisterNetEvent('aendir:server:ApplyMod', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Para Kontrolü
    if Player.PlayerData.money['bank'] >= data.price then
        -- Para Kesme
        Player.Functions.RemoveMoney('bank', data.price)
        
        -- Modifiye Uygulama
        TriggerClientEvent('aendir:client:ApplyModification', src, {
            category = data.category,
            modIndex = data.modIndex
        })
        
        -- Bildirim
        TriggerClientEvent('QBCore:Notify', src, 'Modifiye başarıyla uygulandı!', 'success')
        
        -- Log
        TriggerEvent('aendir:server:LogModification', {
            player = Player.PlayerData.citizenid,
            category = data.category.name,
            modIndex = data.modIndex,
            price = data.price
        })
    else
        TriggerClientEvent('QBCore:Notify', src, 'Yeterli paranız yok!', 'error')
    end
end)

-- Modifiye Logları
RegisterNetEvent('aendir:server:LogModification', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Discord Webhook
    local webhook = Config.Logs.VehicleWebhook
    local message = string.format("**Araç Modifiye Logu**\nOyuncu: %s\nKategori: %s\nMod: %s\nFiyat: $%s",
        Player.PlayerData.citizenid,
        data.category,
        data.modIndex,
        data.price
    )
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Aendir Logs",
        content = message
    }), { ['Content-Type'] = 'application/json' })
    
    -- Veritabanı Log
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)',
        {'vehicle', Player.PlayerData.citizenid, 'modification', json.encode(data)})
end)

-- Araç Modifiye Kaydetme
RegisterNetEvent('aendir:server:SaveVehicleMods', function(plate, mods)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            -- Modifiye Kaydetme
            MySQL.update('UPDATE vehicles SET properties = ? WHERE plate = ?',
                {json.encode(mods), plate})
            
            -- Bildirim
            TriggerClientEvent('QBCore:Notify', src, 'Araç modifikasyonları kaydedildi!', 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Bu araç size ait değil!', 'error')
        end
    end)
end)

-- Araç Modifiye Yükleme
RegisterNetEvent('aendir:server:LoadVehicleMods', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            local vehicle = result[1]
            local mods = json.decode(vehicle.properties)
            
            -- Modifiye Yükleme
            TriggerClientEvent('aendir:client:LoadVehicleModifications', src, mods)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Bu araç size ait değil!', 'error')
        end
    end)
end) 