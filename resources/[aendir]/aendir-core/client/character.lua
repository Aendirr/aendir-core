-- Karakter
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Değişkenler
local cam = nil
local charPed = nil
local currentChar = nil
local isCameraActive = false

-- Kamera Fonksiyonları
local function CreateCamera()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)
        SetCamCoord(cam, -269.0, -955.0, 31.0)
        PointCamAtCoord(cam, -269.0, -955.0, 31.0)
        isCameraActive = true
    end
end

local function DeleteCamera()
    if DoesCamExist(cam) then
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, true, 500, true, true)
        isCameraActive = false
    end
end

-- Karakter Fonksiyonları
local function CreateCharacterPed(model)
    if charPed then
        DeleteEntity(charPed)
    end
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    charPed = CreatePed(4, model, -269.0, -955.0, 31.0, 205.0, false, true)
    SetEntityHeading(charPed, 205.0)
    FreezeEntityPosition(charPed, true)
    SetEntityInvincible(charPed, true)
    SetBlockingOfNonTemporaryEvents(charPed, true)
end

local function DeleteCharacterPed()
    if charPed then
        DeleteEntity(charPed)
        charPed = nil
    end
end

-- Arayüz Fonksiyonları
local function OpenCharacterMenu()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openCharacterMenu',
        characters = currentChar
    })
end

local function CloseCharacterMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'closeCharacterMenu'
    })
end

-- Events
RegisterNetEvent('aendir:client:OpenCharacterMenu', function(characters)
    currentChar = characters
    CreateCamera()
    CreateCharacterPed(Config.DefaultModel)
    OpenCharacterMenu()
end)

RegisterNetEvent('aendir:client:CloseCharacterMenu', function()
    CloseCharacterMenu()
    DeleteCamera()
    DeleteCharacterPed()
end)

RegisterNetEvent('aendir:client:UpdateCharacter', function(data)
    if charPed then
        SetEntityModel(charPed, data.model)
        for k, v in pairs(data.components) do
            SetPedComponentVariation(charPed, k, v.drawable, v.texture, 0)
        end
    end
end)

-- NUI Callbacks
RegisterNUICallback('createCharacter', function(data, cb)
    TriggerServerEvent('aendir:server:CreateCharacter', data)
    cb('ok')
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
    TriggerServerEvent('aendir:server:DeleteCharacter', data.cid)
    cb('ok')
end)

RegisterNUICallback('selectCharacter', function(data, cb)
    TriggerServerEvent('aendir:server:SelectCharacter', data.cid)
    cb('ok')
end)

RegisterNUICallback('updateCharacter', function(data, cb)
    TriggerServerEvent('aendir:server:UpdateCharacter', data)
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    TriggerEvent('aendir:client:CloseCharacterMenu')
    cb('ok')
end)

-- Komutlar
RegisterCommand('char', function()
    TriggerServerEvent('aendir:server:GetCharacters')
end, false)

-- Threads
CreateThread(function()
    while true do
        Wait(0)
        if isCameraActive then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 265, true)
            DisableControlAction(0, 266, true)
            DisableControlAction(0, 267, true)
            DisableControlAction(0, 268, true)
            DisableControlAction(0, 269, true)
            DisableControlAction(0, 270, true)
            DisableControlAction(0, 271, true)
            DisableControlAction(0, 272, true)
            DisableControlAction(0, 273, true)
            DisableControlAction(0, 274, true)
            DisableControlAction(0, 275, true)
        end
    end
end) 