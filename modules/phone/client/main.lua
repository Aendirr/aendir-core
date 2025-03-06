local Aendir = exports['aendir-core']:GetCoreObject()

local isPhoneOpen = false
local isTyping = false
local currentApp = nil
local phoneProp = nil
local phoneNumber = nil

-- Telefon prop'u oluşturma
local function CreatePhoneProp()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local propModel = `prop_npc_phone_02`
    
    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Wait(0)
    end
    
    phoneProp = CreateObject(propModel, coords.x, coords.y, coords.z + 0.2, true, true, true)
    local boneIndex = GetPedBoneIndex(ped, 28405)
    
    AttachEntityToEntity(phoneProp, ped, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    SetEntityAsMissionEntity(phoneProp, true, true)
    SetEntityVisible(phoneProp, true, true)
end

-- Telefon prop'unu silme
local function DeletePhoneProp()
    if phoneProp then
        DeleteEntity(phoneProp)
        phoneProp = nil
    end
end

-- Telefon animasyonu
local function PlayPhoneAnimation()
    local ped = PlayerPedId()
    local dict = "cellphone@"
    local anim = "cellphone_text_read_base"
    
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 49, 0, false, false, false)
end

-- Telefon animasyonunu durdurma
local function StopPhoneAnimation()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
end

-- Telefon açma/kapama
RegisterNetEvent('aendir:client:TogglePhone', function()
    if not isPhoneOpen then
        -- Telefonu aç
        if not HasPhone() then
            TriggerEvent('aendir:client:Notification', 'error', 'Telefonunuz yok!')
            return
        end
        
        if not HasSimCard() then
            TriggerEvent('aendir:client:Notification', 'error', 'SIM kartınız yok!')
            return
        end
        
        isPhoneOpen = true
        CreatePhoneProp()
        PlayPhoneAnimation()
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openPhone",
            phoneNumber = phoneNumber
        })
    else
        -- Telefonu kapat
        isPhoneOpen = false
        DeletePhoneProp()
        StopPhoneAnimation()
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = "closePhone"
        })
    end
end)

-- Telefon kontrolü
RegisterNUICallback('closePhone', function(data, cb)
    isPhoneOpen = false
    DeletePhoneProp()
    StopPhoneAnimation()
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Mesaj yazma başlangıcı
RegisterNUICallback('startTyping', function(data, cb)
    isTyping = true
    DisablePlayerFiring(PlayerId(), true)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 47, true)
    DisableControlAction(0, 58, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 264, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 143, true)
    DisableControlAction(0, 75, true)
    DisableControlAction(27, 75, true)
    cb('ok')
end)

-- Mesaj yazma bitişi
RegisterNUICallback('stopTyping', function(data, cb)
    isTyping = false
    EnableAllControlActions(0)
    cb('ok')
end)

-- Mesaj gönderme
RegisterNUICallback('sendMessage', function(data, cb)
    TriggerServerEvent('aendir:server:SendMessage', data.number, data.message)
    cb('ok')
end)

-- Arama yapma
RegisterNUICallback('makeCall', function(data, cb)
    TriggerServerEvent('aendir:server:MakeCall', data.number)
    cb('ok')
end)

-- Arama cevaplama
RegisterNUICallback('answerCall', function(data, cb)
    TriggerServerEvent('aendir:server:AnswerCall', data.number)
    cb('ok')
end)

-- Arama reddetme
RegisterNUICallback('rejectCall', function(data, cb)
    TriggerServerEvent('aendir:server:RejectCall', data.number)
    cb('ok')
end)

-- Telefon numarası alma
RegisterNetEvent('aendir:client:SetPhoneNumber', function(number)
    phoneNumber = number
end)

-- Arama gelme bildirimi
RegisterNetEvent('aendir:client:IncomingCall', function(number)
    if isPhoneOpen then
        SendNUIMessage({
            action = "incomingCall",
            number = number
        })
    end
end)

-- Arama başlatma
RegisterNetEvent('aendir:client:StartCall', function(number)
    if isPhoneOpen then
        SendNUIMessage({
            action = "startCall",
            number = number
        })
    end
end)

-- Arama sonlandırma
RegisterNetEvent('aendir:client:EndCall', function(number)
    if isPhoneOpen then
        SendNUIMessage({
            action = "endCall",
            number = number
        })
    end
end)

-- Mesaj alma
RegisterNetEvent('aendir:client:ReceiveMessage', function(number, message)
    if isPhoneOpen then
        SendNUIMessage({
            action = "receiveMessage",
            number = number,
            message = message
        })
    end
end)

-- Komutlar
RegisterCommand('telefon', function()
    TriggerEvent('aendir:client:TogglePhone')
end)

-- Keybinds
RegisterKeyMapping('telefon', 'Telefon menüsünü aç', 'keyboard', 'M') 