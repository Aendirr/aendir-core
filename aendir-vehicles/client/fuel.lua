local AendirCore = exports['aendir-core']:GetCoreObject()

-- Yakıt Sistemi
local fuelStations = {
    {x = 49.4187, y = 2778.793, z = 58.043},
    {x = 263.894, y = 2606.463, z = 44.983},
    {x = 1039.958, y = 2671.134, z = 39.550},
    {x = 1207.260, y = 2660.175, z = 37.899},
    {x = 2539.685, y = 2594.192, z = 37.944},
    {x = 2679.858, y = 3263.946, z = 55.240},
    {x = 2005.055, y = 3773.887, z = 32.403},
    {x = 1687.156, y = 4929.392, z = 42.078},
    {x = 1701.314, y = 6416.028, z = 32.763},
    {x = 179.857, y = 6602.839, z = 31.868},
    {x = -94.4619, y = 6419.594, z = 31.489},
    {x = -2554.996, y = 2334.40, z = 33.078},
    {x = -1800.375, y = 803.661, z = 138.651},
    {x = -1437.622, y = -276.747, z = 46.207},
    {x = -2096.243, y = -320.286, z = 13.168},
    {x = -724.619, y = -935.1631, z = 19.213},
    {x = -526.019, y = -1211.003, z = 18.184},
    {x = -70.2148, y = -1761.792, z = 29.534},
    {x = 265.648, y = -1261.309, z = 29.292},
    {x = 819.653, y = -1027.883, z = 26.403},
    {x = 1208.951, y = -1402.567, z = 35.224},
    {x = 1181.381, y = -330.847, z = 69.316},
    {x = 620.843, y = 269.100, z = 103.089},
    {x = 2581.321, y = 362.039, z = 108.468},
    {x = 1785.363, y = 3330.372, z = 41.381}
}

-- Yakıt İstasyonu Blip'leri
CreateThread(function()
    for _, station in ipairs(fuelStations) do
        local blip = AddBlipForCoord(station.x, station.y, station.z)
        SetBlipSprite(blip, 361)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Yakıt İstasyonu')
        EndTextCommandSetBlipName(blip)
    end
end)

-- Yakıt İstasyonu Marker'ları
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, station in ipairs(fuelStations) do
            local distance = #(coords - vector3(station.x, station.y, station.z))
            
            if distance < 10.0 then
                DrawMarker(1, station.x, station.y, station.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 255, 0, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 3.0 then
                    if IsPedInAnyVehicle(playerPed, false) then
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        local fuel = GetVehicleFuelLevel(vehicle)
                        
                        if fuel < 100.0 then
                            AendirCore.Functions.ShowHelpText('~INPUT_CONTEXT~ Yakıt Al')
                            
                            if IsControlJustPressed(0, 38) then -- E tuşu
                                TriggerServerEvent('aendir:server:RefuelVehicle', GetVehicleNumberPlateText(vehicle), 100.0 - fuel)
                            end
                        else
                            AendirCore.Functions.ShowHelpText('Yakıt deposu dolu')
                        end
                    else
                        AendirCore.Functions.ShowHelpText('Bir araçta olmalısınız')
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
        
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local fuel = GetVehicleFuelLevel(vehicle)
            
            if fuel > 0.0 then
                local speed = GetEntitySpeed(vehicle)
                local rpm = GetVehicleCurrentRpm(vehicle)
                local consumption = (speed * 0.01) + (rpm * 0.1)
                
                SetVehicleFuelLevel(vehicle, fuel - consumption)
                
                if fuel < 10.0 then
                    AendirCore.Functions.ShowNotification('Yakıt azalıyor!', 'warning')
                end
            else
                SetVehicleEngineOn(vehicle, false, true, true)
                AendirCore.Functions.ShowNotification('Yakıt bitti!', 'error')
            end
        end
    end
end)

-- Yakıt Durumu Senkronizasyonu
RegisterNetEvent('aendir:client:SyncVehicleFuel', function(plate, fuel)
    local vehicle = GetVehicleByPlate(plate)
    if DoesEntityExist(vehicle) then
        SetVehicleFuelLevel(vehicle, fuel)
    end
end) 