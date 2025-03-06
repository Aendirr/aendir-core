local QBCore = exports['qb-core']:GetCoreObject()
local isRepairing = false

-- Blip Oluşturma
CreateThread(function()
    for _, shop in pairs(Config.RepairShops) do
        local blip = AddBlipForCoord(shop.coords.x, shop.coords.y, shop.coords.z)
        SetBlipSprite(blip, shop.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, shop.blip.scale)
        SetBlipColour(blip, shop.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(shop.blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Tamir Menüsü
function OpenRepairMenu(vehicle)
    if isRepairing then return end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    
    QBCore.Functions.TriggerCallback('aendir:server:CheckVehicleOwnership', function(owned)
        if owned then
            local elements = {
                {
                    title = "Tamir Et",
                    description = string.format("Tamir Ücreti: $%d", Config.RepairPrice),
                    event = "aendir:client:RepairVehicle",
                    args = {
                        plate = plate
                    }
                },
                {
                    title = "Sigorta Talebi",
                    description = string.format("Sigorta Ücreti: $%d", Config.InsurancePrice),
                    event = "aendir:client:ClaimInsurance",
                    args = {
                        plate = plate
                    }
                }
            }
            
            lib.registerContext({
                id = 'repair_menu',
                title = 'Tamir Menüsü',
                options = elements
            })
            
            lib.showContext('repair_menu')
        else
            QBCore.Functions.Notify('Bu araç size ait değil!', 'error')
        end
    end, plate)
end

-- Tamir İşlemi
RegisterNetEvent('aendir:client:RepairVehicle', function(data)
    if isRepairing then return end
    
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    if plate ~= data.plate then return end
    
    isRepairing = true
    
    -- Animasyon
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
    
    -- Progress Bar
    if lib.progressBar({
        duration = 5000,
        label = 'Araç Tamir Ediliyor...'
    }) then
        -- Tamir
        QBCore.Functions.TriggerCallback('aendir:server:RepairVehicle', function(success)
            if success then
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                SetVehicleEngineOn(vehicle, true, true, true)
                QBCore.Functions.Notify('Araç tamir edildi!', 'success')
            else
                QBCore.Functions.Notify('Yeterli paranız yok!', 'error')
            end
        end, plate)
    end
    
    ClearPedTasks(playerPed)
    isRepairing = false
end)

-- Sigorta Talebi
RegisterNetEvent('aendir:client:ClaimInsurance', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    if plate ~= data.plate then return end
    
    TriggerServerEvent('aendir:server:ClaimInsurance', plate)
end)

-- Tamir Menüsünü Aç
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, shop in pairs(Config.RepairShops) do
            local distance = #(coords - shop.coords)
            
            if distance < 10.0 then
                DrawMarker(1, shop.coords.x, shop.coords.y, shop.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 2.0 then
                    if IsControlJustPressed(0, 38) then -- E tuşu
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        if vehicle ~= 0 then
                            OpenRepairMenu(vehicle)
                        else
                            QBCore.Functions.Notify('Bir araçta olmalısınız!', 'error')
                        end
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
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if vehicle ~= 0 then
            local plate = GetVehicleNumberPlateText(vehicle)
            local bodyHealth = GetVehicleBodyHealth(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            
            if bodyHealth < 1000.0 or engineHealth < 1000.0 then
                TriggerServerEvent('aendir:server:UpdateVehicleDamage', plate, bodyHealth, engineHealth)
            end
            
            if engineHealth < 300.0 then
                SetVehicleEngineOn(vehicle, false, true, true)
                QBCore.Functions.Notify('Motor arızası!', 'error')
            end
        end
    end
end) 
 