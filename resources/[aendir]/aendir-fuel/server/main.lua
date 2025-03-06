local QBCore = exports['qb-core']:GetCoreObject()

-- Araç Sahipliği Kontrolü
QBCore.Functions.CreateCallback('aendir:server:CheckVehicleOwnership', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ?', {
        plate,
        Player.PlayerData.citizenid
    }, function(result)
        cb(result[1] ~= nil)
    end)
end)

-- Yakıt Doldurma
QBCore.Functions.CreateCallback('aendir:server:RefuelVehicle', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    
    if Player.PlayerData.money.bank >= Config.FuelPrice then
        Player.Functions.RemoveMoney('bank', Config.FuelPrice)
        
        TriggerClientEvent('aendir:client:LogVehicleRefuel', source, plate)
        cb(true)
    else
        cb(false)
    end
end)

-- Yakıt Güncelleme
RegisterNetEvent('aendir:server:UpdateVehicleFuel', function(plate, fuel)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.query('UPDATE vehicles SET fuel = ? WHERE plate = ? AND owner = ?', {
        fuel,
        plate,
        Player.PlayerData.citizenid
    })
end)

-- Yakıt Doldurma Logu
RegisterNetEvent('aendir:client:LogVehicleRefuel', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)', {
        'vehicle_refuel',
        Player.PlayerData.citizenid,
        'refuel_vehicle',
        json.encode({
            plate = plate,
            price = Config.FuelPrice
        })
    })
end) 