local AendirCore = exports['aendir-core']:GetCoreObject()

-- Hasar Sistemi
local repairShops = {
    {x = -347.291, y = -133.0, z = 39.009},
    {x = -1155.536, y = -2007.183, z = 13.180},
    {x = -731.105, y = -283.263, z = 36.848},
    {x = -275.522, y = 6225.835, z = 31.485},
    {x = 191.979, y = -3030.733, z = 5.907},
    {x = 1174.76, y = 2640.925, z = 37.754},
    {x = 1108.72, y = -778.105, z = 58.289},
    {x = 937.237, y = -970.38, z = 39.569},
    {x = 540.409, y = -183.651, z = 54.481},
    {x = -211.55, y = -1324.55, z = 31.089},
    {x = -458.679, y = -356.481, z = 34.244},
    {x = -1282.54, y = -1115.322, z = 6.99},
    {x = 17.597, y = -1096.362, z = 26.677},
    {x = 386.513, y = -1641.226, z = 29.291},
    {x = -48.519, y = -1757.514, z = 29.421},
    {x = 358.916, y = -1790.502, z = 28.966},
    {x = 481.8, y = -1318.62, z = 29.21},
    {x = -272.038, y = -955.759, z = 31.223},
    {x = -1904.664, y = 285.907, z = 81.969},
    {x = -1420.188, y = -441.874, z = 35.909},
    {x = -338.921, y = -135.592, z = 39.009},
    {x = -661.354, y = -935.961, z = 21.829},
    {x = -1155.536, y = -2007.183, z = 13.180},
    {x = -731.105, y = -283.263, z = 36.848},
    {x = -275.522, y = 6225.835, z = 31.485}
}

-- Tamir İstasyonu Blip'leri
CreateThread(function()
    for _, shop in ipairs(repairShops) do
        local blip = AddBlipForCoord(shop.x, shop.y, shop.z)
        SetBlipSprite(blip, 446)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 5)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Tamir İstasyonu')
        EndTextCommandSetBlipName(blip)
    end
end)

-- Tamir İstasyonu Marker'ları
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, shop in ipairs(repairShops) do
            local distance = #(coords - vector3(shop.x, shop.y, shop.z))
            
            if distance < 10.0 then
                DrawMarker(1, shop.x, shop.y, shop.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 3.0 then
                    if IsPedInAnyVehicle(playerPed, false) then
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        local bodyHealth = GetVehicleBodyHealth(vehicle)
                        local engineHealth = GetVehicleEngineHealth(vehicle)
                        
                        if bodyHealth < 1000.0 or engineHealth < 1000.0 then
                            AendirCore.Functions.ShowHelpText('~INPUT_CONTEXT~ Aracı Tamir Et')
                            
                            if IsControlJustPressed(0, 38) then -- E tuşu
                                TriggerServerEvent('aendir:server:RepairVehicle', GetVehicleNumberPlateText(vehicle))
                            end
                        else
                            AendirCore.Functions.ShowHelpText('Araç hasarlı değil')
                        end
                    else
                        AendirCore.Functions.ShowHelpText('Bir araçta olmalısınız')
                    end
                end
            end
        end
    end
end)

-- Hasar Takibi
CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local bodyHealth = GetVehicleBodyHealth(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            
            if bodyHealth < 500.0 or engineHealth < 500.0 then
                AendirCore.Functions.ShowNotification('Araç ciddi hasar aldı!', 'error')
            end
            
            if engineHealth < 300.0 then
                SetVehicleEngineOn(vehicle, false, true, true)
                AendirCore.Functions.ShowNotification('Motor arızalandı!', 'error')
            end
        end
    end
end)

-- Hasar Durumu Senkronizasyonu
RegisterNetEvent('aendir:client:SyncVehicleDamage', function(plate, bodyHealth, engineHealth)
    local vehicle = GetVehicleByPlate(plate)
    if DoesEntityExist(vehicle) then
        SetVehicleBodyHealth(vehicle, bodyHealth)
        SetVehicleEngineHealth(vehicle, engineHealth)
    end
end)

-- Çarpışma Hasarı
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkVehicleCollision' then
        local vehicle = args[1]
        local damage = args[2]
        
        if IsPedInAnyVehicle(PlayerPedId(), false) and GetVehiclePedIsIn(PlayerPedId(), false) == vehicle then
            local bodyHealth = GetVehicleBodyHealth(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            
            SetVehicleBodyHealth(vehicle, bodyHealth - damage)
            SetVehicleEngineHealth(vehicle, engineHealth - (damage * 0.5))
            
            TriggerServerEvent('aendir:server:UpdateVehicleDamage', GetVehicleNumberPlateText(vehicle), bodyHealth - damage, engineHealth - (damage * 0.5))
        end
    end
end) 