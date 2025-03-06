local Aendir = exports['aendir-core']:GetCoreObject()

local isAdmin = false
local currentCharacter = nil

-- Admin durumu
RegisterNetEvent('aendir:client:SetAdmin', function(admin)
    isAdmin = admin
end)

-- Karakter bilgileri
RegisterNetEvent('aendir:client:SetCharacter', function(data)
    currentCharacter = data
end)

-- Bildirim sistemi
function ShowNotification(type, message)
    if not Config.Notifications.types[type] then return end
    
    local data = Config.Notifications.types[type]
    
    lib.notify({
        title = message,
        type = type,
        position = Config.Notifications.position,
        duration = Config.Notifications.duration,
        style = {
            backgroundColor = data.color,
            color = '#ffffff'
        }
    })
end

-- Animasyon sistemi
function PlayAnimation(dict, anim, flag)
    if not Config.Animations.dicts[dict] or not Config.Animations.dicts[dict][anim] then return end
    
    local data = Config.Animations.dicts[dict][anim]
    
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    
    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, data.duration, data.flag, 0, false, false, false)
end

-- Blip sistemi
function CreateBlip(coords, sprite, color, scale, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

-- Banka blipleri
CreateThread(function()
    for _, bank in ipairs(Config.Banking.banks) do
        CreateBlip(bank.coords, bank.blip.sprite, bank.blip.color, bank.blip.scale, bank.name)
    end
end)

-- ATM blipleri
CreateThread(function()
    for _, model in ipairs(Config.Banking.atmModels) do
        local hash = GetHashKey(model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(0)
        end
        
        local atms = GetGamePool('CObject')
        for _, atm in ipairs(atms) do
            if GetEntityModel(atm) == hash then
                local coords = GetEntityCoords(atm)
                CreateBlip(coords, 108, 2, 0.7, 'ATM')
            end
        end
    end
end)

-- Garaj blipleri
CreateThread(function()
    for _, garage in ipairs(Config.Vehicles.garages) do
        CreateBlip(garage.coords, garage.blip.sprite, garage.blip.color, garage.blip.scale, garage.name)
    end
end)

-- Oyuncu yükleme
RegisterNetEvent('aendir:client:PlayerLoaded', function()
    TriggerServerEvent('aendir:server:PlayerLoaded')
end)

-- Oyuncu çıkış
RegisterNetEvent('aendir:client:PlayerUnload', function()
    TriggerServerEvent('aendir:server:PlayerUnload')
end)

-- Whitelist başvuru menüsü
function OpenWhitelistMenu()
    local input = lib.inputDialog('Whitelist Başvuru', {
        {type = 'input', label = 'İsim', description = 'Adınız ve soyadınız', required = true},
        {type = 'number', label = 'Yaş', description = 'Yaşınız', required = true, min = Config.Whitelist.minimumAge},
        {type = 'input', label = 'Discord', description = 'Discord kullanıcı adınız', required = true},
        {type = 'input', label = 'Teamspeak', description = 'Teamspeak kullanıcı adınız', required = true},
        {type = 'textarea', label = 'Deneyim', description = 'Roleplay deneyiminiz', required = true}
    })
    
    if input then
        TriggerServerEvent('aendir:server:WhitelistApplication', {
            name = input[1],
            age = input[2],
            discord = input[3],
            teamspeak = input[4],
            experience = input[5]
        })
    end
end

-- Komutlar
RegisterCommand('whitelist', function()
    OpenWhitelistMenu()
end)

-- Eventler
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    
    print('^2[Aendir Core] ^7Client başlatıldı!')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    
    print('^1[Aendir Core] ^7Client durduruldu!')
end) 