local Aendir = exports['aendir-core']:GetCoreObject()

-- Araç kayıt sistemi
RegisterNetEvent('aendir:server:RegisterVehicle', function(plate, model)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    if Config.VehicleFeatures.insurance.enabled then
        local insuranceCost = Config.VehicleFeatures.insurance.base_cost
        if Player.money.cash < insuranceCost then
            TriggerClientEvent('aendir:client:Notification', source, 'error', 'Yeterli paranız yok!')
            return
        end
        Player.money.cash = Player.money.cash - insuranceCost
    end

    local vehicle = {
        plate = plate,
        model = model,
        owner = Player.citizenid,
        stored = true,
        fuel = 100,
        body = 1000,
        engine = 1000,
        insurance = true,
        mods = {}
    }

    MySQL.insert('INSERT INTO vehicles (plate, model, owner, stored, fuel, body, engine, insurance, mods) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        plate,
        model,
        Player.citizenid,
        vehicle.stored,
        vehicle.fuel,
        vehicle.body,
        vehicle.engine,
        vehicle.insurance,
        json.encode(vehicle.mods)
    })

    Aendir.Vehicles[plate] = vehicle
    TriggerClientEvent('aendir:client:Notification', source, 'success', 'Araç başarıyla kaydedildi!')
end)

-- Araç modifikasyon sistemi
RegisterNetEvent('aendir:server:UpdateVehicleMods', function(plate, mods)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local vehicle = Aendir.Vehicles[plate]
    if not vehicle or vehicle.owner ~= Player.citizenid then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu araca erişiminiz yok!')
        return
    end

    vehicle.mods = mods
    MySQL.update('UPDATE vehicles SET mods = ? WHERE plate = ?', {
        json.encode(mods),
        plate
    })

    TriggerClientEvent('aendir:client:UpdateVehicleMods', source, plate, mods)
end)

-- Araç hasar sistemi
RegisterNetEvent('aendir:server:UpdateVehicleDamage', function(plate, body, engine)
    local source = source
    local vehicle = Aendir.Vehicles[plate]
    if not vehicle then return end

    vehicle.body = body
    vehicle.engine = engine

    MySQL.update('UPDATE vehicles SET body = ?, engine = ? WHERE plate = ?', {
        body,
        engine,
        plate
    })

    if vehicle.insurance and (body < 200 or engine < 200) then
        local repairCost = (1000 - body) * Config.VehicleFeatures.damage.repair_cost_multiplier
        local coverage = Config.VehicleFeatures.insurance.coverage_percentage
        local playerCost = repairCost * (1 - coverage/100)

        local Player = Aendir.GetPlayer(source)
        if Player then
            Player.money.cash = Player.money.cash - playerCost
            TriggerClientEvent('aendir:client:Notification', source, 'info', string.format('Sigorta kapsamında onarım ücreti: $%s', playerCost))
        end
    end
end)

-- Araç yakıt sistemi
RegisterNetEvent('aendir:server:UpdateVehicleFuel', function(plate, fuel)
    local source = source
    local vehicle = Aendir.Vehicles[plate]
    if not vehicle then return end

    vehicle.fuel = fuel
    MySQL.update('UPDATE vehicles SET fuel = ? WHERE plate = ?', {
        fuel,
        plate
    })
end)

-- Araç takip sistemi
RegisterNetEvent('aendir:server:InstallTracker', function(plate)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local vehicle = Aendir.Vehicles[plate]
    if not vehicle or vehicle.owner ~= Player.citizenid then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu araca erişiminiz yok!')
        return
    end

    if Player.money.cash < Config.VehicleFeatures.tracking.gps_cost then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Yeterli paranız yok!')
        return
    end

    Player.money.cash = Player.money.cash - Config.VehicleFeatures.tracking.gps_cost
    vehicle.tracker = true

    MySQL.update('UPDATE vehicles SET tracker = ? WHERE plate = ?', {
        true,
        plate
    })

    TriggerClientEvent('aendir:client:Notification', source, 'success', 'GPS takip sistemi başarıyla kuruldu!')
end)

-- Araç çıkarma sistemi
RegisterNetEvent('aendir:server:SpawnVehicle', function(plate)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local vehicle = Aendir.Vehicles[plate]
    if not vehicle or vehicle.owner ~= Player.citizenid then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu araca erişiminiz yok!')
        return
    end

    if not vehicle.stored then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu araç zaten dışarıda!')
        return
    end

    vehicle.stored = false
    MySQL.update('UPDATE vehicles SET stored = ? WHERE plate = ?', {
        false,
        plate
    })

    TriggerClientEvent('aendir:client:SpawnVehicle', source, plate, vehicle)
end)

-- Araç park etme sistemi
RegisterNetEvent('aendir:server:StoreVehicle', function(plate)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local vehicle = Aendir.Vehicles[plate]
    if not vehicle or vehicle.owner ~= Player.citizenid then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu araca erişiminiz yok!')
        return
    end

    if vehicle.stored then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu araç zaten garajda!')
        return
    end

    vehicle.stored = true
    MySQL.update('UPDATE vehicles SET stored = ? WHERE plate = ?', {
        true,
        plate
    })

    TriggerClientEvent('aendir:client:Notification', source, 'success', 'Araç başarıyla park edildi!')
end)

-- Araç silme sistemi
RegisterNetEvent('aendir:server:DeleteVehicle', function(plate)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local vehicle = Aendir.Vehicles[plate]
    if not vehicle or vehicle.owner ~= Player.citizenid then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu araca erişiminiz yok!')
        return
    end

    MySQL.query('DELETE FROM vehicles WHERE plate = ?', {plate})
    Aendir.Vehicles[plate] = nil

    TriggerClientEvent('aendir:client:Notification', source, 'success', 'Araç başarıyla silindi!')
end)

-- Araç listesi
RegisterNetEvent('aendir:server:GetVehicles', function()
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local vehicles = {}
    for plate, vehicle in pairs(Aendir.Vehicles) do
        if vehicle.owner == Player.citizenid then
            table.insert(vehicles, vehicle)
        end
    end

    TriggerClientEvent('aendir:client:ShowVehicles', source, vehicles)
end) 