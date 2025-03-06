local QBCore = exports['qb-core']:GetCoreObject()
local isRefueling = false

-- Blip Oluşturma
CreateThread(function()
    for _, station in pairs(Config.FuelStations) do
        local blip = AddBlipForCoord(station.coords.x, station.coords.y, station.coords.z)
        SetBlipSprite(blip, station.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, station.blip.scale)
        SetBlipColour(blip, station.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(station.blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Yakıt Doldurma
function StartRefueling(vehicle)
    if isRefueling then return end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    
    QBCore.Functions.TriggerCallback('aendir:server:CheckVehicleOwnership', function(owned)
        if owned then
            isRefueling = true
            
            -- Animasyon
            local playerPed = PlayerPedId()
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
            
            -- Progress Bar
            if lib.progressBar({
                duration = 5000,
                label = 'Yakıt Dolduruluyor...'
            }) then
                -- Yakıt Doldurma
                QBCore.Functions.TriggerCallback('aendir:server:RefuelVehicle', function(success)
                    if success then
                        SetVehicleFuelLevel(vehicle, 100.0)
                        QBCore.Functions.Notify('Yakıt dolduruldu!', 'success')
                    else
                        QBCore.Functions.Notify('Yeterli paranız yok!', 'error')
                    end
                end, plate)
            end
            
            ClearPedTasks(playerPed)
            isRefueling = false
        else
            QBCore.Functions.Notify('Bu araç size ait değil!', 'error')
        end
    end, plate)
end

-- Yakıt İstasyonu Kontrolü
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, station in pairs(Config.FuelStations) do
            local distance = #(coords - station.coords)
            
            if distance < 10.0 then
                DrawMarker(1, station.coords.x, station.coords.y, station.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 2.0 then
                    if IsControlJustPressed(0, 38) then -- E tuşu
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        if vehicle ~= 0 then
                            StartRefueling(vehicle)
                        else
                            QBCore.Functions.Notify('Bir araçta olmalısınız!', 'error')
                        end
                    end
                end
            end
        end
    end
end)

-- Yakıt Tüketimi
CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if vehicle ~= 0 then
            local plate = GetVehicleNumberPlateText(vehicle)
            local fuel = GetVehicleFuelLevel(vehicle)
            local speed = GetEntitySpeed(vehicle)
            
            if speed > 0 then
                local consumption = speed * Config.FuelConsumption
                local newFuel = fuel - consumption
                
                if newFuel < 0 then
                    newFuel = 0
                end
                
                SetVehicleFuelLevel(vehicle, newFuel)
                
                -- Yakıt Kaydetme
                TriggerServerEvent('aendir:server:UpdateVehicleFuel', plate, newFuel)
                
                -- Yakıt Bittiğinde
                if newFuel <= 0 then
                    SetVehicleEngineOn(vehicle, false, true, true)
                    QBCore.Functions.Notify('Yakıtınız bitti!', 'error')
                end
            end
        end
    end
end) 