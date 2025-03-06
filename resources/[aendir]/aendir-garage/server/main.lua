local QBCore = exports['qb-core']:GetCoreObject()

-- Oyuncu Araçlarını Getir
QBCore.Functions.CreateCallback('aendir:server:GetPlayerVehicles', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    MySQL.query('SELECT * FROM vehicles WHERE owner = ?', {
        Player.PlayerData.citizenid
    }, function(result)
        cb(result)
    end)
end)

-- Araç Getir
QBCore.Functions.CreateCallback('aendir:server:GetVehicle', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {
        plate,
        Player.PlayerData.citizenid
    }, function(result)
        if result[1] then
            MySQL.query('UPDATE vehicles SET stored = 0 WHERE plate = ?', {plate})
            cb(true)
        else
            cb(false)
        end
    end)
end)

-- Araç Park Et
QBCore.Functions.CreateCallback('aendir:server:StoreVehicle', function(source, cb, plate, props)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {
        plate,
        Player.PlayerData.citizenid
    }, function(result)
        if result[1] then
            MySQL.query('UPDATE vehicles SET stored = 1, properties = ? WHERE plate = ?', {
                json.encode(props),
                plate
            })
            cb(true)
        else
            cb(false)
        end
    end)
end)

-- Çekilmiş Araçları Getir
QBCore.Functions.CreateCallback('aendir:server:GetImpoundedVehicles', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    MySQL.query('SELECT * FROM vehicles WHERE owner = ? AND impounded = 1', {
        Player.PlayerData.citizenid
    }, function(result)
        cb(result)
    end)
end)

-- Araç Çek
QBCore.Functions.CreateCallback('aendir:server:ImpoundVehicle', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    
    if Player.PlayerData.money.bank >= Config.Impound.price then
        Player.Functions.RemoveMoney('bank', Config.Impound.price)
        
        MySQL.query('UPDATE vehicles SET impounded = 0 WHERE plate = ? AND owner = ?', {
            plate,
            Player.PlayerData.citizenid
        })
        
        TriggerClientEvent('aendir:client:LogImpound', source, plate)
        cb(true)
    else
        cb(false)
    end
end)

-- Çekme Logu
RegisterNetEvent('aendir:client:LogImpound', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)', {
        'vehicle_impound',
        Player.PlayerData.citizenid,
        'impound_vehicle',
        json.encode({
            plate = plate,
            price = Config.Impound.price
        })
    })
end)

-- Araç Sigorta
RegisterNetEvent('aendir:server:InsureVehicle', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if Player.PlayerData.money.bank >= Config.Insurance.price then
        Player.Functions.RemoveMoney('bank', Config.Insurance.price)
        
        MySQL.query('UPDATE vehicles SET insured = 1 WHERE plate = ? AND owner = ?', {
            plate,
            Player.PlayerData.citizenid
        })
        
        TriggerClientEvent('aendir:client:LogInsurance', src, plate)
        TriggerClientEvent('QBCore:Notify', src, 'Aracınız sigortalandı!', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Yeterli paranız yok!', 'error')
    end
end)

-- Sigorta Logu
RegisterNetEvent('aendir:client:LogInsurance', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)', {
        'vehicle_insurance',
        Player.PlayerData.citizenid,
        'insure_vehicle',
        json.encode({
            plate = plate,
            price = Config.Insurance.price
        })
    })
end) 