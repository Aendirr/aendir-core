local Aendir = exports['aendir-core']:GetCoreObject()

local currentJob = nil
local currentTask = nil
local isOnDuty = false

-- Meslek menüsü
RegisterNetEvent('aendir:client:ShowJobMenu', function(jobId)
    local job = Config.Jobs[jobId]
    if not job then return end

    lib.registerContext({
        id = 'job_menu',
        title = job.label,
        options = {
            {
                title = 'Meslek Bilgileri',
                description = string.format('Açıklama: %s\nMaaş: $%s/saat', job.description, job.grades[1].salary)
            },
            {
                title = 'Görev Al',
                description = 'Yeni görev al',
                onSelect = function()
                    TriggerServerEvent('aendir:server:GetJobTask')
                end
            },
            {
                title = 'Eşya Al',
                description = 'Meslek eşyalarını al',
                onSelect = function()
                    TriggerEvent('aendir:client:OpenJobItems', jobId)
                end
            },
            {
                title = 'Vardiya',
                description = isOnDuty and 'Vardiyadan çık' or 'Vardiyaya gir',
                onSelect = function()
                    TriggerEvent('aendir:client:ToggleDuty')
                end
            }
        }
    })

    lib.showContext('job_menu')
end)

-- Meslek eşyaları menüsü
RegisterNetEvent('aendir:client:OpenJobItems', function(jobId)
    local job = Config.Jobs[jobId]
    if not job then return end

    local options = {}

    for item, data in pairs(job.items) do
        table.insert(options, {
            title = item,
            description = string.format('Maksimum: %s', data.max),
            onSelect = function()
                TriggerServerEvent('aendir:server:GetJobItem', item)
            end
        })
    end

    lib.registerContext({
        id = 'job_items',
        title = 'Meslek Eşyaları',
        options = options
    })

    lib.showContext('job_items')
end)

-- Görev gösterimi
RegisterNetEvent('aendir:client:ShowTask', function(task)
    currentTask = task
    local blip = AddBlipForCoord(task.coords.x, task.coords.y, task.coords.z)
    SetBlipSprite(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(task.label)
    EndTextCommandSetBlipName(blip)

    CreateThread(function()
        while currentTask do
            Wait(0)
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local distance = #(coords - task.coords)

            if distance < 10.0 then
                DrawMarker(1, task.coords.x, task.coords.y, task.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 2.0 then
                    if IsControlJustPressed(0, 38) then -- E tuşu
                        TriggerServerEvent('aendir:server:CompleteTask')
                        RemoveBlip(blip)
                        currentTask = nil
                    end
                end
            end
        end
    end)
end)

-- Vardiya değiştirme
RegisterNetEvent('aendir:client:ToggleDuty', function()
    isOnDuty = not isOnDuty
    TriggerEvent('aendir:client:Notification', isOnDuty and 'success' or 'info', isOnDuty and 'Vardiyaya girdiniz!' or 'Vardiyadan çıktınız!')
end)

-- Meslek listesi
RegisterNetEvent('aendir:client:ShowJobs', function(jobs)
    local options = {}

    for _, job in pairs(jobs) do
        table.insert(options, {
            title = job.label,
            description = job.description,
            onSelect = function()
                TriggerEvent('aendir:client:ShowJobMenu', job.name)
            end
        })
    end

    lib.registerContext({
        id = 'job_list',
        title = 'Meslekler',
        options = options
    })

    lib.showContext('job_list')
end)

-- Meslek blipleri
CreateThread(function()
    for id, job in pairs(Config.Jobs) do
        if job.coords then
            local blip = AddBlipForCoord(job.coords.x, job.coords.y, job.coords.z)
            SetBlipSprite(blip, job.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, job.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(job.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Meslek etkileşimleri
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for id, job in pairs(Config.Jobs) do
            if job.coords then
                local distance = #(coords - job.coords)
                if distance < 10.0 then
                    DrawMarker(1, job.coords.x, job.coords.y, job.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, true, 2, false, nil, nil, false)
                    
                    if distance < 2.0 then
                        if IsControlJustPressed(0, 38) then -- E tuşu
                            TriggerEvent('aendir:client:ShowJobMenu', id)
                        end
                    end
                end
            end
        end
    end
end)

-- Komutlar
RegisterCommand('meslekler', function()
    TriggerServerEvent('aendir:server:GetJobs')
end)

-- Keybinds
RegisterKeyMapping('meslekler', 'Meslekler menüsünü aç', 'keyboard', 'F9') 