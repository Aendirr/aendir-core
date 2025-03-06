local AendirCore = {}
local PlayerData = {}
local PlayerLoaded = false

-- Oyuncu Verilerini Alma
function AendirCore.Functions.GetPlayerData()
    return PlayerData
end

-- Oyuncu Girişi Kontrolü
function AendirCore.Functions.IsPlayerLoggedIn()
    return PlayerLoaded
end

-- Meslek Bilgisi Alma
function AendirCore.Functions.GetPlayerJob()
    return PlayerData.job
end

-- Çete Bilgisi Alma
function AendirCore.Functions.GetPlayerGang()
    return PlayerData.gang
end

-- Para Bilgisi Alma
function AendirCore.Functions.GetPlayerMoney()
    return PlayerData.money
end

-- İsim Alma
function AendirCore.Functions.GetPlayerName()
    return PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname
end

-- Citizen ID Alma
function AendirCore.Functions.GetPlayerCitizenId()
    return PlayerData.citizenid
end

-- Telefon Numarası Alma
function AendirCore.Functions.GetPlayerPhoneNumber()
    return PlayerData.metadata.phone
end

-- Bildirim Gönderme
function AendirCore.Functions.ShowNotification(message, type)
    if Config.Notifications.Types[type] then
        lib.notify({
            title = message,
            type = type,
            position = Config.Notifications.Position,
            duration = Config.Notifications.Duration,
            icon = Config.Notifications.Types[type].icon,
            style = {
                backgroundColor = Config.Notifications.Types[type].color
            }
        })
    end
end

-- Progress Bar
function AendirCore.Functions.ProgressBar(message, duration, useAnim, animDict, animName, flags)
    if useAnim then
        if animDict and animName then
            RequestAnimDict(animDict)
            while not HasAnimDictLoaded(animDict) do
                Wait(0)
            end
            TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, duration, flags, 0, false, false, false)
        end
    end
    
    lib.progressBar({
        duration = duration,
        label = message,
        position = Config.ProgressBar.Position,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = animDict,
            clip = animName
        }
    })
end

-- Blip Oluşturma
function AendirCore.Functions.CreateBlip(coords, sprite, color, scale, label, shortRange)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite or Config.DefaultBlip.Sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale or Config.DefaultBlip.Scale)
    SetBlipColour(blip, color or Config.DefaultBlip.Color)
    SetBlipAsShortRange(blip, shortRange or Config.DefaultBlip.ShortRange)
    
    if label then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(label)
        EndTextCommandSetBlipName(blip)
    end
    
    return blip
end

-- Marker Çizme
function AendirCore.Functions.DrawMarker(coords, type, size, color, drawDistance)
    if #(GetEntityCoords(PlayerPedId()) - coords) < (drawDistance or Config.DefaultMarker.DrawDistance) then
        DrawMarker(
            type or Config.DefaultMarker.Type,
            coords.x, coords.y, coords.z - 1.0,
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0,
            size.x or Config.DefaultMarker.Size.x,
            size.y or Config.DefaultMarker.Size.y,
            size.z or Config.DefaultMarker.Size.z,
            color.r or Config.DefaultMarker.Color.r,
            color.g or Config.DefaultMarker.Color.g,
            color.b or Config.DefaultMarker.Color.b,
            color.a or Config.DefaultMarker.Color.a,
            false, true, 2, false, nil, nil, false
        )
    end
end

-- Mesafe Kontrolü
function AendirCore.Functions.IsNearCoords(coords, distance)
    return #(GetEntityCoords(PlayerPedId()) - coords) < distance
end

-- Araç İşlemleri
function AendirCore.Functions.GetVehicleByPlate(plate)
    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in ipairs(vehicles) do
        if GetVehicleNumberPlateText(vehicle) == plate then
            return vehicle
        end
    end
    return nil
end

function AendirCore.Functions.IsInVehicle()
    return IsPedInAnyVehicle(PlayerPedId(), false)
end

function AendirCore.Functions.GetCurrentVehicle()
    return GetVehiclePedIsIn(PlayerPedId(), false)
end

-- Events
RegisterNetEvent('aendir:client:OnPlayerLoaded', function(data)
    PlayerData = data
    PlayerLoaded = true
    DoScreenFadeIn(1000)
end)

RegisterNetEvent('aendir:client:OnPlayerUnload', function()
    PlayerData = {}
    PlayerLoaded = false
    DoScreenFadeOut(1000)
end)

RegisterNetEvent('aendir:client:OnMoneyChange', function(type, amount, isMinus)
    if isMinus then
        PlayerData.money[type] = PlayerData.money[type] - amount
    else
        PlayerData.money[type] = PlayerData.money[type] + amount
    end
end)

RegisterNetEvent('aendir:client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('aendir:client:OnGangUpdate', function(gang)
    PlayerData.gang = gang
end)

RegisterNetEvent('aendir:client:OnItemAdd', function(item, amount, info)
    -- Envanter sistemi eklendiğinde buraya kod eklenecek
end)

RegisterNetEvent('aendir:client:OnItemRemove', function(item, amount)
    -- Envanter sistemi eklendiğinde buraya kod eklenecek
end)

-- Exports
exports('GetCoreObject', function()
    return AendirCore
end) 