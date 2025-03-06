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

-- Modifiye Uygulama
QBCore.Functions.CreateCallback('aendir:server:ApplyModification', function(source, cb, plate, modType, modIndex, price)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    
    if Player.PlayerData.money.bank >= price then
        Player.Functions.RemoveMoney('bank', price)
        
        MySQL.query('UPDATE vehicles SET properties = JSON_SET(properties, ?, ?) WHERE plate = ?', {
            string.format('$.mods.%d', modType),
            modIndex,
            plate
        })
        
        TriggerClientEvent('aendir:client:LogModification', source, plate, modType, modIndex, price)
        cb(true)
    else
        cb(false)
    end
end)

-- Modifiye Logu
RegisterNetEvent('aendir:client:LogModification', function(plate, modType, modIndex, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local modName = GetModTextLabel(GetVehiclePedIsIn(GetPlayerPed(src), false), modType, modIndex)
    
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)', {
        'vehicle_modification',
        Player.PlayerData.citizenid,
        'apply_modification',
        json.encode({
            plate = plate,
            modType = modType,
            modIndex = modIndex,
            modName = modName,
            price = price
        })
    })
end) 