-- Veritabanı
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Tablolar
MySQL.query([[
    CREATE TABLE IF NOT EXISTS players (
        id INT AUTO_INCREMENT PRIMARY KEY,
        citizenid VARCHAR(50) UNIQUE,
        license VARCHAR(50) UNIQUE,
        name VARCHAR(50),
        money JSON,
        job JSON,
        gang JSON,
        items JSON,
        position JSON,
        metadata JSON,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )
]])

MySQL.query([[
    CREATE TABLE IF NOT EXISTS characters (
        id INT AUTO_INCREMENT PRIMARY KEY,
        citizenid VARCHAR(50),
        model VARCHAR(50),
        components JSON,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (citizenid) REFERENCES players(citizenid) ON DELETE CASCADE
    )
]])

MySQL.query([[
    CREATE TABLE IF NOT EXISTS vehicles (
        id INT AUTO_INCREMENT PRIMARY KEY,
        citizenid VARCHAR(50),
        plate VARCHAR(8) UNIQUE,
        model VARCHAR(50),
        stored BOOLEAN DEFAULT TRUE,
        garage VARCHAR(50),
        fuel INT DEFAULT 100,
        body_health FLOAT DEFAULT 1000.0,
        engine_health FLOAT DEFAULT 1000.0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (citizenid) REFERENCES players(citizenid) ON DELETE CASCADE
    )
]])

MySQL.query([[
    CREATE TABLE IF NOT EXISTS properties (
        id INT AUTO_INCREMENT PRIMARY KEY,
        owner VARCHAR(50),
        label VARCHAR(50),
        price INT,
        type VARCHAR(50),
        position JSON,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (owner) REFERENCES players(citizenid) ON DELETE SET NULL
    )
]])

MySQL.query([[
    CREATE TABLE IF NOT EXISTS businesses (
        id INT AUTO_INCREMENT PRIMARY KEY,
        owner VARCHAR(50),
        label VARCHAR(50),
        price INT,
        type VARCHAR(50),
        position JSON,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (owner) REFERENCES players(citizenid) ON DELETE SET NULL
    )
]])

MySQL.query([[
    CREATE TABLE IF NOT EXISTS bans (
        id INT AUTO_INCREMENT PRIMARY KEY,
        license VARCHAR(50),
        name VARCHAR(50),
        reason TEXT,
        duration INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )
]])

-- Veritabanı Fonksiyonları
function AendirCore.Functions.GetPlayer(citizenid)
    local result = MySQL.single.await('SELECT * FROM players WHERE citizenid = ?', {citizenid})
    if result then
        result.money = json.decode(result.money)
        result.job = json.decode(result.job)
        result.gang = json.decode(result.gang)
        result.items = json.decode(result.items)
        result.position = json.decode(result.position)
        result.metadata = json.decode(result.metadata)
    end
    return result
end

function AendirCore.Functions.GetCharacter(citizenid)
    local result = MySQL.single.await('SELECT * FROM characters WHERE citizenid = ?', {citizenid})
    if result then
        result.components = json.decode(result.components)
    end
    return result
end

function AendirCore.Functions.GetVehicle(plate)
    local result = MySQL.single.await('SELECT * FROM vehicles WHERE plate = ?', {plate})
    if result then
        result.position = json.decode(result.position)
    end
    return result
end

function AendirCore.Functions.GetProperty(id)
    local result = MySQL.single.await('SELECT * FROM properties WHERE id = ?', {id})
    if result then
        result.position = json.decode(result.position)
    end
    return result
end

function AendirCore.Functions.GetBusiness(id)
    local result = MySQL.single.await('SELECT * FROM businesses WHERE id = ?', {id})
    if result then
        result.position = json.decode(result.position)
    end
    return result
end

function AendirCore.Functions.GetBan(license)
    return MySQL.single.await('SELECT * FROM bans WHERE license = ?', {license})
end

function AendirCore.Functions.CreatePlayer(data)
    MySQL.insert('INSERT INTO players (citizenid, license, name, money, job, gang, items, position, metadata) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        data.citizenid,
        data.license,
        data.name,
        json.encode(data.money),
        json.encode(data.job),
        json.encode(data.gang),
        json.encode(data.items),
        json.encode(data.position),
        json.encode(data.metadata)
    })
end

function AendirCore.Functions.CreateCharacter(data)
    MySQL.insert('INSERT INTO characters (citizenid, model, components) VALUES (?, ?, ?)', {
        data.citizenid,
        data.model,
        json.encode(data.components)
    })
end

function AendirCore.Functions.CreateVehicle(data)
    MySQL.insert('INSERT INTO vehicles (citizenid, plate, model, stored, garage, fuel, body_health, engine_health) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        data.citizenid,
        data.plate,
        data.model,
        data.stored,
        data.garage,
        data.fuel,
        data.body_health,
        data.engine_health
    })
end

function AendirCore.Functions.CreateProperty(data)
    MySQL.insert('INSERT INTO properties (owner, label, price, type, position) VALUES (?, ?, ?, ?, ?)', {
        data.owner,
        data.label,
        data.price,
        data.type,
        json.encode(data.position)
    })
end

function AendirCore.Functions.CreateBusiness(data)
    MySQL.insert('INSERT INTO businesses (owner, label, price, type, position) VALUES (?, ?, ?, ?, ?)', {
        data.owner,
        data.label,
        data.price,
        data.type,
        json.encode(data.position)
    })
end

function AendirCore.Functions.CreateBan(data)
    MySQL.insert('INSERT INTO bans (license, name, reason, duration) VALUES (?, ?, ?, ?)', {
        data.license,
        data.name,
        data.reason,
        data.duration
    })
end

function AendirCore.Functions.UpdatePlayer(citizenid, data)
    MySQL.update('UPDATE players SET money = ?, job = ?, gang = ?, items = ?, position = ?, metadata = ? WHERE citizenid = ?', {
        json.encode(data.money),
        json.encode(data.job),
        json.encode(data.gang),
        json.encode(data.items),
        json.encode(data.position),
        json.encode(data.metadata),
        citizenid
    })
end

function AendirCore.Functions.UpdateCharacter(citizenid, data)
    MySQL.update('UPDATE characters SET model = ?, components = ? WHERE citizenid = ?', {
        data.model,
        json.encode(data.components),
        citizenid
    })
end

function AendirCore.Functions.UpdateVehicle(plate, data)
    MySQL.update('UPDATE vehicles SET stored = ?, garage = ?, fuel = ?, body_health = ?, engine_health = ? WHERE plate = ?', {
        data.stored,
        data.garage,
        data.fuel,
        data.body_health,
        data.engine_health,
        plate
    })
end

function AendirCore.Functions.UpdateProperty(id, data)
    MySQL.update('UPDATE properties SET owner = ?, label = ?, price = ?, type = ?, position = ? WHERE id = ?', {
        data.owner,
        data.label,
        data.price,
        data.type,
        json.encode(data.position),
        id
    })
end

function AendirCore.Functions.UpdateBusiness(id, data)
    MySQL.update('UPDATE businesses SET owner = ?, label = ?, price = ?, type = ?, position = ? WHERE id = ?', {
        data.owner,
        data.label,
        data.price,
        data.type,
        json.encode(data.position),
        id
    })
end

function AendirCore.Functions.DeletePlayer(citizenid)
    MySQL.query('DELETE FROM players WHERE citizenid = ?', {citizenid})
end

function AendirCore.Functions.DeleteCharacter(citizenid)
    MySQL.query('DELETE FROM characters WHERE citizenid = ?', {citizenid})
end

function AendirCore.Functions.DeleteVehicle(plate)
    MySQL.query('DELETE FROM vehicles WHERE plate = ?', {plate})
end

function AendirCore.Functions.DeleteProperty(id)
    MySQL.query('DELETE FROM properties WHERE id = ?', {id})
end

function AendirCore.Functions.DeleteBusiness(id)
    MySQL.query('DELETE FROM businesses WHERE id = ?', {id})
end

function AendirCore.Functions.DeleteBan(license)
    MySQL.query('DELETE FROM bans WHERE license = ?', {license})
end 