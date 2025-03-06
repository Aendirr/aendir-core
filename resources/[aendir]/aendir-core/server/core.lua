local AendirCore = {}
local Players = {}

-- Oyuncu Yönetimi
function AendirCore.Functions.GetPlayer(source)
    return Players[source]
end

function AendirCore.Functions.GetPlayerByCitizenId(citizenid)
    for _, player in pairs(Players) do
        if player.PlayerData.citizenid == citizenid then
            return player
        end
    end
    return nil
end

function AendirCore.Functions.GetPlayerByPhone(phone)
    for _, player in pairs(Players) do
        if player.PlayerData.charinfo.phone == phone then
            return player
        end
    end
    return nil
end

function AendirCore.Functions.GetPlayers()
    return Players
end

function AendirCore.Functions.GetPlayersByJob(job)
    local players = {}
    for _, player in pairs(Players) do
        if player.PlayerData.job.name == job then
            table.insert(players, player)
        end
    end
    return players
end

function AendirCore.Functions.GetPlayersByGang(gang)
    local players = {}
    for _, player in pairs(Players) do
        if player.PlayerData.gang.name == gang then
            table.insert(players, player)
        end
    end
    return players
end

-- Karakter Yönetimi
function AendirCore.Functions.CreateCharacter(source, data)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    Player.PlayerData.charinfo = data
    Players[source] = Player
    TriggerClientEvent('aendir:client:SetPlayerData', source, Player.PlayerData)
    return true
end

function AendirCore.Functions.UpdateCharacter(source, data)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    for key, value in pairs(data) do
        Player.PlayerData.charinfo[key] = value
    end
    
    Players[source] = Player
    TriggerClientEvent('aendir:client:SetPlayerData', source, Player.PlayerData)
    return true
end

function AendirCore.Functions.DeleteCharacter(source)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    Players[source] = nil
    TriggerClientEvent('aendir:client:OnPlayerUnload', source)
    return true
end

-- Meslek Yönetimi
function AendirCore.Functions.SetJob(source, job, grade)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    Player.PlayerData.job.name = job
    Player.PlayerData.job.grade = grade
    Players[source] = Player
    TriggerClientEvent('aendir:client:SetPlayerData', source, Player.PlayerData)
    return true
end

function AendirCore.Functions.GetJob(source)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return nil end
    
    return Player.PlayerData.job
end

-- Çete Yönetimi
function AendirCore.Functions.SetGang(source, gang, grade)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    Player.PlayerData.gang.name = gang
    Player.PlayerData.gang.grade = grade
    Players[source] = Player
    TriggerClientEvent('aendir:client:SetPlayerData', source, Player.PlayerData)
    return true
end

function AendirCore.Functions.GetGang(source)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return nil end
    
    return Player.PlayerData.gang
end

-- Para İşlemleri
function AendirCore.Functions.AddMoney(source, amount, moneyType)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    Player.PlayerData.money[moneyType or 'bank'] = Player.PlayerData.money[moneyType or 'bank'] + amount
    TriggerClientEvent('aendir:client:SetPlayerData', source, Player.PlayerData)
    return true
end

function AendirCore.Functions.RemoveMoney(source, amount, moneyType)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    if Player.PlayerData.money[moneyType or 'bank'] >= amount then
        Player.PlayerData.money[moneyType or 'bank'] = Player.PlayerData.money[moneyType or 'bank'] - amount
        TriggerClientEvent('aendir:client:SetPlayerData', source, Player.PlayerData)
        return true
    end
    return false
end

function AendirCore.Functions.GetMoney(source, moneyType)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return 0 end
    
    return Player.PlayerData.money[moneyType or 'bank']
end

-- Eşya Yönetimi
function AendirCore.Functions.AddItem(source, item, amount, slot)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    if not Player.PlayerData.items then
        Player.PlayerData.items = {}
    end
    
    table.insert(Player.PlayerData.items, {
        name = item,
        amount = amount,
        slot = slot or #Player.PlayerData.items + 1
    })
    
    Players[source] = Player
    TriggerClientEvent('aendir:client:SetPlayerData', source, Player.PlayerData)
    return true
end

function AendirCore.Functions.RemoveItem(source, item, amount)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    if not Player.PlayerData.items then return false end
    
    for i, itemData in ipairs(Player.PlayerData.items) do
        if itemData.name == item then
            if itemData.amount >= amount then
                itemData.amount = itemData.amount - amount
                if itemData.amount <= 0 then
                    table.remove(Player.PlayerData.items, i)
                end
                Players[source] = Player
                TriggerClientEvent('aendir:client:SetPlayerData', source, Player.PlayerData)
                return true
            end
            return false
        end
    end
    
    return false
end

function AendirCore.Functions.GetItem(source, item)
    local Player = AendirCore.Functions.GetPlayer(source)
    if not Player then return nil end
    
    if not Player.PlayerData.items then return nil end
    
    for _, itemData in ipairs(Player.PlayerData.items) do
        if itemData.name == item then
            return itemData
        end
    end
    
    return nil
end

-- İşlem Loglama
function AendirCore.Functions.LogAction(type, identifier, action, details)
    -- Discord Webhook
    local webhook = Config.Discord.Webhook
    if webhook and webhook ~= "" then
        local embed = {
            {
                title = Config.Discord.Title,
                description = string.format("**Tür:** %s\n**Oyuncu:** %s\n**İşlem:** %s", type, identifier, action),
                color = Config.Discord.Color,
                fields = {
                    {
                        name = "Detaylar",
                        value = json.encode(details, {indent = true})
                    }
                },
                footer = {
                    text = os.date("%Y-%m-%d %H:%M:%S")
                }
            }
        }
        
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
            username = "Aendir Core",
            embeds = embed
        }), { ['Content-Type'] = 'application/json' })
    end
    
    -- Veritabanı Log
    MySQL.insert('INSERT INTO logs (type, identifier, action, details) VALUES (?, ?, ?, ?)', {
        type,
        identifier,
        action,
        json.encode(details)
    })
end

-- Veritabanı İşlemleri
function AendirCore.Functions.SaveData(table, data)
    local query = 'INSERT INTO ' .. table .. ' SET '
    local params = {}
    
    for key, value in pairs(data) do
        query = query .. key .. ' = ?, '
        table.insert(params, value)
    end
    
    query = query:sub(1, -3)
    MySQL.insert(query, params)
end

function AendirCore.Functions.UpdateData(table, data, where)
    local query = 'UPDATE ' .. table .. ' SET '
    local params = {}
    
    for key, value in pairs(data) do
        query = query .. key .. ' = ?, '
        table.insert(params, value)
    end
    
    query = query:sub(1, -3) .. ' WHERE '
    
    for key, value in pairs(where) do
        query = query .. key .. ' = ? AND '
        table.insert(params, value)
    end
    
    query = query:sub(1, -5)
    MySQL.update(query, params)
end

function AendirCore.Functions.DeleteData(table, where)
    local query = 'DELETE FROM ' .. table .. ' WHERE '
    local params = {}
    
    for key, value in pairs(where) do
        query = query .. key .. ' = ? AND '
        table.insert(params, value)
    end
    
    query = query:sub(1, -5)
    MySQL.query(query, params)
end

function AendirCore.Functions.GetData(table, where)
    local query = 'SELECT * FROM ' .. table .. ' WHERE '
    local params = {}
    
    for key, value in pairs(where) do
        query = query .. key .. ' = ? AND '
        table.insert(params, value)
    end
    
    query = query:sub(1, -5)
    local result = MySQL.query.await(query, params)
    return result[1]
end

function AendirCore.Functions.GetAllData(table, where)
    local query = 'SELECT * FROM ' .. table
    local params = {}
    
    if where then
        query = query .. ' WHERE '
        for key, value in pairs(where) do
            query = query .. key .. ' = ? AND '
            table.insert(params, value)
        end
        query = query:sub(1, -5)
    end
    
    return MySQL.query.await(query, params)
end

-- Event Yönetimi
RegisterNetEvent('aendir:server:PlayerLoaded', function()
    local src = source
    local Player = {
        PlayerData = {
            citizenid = GetPlayerIdentifiers(src)[1],
            charinfo = {
                firstname = "İsim",
                lastname = "Soyisim",
                phone = "555-555-5555"
            },
            job = {
                name = Config.Player.DefaultJob,
                grade = 0
            },
            gang = {
                name = Config.Player.DefaultGang,
                grade = 0
            },
            money = {
                cash = Config.Player.StartingMoney.cash,
                bank = Config.Player.StartingMoney.bank
            },
            items = {}
        }
    }
    
    Players[src] = Player
    TriggerClientEvent('aendir:client:SetPlayerData', src, Player.PlayerData)
end)

RegisterNetEvent('aendir:server:PlayerUnloaded', function()
    local src = source
    Players[src] = nil
    TriggerClientEvent('aendir:client:OnPlayerUnload', src)
end)

-- Export Fonksiyonları
exports('GetCoreObject', function()
    return AendirCore
end) 