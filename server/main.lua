local Aendir = {}
Aendir.Players = {}
Aendir.Businesses = {}
Aendir.Houses = {}
Aendir.Vehicles = {}
Aendir.Events = {}

-- Veritabanı bağlantısı
MySQL.ready(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS players (
            id INT AUTO_INCREMENT PRIMARY KEY,
            citizenid VARCHAR(50) UNIQUE,
            cid INT DEFAULT 1,
            license VARCHAR(255),
            name VARCHAR(255),
            money JSON,
            charinfo JSON,
            job JSON,
            gang JSON,
            position JSON,
            metadata JSON,
            inventory JSON,
            skills JSON,
            achievements JSON,
            quests JSON,
            vehicles JSON,
            last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS businesses (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(255),
            owner VARCHAR(50),
            employees JSON,
            inventory JSON,
            money JSON,
            settings JSON,
            last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS houses (
            id INT AUTO_INCREMENT PRIMARY KEY,
            owner VARCHAR(50),
            price INT,
            location JSON,
            inventory JSON,
            last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
    ]])
end)

-- Oyuncu oluşturma
function Aendir.CreatePlayer(source, data)
    local Player = {
        source = source,
        citizenid = data.citizenid,
        cid = data.cid,
        license = data.license,
        name = data.name,
        money = data.money or Config.StartingMoney,
        charinfo = data.charinfo or {},
        job = data.job or {name = "unemployed", label = "İşsiz", payment = 10},
        gang = data.gang or {name = "none", label = "Çete Yok", grade = {name = "none", level = 0}},
        position = data.position or Config.DefaultSpawn,
        metadata = data.metadata or {},
        inventory = data.inventory or {},
        skills = data.skills or Config.SkillXP,
        achievements = data.achievements or {},
        quests = data.quests or {
            daily = {},
            weekly = {},
            monthly = {}
        },
        vehicles = data.vehicles or {}
    }
    
    Aendir.Players[source] = Player
    return Player
end

-- Yetenek sistemi
function Aendir.AddSkillXP(source, skill, amount)
    local Player = Aendir.Players[source]
    if not Player then return end
    
    Player.skills[skill] = (Player.skills[skill] or 0) + amount
    if Player.skills[skill] >= Config.MaxSkillLevel * 100 then
        Player.skills[skill] = Config.MaxSkillLevel * 100
    end
    
    TriggerClientEvent('aendir:client:UpdateSkills', source, Player.skills)
    Aendir.SavePlayer(source)
end

-- Başarı sistemi
function Aendir.UnlockAchievement(source, achievement)
    local Player = Aendir.Players[source]
    if not Player then return end
    
    if not Player.achievements[achievement] then
        Player.achievements[achievement] = true
        Player.money.cash = Player.money.cash + Config.Achievements[achievement].reward
        
        TriggerClientEvent('aendir:client:UnlockAchievement', source, achievement)
        Aendir.SavePlayer(source)
    end
end

-- Görev sistemi
function Aendir.CompleteQuest(source, questType, questId)
    local Player = Aendir.Players[source]
    if not Player then return end
    
    if not Player.quests[questType][questId] then
        Player.quests[questType][questId] = true
        Player.money.cash = Player.money.cash + Config.Quests[questType][questId].reward
        
        TriggerClientEvent('aendir:client:CompleteQuest', source, questType, questId)
        Aendir.SavePlayer(source)
    end
end

-- İşletme sistemi
function Aendir.CreateBusiness(name, owner, price)
    local business = {
        name = name,
        owner = owner,
        employees = {},
        inventory = {},
        money = {cash = 0, bank = 0},
        settings = {}
    }
    
    MySQL.insert('INSERT INTO businesses (name, owner, employees, inventory, money, settings) VALUES (?, ?, ?, ?, ?, ?)', {
        name,
        owner,
        json.encode(business.employees),
        json.encode(business.inventory),
        json.encode(business.money),
        json.encode(business.settings)
    })
    
    Aendir.Businesses[name] = business
    return business
end

-- Ev sistemi
function Aendir.CreateHouse(location, price)
    local house = {
        owner = nil,
        price = price,
        location = location,
        inventory = {}
    }
    
    MySQL.insert('INSERT INTO houses (price, location, inventory) VALUES (?, ?, ?)', {
        price,
        json.encode(location),
        json.encode(house.inventory)
    })
    
    table.insert(Aendir.Houses, house)
    return house
end

-- Araç sistemi
function Aendir.RegisterVehicle(plate, model, owner)
    local vehicle = {
        plate = plate,
        model = model,
        owner = owner,
        stored = true,
        fuel = 100,
        body = 1000,
        engine = 1000
    }
    
    MySQL.insert('INSERT INTO vehicles (plate, model, owner, stored, fuel, body, engine) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        plate,
        model,
        owner,
        vehicle.stored,
        vehicle.fuel,
        vehicle.body,
        vehicle.engine
    })
    
    Aendir.Vehicles[plate] = vehicle
    return vehicle
end

-- Event sistemi
function Aendir.CreateEvent(type, data)
    local event = {
        type = type,
        data = data,
        participants = {},
        active = false
    }
    
    table.insert(Aendir.Events, event)
    return event
end

-- Ekonomi sistemi
function Aendir.UpdateEconomy()
    for _, Player in pairs(Aendir.Players) do
        -- Enflasyon uygula
        Player.money.cash = math.floor(Player.money.cash * (1 - Config.EconomySettings.inflation_rate))
        Player.money.bank = math.floor(Player.money.bank * (1 - Config.EconomySettings.inflation_rate))
    end
end

-- Event handlers
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    deferrals.defer()
    Wait(0)
    deferrals.update('Oyuncu bilgileri kontrol ediliyor...')
    
    local license = GetPlayerIdentifier(source, 'license')
    if not license then
        deferrals.done('Lisans bulunamadı!')
        return
    end
    
    if Config.EnableWhitelist then
        local group = MySQL.query.await('SELECT group FROM whitelist WHERE license = ?', {license})
        if not group or not Config.WhitelistGroups[group] then
            deferrals.done('Whitelist\'te bulunmuyorsunuz!')
            return
        end
    end
    
    deferrals.done()
end)

AddEventHandler('playerDropped', function()
    local source = source
    if Aendir.Players[source] then
        Aendir.SavePlayer(source)
        Aendir.Players[source] = nil
    end
end)

AddEventHandler('playerJoining', function()
    local source = source
    Aendir.LoadPlayer(source)
end)

-- Yeni komutlar
if Config.EnableCustomCommands then
    for cmd, desc in pairs(Config.CustomCommands) do
        RegisterCommand(cmd:sub(2), function(source, args)
            local Player = Aendir.Players[source]
            if not Player then return end
            
            if cmd == "/help" then
                TriggerClientEvent('aendir:client:ShowHelpMenu', source)
            elseif cmd == "/stats" then
                TriggerClientEvent('aendir:client:ShowStats', source)
            elseif cmd == "/skills" then
                TriggerClientEvent('aendir:client:ShowSkills', source)
            end
        end)
    end
end

-- Export framework
exports('GetPlayer', function(source)
    return Aendir.Players[source]
end)

exports('GetBusiness', function(name)
    return Aendir.Businesses[name]
end)

exports('GetHouse', function(id)
    return Aendir.Houses[id]
end)

exports('GetVehicle', function(plate)
    return Aendir.Vehicles[plate]
end)
