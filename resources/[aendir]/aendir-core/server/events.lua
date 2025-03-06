-- Events
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Oyuncu Bağlantı
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    
    deferrals.defer()
    Wait(0)
    
    -- Ban Kontrolü
    local ban = AendirCore.Functions.GetBan(license)
    if ban then
        if ban.duration > 0 and (os.time() - ban.created_at) > ban.duration then
            AendirCore.Functions.DeleteBan(license)
        else
            deferrals.done('Banlandınız! Sebep: ' .. ban.reason)
            return
        end
    end
    
    -- Oyuncu Kontrolü
    local player = AendirCore.Functions.GetPlayer(license)
    if not player then
        -- Yeni Oyuncu
        local citizenid = AendirCore.Functions.GenerateCitizenId()
        local data = {
            citizenid = citizenid,
            license = license,
            name = name,
            money = {
                cash = Config.StartingMoney.Cash,
                bank = Config.StartingMoney.Bank,
                black = Config.StartingMoney.Black
            },
            job = {
                name = Config.DefaultJob.Name,
                grade = Config.DefaultJob.Grade
            },
            gang = {
                name = Config.DefaultGang.Name,
                grade = Config.DefaultGang.Grade
            },
            items = {},
            position = {
                x = Config.DefaultPosition.X,
                y = Config.DefaultPosition.Y,
                z = Config.DefaultPosition.Z,
                heading = Config.DefaultPosition.Heading
            },
            metadata = {
                hunger = 100,
                thirst = 100,
                stress = 0,
                drunk = 0,
                armor = 0,
                phone = nil,
                radio = nil
            }
        }
        AendirCore.Functions.CreatePlayer(data)
    end
    
    deferrals.done()
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    
    -- Pozisyon Güncelleme
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    local player = AendirCore.Functions.GetPlayer(license)
    if player then
        player.position = {
            x = coords.x,
            y = coords.y,
            z = coords.z,
            heading = heading
        }
        AendirCore.Functions.UpdatePlayer(license, player)
    end
end)

-- Para Events
RegisterNetEvent('aendir:server:GiveMoney', function(target, type, amount)
    local source = source
    local targetPlayer = AendirCore.Functions.GetPlayer(target)
    
    if targetPlayer then
        if AendirCore.Functions.AddMoney(target, type, amount) then
            TriggerClientEvent('aendir:client:Notify', source, 'Para verildi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz para!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

RegisterNetEvent('aendir:server:RemoveMoney', function(target, type, amount)
    local source = source
    local targetPlayer = AendirCore.Functions.GetPlayer(target)
    
    if targetPlayer then
        if AendirCore.Functions.RemoveMoney(target, type, amount) then
            TriggerClientEvent('aendir:client:Notify', source, 'Para alındı!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz para!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Meslek Events
RegisterNetEvent('aendir:server:SetJob', function(target, job, grade)
    local source = source
    local targetPlayer = AendirCore.Functions.GetPlayer(target)
    
    if targetPlayer then
        if Config.Jobs[job] and Config.Jobs[job].grades[tostring(grade)] then
            AendirCore.Functions.SetJob(target, job, grade)
            TriggerClientEvent('aendir:client:Notify', source, 'Meslek güncellendi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Geçersiz meslek veya rütbe!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Çete Events
RegisterNetEvent('aendir:server:SetGang', function(target, gang, grade)
    local source = source
    local targetPlayer = AendirCore.Functions.GetPlayer(target)
    
    if targetPlayer then
        if Config.Gangs[gang] and Config.Gangs[gang].grades[tostring(grade)] then
            AendirCore.Functions.SetGang(target, gang, grade)
            TriggerClientEvent('aendir:client:Notify', source, 'Çete güncellendi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Geçersiz çete veya rütbe!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Eşya Events
RegisterNetEvent('aendir:server:AddItem', function(target, item, amount)
    local source = source
    local targetPlayer = AendirCore.Functions.GetPlayer(target)
    
    if targetPlayer then
        if AendirCore.Functions.AddItem(target, item, amount) then
            TriggerClientEvent('aendir:client:Notify', source, 'Eşya verildi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz eşya!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

RegisterNetEvent('aendir:server:RemoveItem', function(target, item, amount)
    local source = source
    local targetPlayer = AendirCore.Functions.GetPlayer(target)
    
    if targetPlayer then
        if AendirCore.Functions.RemoveItem(target, item, amount) then
            TriggerClientEvent('aendir:client:Notify', source, 'Eşya alındı!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz eşya!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Karakter Events
RegisterNetEvent('aendir:server:CreateCharacter', function(data)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    
    local player = AendirCore.Functions.GetPlayer(license)
    if player then
        data.citizenid = player.citizenid
        AendirCore.Functions.CreateCharacter(data)
        TriggerClientEvent('aendir:client:Notify', source, 'Karakter oluşturuldu!', 'success')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

RegisterNetEvent('aendir:server:DeleteCharacter', function(cid)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    
    local player = AendirCore.Functions.GetPlayer(license)
    if player then
        AendirCore.Functions.DeleteCharacter(player.citizenid)
        TriggerClientEvent('aendir:client:Notify', source, 'Karakter silindi!', 'success')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

RegisterNetEvent('aendir:server:UpdateCharacter', function(data)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    
    local player = AendirCore.Functions.GetPlayer(license)
    if player then
        AendirCore.Functions.UpdateCharacter(player.citizenid, data)
        TriggerClientEvent('aendir:client:Notify', source, 'Karakter güncellendi!', 'success')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

RegisterNetEvent('aendir:server:SelectCharacter', function(cid)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    
    local player = AendirCore.Functions.GetPlayer(license)
    if player then
        local character = AendirCore.Functions.GetCharacter(player.citizenid)
        if character then
            TriggerClientEvent('aendir:client:LoadCharacter', source, character)
            TriggerClientEvent('aendir:client:Notify', source, 'Karakter yüklendi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Karakter bulunamadı!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- Yardımcı Fonksiyonlar
function GenerateCitizenId()
    local template = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local citizenid = ''
    
    for i = 1, 10 do
        local random = math.random(1, #template)
        citizenid = citizenid .. string.sub(template, random, random)
    end
    
    return citizenid
end 