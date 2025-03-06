local AendirCore = exports['aendir-core']:GetCoreObject()

-- Araç Oluşturma
RegisterNetEvent('aendir:server:CreateVehicle', function(data)
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Plaka kontrolü
    local plate = GeneratePlate()
    while AendirCore.Functions.GetData('vehicles', {plate = plate}) do
        plate = GeneratePlate()
    end
    
    -- Araç verilerini kaydet
    local vehicleData = {
        plate = plate,
        owner = Player.PlayerData.citizenid,
        model = data.model,
        price = data.price,
        stored = true,
        impounded = false,
        insured = false,
        tracker = false,
        fuel = Config.Vehicles.MaxFuel,
        damage = json.encode({body = 1000.0, engine = 1000.0}),
        properties = json.encode({})
    }
    
    AendirCore.Functions.SaveData('vehicles', vehicleData)
    AendirCore.Functions.LogAction('vehicle', Player.PlayerData.citizenid, 'create', vehicleData)
    
    TriggerClientEvent('aendir:client:ShowNotification', src, 'Araç başarıyla oluşturuldu', 'success')
end)

-- Araç Çıkarma
RegisterNetEvent('aendir:server:SpawnVehicle', function(plate)
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = Player.PlayerData.citizenid})
    if not vehicle then return end
    
    if vehicle.stored then
        -- Garaj konumunu al
        local garage = Config.Vehicles.Garages[1] -- Varsayılan garaj
        local coords = garage.spawn
        
        -- Aracı oluştur
        local model = GetHashKey(vehicle.model)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
        
        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleNumberPlateText(vehicle, plate)
        
        -- Araç özelliklerini ayarla
        local properties = json.decode(vehicle.properties)
        AendirCore.Functions.SetVehicleProperties(vehicle, properties)
        
        -- Veritabanını güncelle
        AendirCore.Functions.UpdateData('vehicles', {stored = false}, {plate = plate})
        AendirCore.Functions.LogAction('vehicle', Player.PlayerData.citizenid, 'spawn', {plate = plate})
        
        TriggerClientEvent('aendir:client:ShowNotification', src, 'Araç başarıyla çıkarıldı', 'success')
    end
end)

-- Araç Garaja Alma
RegisterNetEvent('aendir:server:StoreVehicle', function(plate)
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = Player.PlayerData.citizenid})
    if not vehicle then return end
    
    if not vehicle.stored then
        -- Araç özelliklerini kaydet
        local vehicleEntity = AendirCore.Functions.GetVehicleByPlate(plate)
        if vehicleEntity then
            local properties = AendirCore.Functions.GetVehicleProperties(vehicleEntity)
            AendirCore.Functions.UpdateData('vehicles', {
                stored = true,
                properties = json.encode(properties)
            }, {plate = plate})
            
            DeleteEntity(vehicleEntity)
            AendirCore.Functions.LogAction('vehicle', Player.PlayerData.citizenid, 'store', {plate = plate})
            
            TriggerClientEvent('aendir:client:ShowNotification', src, 'Araç başarıyla garaja alındı', 'success')
        end
    end
end)

-- Araç Çekme
RegisterNetEvent('aendir:server:RetrieveImpoundedVehicle', function(plate)
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = Player.PlayerData.citizenid})
    if not vehicle then return end
    
    if vehicle.impounded then
        if AendirCore.Functions.RemoveMoney(src, Config.Vehicles.ImpoundCost, 'bank') then
            -- Çekme noktasını al
            local impound = Config.Vehicles.Impound
            local coords = impound.spawn
            
            -- Aracı oluştur
            local model = GetHashKey(vehicle.model)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            
            local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)
            SetEntityAsMissionEntity(vehicle, true, true)
            SetVehicleNumberPlateText(vehicle, plate)
            
            -- Araç özelliklerini ayarla
            local properties = json.decode(vehicle.properties)
            AendirCore.Functions.SetVehicleProperties(vehicle, properties)
            
            -- Veritabanını güncelle
            AendirCore.Functions.UpdateData('vehicles', {impounded = false}, {plate = plate})
            AendirCore.Functions.LogAction('vehicle', Player.PlayerData.citizenid, 'retrieve', {plate = plate})
            
            TriggerClientEvent('aendir:client:ShowNotification', src, 'Araç başarıyla çekildi', 'success')
        else
            TriggerClientEvent('aendir:client:ShowNotification', src, 'Yeterli paranız yok!', 'error')
        end
    end
end)

-- Araç Sigortalama
RegisterNetEvent('aendir:server:InsureVehicle', function(plate)
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = Player.PlayerData.citizenid})
    if not vehicle then return end
    
    if not vehicle.insured then
        if AendirCore.Functions.RemoveMoney(src, Config.Vehicles.InsuranceCost, 'bank') then
            AendirCore.Functions.UpdateData('vehicles', {insured = true}, {plate = plate})
            AendirCore.Functions.LogAction('vehicle', Player.PlayerData.citizenid, 'insure', {plate = plate})
            
            TriggerClientEvent('aendir:client:ShowNotification', src, 'Araç başarıyla sigortalandı', 'success')
        else
            TriggerClientEvent('aendir:client:ShowNotification', src, 'Yeterli paranız yok!', 'error')
        end
    end
end)

-- Araç Modifiye
RegisterNetEvent('aendir:server:ApplyModification', function(plate, category)
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = Player.PlayerData.citizenid})
    if not vehicle then return end
    
    local price = Config.Vehicles.Prices.modshop[category]
    if AendirCore.Functions.RemoveMoney(src, price, 'bank') then
        local properties = json.decode(vehicle.properties)
        properties.mods = properties.mods or {}
        properties.mods[category] = (properties.mods[category] or 0) + 1
        
        AendirCore.Functions.UpdateData('vehicles', {
            properties = json.encode(properties)
        }, {plate = plate})
        
        AendirCore.Functions.LogAction('vehicle', Player.PlayerData.citizenid, 'modify', {plate = plate, category = category})
        
        TriggerClientEvent('aendir:client:ShowNotification', src, 'Modifiye başarıyla uygulandı', 'success')
    else
        TriggerClientEvent('aendir:client:ShowNotification', src, 'Yeterli paranız yok!', 'error')
    end
end)

-- Araç Hasar Güncelleme
RegisterNetEvent('aendir:server:UpdateVehicleDamage', function(plate, damage)
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = Player.PlayerData.citizenid})
    if not vehicle then return end
    
    local damageData = json.decode(vehicle.damage)
    damageData.body = damage
    damageData.engine = damage
    
    AendirCore.Functions.UpdateData('vehicles', {
        damage = json.encode(damageData)
    }, {plate = plate})
end)

-- Araç Konum Güncelleme
RegisterNetEvent('aendir:server:UpdateVehicleLocation', function(plate, coords)
    local src = source
    local Player = AendirCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local vehicle = AendirCore.Functions.GetData('vehicles', {plate = plate, owner = Player.PlayerData.citizenid})
    if not vehicle then return end
    
    if vehicle.tracker then
        TriggerClientEvent('aendir:client:UpdateVehicleBlip', -1, plate, coords)
    end
end)

-- Yardımcı Fonksiyonlar
function GeneratePlate()
    local plate = ""
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    for i = 1, 8 do
        local rand = math.random(1, #chars)
        plate = plate .. string.sub(chars, rand, rand)
    end
    
    return plate
end 