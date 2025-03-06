local Aendir = exports['aendir-core']:GetCoreObject()

local isOnDuty = false
local currentJob = nil
local currentGrade = nil
local isAdmin = false

-- Admin kontrolü
RegisterNetEvent('aendir:client:SetAdmin', function(admin)
    isAdmin = admin
end)

-- Meslek menüsü
local function OpenJobMenu()
    if not isAdmin then
        TriggerEvent('aendir:client:Notification', 'error', 'Bu menüyü kullanma yetkiniz yok!')
        return
    end
    
    local elements = {}
    
    for category, data in pairs(Config.JobCategories) do
        table.insert(elements, {
            label = data.label,
            value = category,
            description = 'Meslek kategorisini görüntüle'
        })
    end
    
    lib.registerContext({
        id = 'job_menu',
        title = 'Meslek Menüsü',
        options = elements
    })
    
    lib.showContext('job_menu')
end

-- Kategori menüsü
local function OpenCategoryMenu(category)
    if not isAdmin then return end
    
    local elements = {}
    local categoryData = Config.JobCategories[category]
    
    for job, data in pairs(categoryData.jobs) do
        table.insert(elements, {
            label = data.label,
            value = job,
            description = 'Meslek detaylarını görüntüle'
        })
    end
    
    lib.registerContext({
        id = 'category_menu',
        title = categoryData.label,
        menu = 'job_menu',
        options = elements
    })
    
    lib.showContext('category_menu')
end

-- Meslek detay menüsü
local function OpenJobDetailsMenu(job)
    if not isAdmin then return end
    
    local elements = {}
    local jobData = nil
    
    for category, data in pairs(Config.JobCategories) do
        if data.jobs[job] then
            jobData = data.jobs[job]
            break
        end
    end
    
    if not jobData then return end
    
    for _, grade in ipairs(jobData.grades) do
        table.insert(elements, {
            label = grade.label,
            value = grade.name,
            description = 'Maaş: $' .. grade.salary
        })
    end
    
    lib.registerContext({
        id = 'job_details',
        title = jobData.label,
        menu = 'category_menu',
        options = elements
    })
    
    lib.showContext('job_details')
end

-- Vardiya başlatma/bitirme
local function ToggleDuty()
    if not currentJob then
        TriggerEvent('aendir:client:Notification', 'error', 'Bir mesleğiniz yok!')
        return
    end
    
    isOnDuty = not isOnDuty
    
    if isOnDuty then
        TriggerServerEvent('aendir:server:SetDuty', currentJob, currentGrade)
        TriggerEvent('aendir:client:Notification', 'success', 'Vardiyaya başladınız!')
    else
        TriggerServerEvent('aendir:server:SetDuty', 'unemployed', 'unemployed')
        TriggerEvent('aendir:client:Notification', 'error', 'Vardiyayı bitirdiniz!')
    end
end

-- Kıyafet menüsü
local function OpenUniformMenu()
    if not currentJob or not isOnDuty then
        TriggerEvent('aendir:client:Notification', 'error', 'Vardiyada değilsiniz!')
        return
    end
    
    local elements = {}
    local jobData = nil
    
    for category, data in pairs(Config.JobCategories) do
        if data.jobs[currentJob] then
            jobData = data.jobs[currentJob]
            break
        end
    end
    
    if not jobData then return end
    
    -- Burada kıyafet seçenekleri eklenecek
    
    lib.registerContext({
        id = 'uniform_menu',
        title = 'Kıyafet Menüsü',
        options = elements
    })
    
    lib.showContext('uniform_menu')
end

-- Araç menüsü
local function OpenVehicleMenu()
    if not currentJob or not isOnDuty then
        TriggerEvent('aendir:client:Notification', 'error', 'Vardiyada değilsiniz!')
        return
    end
    
    local elements = {}
    local jobData = nil
    
    for category, data in pairs(Config.JobCategories) do
        if data.jobs[currentJob] then
            jobData = data.jobs[currentJob]
            break
        end
    end
    
    if not jobData then return end
    
    -- Burada araç seçenekleri eklenecek
    
    lib.registerContext({
        id = 'vehicle_menu',
        title = 'Araç Menüsü',
        options = elements
    })
    
    lib.showContext('vehicle_menu')
end

-- Envanter menüsü
local function OpenInventoryMenu()
    if not currentJob or not isOnDuty then
        TriggerEvent('aendir:client:Notification', 'error', 'Vardiyada değilsiniz!')
        return
    end
    
    local elements = {}
    local jobData = nil
    
    for category, data in pairs(Config.JobCategories) do
        if data.jobs[currentJob] then
            jobData = data.jobs[currentJob]
            break
        end
    end
    
    if not jobData then return end
    
    -- Burada envanter seçenekleri eklenecek
    
    lib.registerContext({
        id = 'inventory_menu',
        title = 'Envanter Menüsü',
        options = elements
    })
    
    lib.showContext('inventory_menu')
end

-- Eventler
RegisterNetEvent('aendir:client:SetJob', function(job, grade)
    currentJob = job
    currentGrade = grade
end)

-- Menü seçimleri
lib.registerCallback('job_menu', function(source, cb)
    OpenJobMenu()
    cb('ok')
end)

lib.registerCallback('category_menu', function(source, cb, value)
    OpenCategoryMenu(value)
    cb('ok')
end)

lib.registerCallback('job_details', function(source, cb, value)
    TriggerServerEvent('aendir:server:SetJob', currentJob, value)
    cb('ok')
end)

-- Komutlar
RegisterCommand('meslek', function()
    OpenJobMenu()
end)

RegisterCommand('duty', function()
    ToggleDuty()
end)

RegisterCommand('uniform', function()
    OpenUniformMenu()
end)

RegisterCommand('vehicle', function()
    OpenVehicleMenu()
end)

RegisterCommand('inventory', function()
    OpenInventoryMenu()
end)

-- Keybinds
RegisterKeyMapping('duty', 'Vardiya başlat/bitir', 'keyboard', 'F6') 