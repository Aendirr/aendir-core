-- Whitelist Sistemi
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Değişkenler
local WhitelistedPlayers = {}
local PendingWhitelist = {}

-- Fonksiyonlar
local function IsPlayerWhitelisted(source)
    local Player = AendirCore.Functions.GetPlayer(source)
    if Player then
        return WhitelistedPlayers[Player.PlayerData.citizenid] or false
    end
    return false
end

local function IsPlayerPendingWhitelist(source)
    local Player = AendirCore.Functions.GetPlayer(source)
    if Player then
        return PendingWhitelist[Player.PlayerData.citizenid] or false
    end
    return false
end

local function AddToWhitelist(source)
    local Player = AendirCore.Functions.GetPlayer(source)
    if Player then
        WhitelistedPlayers[Player.PlayerData.citizenid] = true
        PendingWhitelist[Player.PlayerData.citizenid] = nil
        
        MySQL.insert('INSERT INTO whitelist (citizenid, name, added_by, added_at) VALUES (?, ?, ?, ?)', {
            Player.PlayerData.citizenid,
            GetPlayerName(source),
            'System',
            os.date('%Y-%m-%d %H:%M:%S')
        })
        
        TriggerEvent('aendir:server:Log', 'whitelist', 'Add', string.format('%s whitelist\'e eklendi.', GetPlayerName(source)))
    end
end

local function RemoveFromWhitelist(source)
    local Player = AendirCore.Functions.GetPlayer(source)
    if Player then
        WhitelistedPlayers[Player.PlayerData.citizenid] = nil
        
        MySQL.query('DELETE FROM whitelist WHERE citizenid = ?', {Player.PlayerData.citizenid})
        
        TriggerEvent('aendir:server:Log', 'whitelist', 'Remove', string.format('%s whitelist\'ten çıkarıldı.', GetPlayerName(source)))
    end
end

local function AddToPendingWhitelist(source)
    local Player = AendirCore.Functions.GetPlayer(source)
    if Player then
        PendingWhitelist[Player.PlayerData.citizenid] = true
        
        MySQL.insert('INSERT INTO pending_whitelist (citizenid, name, added_at) VALUES (?, ?, ?)', {
            Player.PlayerData.citizenid,
            GetPlayerName(source),
            os.date('%Y-%m-%d %H:%M:%S')
        })
        
        TriggerEvent('aendir:server:Log', 'whitelist', 'Pending', string.format('%s whitelist bekleme listesine eklendi.', GetPlayerName(source)))
    end
end

local function RemoveFromPendingWhitelist(source)
    local Player = AendirCore.Functions.GetPlayer(source)
    if Player then
        PendingWhitelist[Player.PlayerData.citizenid] = nil
        
        MySQL.query('DELETE FROM pending_whitelist WHERE citizenid = ?', {Player.PlayerData.citizenid})
        
        TriggerEvent('aendir:server:Log', 'whitelist', 'PendingRemove', string.format('%s whitelist bekleme listesinden çıkarıldı.', GetPlayerName(source)))
    end
end

-- Events
RegisterNetEvent('aendir:server:RequestWhitelist', function()
    local source = source
    
    if not IsPlayerWhitelisted(source) and not IsPlayerPendingWhitelist(source) then
        AddToPendingWhitelist(source)
        TriggerClientEvent('aendir:client:Notify', source, 'Whitelist talebiniz alındı! Lütfen yöneticilerin onayını bekleyin.', 'info')
    end
end)

RegisterNetEvent('aendir:server:AcceptWhitelist', function(target)
    local source = source
    
    if IsPlayerAdmin(source) then
        if IsPlayerPendingWhitelist(target) then
            AddToWhitelist(target)
            TriggerClientEvent('aendir:client:Notify', target, 'Whitelist talebiniz kabul edildi! Artık sunucuya girebilirsiniz.', 'success')
            TriggerClientEvent('aendir:client:Notify', source, string.format('%s\'in whitelist talebi kabul edildi!', GetPlayerName(target)), 'success')
        end
    end
end)

RegisterNetEvent('aendir:server:RejectWhitelist', function(target)
    local source = source
    
    if IsPlayerAdmin(source) then
        if IsPlayerPendingWhitelist(target) then
            RemoveFromPendingWhitelist(target)
            TriggerClientEvent('aendir:client:Notify', target, 'Whitelist talebiniz reddedildi! Lütfen yeni bir talep gönderin.', 'error')
            TriggerClientEvent('aendir:client:Notify', source, string.format('%s\'in whitelist talebi reddedildi!', GetPlayerName(target)), 'success')
        end
    end
end)

-- Komutlar
RegisterCommand('whitelist', function(source, args)
    if IsPlayerAdmin(source) then
        if args[1] then
            if args[1] == 'add' then
                if args[2] then
                    local target = tonumber(args[2])
                    local Player = AendirCore.Functions.GetPlayer(target)
                    
                    if Player then
                        AddToWhitelist(target)
                        TriggerClientEvent('aendir:client:Notify', source, string.format('%s whitelist\'e eklendi!', GetPlayerName(target)), 'success')
                    end
                end
            elseif args[1] == 'remove' then
                if args[2] then
                    local target = tonumber(args[2])
                    local Player = AendirCore.Functions.GetPlayer(target)
                    
                    if Player then
                        RemoveFromWhitelist(target)
                        TriggerClientEvent('aendir:client:Notify', source, string.format('%s whitelist\'ten çıkarıldı!', GetPlayerName(target)), 'success')
                    end
                end
            elseif args[1] == 'list' then
                MySQL.query('SELECT * FROM whitelist ORDER BY added_at DESC', {}, function(results)
                    if results then
                        TriggerClientEvent('aendir:client:Notify', source, 'Whitelist Listesi:', 'info')
                        for _, player in ipairs(results) do
                            TriggerClientEvent('aendir:client:Notify', source, string.format('%s - %s', player.name, player.citizenid), 'info')
                        end
                    end
                end)
            elseif args[1] == 'pending' then
                MySQL.query('SELECT * FROM pending_whitelist ORDER BY added_at DESC', {}, function(results)
                    if results then
                        TriggerClientEvent('aendir:client:Notify', source, 'Bekleyen Whitelist Talepleri:', 'info')
                        for _, player in ipairs(results) do
                            TriggerClientEvent('aendir:client:Notify', source, string.format('%s - %s', player.name, player.citizenid), 'info')
                        end
                    end
                end)
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Geçersiz whitelist komutu!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /whitelist [komut] [parametreler]', 'error')
        end
    end
end, false)

-- Threads
CreateThread(function()
    MySQL.query('SELECT * FROM whitelist', {}, function(results)
        if results then
            for _, player in ipairs(results) do
                WhitelistedPlayers[player.citizenid] = true
            end
        end
    end)
    
    MySQL.query('SELECT * FROM pending_whitelist', {}, function(results)
        if results then
            for _, player in ipairs(results) do
                PendingWhitelist[player.citizenid] = true
            end
        end
    end)
end) 