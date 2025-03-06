local AendirCore = {}
local PlayerData = {}
local isLoggedIn = false

-- Oyuncu Verilerini Güncelleme
RegisterNetEvent('aendir:client:SetPlayerData', function(data)
    PlayerData = data
    isLoggedIn = true
end)

RegisterNetEvent('aendir:client:OnPlayerUnload', function()
    PlayerData = {}
    isLoggedIn = false
end)

-- Yardımcı Fonksiyonlar
function AendirCore.Functions.GetPlayerData()
    return PlayerData
end

function AendirCore.Functions.IsPlayerLoggedIn()
    return isLoggedIn
end

function AendirCore.Functions.GetPlayerJob()
    return PlayerData.job
end

function AendirCore.Functions.GetPlayerGang()
    return PlayerData.gang
end

function AendirCore.Functions.GetPlayerMoney()
    return PlayerData.money
end

function AendirCore.Functions.GetPlayerName()
    return PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname
end

function AendirCore.Functions.GetPlayerCitizenId()
    return PlayerData.citizenid
end

function AendirCore.Functions.GetPlayerPhoneNumber()
    return PlayerData.charinfo.phone
end

-- Karakter Yönetimi
function AendirCore.Functions.CreateCharacter(data)
    TriggerServerEvent('aendir:server:CreateCharacter', data)
end

function AendirCore.Functions.UpdateCharacter(data)
    TriggerServerEvent('aendir:server:UpdateCharacter', data)
end

function AendirCore.Functions.DeleteCharacter()
    TriggerServerEvent('aendir:server:DeleteCharacter')
end

-- Meslek Yönetimi
function AendirCore.Functions.SetJob(job, grade)
    TriggerServerEvent('aendir:server:SetJob', job, grade)
end

function AendirCore.Functions.GetJob()
    return PlayerData.job
end

-- Çete Yönetimi
function AendirCore.Functions.SetGang(gang, grade)
    TriggerServerEvent('aendir:server:SetGang', gang, grade)
end

function AendirCore.Functions.GetGang()
    return PlayerData.gang
end

-- Para İşlemleri
function AendirCore.Functions.AddMoney(amount, moneyType)
    TriggerServerEvent('aendir:server:AddMoney', amount, moneyType)
end

function AendirCore.Functions.RemoveMoney(amount, moneyType)
    TriggerServerEvent('aendir:server:RemoveMoney', amount, moneyType)
end

function AendirCore.Functions.GetMoney(moneyType)
    return PlayerData.money[moneyType or 'bank']
end

-- Eşya Yönetimi
function AendirCore.Functions.AddItem(item, amount, slot)
    TriggerServerEvent('aendir:server:AddItem', item, amount, slot)
end

function AendirCore.Functions.RemoveItem(item, amount)
    TriggerServerEvent('aendir:server:RemoveItem', item, amount)
end

function AendirCore.Functions.GetItem(item)
    if not PlayerData.items then return nil end
    
    for _, itemData in ipairs(PlayerData.items) do
        if itemData.name == item then
            return itemData
        end
    end
    
    return nil
end

-- Bildirim Sistemi
function AendirCore.Functions.ShowNotification(text, type)
    lib.notify({
        title = 'Aendir Core',
        description = text,
        type = type,
        position = Config.Notifications.Position,
        duration = Config.Notifications.Duration
    })
end

-- Progress Bar
function AendirCore.Functions.ShowProgressBar(text, duration)
    if lib.progressBar({
        duration = duration or Config.ProgressBar.Duration,
        label = text,
        position = Config.ProgressBar.Position,
        useAnimation = Config.ProgressBar.UseAnimation
    }) then
        return true
    end
    return false
end

-- Blip Sistemi
function AendirCore.Functions.CreateBlip(coords, sprite, color, scale, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite or Config.Blips.Default.Sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale or Config.Blips.Default.Scale)
    SetBlipColour(blip, color or Config.Blips.Default.Color)
    SetBlipAsShortRange(blip, Config.Blips.Default.ShortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

-- Marker Sistemi
function AendirCore.Functions.DrawMarker(coords, type, size, color)
    DrawMarker(
        type or Config.Markers.Default.Type,
        coords.x, coords.y, coords.z - 1.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        size or Config.Markers.Default.Size.x, size or Config.Markers.Default.Size.y, size or Config.Markers.Default.Size.z,
        color or Config.Markers.Default.Color.x, color or Config.Markers.Default.Color.y, color or Config.Markers.Default.Color.z, 100,
        Config.Markers.Default.BobUpAndDown,
        Config.Markers.Default.FaceCamera,
        2,
        Config.Markers.Default.Rotate,
        nil, nil, false
    )
end

-- Mesafe Kontrolü
function AendirCore.Functions.IsNearCoords(coords, distance)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - coords)
    return distance <= distance
end

-- Araç Sistemi
function AendirCore.Functions.GetCurrentVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    return vehicle
end

function AendirCore.Functions.GetVehiclePlate(vehicle)
    return GetVehicleNumberPlateText(vehicle)
end

function AendirCore.Functions.GetVehicleByPlate(plate)
    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in ipairs(vehicles) do
        if AendirCore.Functions.GetVehiclePlate(vehicle) == plate then
            return vehicle
        end
    end
    return 0
end

function AendirCore.Functions.SetVehicleProperties(vehicle, props)
    if not props then return end
    
    -- Modifiye
    if props.mods then
        for modType, modIndex in pairs(props.mods) do
            SetVehicleMod(vehicle, tonumber(modType), tonumber(modIndex), false)
        end
    end
    
    -- Renk
    if props.color1 then
        SetVehicleColours(vehicle, props.color1, props.color2 or props.color1)
    end
    
    -- Plaka
    if props.plate then
        SetVehicleNumberPlateText(vehicle, props.plate)
    end
    
    -- Hasar
    if props.damage then
        SetVehicleBodyHealth(vehicle, props.damage.body or 1000.0)
        SetVehicleEngineHealth(vehicle, props.damage.engine or 1000.0)
    end
    
    -- Yakıt
    if props.fuel then
        SetVehicleFuelLevel(vehicle, props.fuel)
    end
end

function AendirCore.Functions.GetVehicleProperties(vehicle)
    local props = {}
    
    -- Modifiye
    props.mods = {}
    for i = 0, 49 do
        local modValue = GetVehicleMod(vehicle, i)
        if modValue ~= -1 then
            props.mods[i] = modValue
        end
    end
    
    -- Renk
    props.color1, props.color2 = GetVehicleColours(vehicle)
    
    -- Plaka
    props.plate = GetVehicleNumberPlateText(vehicle)
    
    -- Hasar
    props.damage = {
        body = GetVehicleBodyHealth(vehicle),
        engine = GetVehicleEngineHealth(vehicle)
    }
    
    -- Yakıt
    props.fuel = GetVehicleFuelLevel(vehicle)
    
    return props
end

-- Export Fonksiyonları
exports('GetCoreObject', function()
    return AendirCore
end) 