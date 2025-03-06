-- Animasyonlar
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Değişkenler
local isPlayingAnim = false
local currentAnim = nil
local currentDict = nil

-- Animasyon Fonksiyonları
local function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function PlayAnimation(dict, anim, flag)
    if not isPlayingAnim then
        LoadAnimDict(dict)
        TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, -1, flag, 0, false, false, false)
        isPlayingAnim = true
        currentAnim = anim
        currentDict = dict
    end
end

local function StopAnimation()
    if isPlayingAnim then
        ClearPedTasks(PlayerPedId())
        isPlayingAnim = false
        currentAnim = nil
        currentDict = nil
    end
end

-- Animasyon Tanımlamaları
local Animations = {
    idle = {
        dict = 'anim@mp_player_intcelebrationmaleidles',
        anim = 'idle',
        flag = 1
    },
    wave = {
        dict = 'anim@mp_player_intcelebrationmalewave',
        anim = 'wave',
        flag = 1
    },
    salute = {
        dict = 'anim@mp_player_intcelebrationmalesalute',
        anim = 'salute',
        flag = 1
    },
    cheer = {
        dict = 'anim@mp_player_intcelebrationmalecheer',
        anim = 'cheer',
        flag = 1
    },
    dance = {
        dict = 'anim@mp_player_intcelebrationmaledance',
        anim = 'dance',
        flag = 1
    },
    sit = {
        dict = 'anim@mp_player_intcelebrationmalesit',
        anim = 'sit',
        flag = 1
    },
    stand = {
        dict = 'anim@mp_player_intcelebrationmalestand',
        anim = 'stand',
        flag = 1
    },
    walk = {
        dict = 'anim@mp_player_intcelebrationmalewalk',
        anim = 'walk',
        flag = 1
    },
    run = {
        dict = 'anim@mp_player_intcelebrationmalerun',
        anim = 'run',
        flag = 1
    },
    jump = {
        dict = 'anim@mp_player_intcelebrationmalejump',
        anim = 'jump',
        flag = 1
    },
    crouch = {
        dict = 'anim@mp_player_intcelebrationmalecrouch',
        anim = 'crouch',
        flag = 1
    },
    lean = {
        dict = 'anim@mp_player_intcelebrationmalelean',
        anim = 'lean',
        flag = 1
    },
    point = {
        dict = 'anim@mp_player_intcelebrationmalepoint',
        anim = 'point',
        flag = 1
    },
    shrug = {
        dict = 'anim@mp_player_intcelebrationmaleshrug',
        anim = 'shrug',
        flag = 1
    },
    stretch = {
        dict = 'anim@mp_player_intcelebrationmalestretch',
        anim = 'stretch',
        flag = 1
    },
    yawn = {
        dict = 'anim@mp_player_intcelebrationmaleyawn',
        anim = 'yawn',
        flag = 1
    },
    laugh = {
        dict = 'anim@mp_player_intcelebrationmalelaugh',
        anim = 'laugh',
        flag = 1
    },
    cry = {
        dict = 'anim@mp_player_intcelebrationmalecry',
        anim = 'cry',
        flag = 1
    },
    angry = {
        dict = 'anim@mp_player_intcelebrationmaleangry',
        anim = 'angry',
        flag = 1
    },
    scared = {
        dict = 'anim@mp_player_intcelebrationmalescared',
        anim = 'scared',
        flag = 1
    },
    surprised = {
        dict = 'anim@mp_player_intcelebrationmalesurprised',
        anim = 'surprised',
        flag = 1
    },
    confused = {
        dict = 'anim@mp_player_intcelebrationmaleconfused',
        anim = 'confused',
        flag = 1
    },
    thinking = {
        dict = 'anim@mp_player_intcelebrationmalethinking',
        anim = 'thinking',
        flag = 1
    },
    bored = {
        dict = 'anim@mp_player_intcelebrationmalebored',
        anim = 'bored',
        flag = 1
    },
    tired = {
        dict = 'anim@mp_player_intcelebrationmaletired',
        anim = 'tired',
        flag = 1
    },
    sick = {
        dict = 'anim@mp_player_intcelebrationmalesick',
        anim = 'sick',
        flag = 1
    },
    drunk = {
        dict = 'anim@mp_player_intcelebrationmaledrunk',
        anim = 'drunk',
        flag = 1
    },
    dead = {
        dict = 'anim@mp_player_intcelebrationmaledead',
        anim = 'dead',
        flag = 1
    }
}

-- Events
RegisterNetEvent('aendir:client:PlayAnimation', function(anim)
    if Animations[anim] then
        PlayAnimation(Animations[anim].dict, Animations[anim].anim, Animations[anim].flag)
    end
end)

RegisterNetEvent('aendir:client:StopAnimation', function()
    StopAnimation()
end)

-- Komutlar
RegisterCommand('anim', function(source, args)
    if args[1] then
        if Animations[args[1]] then
            PlayAnimation(Animations[args[1]].dict, Animations[args[1]].anim, Animations[args[1]].flag)
        else
            TriggerEvent('aendir:client:Notify', 'Geçersiz animasyon!', 'error')
        end
    else
        TriggerEvent('aendir:client:Notify', 'Kullanım: /anim [animasyon]', 'error')
    end
end, false)

RegisterCommand('stopanim', function()
    StopAnimation()
end, false)

-- Threads
CreateThread(function()
    while true do
        Wait(0)
        if isPlayingAnim then
            if not IsEntityPlayingAnim(PlayerPedId(), currentDict, currentAnim, 3) then
                StopAnimation()
            end
        end
    end
end) 