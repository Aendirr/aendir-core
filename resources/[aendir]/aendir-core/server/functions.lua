-- Fonksiyonlar
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Oyuncu Verilerini Alma
function AendirCore.Functions.GetPlayer(source)
    local license = GetPlayerIdentifier(source, 'license')
    local citizenid = nil
    
    MySQL.query('SELECT citizenid FROM players WHERE license = ?', {license}, function(result)
        if result[1] then
            citizenid = result[1].citizenid
        end
    end)
    
    return citizenid
end

-- Oyuncu Verilerini Güncelleme
function AendirCore.Functions.UpdatePlayer(source, data)
    local citizenid = AendirCore.Functions.GetPlayer(source)
    if citizenid then
        MySQL.update('UPDATE players SET ? WHERE citizenid = ?', {
            json.encode(data),
            citizenid
        })
    end
end

-- Para İşlemleri
function AendirCore.Functions.AddMoney(citizenid, type, amount)
    local player = AendirCore.Functions.GetPlayer(citizenid)
    if player then
        if type == 'cash' then
            player.money.cash = player.money.cash + amount
        elseif type == 'bank' then
            player.money.bank = player.money.bank + amount
        elseif type == 'black' then
            player.money.black = player.money.black + amount
        end
        
        AendirCore.Functions.UpdatePlayer(citizenid, player)
        TriggerClientEvent('aendir:client:UpdateMoney', citizenid, player.money)
        return true
    end
    return false
end

function AendirCore.Functions.RemoveMoney(citizenid, type, amount)
    local player = AendirCore.Functions.GetPlayer(citizenid)
    if player then
        if type == 'cash' and player.money.cash >= amount then
            player.money.cash = player.money.cash - amount
        elseif type == 'bank' and player.money.bank >= amount then
            player.money.bank = player.money.bank - amount
        elseif type == 'black' and player.money.black >= amount then
            player.money.black = player.money.black - amount
        else
            return false
        end
        
        AendirCore.Functions.UpdatePlayer(citizenid, player)
        TriggerClientEvent('aendir:client:UpdateMoney', citizenid, player.money)
        return true
    end
    return false
end

-- Meslek İşlemleri
function AendirCore.Functions.SetJob(citizenid, job, grade)
    local player = AendirCore.Functions.GetPlayer(citizenid)
    if player then
        player.job.name = job
        player.job.grade = grade
        
        AendirCore.Functions.UpdatePlayer(citizenid, player)
        TriggerClientEvent('aendir:client:UpdateJob', citizenid, player.job)
        return true
    end
    return false
end

-- Çete İşlemleri
function AendirCore.Functions.SetGang(citizenid, gang, grade)
    local player = AendirCore.Functions.GetPlayer(citizenid)
    if player then
        player.gang.name = gang
        player.gang.grade = grade
        
        AendirCore.Functions.UpdatePlayer(citizenid, player)
        TriggerClientEvent('aendir:client:UpdateGang', citizenid, player.gang)
        return true
    end
    return false
end

-- Eşya İşlemleri
function AendirCore.Functions.AddItem(citizenid, item, amount)
    local player = AendirCore.Functions.GetPlayer(citizenid)
    if player then
        local found = false
        for i, v in ipairs(player.items) do
            if v.name == item then
                v.amount = v.amount + amount
                found = true
                break
            end
        end
        
        if not found then
            table.insert(player.items, {
                name = item,
                amount = amount,
                info = {}
            })
        end
        
        AendirCore.Functions.UpdatePlayer(citizenid, player)
        TriggerClientEvent('aendir:client:UpdateItems', citizenid, player.items)
        return true
    end
    return false
end

function AendirCore.Functions.RemoveItem(citizenid, item, amount)
    local player = AendirCore.Functions.GetPlayer(citizenid)
    if player then
        for i, v in ipairs(player.items) do
            if v.name == item then
                if v.amount >= amount then
                    v.amount = v.amount - amount
                    if v.amount <= 0 then
                        table.remove(player.items, i)
                    end
                    
                    AendirCore.Functions.UpdatePlayer(citizenid, player)
                    TriggerClientEvent('aendir:client:UpdateItems', citizenid, player.items)
                    return true
                end
                break
            end
        end
    end
    return false
end

-- Karakter İşlemleri
function AendirCore.Functions.CreateCharacter(data)
    local player = AendirCore.Functions.GetPlayer(data.citizenid)
    if player then
        AendirCore.Functions.CreateCharacter(data)
        return true
    end
    return false
end

function AendirCore.Functions.DeleteCharacter(citizenid)
    local player = AendirCore.Functions.GetPlayer(citizenid)
    if player then
        AendirCore.Functions.DeleteCharacter(citizenid)
        return true
    end
    return false
end

function AendirCore.Functions.UpdateCharacter(citizenid, data)
    local player = AendirCore.Functions.GetPlayer(citizenid)
    if player then
        AendirCore.Functions.UpdateCharacter(citizenid, data)
        return true
    end
    return false
end

function AendirCore.Functions.SelectCharacter(citizenid)
    local player = AendirCore.Functions.GetPlayer(citizenid)
    if player then
        local character = AendirCore.Functions.GetCharacter(citizenid)
        if character then
            return character
        end
    end
    return nil
end

-- Yardımcı Fonksiyonlar
function AendirCore.Functions.GenerateCitizenId()
    local template = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local length = 10
    local citizenid = ''
    
    for i = 1, length do
        local random = math.random(1, #template)
        citizenid = citizenid .. string.sub(template, random, random)
    end
    
    return citizenid
end

function AendirCore.Functions.IsPlayerOnline(citizenid)
    local players = GetPlayers()
    for _, player in ipairs(players) do
        local license = GetPlayerIdentifier(player, 'license')
        local playerData = AendirCore.Functions.GetPlayer(license)
        if playerData and playerData.citizenid == citizenid then
            return true
        end
    end
    return false
end

function AendirCore.Functions.GetPlayerByCitizenId(citizenid)
    local players = GetPlayers()
    for _, player in ipairs(players) do
        local license = GetPlayerIdentifier(player, 'license')
        local playerData = AendirCore.Functions.GetPlayer(license)
        if playerData and playerData.citizenid == citizenid then
            return player
        end
    end
    return nil
end

function AendirCore.Functions.GetPlayerByLicense(license)
    local players = GetPlayers()
    for _, player in ipairs(players) do
        if GetPlayerIdentifier(player, 'license') == license then
            return player
        end
    end
    return nil
end

function AendirCore.Functions.GetPlayerByPhone(phone)
    local players = GetPlayers()
    for _, player in ipairs(players) do
        local license = GetPlayerIdentifier(player, 'license')
        local playerData = AendirCore.Functions.GetPlayer(license)
        if playerData and playerData.metadata.phone == phone then
            return player
        end
    end
    return nil
end

function AendirCore.Functions.GetPlayerByRadio(channel)
    local players = GetPlayers()
    for _, player in ipairs(players) do
        local license = GetPlayerIdentifier(player, 'license')
        local playerData = AendirCore.Functions.GetPlayer(license)
        if playerData and playerData.metadata.radio == channel then
            return player
        end
    end
    return nil
end

-- Exports
exports('GetCoreObject', function()
    return AendirCore
end) 