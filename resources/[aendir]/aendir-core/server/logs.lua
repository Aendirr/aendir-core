-- Loglama Sistemi
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Değişkenler
local LogTypes = {
    ['admin'] = true,
    ['player'] = true,
    ['chat'] = true,
    ['money'] = true,
    ['item'] = true,
    ['vehicle'] = true,
    ['property'] = true,
    ['business'] = true,
    ['weapon'] = true,
    ['error'] = true
}

-- Fonksiyonlar
local function GetLogColor(type)
    if type == 'admin' then
        return '^1' -- Kırmızı
    elseif type == 'player' then
        return '^2' -- Yeşil
    elseif type == 'chat' then
        return '^3' -- Sarı
    elseif type == 'money' then
        return '^4' -- Mavi
    elseif type == 'item' then
        return '^5' -- Turkuaz
    elseif type == 'vehicle' then
        return '^6' -- Pembe
    elseif type == 'property' then
        return '^7' -- Beyaz
    elseif type == 'business' then
        return '^8' -- Gri
    elseif type == 'weapon' then
        return '^9' -- Turuncu
    elseif type == 'error' then
        return '^1' -- Kırmızı
    else
        return '^7' -- Beyaz
    end
end

local function GetLogPrefix(type)
    if type == 'admin' then
        return '[ADMIN]'
    elseif type == 'player' then
        return '[PLAYER]'
    elseif type == 'chat' then
        return '[CHAT]'
    elseif type == 'money' then
        return '[MONEY]'
    elseif type == 'item' then
        return '[ITEM]'
    elseif type == 'vehicle' then
        return '[VEHICLE]'
    elseif type == 'property' then
        return '[PROPERTY]'
    elseif type == 'business' then
        return '[BUSINESS]'
    elseif type == 'weapon' then
        return '[WEAPON]'
    elseif type == 'error' then
        return '[ERROR]'
    else
        return '[UNKNOWN]'
    end
end

local function FormatLog(type, message)
    local color = GetLogColor(type)
    local prefix = GetLogPrefix(type)
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    return string.format('%s%s %s %s^7', color, timestamp, prefix, message)
end

local function SaveLog(type, message)
    if LogTypes[type] then
        local log = FormatLog(type, message)
        print(log)
        
        MySQL.insert('INSERT INTO logs (type, message, timestamp) VALUES (?, ?, ?)', {
            type,
            message,
            os.date('%Y-%m-%d %H:%M:%S')
        })
    end
end

-- Events
RegisterNetEvent('aendir:server:Log', function(type, action, message)
    SaveLog(type, string.format('%s: %s', action, message))
end)

-- Komutlar
RegisterCommand('logs', function(source, args)
    if IsPlayerAdmin(source) then
        if args[1] then
            if args[1] == 'clear' then
                MySQL.query('TRUNCATE TABLE logs')
                TriggerClientEvent('aendir:client:Notify', source, 'Loglar temizlendi!', 'success')
            elseif args[1] == 'show' then
                if args[2] then
                    MySQL.query('SELECT * FROM logs WHERE type = ? ORDER BY timestamp DESC LIMIT 100', {args[2]}, function(results)
                        if results then
                            for _, log in ipairs(results) do
                                TriggerClientEvent('aendir:client:Notify', source, string.format('%s: %s', log.type, log.message), 'info')
                            end
                        end
                    end)
                else
                    MySQL.query('SELECT * FROM logs ORDER BY timestamp DESC LIMIT 100', {}, function(results)
                        if results then
                            for _, log in ipairs(results) do
                                TriggerClientEvent('aendir:client:Notify', source, string.format('%s: %s', log.type, log.message), 'info')
                            end
                        end
                    end)
                end
            elseif args[1] == 'export' then
                MySQL.query('SELECT * FROM logs ORDER BY timestamp DESC', {}, function(results)
                    if results then
                        local file = io.open('logs.txt', 'w')
                        if file then
                            for _, log in ipairs(results) do
                                file:write(string.format('%s: %s\n', log.type, log.message))
                            end
                            file:close()
                            TriggerClientEvent('aendir:client:Notify', source, 'Loglar logs.txt dosyasına kaydedildi!', 'success')
                        end
                    end
                end)
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Geçersiz log komutu!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /logs [komut] [parametreler]', 'error')
        end
    end
end, false)

-- Threads
CreateThread(function()
    while true do
        Wait(3600000) -- Her saat
        MySQL.query('DELETE FROM logs WHERE timestamp < DATE_SUB(NOW(), INTERVAL 7 DAY)')
    end
end) 