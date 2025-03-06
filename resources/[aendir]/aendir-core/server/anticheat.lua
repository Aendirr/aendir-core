-- Anti-Cheat Sistemi
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Değişkenler
local Violations = {}
local BannedPlayers = {}
local WhitelistedPlayers = {}

-- Fonksiyonlar
local function IsPlayerWhitelisted(source)
    local Player = AendirCore.Functions.GetPlayer(source)
    if Player then
        return WhitelistedPlayers[Player.PlayerData.citizenid] or false
    end
    return false
end

local function AddViolation(source, type, data)
    if not Violations[source] then
        Violations[source] = {}
    end
    
    table.insert(Violations[source], {
        type = type,
        data = data,
        timestamp = os.time()
    })
    
    if #Violations[source] >= 5 then
        BanPlayer(source, 'Anti-Cheat: Çok fazla ihlal')
    end
end

local function BanPlayer(source, reason)
    local Player = AendirCore.Functions.GetPlayer(source)
    if Player then
        local banData = {
            citizenid = Player.PlayerData.citizenid,
            name = GetPlayerName(source),
            reason = reason,
            admin = 'Anti-Cheat',
            expires = 0
        }
        
        MySQL.insert('INSERT INTO bans (citizenid, name, reason, admin, expires) VALUES (?, ?, ?, ?, ?)', {
            banData.citizenid,
            banData.name,
            banData.reason,
            banData.admin,
            banData.expires
        })
        
        BannedPlayers[Player.PlayerData.citizenid] = true
        DropPlayer(source, string.format('Anti-Cheat: %s', reason))
        TriggerEvent('aendir:server:Log', 'anticheat', 'Ban', string.format('%s yasaklandı. Sebep: %s', banData.name, reason))
    end
end

local function CheckHealth(source)
    local ped = GetPlayerPed(source)
    local health = GetEntityHealth(ped)
    
    if health > 200 then
        AddViolation(source, 'health', {
            current = health,
            max = 200
        })
    end
end

local function CheckArmor(source)
    local ped = GetPlayerPed(source)
    local armor = GetPedArmour(ped)
    
    if armor > 100 then
        AddViolation(source, 'armor', {
            current = armor,
            max = 100
        })
    end
end

local function CheckSpeed(source)
    local ped = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle ~= 0 then
        local speed = GetEntitySpeed(vehicle)
        local maxSpeed = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel')
        
        if speed > maxSpeed * 1.5 then
            AddViolation(source, 'speed', {
                current = speed,
                max = maxSpeed
            })
        end
    end
end

local function CheckTeleport(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local lastCoords = GetPlayerLastCoords(source)
    
    if lastCoords then
        local distance = #(coords - lastCoords)
        
        if distance > 100.0 then
            AddViolation(source, 'teleport', {
                from = lastCoords,
                to = coords,
                distance = distance
            })
        end
    end
    
    SetPlayerLastCoords(source, coords)
end

local function CheckWeapon(source)
    local ped = GetPlayerPed(source)
    local weapon = GetSelectedPedWeapon(ped)
    
    if weapon ~= GetHashKey('WEAPON_UNARMED') then
        local Player = AendirCore.Functions.GetPlayer(source)
        if Player then
            local hasWeapon = false
            
            for _, weaponData in pairs(Player.PlayerData.weapons) do
                if weaponData.name == weapon then
                    hasWeapon = true
                    break
                end
            end
            
            if not hasWeapon then
                AddViolation(source, 'weapon', {
                    weapon = weapon
                })
            end
        end
    end
end

local function CheckMoney(source)
    local Player = AendirCore.Functions.GetPlayer(source)
    if Player then
        local cash = Player.PlayerData.money.cash
        local bank = Player.PlayerData.money.bank
        local crypto = Player.PlayerData.money.crypto
        
        if cash > 1000000 or bank > 10000000 or crypto > 1000000 then
            AddViolation(source, 'money', {
                cash = cash,
                bank = bank,
                crypto = crypto
            })
        end
    end
end

local function CheckItems(source)
    local Player = AendirCore.Functions.GetPlayer(source)
    if Player then
        for _, item in pairs(Player.PlayerData.items) do
            if item.amount > 1000 then
                AddViolation(source, 'items', {
                    item = item.name,
                    amount = item.amount
                })
            end
        end
    end
end

local function CheckVehicle(source)
    local ped = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle ~= 0 then
        local Player = AendirCore.Functions.GetPlayer(source)
        if Player then
            local hasVehicle = false
            
            for _, vehicleData in pairs(Player.PlayerData.vehicles) do
                if vehicleData.plate == GetVehicleNumberPlateText(vehicle) then
                    hasVehicle = true
                    break
                end
            end
            
            if not hasVehicle then
                AddViolation(source, 'vehicle', {
                    plate = GetVehicleNumberPlateText(vehicle)
                })
            end
        end
    end
end

local function CheckProperty(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    
    for _, property in pairs(Config.Properties) do
        if #(coords - property.coords) < 10.0 then
            local Player = AendirCore.Functions.GetPlayer(source)
            if Player then
                local hasProperty = false
                
                for _, propertyData in pairs(Player.PlayerData.properties) do
                    if propertyData.id == property.id then
                        hasProperty = true
                        break
                    end
                end
                
                if not hasProperty then
                    AddViolation(source, 'property', {
                        id = property.id
                    })
                end
            end
        end
    end
end

local function CheckBusiness(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    
    for _, business in pairs(Config.Businesses) do
        if #(coords - business.coords) < 10.0 then
            local Player = AendirCore.Functions.GetPlayer(source)
            if Player then
                local hasBusiness = false
                
                for _, businessData in pairs(Player.PlayerData.businesses) do
                    if businessData.id == business.id then
                        hasBusiness = true
                        break
                    end
                end
                
                if not hasBusiness then
                    AddViolation(source, 'business', {
                        id = business.id
                    })
                end
            end
        end
    end
end

-- Events
RegisterNetEvent('aendir:server:CheckAntiCheat', function()
    local source = source
    
    if not IsPlayerWhitelisted(source) then
        CheckHealth(source)
        CheckArmor(source)
        CheckSpeed(source)
        CheckTeleport(source)
        CheckWeapon(source)
        CheckMoney(source)
        CheckItems(source)
        CheckVehicle(source)
        CheckProperty(source)
        CheckBusiness(source)
    end
end)

-- Threads
CreateThread(function()
    while true do
        Wait(1000) -- Her saniye
        
        for _, source in ipairs(GetPlayers()) do
            TriggerEvent('aendir:server:CheckAntiCheat', source)
        end
    end
end)

-- Komutlar
RegisterCommand('whitelist', function(source, args)
    if IsPlayerAdmin(source) then
        if args[1] then
            local target = tonumber(args[1])
            local Player = AendirCore.Functions.GetPlayer(target)
            
            if Player then
                WhitelistedPlayers[Player.PlayerData.citizenid] = true
                TriggerClientEvent('aendir:client:Notify', source, string.format('%s whitelist\'e eklendi!', GetPlayerName(target)), 'success')
                TriggerEvent('aendir:server:Log', 'anticheat', 'Whitelist', string.format('%s tarafından %s whitelist\'e eklendi.', GetPlayerName(source), GetPlayerName(target)))
            end
        end
    end
end, false)

RegisterCommand('unwhitelist', function(source, args)
    if IsPlayerAdmin(source) then
        if args[1] then
            local target = tonumber(args[1])
            local Player = AendirCore.Functions.GetPlayer(target)
            
            if Player then
                WhitelistedPlayers[Player.PlayerData.citizenid] = nil
                TriggerClientEvent('aendir:client:Notify', source, string.format('%s whitelist\'ten çıkarıldı!', GetPlayerName(target)), 'success')
                TriggerEvent('aendir:server:Log', 'anticheat', 'Unwhitelist', string.format('%s tarafından %s whitelist\'ten çıkarıldı.', GetPlayerName(source), GetPlayerName(target)))
            end
        end
    end
end, false)

RegisterCommand('violations', function(source, args)
    if IsPlayerAdmin(source) then
        if args[1] then
            local target = tonumber(args[1])
            
            if Violations[target] then
                for _, violation in ipairs(Violations[target]) do
                    TriggerClientEvent('aendir:client:Notify', source, string.format('İhlal: %s - %s', violation.type, json.encode(violation.data)), 'error')
                end
            end
        end
    end
end, false)

RegisterCommand('clearviolations', function(source, args)
    if IsPlayerAdmin(source) then
        if args[1] then
            local target = tonumber(args[1])
            
            if Violations[target] then
                Violations[target] = {}
                TriggerClientEvent('aendir:client:Notify', source, string.format('%s\'in ihlalleri temizlendi!', GetPlayerName(target)), 'success')
                TriggerEvent('aendir:server:Log', 'anticheat', 'ClearViolations', string.format('%s tarafından %s\'in ihlalleri temizlendi.', GetPlayerName(source), GetPlayerName(target)))
            end
        end
    end
end, false) 