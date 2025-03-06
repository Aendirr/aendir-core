local QBCore = exports['qb-core']:GetCoreObject()

-- Polis Sayısını Kontrol Etme
QBCore.Functions.CreateCallback('aendir:server:CheckCops', function(source, cb)
    local cops = 0
    local players = QBCore.Functions.GetQBPlayers()
    
    for _, player in pairs(players) do
        if player.PlayerData.job.name == "police" then
            cops = cops + 1
        end
    end
    
    cb(cops)
end)

-- Hırsızlık Tamamlama
RegisterNetEvent('aendir:server:CompleteHeist', function(location)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Ödül Hesaplama
    local reward = math.random(location.reward.min, location.reward.max)
    
    -- Para Ödülü
    Player.Functions.AddMoney('cash', reward)
    
    -- Eşya Ödülleri
    for _, item in pairs(location.reward.items) do
        local amount = math.random(item.amount.min, item.amount.max)
        Player.Functions.AddItem(item.name, amount)
    end
    
    -- Bildirim
    TriggerClientEvent('QBCore:Notify', src, 'Soygun başarılı! Kazanç: $' .. reward, 'success')
    
    -- Log
    TriggerEvent('aendir:server:LogHeist', {
        player = Player.PlayerData.citizenid,
        location = location.name,
        reward = reward,
        items = location.reward.items
    })
end)

-- Polis Bildirimi
RegisterNetEvent('aendir:server:AlertPolice', function(location)
    local players = QBCore.Functions.GetQBPlayers()
    
    for _, player in pairs(players) do
        if player.PlayerData.job.name == "police" then
            TriggerClientEvent('aendir:client:PoliceAlert', player.PlayerData.source, {
                title = "Soygun Bildirimi",
                message = location.name .. " soygunu başladı!",
                coords = location.coords,
                type = location.type
            })
        end
    end
end)

-- Hırsızlık Logları
RegisterNetEvent('aendir:server:LogHeist', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Discord Webhook
    local webhook = Config.Logs.HeistWebhook
    local message = string.format("**Soygun Logu**\nOyuncu: %s\nLokasyon: %s\nKazanç: $%s\nEşyalar: %s",
        Player.PlayerData.citizenid,
        data.location,
        data.reward,
        json.encode(data.items)
    )
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Aendir Logs",
        content = message
    }), { ['Content-Type'] = 'application/json' })
    
    -- Veritabanı Log
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)',
        {'heist', Player.PlayerData.citizenid, 'complete', json.encode(data)})
end) 