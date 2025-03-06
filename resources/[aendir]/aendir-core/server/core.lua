local AendirCore = {}

-- Veritabanı Bağlantısı
MySQL.ready(function()
    print('^2[Aendir Core] ^7Veritabanı bağlantısı başarılı!')
end)

-- Oyuncu Verileri
local Players = {}

-- Oyuncu Oluşturma
function AendirCore.Functions.CreatePlayer(source, data)
    local citizenid = GenerateCitizenId()
    
    MySQL.insert('INSERT INTO players (citizenid, license, name, money, charinfo, job, gang, position, metadata) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        citizenid,
        GetPlayerIdentifier(source, 'license'),
        data.name,
        json.encode(Config.DefaultMoney),
        json.encode({
            firstname = data.firstname,
            lastname = data.lastname,
            birthdate = data.birthdate,
            gender = data.gender,
            nationality = data.nationality
        }),
        json.encode({
            name = Config.Player.DefaultJob,
            grade = { level = 0, name = 'Stajyer' }
        }),
        json.encode({
            name = Config.Player.DefaultGang,
            grade = { level = 0, name = 'Üye' }
        }),
        json.encode(Config.DefaultSpawn),
        json.encode({
            phone = GeneratePhoneNumber(),
            status = {},
            stress = 0,
            hunger = 100,
            thirst = 100,
            armor = 0,
            isdead = false,
            inlaststand = false,
            phone = GeneratePhoneNumber(),
            status = {},
            commandbinds = {},
            bloodtype = GenerateBloodType(),
            dealerrep = 0,
            craftingrep = 0,
            attachmentcraftingrep = 0,
            currentapartment = nil,
            jobrep = {
                ['tow'] = 0,
                ['trucker'] = 0,
                ['taxi'] = 0,
                ['hotdog'] = 0,
            },
            licences = {
                ['driver'] = true,
                ['business'] = false,
                ['weapon'] = false
            },
            "callsign" = "NO CALLSIGN",
            "crypto"] = "qbit",
            "phonedata"] = {
                SerialNumber = math.random(1000000, 9999999),
                InstalledApps = []
            }
        })
    }, function(id)
        if id then
            Players[source] = {
                source = source,
                citizenid = citizenid,
                PlayerData = {
                    citizenid = citizenid,
                    cid = id,
                    license = GetPlayerIdentifier(source, 'license'),
                    name = data.name,
                    money = Config.DefaultMoney,
                    charinfo = {
                        firstname = data.firstname,
                        lastname = data.lastname,
                        birthdate = data.birthdate,
                        gender = data.gender,
                        nationality = data.nationality
                    },
                    job = {
                        name = Config.Player.DefaultJob,
                        grade = { level = 0, name = 'Stajyer' }
                    },
                    gang = {
                        name = Config.Player.DefaultGang,
                        grade = { level = 0, name = 'Üye' }
                    },
                    position = Config.DefaultSpawn,
                    metadata = {
                        phone = GeneratePhoneNumber(),
                        status = {},
                        stress = 0,
                        hunger = 100,
                        thirst = 100,
                        armor = 0,
                        isdead = false,
                        inlaststand = false,
                        phone = GeneratePhoneNumber(),
                        status = {},
                        commandbinds = {},
                        bloodtype = GenerateBloodType(),
                        dealerrep = 0,
                        craftingrep = 0,
                        attachmentcraftingrep = 0,
                        currentapartment = nil,
                        jobrep = {
                            ['tow'] = 0,
                            ['trucker'] = 0,
                            ['taxi'] = 0,
                            ['hotdog'] = 0,
                        },
                        licences = {
                            ['driver'] = true,
                            ['business'] = false,
                            ['weapon'] = false
                        },
                        "callsign" = "NO CALLSIGN",
                        "crypto"] = "qbit",
                        "phonedata"] = {
                            SerialNumber = math.random(1000000, 9999999),
                            InstalledApps = []
                        }
                    }
                }
            }
            
            TriggerClientEvent('aendir:client:OnPlayerLoaded', source, Players[source].PlayerData)
        end
    end)
end

-- Oyuncu Verilerini Yükleme
function AendirCore.Functions.LoadPlayer(source)
    local license = GetPlayerIdentifier(source, 'license')
    
    MySQL.query('SELECT * FROM players WHERE license = ?', {license}, function(result)
        if result[1] then
            Players[source] = {
                source = source,
                citizenid = result[1].citizenid,
                PlayerData = {
                    citizenid = result[1].citizenid,
                    cid = result[1].id,
                    license = result[1].license,
                    name = result[1].name,
                    money = json.decode(result[1].money),
                    charinfo = json.decode(result[1].charinfo),
                    job = json.decode(result[1].job),
                    gang = json.decode(result[1].gang),
                    position = json.decode(result[1].position),
                    metadata = json.decode(result[1].metadata)
                }
            }
            
            TriggerClientEvent('aendir:client:OnPlayerLoaded', source, Players[source].PlayerData)
        else
            TriggerClientEvent('aendir:client:OnPlayerUnload', source)
        end
    end)
end

-- Oyuncu Verilerini Kaydetme
function AendirCore.Functions.SavePlayer(source)
    if Players[source] then
        MySQL.update('UPDATE players SET money = ?, charinfo = ?, job = ?, gang = ?, position = ?, metadata = ? WHERE citizenid = ?', {
            json.encode(Players[source].PlayerData.money),
            json.encode(Players[source].PlayerData.charinfo),
            json.encode(Players[source].PlayerData.job),
            json.encode(Players[source].PlayerData.gang),
            json.encode(Players[source].PlayerData.position),
            json.encode(Players[source].PlayerData.metadata),
            Players[source].PlayerData.citizenid
        })
    end
end

-- Oyuncu Verilerini Silme
function AendirCore.Functions.DeletePlayer(source)
    if Players[source] then
        MySQL.query('DELETE FROM players WHERE citizenid = ?', {Players[source].PlayerData.citizenid})
        Players[source] = nil
    end
end

-- Oyuncu Verilerini Güncelleme
function AendirCore.Functions.UpdatePlayer(source, key, value)
    if Players[source] then
        if key == 'money' then
            Players[source].PlayerData.money = value
        elseif key == 'charinfo' then
            Players[source].PlayerData.charinfo = value
        elseif key == 'job' then
            Players[source].PlayerData.job = value
        elseif key == 'gang' then
            Players[source].PlayerData.gang = value
        elseif key == 'position' then
            Players[source].PlayerData.position = value
        elseif key == 'metadata' then
            Players[source].PlayerData.metadata = value
        end
        
        AendirCore.Functions.SavePlayer(source)
    end
end

-- Para İşlemleri
function AendirCore.Functions.AddMoney(source, type, amount)
    if Players[source] then
        if type == 'cash' then
            Players[source].PlayerData.money.cash = Players[source].PlayerData.money.cash + amount
        elseif type == 'bank' then
            Players[source].PlayerData.money.bank = Players[source].PlayerData.money.bank + amount
        end
        
        AendirCore.Functions.UpdatePlayer(source, 'money', Players[source].PlayerData.money)
        TriggerClientEvent('aendir:client:OnMoneyChange', source, type, amount, 'add')
    end
end

function AendirCore.Functions.RemoveMoney(source, type, amount)
    if Players[source] then
        if type == 'cash' then
            if Players[source].PlayerData.money.cash >= amount then
                Players[source].PlayerData.money.cash = Players[source].PlayerData.money.cash - amount
            else
                return false
            end
        elseif type == 'bank' then
            if Players[source].PlayerData.money.bank >= amount then
                Players[source].PlayerData.money.bank = Players[source].PlayerData.money.bank - amount
            else
                return false
            end
        end
        
        AendirCore.Functions.UpdatePlayer(source, 'money', Players[source].PlayerData.money)
        TriggerClientEvent('aendir:client:OnMoneyChange', source, type, amount, 'remove')
        return true
    end
    return false
end

-- Meslek İşlemleri
function AendirCore.Functions.SetJob(source, job, grade)
    if Players[source] then
        Players[source].PlayerData.job = {
            name = job,
            grade = { level = grade, name = Config.Jobs[job].grades[tostring(grade)].name }
        }
        
        AendirCore.Functions.UpdatePlayer(source, 'job', Players[source].PlayerData.job)
        TriggerClientEvent('aendir:client:OnJobUpdate', source, Players[source].PlayerData.job)
    end
end

-- Çete İşlemleri
function AendirCore.Functions.SetGang(source, gang, grade)
    if Players[source] then
        Players[source].PlayerData.gang = {
            name = gang,
            grade = { level = grade, name = Config.Gangs[gang].grades[tostring(grade)].name }
        }
        
        AendirCore.Functions.UpdatePlayer(source, 'gang', Players[source].PlayerData.gang)
        TriggerClientEvent('aendir:client:OnGangUpdate', source, Players[source].PlayerData.gang)
    end
end

-- Eşya İşlemleri
function AendirCore.Functions.AddItem(source, item, amount, info)
    if Players[source] then
        MySQL.insert('INSERT INTO items (citizenid, name, amount, info) VALUES (?, ?, ?, ?)', {
            Players[source].PlayerData.citizenid,
            item,
            amount,
            json.encode(info or {})
        }, function(id)
            if id then
                TriggerClientEvent('aendir:client:OnItemAdd', source, item, amount, info)
            end
        end)
    end
end

function AendirCore.Functions.RemoveItem(source, item, amount)
    if Players[source] then
        MySQL.query('SELECT * FROM items WHERE citizenid = ? AND name = ?', {
            Players[source].PlayerData.citizenid,
            item
        }, function(result)
            if result[1] and result[1].amount >= amount then
                MySQL.update('UPDATE items SET amount = amount - ? WHERE id = ?', {
                    amount,
                    result[1].id
                })
                
                TriggerClientEvent('aendir:client:OnItemRemove', source, item, amount)
                return true
            end
            return false
        end)
    end
end

-- Yardımcı Fonksiyonlar
function GenerateCitizenId()
    local template = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local length = 10
    local result = ''
    
    for i = 1, length do
        local random = math.random(1, #template)
        result = result .. string.sub(template, random, random)
    end
    
    return result
end

function GeneratePhoneNumber()
    local template = '0123456789'
    local length = 10
    local result = ''
    
    for i = 1, length do
        local random = math.random(1, #template)
        result = result .. string.sub(template, random, random)
    end
    
    return result
end

function GenerateBloodType()
    local types = {'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'}
    return types[math.random(1, #types)]
end

-- Events
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    
    deferrals.defer()
    Wait(0)
    
    MySQL.query('SELECT * FROM players WHERE license = ?', {license}, function(result)
        if result[1] then
            deferrals.done()
        else
            deferrals.done('Sunucuya bağlanmak için bir karakter oluşturmalısınız!')
        end
    end)
end)

AddEventHandler('playerDropped', function()
    local source = source
    if Players[source] then
        AendirCore.Functions.SavePlayer(source)
        Players[source] = nil
    end
end)

-- Exports
exports('GetCoreObject', function()
    return AendirCore
end) 