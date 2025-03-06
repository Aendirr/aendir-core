local Aendir = exports['aendir-core']:GetCoreObject()

-- Meslek atama
RegisterNetEvent('aendir:server:SetJob', function(job, grade)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    if not Config.Jobs[job] then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Geçersiz meslek!')
        return
    end

    if not Config.Jobs[job].grades[grade] then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Geçersiz meslek seviyesi!')
        return
    end

    Player.job = job
    Player.job.grade = grade
    Player.job.label = Config.Jobs[job].grades[grade].label

    MySQL.update('UPDATE players SET job = ?, job_grade = ? WHERE citizenid = ?', {
        job,
        grade,
        Player.citizenid
    })

    TriggerClientEvent('aendir:client:Notification', source, 'success', string.format('Mesleğiniz %s olarak değiştirildi!', Player.job.label))
end)

-- Meslek maaşı
CreateThread(function()
    while true do
        Wait(Config.Jobs.payment_interval * 1000)
        
        for _, Player in pairs(Aendir.Players) do
            if Player.job and Config.Jobs[Player.job.name] then
                local job = Config.Jobs[Player.job.name]
                local grade = job.grades[Player.job.grade]
                
                if grade and grade.salary > 0 then
                    Player.money.bank = Player.money.bank + grade.salary
                    TriggerClientEvent('aendir:client:Notification', Player.source, 'info', string.format('Maaşınız ödendi: $%s', grade.salary))
                end
            end
        end
    end
end)

-- Meslek eşyası alma
RegisterNetEvent('aendir:server:GetJobItem', function(item)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    if not Player.job then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bir mesleğiniz yok!')
        return
    end

    local job = Config.Jobs[Player.job.name]
    if not job or not job.items[item] then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu eşyayı alamazsınız!')
        return
    end

    if Player.inventory[item] and Player.inventory[item].amount >= job.items[item].max then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu eşyadan yeterince var!')
        return
    end

    if not Player.inventory[item] then
        Player.inventory[item] = {amount = 0}
    end

    Player.inventory[item].amount = Player.inventory[item].amount + 1
    TriggerClientEvent('aendir:client:Notification', source, 'success', 'Eşya başarıyla alındı!')
end)

-- Meslek eşyası kullanma
RegisterNetEvent('aendir:server:UseJobItem', function(item)
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    if not Player.job then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bir mesleğiniz yok!')
        return
    end

    local job = Config.Jobs[Player.job.name]
    if not job or not job.items[item] then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu eşyayı kullanamazsınız!')
        return
    end

    if not Player.inventory[item] or Player.inventory[item].amount <= 0 then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu eşyadan yok!')
        return
    end

    Player.inventory[item].amount = Player.inventory[item].amount - 1
    TriggerClientEvent('aendir:client:Notification', source, 'success', 'Eşya başarıyla kullanıldı!')
end)

-- Meslek görevi alma
RegisterNetEvent('aendir:server:GetJobTask', function()
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    if not Player.job then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bir mesleğiniz yok!')
        return
    end

    local job = Config.Jobs[Player.job.name]
    if not job or not job.tasks then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Bu meslekte görev yok!')
        return
    end

    local task = job.tasks[math.random(#job.tasks)]
    Player.currentTask = task

    TriggerClientEvent('aendir:client:ShowTask', source, task)
end)

-- Meslek görevi tamamlama
RegisterNetEvent('aendir:server:CompleteTask', function()
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    if not Player.currentTask then
        TriggerClientEvent('aendir:client:Notification', source, 'error', 'Aktif göreviniz yok!')
        return
    end

    local job = Config.Jobs[Player.job.name]
    if not job then return end

    local task = Player.currentTask
    local reward = task.reward

    Player.money.cash = Player.money.cash + reward
    Player.currentTask = nil

    TriggerClientEvent('aendir:client:Notification', source, 'success', string.format('Görev tamamlandı! $%s kazandınız.', reward))
end)

-- Meslek listesi
RegisterNetEvent('aendir:server:GetJobs', function()
    local source = source
    local Player = Aendir.GetPlayer(source)
    if not Player then return end

    local jobs = {}
    for name, job in pairs(Config.Jobs) do
        table.insert(jobs, {
            name = name,
            label = job.label,
            description = job.description,
            grades = job.grades
        })
    end

    TriggerClientEvent('aendir:client:ShowJobs', source, jobs)
end) 