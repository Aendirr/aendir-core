-- Threads
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Maaş Ödemesi
CreateThread(function()
    while true do
        Wait(Config.PaymentInterval or 3600000) -- 1 saat
        
        local players = GetPlayers()
        for _, player in ipairs(players) do
            local license = GetPlayerIdentifier(player, 'license')
            local playerData = AendirCore.Functions.GetPlayer(license)
            
            if playerData then
                -- Meslek Maaşı
                local job = playerData.job
                if Config.Jobs[job.name] and Config.Jobs[job.name].grades[tostring(job.grade)] then
                    local payment = Config.Jobs[job.name].grades[tostring(job.grade)].payment
                    if payment > 0 then
                        AendirCore.Functions.AddMoney(license, 'bank', payment)
                        TriggerClientEvent('aendir:client:Notify', player, 'Maaşınız yatırıldı: $' .. payment, 'success')
                    end
                end
                
                -- Çete Maaşı
                local gang = playerData.gang
                if Config.Gangs[gang.name] and Config.Gangs[gang.name].grades[tostring(gang.grade)] then
                    local payment = Config.Gangs[gang.name].grades[tostring(gang.grade)].payment
                    if payment > 0 then
                        AendirCore.Functions.AddMoney(license, 'black', payment)
                        TriggerClientEvent('aendir:client:Notify', player, 'Çete maaşınız yatırıldı: $' .. payment, 'success')
                    end
                end
            end
        end
    end
end)

-- Metadata Güncelleme
CreateThread(function()
    while true do
        Wait(Config.MetadataInterval or 60000) -- 1 dakika
        
        local players = GetPlayers()
        for _, player in ipairs(players) do
            local license = GetPlayerIdentifier(player, 'license')
            local playerData = AendirCore.Functions.GetPlayer(license)
            
            if playerData then
                local ped = GetPlayerPed(player)
                
                -- Zırh
                playerData.metadata.armor = GetPedArmour(ped)
                
                -- Açlık ve Susuzluk
                if playerData.metadata.hunger > 0 then
                    playerData.metadata.hunger = playerData.metadata.hunger - 1
                end
                
                if playerData.metadata.thirst > 0 then
                    playerData.metadata.thirst = playerData.metadata.thirst - 1
                end
                
                -- Stres ve Sarhoşluk
                if playerData.metadata.stress > 0 then
                    playerData.metadata.stress = playerData.metadata.stress - 1
                end
                
                if playerData.metadata.drunk > 0 then
                    playerData.metadata.drunk = playerData.metadata.drunk - 1
                end
                
                AendirCore.Functions.UpdatePlayer(license, playerData)
                TriggerClientEvent('aendir:client:UpdateMetadata', player, playerData.metadata)
            end
        end
    end
end)

-- Araç Durumu
CreateThread(function()
    while true do
        Wait(Config.VehicleInterval or 300000) -- 5 dakika
        
        local vehicles = GetAllVehicles()
        for _, vehicle in ipairs(vehicles) do
            if DoesEntityExist(vehicle) then
                local plate = GetVehicleNumberPlateText(vehicle)
                local vehicleData = AendirCore.Functions.GetVehicle(plate)
                
                if vehicleData then
                    -- Yakıt
                    local fuel = GetVehicleFuelLevel(vehicle)
                    if fuel ~= vehicleData.fuel then
                        vehicleData.fuel = fuel
                    end
                    
                    -- Sağlık
                    local bodyHealth = GetVehicleBodyHealth(vehicle)
                    if bodyHealth ~= vehicleData.body_health then
                        vehicleData.body_health = bodyHealth
                    end
                    
                    local engineHealth = GetVehicleEngineHealth(vehicle)
                    if engineHealth ~= vehicleData.engine_health then
                        vehicleData.engine_health = engineHealth
                    end
                    
                    AendirCore.Functions.UpdateVehicle(plate, vehicleData)
                end
            end
        end
    end
end)

-- Ban Kontrolü
CreateThread(function()
    while true do
        Wait(Config.BanInterval or 300000) -- 5 dakika
        
        local bans = MySQL.query.await('SELECT * FROM bans WHERE duration > 0')
        for _, ban in ipairs(bans) do
            if (os.time() - ban.created_at) > ban.duration then
                AendirCore.Functions.DeleteBan(ban.license)
            end
        end
    end
end)

-- Sunucu Durumu
CreateThread(function()
    while true do
        Wait(Config.StatusInterval or 300000) -- 5 dakika
        
        local players = GetPlayers()
        local maxPlayers = GetConvarInt('sv_maxclients', 32)
        local uptime = os.time() - GetResourceMetadata(GetCurrentResourceName(), 'started_at', 0)
        
        local status = {
            players = #players,
            maxPlayers = maxPlayers,
            uptime = uptime,
            resources = GetNumResources()
        }
        
        TriggerClientEvent('aendir:client:UpdateStatus', -1, status)
    end
end) 