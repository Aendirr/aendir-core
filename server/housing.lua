local Aendir = exports['aendir-core']:GetCoreObject()

-- Ev satın alma
RegisterNetEvent('aendir:server:BuyHouse', function(houseId)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local house = Aendir.Houses[houseId]
    if not house then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Ev bulunamadı!')
        return
    end

    if house.owner then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu ev zaten satılmış!')
        return
    end

    if Player.money.bank < house.price then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Yeterli paranız yok!')
        return
    end

    Player.money.bank = Player.money.bank - house.price
    house.owner = Player.citizenid

    MySQL.update('UPDATE houses SET owner = ? WHERE id = ?', {
        Player.citizenid,
        houseId
    })

    TriggerClientEvent('aendir:client:Notification', source, 'success', 'Ev başarıyla satın alındı!')
end)

-- Ev satma
RegisterNetEvent('aendir:server:SellHouse', function(houseId)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local house = Aendir.Houses[houseId]
    if not house then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Ev bulunamadı!')
        return
    end

    if house.owner ~= Player.citizenid then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu ev size ait değil!')
        return
    end

    local sellPrice = math.floor(house.price * 0.7) -- %70 geri ödeme
    Player.money.bank = Player.money.bank + sellPrice
    house.owner = nil

    MySQL.update('UPDATE houses SET owner = NULL WHERE id = ?', {houseId})

    TriggerClientEvent('aendir:client:Notification', source, 'success', string.format('Ev başarıyla satıldı! $%s kazandınız.', sellPrice))
end)

-- Ev faturaları
CreateThread(function()
    while true do
        Wait(Config.HousingFeatures.utilities.payment_interval * 1000)
        
        for _, house in pairs(Aendir.Houses) do
            if house.owner then
                local Player = Aendir.GetPlayerByCitizenId(house.owner)
                if Player then
                    local electricityCost = Config.HousingFeatures.utilities.electricity_cost
                    local waterCost = Config.HousingFeatures.utilities.water_cost
                    local totalCost = electricityCost + waterCost

                    if Player.money.bank >= totalCost then
                        Player.money.bank = Player.money.bank - totalCost
                        TriggerClientEvent('aendir:client:Notification', Player.source, 'info', string.format('Ev faturaları ödendi: $%s', totalCost))
                    else
                        TriggerClientEvent('aendir:client:Notification', Player.source, 'error', 'Ev faturalarını ödeyemediniz!')
                    end
                end
            end
        end
    end
end)

-- Ev envanteri
RegisterNetEvent('aendir:server:StoreItem', function(houseId, item, amount)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local house = Aendir.Houses[houseId]
    if not house then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Ev bulunamadı!')
        return
    end

    if house.owner ~= Player.citizenid then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu ev size ait değil!')
        return
    end

    if #house.inventory >= Config.HousingFeatures.storage.max_storage then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Ev deposu dolu!')
        return
    end

    local itemData = Player.inventory[item]
    if not itemData or itemData.amount < amount then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Yeterli eşyanız yok!')
        return
    end

    Player.inventory[item].amount = Player.inventory[item].amount - amount
    table.insert(house.inventory, {item = item, amount = amount})

    MySQL.update('UPDATE houses SET inventory = ? WHERE id = ?', {
        json.encode(house.inventory),
        houseId
    })

    TriggerClientEvent('aendir:client:Notification', source, 'success', 'Eşya başarıyla depolandı!')
end)

RegisterNetEvent('aendir:server:RetrieveItem', function(houseId, itemIndex)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local house = Aendir.Houses[houseId]
    if not house then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Ev bulunamadı!')
        return
    end

    if house.owner ~= Player.citizenid then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu ev size ait değil!')
        return
    end

    local item = house.inventory[itemIndex]
    if not item then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Eşya bulunamadı!')
        return
    end

    if not Player.inventory[item.item] then
        Player.inventory[item.item] = {amount = 0}
    end

    Player.inventory[item.item].amount = Player.inventory[item.item].amount + item.amount
    table.remove(house.inventory, itemIndex)

    MySQL.update('UPDATE houses SET inventory = ? WHERE id = ?', {
        json.encode(house.inventory),
        houseId
    })

    TriggerClientEvent('aendir:client:Notification', source, 'success', 'Eşya başarıyla alındı!')
end)

-- Ev güvenlik sistemi
RegisterNetEvent('aendir:server:ToggleAlarm', function(houseId)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local house = Aendir.Houses[houseId]
    if not house then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Ev bulunamadı!')
        return
    end

    if house.owner ~= Player.citizenid then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu ev size ait değil!')
        return
    end

    house.alarm = not house.alarm
    MySQL.update('UPDATE houses SET alarm = ? WHERE id = ?', {
        house.alarm,
        houseId
    })

    TriggerClientEvent('aendir:client:Notification', source, 'success', house.alarm and 'Alarm sistemi aktif!' or 'Alarm sistemi devre dışı!')
end)

-- Ev kamera sistemi
RegisterNetEvent('aendir:server:ToggleCamera', function(houseId)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local house = Aendir.Houses[houseId]
    if not house then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Ev bulunamadı!')
        return
    end

    if house.owner ~= Player.citizenid then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu ev size ait değil!')
        return
    end

    house.camera = not house.camera
    MySQL.update('UPDATE houses SET camera = ? WHERE id = ?', {
        house.camera,
        houseId
    })

    TriggerClientEvent('aendir:client:Notification', source, 'success', house.camera and 'Kamera sistemi aktif!' or 'Kamera sistemi devre dışı!')
end)

-- Ev listesi
RegisterNetEvent('aendir:server:GetHouses', function()
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local houses = {}
    for id, house in pairs(Aendir.Houses) do
        if house.owner == Player.citizenid then
            table.insert(houses, {
                id = id,
                price = house.price,
                location = house.location,
                inventory = house.inventory,
                alarm = house.alarm,
                camera = house.camera
            })
        end
    end

    TriggerClientEvent('aendir:client:ShowHouses', source, houses)
end) 