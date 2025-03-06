local AendirCore = exports['aendir-core']:GetCoreObject()

-- Animasyon ve Ses Fonksiyonları
local function PlayAnimation(dict, anim)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
    RemoveAnimDict(dict)
end

local function PlaySound(soundName)
    PlaySoundFrontend(-1, soundName, "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
end

-- Araç İşlemleri için Animasyonlar ve Sesler
RegisterNetEvent('aendir:client:PlayRefuelAnimation', function()
    PlayAnimation("mini@repair", "fixing_a_ped")
    PlaySound("Start_Squelch")
end)

RegisterNetEvent('aendir:client:PlayRepairAnimation', function()
    PlayAnimation("mini@repair", "fixing_a_player")
    PlaySound("Start_Squelch")
end)

RegisterNetEvent('aendir:client:PlayModifyAnimation', function()
    PlayAnimation("mini@repair", "fixing_a_ped")
    PlaySound("Start_Squelch")
end)

RegisterNetEvent('aendir:client:PlayInsuranceAnimation', function()
    PlayAnimation("mp_common", "givetake1_a")
    PlaySound("Start_Squelch")
end)

RegisterNetEvent('aendir:client:PlayImpoundAnimation', function()
    PlayAnimation("mp_common", "givetake1_a")
    PlaySound("Start_Squelch")
end)

-- Araç Kontrolleri için Sesler
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            
            -- Motor Çalıştırma/Durdurma
            if IsControlJustPressed(0, 244) then -- M tuşu
                if not isEngineRunning then
                    PlaySound("Remote_Control_Fob")
                else
                    PlaySound("Remote_Control_Fob")
                end
            end
            
            -- Kilit Açma/Kapama
            if IsControlJustPressed(0, 303) then -- U tuşu
                if not isLocked then
                    PlaySound("Remote_Control_Fob")
                else
                    PlaySound("Remote_Control_Fob")
                end
            end
            
            -- Kapı Açma/Kapama
            if IsControlJustPressed(0, 47) then -- G tuşu
                local door = GetVehicleDoorAngleRatio(vehicle, 0)
                if door > 0.0 then
                    PlaySound("Remote_Control_Fob")
                else
                    PlaySound("Remote_Control_Fob")
                end
            end
        end
    end
end)

-- Araç Hasar Sesleri
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = GetEntitySpeed(vehicle)
            
            if HasEntityCollidedWithAnything(vehicle) and speed > 10.0 then
                PlaySound("Vehicle_Collision")
            end
            
            if GetVehicleEngineHealth(vehicle) < 300.0 then
                PlaySound("Engine_Failure")
            end
        end
    end
end)

-- Araç Yakıt Uyarı Sesi
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local fuel = GetVehicleFuelLevel(vehicle)
            
            if fuel < 20.0 and not hasPlayedLowFuelSound then
                PlaySound("Fuel_Low")
                hasPlayedLowFuelSound = true
            elseif fuel >= 20.0 then
                hasPlayedLowFuelSound = false
            end
        end
    end
end) 