local PlayerData = {}
local isLoggedIn = false
local currentVehicle = nil
local currentHouse = nil
local currentBusiness = nil

-- Oyuncu verilerini güncelleme
RegisterNetEvent('aendir:client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = {}
end)

RegisterNetEvent('aendir:client:OnPlayerUnload', function()
    isLoggedIn = false
    PlayerData = {}
end)

-- Oyuncu verilerini güncelleme
RegisterNetEvent('aendir:client:SetPlayerData', function(val)
    PlayerData = val
end)

-- Para işlemleri
RegisterNetEvent('aendir:client:SetMoney', function(moneytype, amount)
    if moneytype == "cash" then
        PlayerData.money.cash = amount
    elseif moneytype == "bank" then
        PlayerData.money.bank = amount
    end
end)

-- İş işlemleri
RegisterNetEvent('aendir:client:SetJob', function(job)
    PlayerData.job = job
end)

-- Çete işlemleri
RegisterNetEvent('aendir:client:SetGang', function(gang)
    PlayerData.gang = gang
end)

-- Envanter işlemleri
RegisterNetEvent('aendir:client:UpdateInventory', function(inventory)
    PlayerData.inventory = inventory
end)

-- Yetenek işlemleri
RegisterNetEvent('aendir:client:UpdateSkills', function(skills)
    PlayerData.skills = skills
end)

-- Başarı işlemleri
RegisterNetEvent('aendir:client:UnlockAchievement', function(achievement)
    if Config.EnableSounds then
        PlaySoundFrontend(-1, Config.Sounds.achievement, "HUD_AWARDS", true)
    end
    
    if Config.EnableNotifications then
        lib.notify({
            title = 'Başarı Kazanıldı!',
            description = Config.Achievements[achievement].name,
            type = 'success'
        })
    end
end)

-- Görev işlemleri
RegisterNetEvent('aendir:client:CompleteQuest', function(questType, questId)
    if Config.EnableSounds then
        PlaySoundFrontend(-1, Config.Sounds.quest_complete, "HUD_AWARDS", true)
    end
    
    if Config.EnableNotifications then
        lib.notify({
            title = 'Görev Tamamlandı!',
            description = Config.Quests[questType][questId].name,
            type = 'success'
        })
    end
end)

-- Araç işlemleri
RegisterNetEvent('aendir:client:SetVehicle', function(vehicle)
    currentVehicle = vehicle
end)

-- Ev işlemleri
RegisterNetEvent('aendir:client:SetHouse', function(house)
    currentHouse = house
end)

-- İşletme işlemleri
RegisterNetEvent('aendir:client:SetBusiness', function(business)
    currentBusiness = business
end)

-- Spawn işlemleri
RegisterNetEvent('aendir:client:SpawnPlayer', function()
    DoScreenFadeOut(0)
    Wait(500)
    local ped = PlayerPedId()
    SetEntityCoords(ped, Config.DefaultSpawn.x, Config.DefaultSpawn.y, Config.DefaultSpawn.z)
    SetEntityHeading(ped, Config.DefaultSpawn.w)
    FreezeEntityPosition(ped, true)
    Wait(1000)
    FreezeEntityPosition(ped, false)
    DoScreenFadeIn(1000)
end)

-- Yardım menüsü
RegisterNetEvent('aendir:client:ShowHelpMenu', function()
    lib.registerContext({
        id = 'help_menu',
        title = 'Yardım Menüsü',
        options = {
            {
                title = 'Genel Komutlar',
                description = 'Temel komutları gösterir',
                onSelect = function()
                    ShowGeneralCommands()
                end
            },
            {
                title = 'İş Komutları',
                description = 'İş ile ilgili komutları gösterir',
                onSelect = function()
                    ShowJobCommands()
                end
            },
            {
                title = 'Araç Komutları',
                description = 'Araç ile ilgili komutları gösterir',
                onSelect = function()
                    ShowVehicleCommands()
                end
            }
        }
    })
    
    lib.showContext('help_menu')
end)

-- İstatistikler
RegisterNetEvent('aendir:client:ShowStats', function()
    lib.registerContext({
        id = 'stats_menu',
        title = 'İstatistikler',
        options = {
            {
                title = 'Para',
                description = string.format('Nakit: $%s\nBanka: $%s', PlayerData.money.cash, PlayerData.money.bank)
            },
            {
                title = 'İş',
                description = string.format('İş: %s\nSeviye: %s', PlayerData.job.label, PlayerData.job.grade.name)
            },
            {
                title = 'Çete',
                description = string.format('Çete: %s\nSeviye: %s', PlayerData.gang.label, PlayerData.gang.grade.name)
            }
        }
    })
    
    lib.showContext('stats_menu')
end)

-- Yetenekler
RegisterNetEvent('aendir:client:ShowSkills', function()
    lib.registerContext({
        id = 'skills_menu',
        title = 'Yetenekler',
        options = {
            {
                title = 'Güç',
                description = string.format('Seviye: %s', math.floor(PlayerData.skills.strength / 100))
            },
            {
                title = 'Dayanıklılık',
                description = string.format('Seviye: %s', math.floor(PlayerData.skills.stamina / 100))
            },
            {
                title = 'Sürüş',
                description = string.format('Seviye: %s', math.floor(PlayerData.skills.driving / 100))
            },
            {
                title = 'Ateş Etme',
                description = string.format('Seviye: %s', math.floor(PlayerData.skills.shooting / 100))
            }
        }
    })
    
    lib.showContext('skills_menu')
end)

-- Komutlar
if Config.EnableCommands then
    RegisterCommand('setjob', function(source, args)
        if not args[1] or not args[2] then return end
        TriggerServerEvent('aendir:server:SetJob', args[1], args[2])
    end)

    RegisterCommand('setmoney', function(source, args)
        if not args[1] or not args[2] then return end
        TriggerServerEvent('aendir:server:SetMoney', args[1], tonumber(args[2]))
    end)
end

-- Export fonksiyonları
exports('GetPlayerData', function()
    return PlayerData
end)

exports('IsLoggedIn', function()
    return isLoggedIn
end)

exports('GetCurrentVehicle', function()
    return currentVehicle
end)

exports('GetCurrentHouse', function()
    return currentHouse
end)

exports('GetCurrentBusiness', function()
    return currentBusiness
end)
