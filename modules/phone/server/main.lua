local Aendir = exports['aendir-core']:GetCoreObject()

-- Telefon numarası oluşturma
local function GeneratePhoneNumber()
    local number = "05"
    for i = 1, 9 do
        number = number .. math.random(0, 9)
    end
    return number
end

-- SIM kart satın alma
RegisterNetEvent('aendir:server:BuySimCard', function()
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if Player.PlayerData.money.cash >= Config.SimCardPrice then
        local phoneNumber = GeneratePhoneNumber()
        
        Player.Functions.RemoveMoney('cash', Config.SimCardPrice)
        Player.Functions.AddItem('sim_card', 1, false, {
            phoneNumber = phoneNumber
        })
        
        TriggerClientEvent('aendir:client:Notification', src, 'success', 'SIM kart satın aldınız!')
        TriggerClientEvent('aendir:client:SetPhoneNumber', src, phoneNumber)
    else
        TriggerClientEvent('aendir:client:Notification', src, 'error', 'Yeterli paranız yok!')
    end
end)

-- Telefon satın alma
RegisterNetEvent('aendir:server:BuyPhone', function()
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if Player.PlayerData.money.cash >= Config.PhonePrice then
        Player.Functions.RemoveMoney('cash', Config.PhonePrice)
        Player.Functions.AddItem('phone', 1)
        
        TriggerClientEvent('aendir:client:Notification', src, 'success', 'Telefon satın aldınız!')
    else
        TriggerClientEvent('aendir:client:Notification', src, 'error', 'Yeterli paranız yok!')
    end
end)

-- Mesaj gönderme
RegisterNetEvent('aendir:server:SendMessage', function(number, message)
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local targetPlayer = Aendir.Functions.GetPlayerByPhoneNumber(number)
    if targetPlayer then
        TriggerClientEvent('aendir:client:ReceiveMessage', targetPlayer.PlayerData.source, Player.PlayerData.phoneNumber, message)
    end
end)

-- Arama yapma
RegisterNetEvent('aendir:server:MakeCall', function(number)
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local targetPlayer = Aendir.Functions.GetPlayerByPhoneNumber(number)
    if targetPlayer then
        TriggerClientEvent('aendir:client:IncomingCall', targetPlayer.PlayerData.source, Player.PlayerData.phoneNumber)
    end
end)

-- Arama cevaplama
RegisterNetEvent('aendir:server:AnswerCall', function(number)
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local targetPlayer = Aendir.Functions.GetPlayerByPhoneNumber(number)
    if targetPlayer then
        TriggerClientEvent('aendir:client:StartCall', targetPlayer.PlayerData.source, Player.PlayerData.phoneNumber)
        TriggerClientEvent('aendir:client:StartCall', src, number)
    end
end)

-- Arama reddetme
RegisterNetEvent('aendir:server:RejectCall', function(number)
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local targetPlayer = Aendir.Functions.GetPlayerByPhoneNumber(number)
    if targetPlayer then
        TriggerClientEvent('aendir:client:EndCall', targetPlayer.PlayerData.source, Player.PlayerData.phoneNumber)
    end
end)

-- Telefon numarası kontrolü
Aendir.Functions.CreateCallback('aendir:server:GetPhoneNumber', function(source, cb)
    local Player = Aendir.Functions.GetPlayer(source)
    if not Player then return cb(nil) end
    
    local simCard = Player.Functions.GetItemByName('sim_card')
    if simCard then
        cb(simCard.info.phoneNumber)
    else
        cb(nil)
    end
end) 