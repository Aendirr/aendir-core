local Aendir = exports['aendir-core']:GetCoreObject()

-- Admin kontrolü
local function IsAdmin(source)
    local Player = Aendir.Functions.GetPlayer(source)
    if not Player then return false end
    
    return Player.PlayerData.admin or false
end

-- Meslek verme komutu
RegisterCommand('meslekver', function(source, args)
    if not IsAdmin(source) then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu komutu kullanma yetkiniz yok!')
        return
    end
    
    if #args < 2 then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Kullanım: /meslekver [id] [meslek] [rütbe]')
        return
    end
    
    local targetId = tonumber(args[1])
    local jobName = args[2]
    local gradeName = args[3] or 'recruit' -- Rütbe belirtilmezse en düşük rütbe
    
    local targetPlayer = Aendir.Functions.GetPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Oyuncu bulunamadı!')
        return
    end
    
    -- Meslek kontrolü
    local jobExists = false
    local gradeExists = false
    local jobData = nil
    
    for category, data in pairs(Config.JobCategories) do
        if data.jobs[jobName] then
            jobExists = true
            jobData = data.jobs[jobName]
            for _, grade in ipairs(data.jobs[jobName].grades) do
                if grade.name == gradeName then
                    gradeExists = true
                    break
                end
            end
            break
        end
    end
    
    if not jobExists then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Geçersiz meslek!')
        return
    end
    
    if not gradeExists then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Geçersiz rütbe!')
        return
    end
    
    -- Mesleği ayarla
    targetPlayer.Functions.SetJob(jobName, gradeName)
    TriggerClientEvent('aendir:client:SetJob', targetId, jobName, gradeName)
    
    -- Bildirimler
    TriggerClientEvent('aendir:client:Notification', source, 'success', targetPlayer.PlayerData.charinfo.firstname .. ' ' .. targetPlayer.PlayerData.charinfo.lastname .. ' isimli oyuncuya ' .. jobData.label .. ' mesleği verildi!')
    TriggerClientEvent('aendir:client:Notification', targetId, 'success', 'Yeni mesleğiniz: ' .. jobData.label)
end)

-- Meslek silme komutu
RegisterCommand('mesleksil', function(source, args)
    if not IsAdmin(source) then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu komutu kullanma yetkiniz yok!')
        return
    end
    
    if #args < 1 then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Kullanım: /mesleksil [id]')
        return
    end
    
    local targetId = tonumber(args[1])
    local targetPlayer = Aendir.Functions.GetPlayer(targetId)
    
    if not targetPlayer then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Oyuncu bulunamadı!')
        return
    end
    
    -- Mesleği sil
    targetPlayer.Functions.SetJob('unemployed', 'unemployed')
    TriggerClientEvent('aendir:client:SetJob', targetId, 'unemployed', 'unemployed')
    
    -- Bildirimler
    TriggerClientEvent('aendir:client:Notification', source, 'success', targetPlayer.PlayerData.charinfo.firstname .. ' ' .. targetPlayer.PlayerData.charinfo.lastname .. ' isimli oyuncunun mesleği silindi!')
    TriggerClientEvent('aendir:client:Notification', targetId, 'error', 'Mesleğiniz silindi!')
end)

-- Meslek ayarlama
RegisterNetEvent('aendir:server:SetJob', function(job, grade)
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Meslek kontrolü
    local jobExists = false
    local gradeExists = false
    
    for category, data in pairs(Config.JobCategories) do
        if data.jobs[job] then
            jobExists = true
            for _, gradeData in ipairs(data.jobs[job].grades) do
                if gradeData.name == grade then
                    gradeExists = true
                    break
                end
            end
            break
        end
    end
    
    if not jobExists or not gradeExists then
        TriggerClientEvent('aendir:client:Notification', src, 'error', 'Geçersiz meslek veya rütbe!')
        return
    end
    
    -- Mesleği ayarla
    Player.Functions.SetJob(job, grade)
    TriggerClientEvent('aendir:client:SetJob', src, job, grade)
    TriggerClientEvent('aendir:client:Notification', src, 'success', 'Mesleğiniz güncellendi!')
end)

-- Vardiya ayarlama
RegisterNetEvent('aendir:server:SetDuty', function(job, grade)
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Vardiya kontrolü
    if job == 'unemployed' then
        Player.Functions.SetDuty(false)
        TriggerClientEvent('aendir:client:Notification', src, 'error', 'Vardiyayı bitirdiniz!')
    else
        if Player.PlayerData.job.name ~= job then
            TriggerClientEvent('aendir:client:Notification', src, 'error', 'Bu mesleğe sahip değilsiniz!')
            return
        end
        
        Player.Functions.SetDuty(true)
        TriggerClientEvent('aendir:client:Notification', src, 'success', 'Vardiyaya başladınız!')
    end
end)

-- Maaş ödeme
CreateThread(function()
    while true do
        Wait(Config.PayInterval or 3600000) -- Varsayılan: 1 saat
        
        local Players = Aendir.Functions.GetPlayers()
        for _, playerId in ipairs(Players) do
            local Player = Aendir.Functions.GetPlayer(playerId)
            if Player and Player.PlayerData.job and Player.PlayerData.job.name ~= 'unemployed' then
                local jobData = nil
                for category, data in pairs(Config.JobCategories) do
                    if data.jobs[Player.PlayerData.job.name] then
                        jobData = data.jobs[Player.PlayerData.job.name]
                        break
                    end
                end
                
                if jobData then
                    for _, grade in ipairs(jobData.grades) do
                        if grade.name == Player.PlayerData.job.grade.name then
                            Player.Functions.AddMoney('bank', grade.salary)
                            TriggerClientEvent('aendir:client:Notification', playerId, 'success', 'Maaşınız ödendi: $' .. grade.salary)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- Meslek izinleri kontrolü
Aendir.Functions.CreateCallback('aendir:server:HasJobPermission', function(source, cb, permission)
    local Player = Aendir.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    
    local job = Player.PlayerData.job.name
    if not Config.JobPermissions[job] then return cb(false) end
    
    cb(Config.JobPermissions[job][permission] or false)
end)

-- Meslek ödülü
RegisterNetEvent('aendir:server:GiveJobReward', function(rewardType)
    local src = source
    local Player = Aendir.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local job = Player.PlayerData.job.name
    if not Config.JobRewards[job] then return end
    
    local reward = Config.JobRewards[job][rewardType]
    if not reward then return end
    
    Player.Functions.AddMoney('bank', reward)
    TriggerClientEvent('aendir:client:Notification', src, 'success', 'Ödül kazandınız: $' .. reward)
end) 