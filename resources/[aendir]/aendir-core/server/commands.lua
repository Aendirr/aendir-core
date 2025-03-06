-- Komutlar
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Meslek Komutları
RegisterCommand('setjob', function(source, args)
    local target = tonumber(args[1])
    local job = args[2]
    local grade = tonumber(args[3])
    
    if target and job and grade then
        if Config.Jobs[job] and Config.Jobs[job].grades[tostring(grade)] then
            AendirCore.Functions.SetJob(target, job, grade)
            TriggerClientEvent('aendir:client:Notify', source, 'Meslek güncellendi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Geçersiz meslek veya rütbe!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /setjob [id] [meslek] [rütbe]', 'error')
    end
end, true)

-- Çete Komutları
RegisterCommand('setgang', function(source, args)
    local target = tonumber(args[1])
    local gang = args[2]
    local grade = tonumber(args[3])
    
    if target and gang and grade then
        if Config.Gangs[gang] and Config.Gangs[gang].grades[tostring(grade)] then
            AendirCore.Functions.SetGang(target, gang, grade)
            TriggerClientEvent('aendir:client:Notify', source, 'Çete güncellendi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Geçersiz çete veya rütbe!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /setgang [id] [çete] [rütbe]', 'error')
    end
end, true)

-- Para Komutları
RegisterCommand('givemoney', function(source, args)
    local target = tonumber(args[1])
    local type = args[2]
    local amount = tonumber(args[3])
    
    if target and type and amount then
        if type == 'cash' or type == 'bank' then
            AendirCore.Functions.AddMoney(target, type, amount)
            TriggerClientEvent('aendir:client:Notify', source, 'Para verildi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Geçersiz para tipi!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /givemoney [id] [tip] [miktar]', 'error')
    end
end, true)

RegisterCommand('removemoney', function(source, args)
    local target = tonumber(args[1])
    local type = args[2]
    local amount = tonumber(args[3])
    
    if target and type and amount then
        if type == 'cash' or type == 'bank' then
            if AendirCore.Functions.RemoveMoney(target, type, amount) then
                TriggerClientEvent('aendir:client:Notify', source, 'Para alındı!', 'success')
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz para!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Geçersiz para tipi!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /removemoney [id] [tip] [miktar]', 'error')
    end
end, true)

-- Eşya Komutları
RegisterCommand('giveitem', function(source, args)
    local target = tonumber(args[1])
    local item = args[2]
    local amount = tonumber(args[3])
    
    if target and item and amount then
        AendirCore.Functions.AddItem(target, item, amount)
        TriggerClientEvent('aendir:client:Notify', source, 'Eşya verildi!', 'success')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /giveitem [id] [eşya] [miktar]', 'error')
    end
end, true)

RegisterCommand('removeitem', function(source, args)
    local target = tonumber(args[1])
    local item = args[2]
    local amount = tonumber(args[3])
    
    if target and item and amount then
        if AendirCore.Functions.RemoveItem(target, item, amount) then
            TriggerClientEvent('aendir:client:Notify', source, 'Eşya alındı!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz eşya!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /removeitem [id] [eşya] [miktar]', 'error')
    end
end, true)

-- Karakter Komutları
RegisterCommand('createchar', function(source, args)
    local data = {
        model = Config.DefaultModel,
        components = {}
    }
    
    AendirCore.Functions.CreateCharacter(source, data)
end, true)

RegisterCommand('deletechar', function(source, args)
    local cid = tonumber(args[1])
    
    if cid then
        AendirCore.Functions.DeleteCharacter(source, cid)
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /deletechar [id]', 'error')
    end
end, true)

RegisterCommand('selectchar', function(source, args)
    local cid = tonumber(args[1])
    
    if cid then
        AendirCore.Functions.SelectCharacter(source, cid)
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /selectchar [id]', 'error')
    end
end, true)

-- Yönetici Komutları
RegisterCommand('kick', function(source, args)
    local target = tonumber(args[1])
    local reason = table.concat(args, ' ', 2)
    
    if target then
        DropPlayer(target, reason or 'Kick edildiniz!')
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu kicklendi!', 'success')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /kick [id] [sebep]', 'error')
    end
end, true)

RegisterCommand('ban', function(source, args)
    local target = tonumber(args[1])
    local duration = tonumber(args[2])
    local reason = table.concat(args, ' ', 3)
    
    if target and duration then
        local license = GetPlayerIdentifier(target, 'license')
        local name = GetPlayerName(target)
        
        MySQL.insert('INSERT INTO bans (license, name, reason, duration) VALUES (?, ?, ?, ?)', {
            license,
            name,
            reason or 'Banlandınız!',
            duration
        }, function()
            DropPlayer(target, reason or 'Banlandınız!')
            TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu banlandı!', 'success')
        end)
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /ban [id] [süre] [sebep]', 'error')
    end
end, true)

RegisterCommand('unban', function(source, args)
    local license = args[1]
    
    if license then
        MySQL.query('DELETE FROM bans WHERE license = ?', {license}, function()
            TriggerClientEvent('aendir:client:Notify', source, 'Ban kaldırıldı!', 'success')
        end)
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /unban [license]', 'error')
    end
end, true)

RegisterCommand('cleararea', function(source, args)
    local target = tonumber(args[1])
    
    if target then
        local ped = GetPlayerPed(target)
        local coords = GetEntityCoords(ped)
        
        local vehicles = GetGamePool('CVehicle')
        for _, vehicle in ipairs(vehicles) do
            if #(GetEntityCoords(vehicle) - coords) < 50.0 then
                DeleteEntity(vehicle)
            end
        end
        
        local peds = GetGamePool('CPed')
        for _, ped in ipairs(peds) do
            if #(GetEntityCoords(ped) - coords) < 50.0 and not IsPedAPlayer(ped) then
                DeleteEntity(ped)
            end
        end
        
        TriggerClientEvent('aendir:client:Notify', source, 'Alan temizlendi!', 'success')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Kullanım: /cleararea [id]', 'error')
    end
end, true)

RegisterCommand('noclip', function(source)
    TriggerClientEvent('aendir:client:ToggleNoClip', source)
end, true)

RegisterCommand('godmode', function(source)
    TriggerClientEvent('aendir:client:ToggleGodMode', source)
end, true)

RegisterCommand('invisible', function(source)
    TriggerClientEvent('aendir:client:ToggleInvisible', source)
end, true) 