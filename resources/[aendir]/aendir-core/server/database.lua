local QBCore = exports['qb-core']:GetCoreObject()

-- Veritabanı Tablolarını Oluştur
CreateThread(function()
    for _, query in pairs(Config.Database.Tables) do
        MySQL.query(query)
    end
end)

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

-- Araç Takip Cihazı Kontrolü
QBCore.Functions.CreateCallback('aendir:server:CheckVehicleTracker', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    
    MySQL.query('SELECT * FROM vehicles WHERE plate = ? AND owner = ? AND tracker = 1', {
        plate,
        Player.PlayerData.citizenid
    }, function(result)
        cb(result[1] ~= nil)
    end)
end)

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

-- Log Kaydet
function LogAction(type, identifier, action, details)
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)', {
        type,
        identifier,
        action,
        json.encode(details)
    })
end

-- Discord Webhook
function SendDiscordWebhook(title, message)
    local embed = {
        {
            ["title"] = title,
            ["description"] = message,
            ["color"] = Config.Discord.Color,
            ["footer"] = {
                ["text"] = "Aendir Core - " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }
    
    PerformHttpRequest(Config.Discord.Webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.Discord.Title, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

-- Exports
exports('LogAction', LogAction)
exports('SendDiscordWebhook', SendDiscordWebhook) 