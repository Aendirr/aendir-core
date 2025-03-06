-- Oyuncu Durumu
CreateThread(function()
    while true do
        Wait(1000)
        if PlayerLoaded then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            
            -- Pozisyon Güncelleme
            TriggerServerEvent('aendir:server:UpdatePosition', vector4(coords.x, coords.y, coords.z, heading))
            
            -- Ölüm Kontrolü
            if IsEntityDead(ped) and not PlayerData.metadata.isdead then
                TriggerEvent('aendir:client:OnDeath')
            end
            
            -- Son Durum Kontrolü
            if GetEntityHealth(ped) <= 150 and not PlayerData.metadata.inlaststand then
                TriggerEvent('aendir:client:OnLastStand')
            end
            
            -- Hapishane Kontrolü
            if PlayerData.metadata.jail > 0 then
                PlayerData.metadata.jail = PlayerData.metadata.jail - 1
                
                if PlayerData.metadata.jail <= 0 then
                    TriggerEvent('aendir:client:OnJailRelease')
                end
            end
            
            -- Stres Kontrolü
            if PlayerData.metadata.stress > 0 then
                PlayerData.metadata.stress = PlayerData.metadata.stress - 1
            end
            
            -- Açlık Kontrolü
            if PlayerData.metadata.hunger > 0 then
                PlayerData.metadata.hunger = PlayerData.metadata.hunger - 1
                
                if PlayerData.metadata.hunger <= 0 then
                    TriggerEvent('aendir:client:OnHunger')
                end
            end
            
            -- Susuzluk Kontrolü
            if PlayerData.metadata.thirst > 0 then
                PlayerData.metadata.thirst = PlayerData.metadata.thirst - 1
                
                if PlayerData.metadata.thirst <= 0 then
                    TriggerEvent('aendir:client:OnThirst')
                end
            end
        end
    end
end)

-- Araç Kontrolü
CreateThread(function()
    while true do
        Wait(0)
        if PlayerLoaded then
            local ped = PlayerPedId()
            
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                
                -- Motor Kontrolü
                if IsControlJustPressed(0, 244) then -- M
                    local engine = GetIsVehicleEngineRunning(vehicle)
                    SetVehicleEngineOn(vehicle, not engine, false, true)
                    
                    if not engine then
                        AendirCore.Functions.ShowNotification('Motor çalıştırıldı', 'success')
                    else
                        AendirCore.Functions.ShowNotification('Motor durduruldu', 'error')
                    end
                end
                
                -- Kapı Kontrolü
                if IsControlJustPressed(0, 173) then -- U
                    local door = GetVehicleDoorAngleRatio(vehicle, 0)
                    if door > 0.0 then
                        SetVehicleDoorShut(vehicle, 0, false)
                        AendirCore.Functions.ShowNotification('Kapı kapatıldı', 'success')
                    else
                        SetVehicleDoorOpen(vehicle, 0, false, false)
                        AendirCore.Functions.ShowNotification('Kapı açıldı', 'success')
                    end
                end
                
                -- Bagaj Kontrolü
                if IsControlJustPressed(0, 47) then -- G
                    local trunk = GetVehicleDoorAngleRatio(vehicle, 5)
                    if trunk > 0.0 then
                        SetVehicleDoorShut(vehicle, 5, false)
                        AendirCore.Functions.ShowNotification('Bagaj kapatıldı', 'success')
                    else
                        SetVehicleDoorOpen(vehicle, 5, false, false)
                        AendirCore.Functions.ShowNotification('Bagaj açıldı', 'success')
                    end
                end
            end
        end
    end
end)

-- Hasar Kontrolü
CreateThread(function()
    while true do
        Wait(1000)
        if PlayerLoaded then
            local ped = PlayerPedId()
            
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local bodyHealth = GetVehicleBodyHealth(vehicle)
                local engineHealth = GetVehicleEngineHealth(vehicle)
                
                -- Hasar Bildirimi
                if bodyHealth < 500.0 or engineHealth < 500.0 then
                    AendirCore.Functions.ShowNotification('Araç ciddi hasar aldı!', 'warning')
                end
                
                -- Motor Arıza Bildirimi
                if engineHealth < 300.0 then
                    SetVehicleEngineOn(vehicle, false, true, true)
                    AendirCore.Functions.ShowNotification('Motor arızalandı!', 'error')
                end
            end
        end
    end
end)

-- Yakıt Kontrolü
CreateThread(function()
    while true do
        Wait(1000)
        if PlayerLoaded then
            local ped = PlayerPedId()
            
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local fuel = GetVehicleFuelLevel(vehicle)
                
                -- Yakıt Bildirimi
                if fuel < 10.0 then
                    AendirCore.Functions.ShowNotification('Yakıt azalıyor!', 'warning')
                end
                
                -- Yakıt Bitti Bildirimi
                if fuel <= 0.0 then
                    SetVehicleEngineOn(vehicle, false, true, true)
                    AendirCore.Functions.ShowNotification('Yakıt bitti!', 'error')
                end
            end
        end
    end
end)

-- Animasyon Kontrolü
CreateThread(function()
    while true do
        Wait(0)
        if PlayerLoaded then
            local ped = PlayerPedId()
            
            -- Yürüme Animasyonu
            if IsPedWalking(ped) then
                SetPedMovementClipset(ped, "move_m@hiking@b", 0.2)
            end
            
            -- Koşma Animasyonu
            if IsPedRunning(ped) then
                SetPedMovementClipset(ped, "move_m@hiking@a", 0.2)
            end
            
            -- Sprint Animasyonu
            if IsPedSprinting(ped) then
                SetPedMovementClipset(ped, "move_m@hiking@c", 0.2)
            end
        end
    end
end) 