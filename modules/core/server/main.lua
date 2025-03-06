local Aendir = exports['aendir-core']:GetCoreObject()

-- Oyuncu Yükleme
RegisterNetEvent('aendir:server:PlayerLoaded', function()
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Admin durumunu kontrol et
    TriggerClientEvent('aendir:client:SetAdmin', src, Player.PlayerData.admin or false)
    
    -- Karakter bilgilerini gönder
    TriggerClientEvent('aendir:client:SetCharacter', src, {
        name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
        job = Player.PlayerData.job,
        money = Player.PlayerData.money,
        items = Player.PlayerData.items
    })
end)

-- Oyuncu Çıkış
RegisterNetEvent('aendir:server:PlayerUnload', function()
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Oyuncu verilerini kaydet
    Player.Functions.Save()
end)

-- Whitelist Kontrolü
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    
    deferrals.defer()
    Wait(0)
    
    if Config.Whitelist.enabled then
        -- Discord kontrolü
        if Config.Whitelist.discordRequired then
            local hasDiscord = false
            for _, id in ipairs(identifiers) do
                if string.match(id, 'discord:') then
                    hasDiscord = true
                    break
                end
            end
            
            if not hasDiscord then
                deferrals.done('Discord hesabınız bağlı değil!')
                return
            end
        end
        
        -- Teamspeak kontrolü
        if Config.Whitelist.teamspeakRequired then
            local hasTeamspeak = false
            for _, id in ipairs(identifiers) do
                if string.match(id, 'teamspeak:') then
                    hasTeamspeak = true
                    break
                end
            end
            
            if not hasTeamspeak then
                deferrals.done('Teamspeak hesabınız bağlı değil!')
                return
            end
        end
        
        -- Whitelist kontrolü
        MySQL.query('SELECT * FROM whitelist WHERE identifier = ?', {
            identifiers[1]
        }, function(result)
            if #result == 0 then
                deferrals.done('Whitelist\'te kayıtlı değilsiniz!')
                return
            end
            
            deferrals.done()
        end)
    else
        deferrals.done()
    end
end)

-- Whitelist Başvuru
RegisterNetEvent('aendir:server:WhitelistApplication', function(data)
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if not Player then return end
    
    if not Config.Whitelist.applications.enabled then
        TriggerClientEvent('aendir:client:Notification', src, 'error', 'Whitelist başvuruları şu anda kapalı!')
        return
    end
    
    -- Discord'a başvuruyu gönder
    local webhook = Config.Whitelist.applications.webhook
    if webhook then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
            username = 'Whitelist Başvuru',
            embeds = {
                {
                    title = 'Yeni Whitelist Başvurusu',
                    description = string.format('**İsim:** %s\n**Yaş:** %s\n**Discord:** %s\n**Teamspeak:** %s\n**Deneyim:** %s', 
                        data.name, data.age, data.discord, data.teamspeak, data.experience),
                    color = 3447003
                }
            }
        }), { ['Content-Type'] = 'application/json' })
    end
    
    TriggerClientEvent('aendir:client:Notification', src, 'success', 'Whitelist başvurunuz alındı!')
end)

-- Admin Komutları
RegisterCommand('ahelp', function(source, args)
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if not Player or not Player.PlayerData.admin then
        TriggerClientEvent('aendir:client:Notification', src, 'error', 'Bu komutu kullanma yetkiniz yok!')
        return
    end
    
    local helpText = 'Admin Komutları:\n'
    for cmd, data in pairs(Config.Commands.admin.commands) do
        helpText = helpText .. string.format('/%s%s - %s\n', Config.Commands.admin.prefix, cmd, data.label)
    end
    
    TriggerClientEvent('aendir:client:Notification', src, 'info', helpText)
end)

-- Oyuncu Komutları
RegisterCommand('help', function(source, args)
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local helpText = 'Oyuncu Komutları:\n'
    helpText = helpText .. '/help - Bu menüyü göster\n'
    helpText = helpText .. '/duty - Vardiya başlat/bitir\n'
    helpText = helpText .. '/inventory - Envanterini aç\n'
    helpText = helpText .. '/phone - Telefonunu aç\n'
    helpText = helpText .. '/vehicle - Araç menüsünü aç\n'
    helpText = helpText .. '/house - Ev menüsünü aç\n'
    helpText = helpText .. '/bank - Banka menüsünü aç'
    
    TriggerClientEvent('aendir:client:Notification', src, 'info', helpText)
end)

-- Sunucu Başlangıç
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    
    print('^2[Aendir Core] ^7Sunucu başlatıldı!')
end)

-- Sunucu Durdurma
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    
    print('^1[Aendir Core] ^7Sunucu durduruldu!')
end) 