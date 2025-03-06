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

-- Araç Tamir
QBCore.Functions.CreateCallback('aendir:server:RepairVehicle', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    
    if Player.PlayerData.money.bank >= Config.RepairPrice then
        Player.Functions.RemoveMoney('bank', Config.RepairPrice)
        
        TriggerClientEvent('aendir:client:LogVehicleRepair', source, plate)
        cb(true)
    else
        cb(false)
    end
end)

-- Hasar Güncelleme
RegisterNetEvent('aendir:server:UpdateVehicleDamage', function(plate, bodyHealth, engineHealth)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.query('UPDATE vehicles SET damage = ? WHERE plate = ? AND owner = ?', {
        json.encode({
            body = bodyHealth,
            engine = engineHealth
        }),
        plate,
        Player.PlayerData.citizenid
    })
end)

-- Sigorta Talebi
RegisterNetEvent('aendir:server:ClaimInsurance', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ? AND insured = 1', {
        plate,
        Player.PlayerData.citizenid
    }, function(result)
        if result[1] then
            local damage = json.decode(result[1].damage)
            local repairCost = math.floor((1000 - damage.body) * 100 + (1000 - damage.engine) * 200)
            local insuranceAmount = math.floor(repairCost * Config.InsurancePrice)
            
            Player.Functions.AddMoney('bank', insuranceAmount)
            TriggerClientEvent('QBCore:Notify', src, string.format('Sigorta ödemesi: $%d', insuranceAmount), 'success')
            
            TriggerClientEvent('aendir:client:LogInsuranceClaim', src, plate, insuranceAmount)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Bu araç sigortalı değil!', 'error')
        end
    end)
end)

-- Tamir Logu
RegisterNetEvent('aendir:client:LogVehicleRepair', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)', {
        'vehicle_repair',
        Player.PlayerData.citizenid,
        'repair_vehicle',
        json.encode({
            plate = plate,
            price = Config.RepairPrice
        })
    })
end)

-- Sigorta Talebi Logu
RegisterNetEvent('aendir:client:LogInsuranceClaim', function(plate, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)', {
        'vehicle_insurance',
        Player.PlayerData.citizenid,
        'claim_insurance',
        json.encode({
            plate = plate,
            amount = amount
        })
    })
end) 