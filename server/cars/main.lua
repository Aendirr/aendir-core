local QBCore = exports['qb-core']:GetCoreObject()

-- Araç Sahipliği Kontrolü
QBCore.Functions.CreateCallback('aendir:server:CheckVehicleOwnership', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if not Player then return cb(false) end
    
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        cb(result[1] ~= nil)
    end)
end)

-- Takip Cihazı Kontrolü
QBCore.Functions.CreateCallback('aendir:server:CheckVehicleTracker', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if not Player then return cb(false) end
    
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        cb(result[1] and result[1].tracker == 1)
    end)
end)

-- Araç Hasar Güncelleme
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

-- Araç Yakıt Güncelleme
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

-- Araç Sigorta Talebi
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

-- Araç Modifiye Uygulama
RegisterNetEvent('aendir:server:ApplyModification', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Araç Kontrolü
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result[1] then
            local vehicle = result[1]
            local properties = json.decode(vehicle.properties)
            properties.mods = properties.mods or {}
            properties.mods[data.category.id] = data.modIndex
            
            -- Modifiye Kaydetme
            MySQL.update('UPDATE vehicles SET properties = ? WHERE plate = ?',
                {json.encode(properties), plate})
            
            -- Bildirim
            TriggerClientEvent('QBCore:Notify', src, 'Modifiye uygulandı!', 'success')
            
            -- Log
            TriggerEvent('aendir:server:LogVehicleModification', {
                player = Player.PlayerData.citizenid,
                category = data.category.name,
                modIndex = data.modIndex,
                plate = plate
            })
        else
            TriggerClientEvent('QBCore:Notify', src, 'Bu araç size ait değil!', 'error')
        end
    end)
end) 