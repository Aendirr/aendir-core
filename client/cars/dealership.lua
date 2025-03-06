local QBCore = exports['qb-core']:GetCoreObject()
local currentVehicle = nil
local testDriveVehicle = nil
local isTestDriving = false

-- Araç Showroom Noktaları
local dealerships = {
    {
        name = "Premium Motorsport",
        coords = vector3(-45.2, -1758.8, 29.4),
        vehicles = {
            {model = "adder", label = "Adder", price = 1000000},
            {model = "zentorno", label = "Zentorno", price = 950000},
            {model = "t20", label = "T20", price = 900000},
            {model = "entityxf", label = "Entity XF", price = 850000},
            {model = "nero", label = "Nero", price = 800000}
        },
        blip = {
            sprite = 225,
            color = 2,
            scale = 0.8,
            label = "Premium Motorsport"
        }
    },
    {
        name = "Luxury Auto",
        coords = vector3(-795.0, -220.2, 37.1),
        vehicles = {
            {model = "schafter3", label = "Schafter", price = 40000},
            {model = "tailgater", label = "Tailgater", price = 35000},
            {model = "felon", label = "Felon", price = 45000},
            {model = "oracle", label = "Oracle", price = 30000},
            {model = "washington", label = "Washington", price = 25000}
        },
        blip = {
            sprite = 225,
            color = 2,
            scale = 0.8,
            label = "Luxury Auto"
        }
    },
    {
        name = "Süper Otomobil",
        coords = vector3(-33.7, -1102.0, 26.4),
        vehicles = {
            {model = "blista", label = "Blista", price = 15000},
            {model = "brioso", label = "Brioso", price = 18000},
            {model = "issi2", label = "Issi", price = 12000},
            {model = "panto", label = "Panto", price = 10000},
            {model = "prairie", label = "Prairie", price = 14000}
        },
        blip = {
            sprite = 225,
            color = 2,
            scale = 0.8,
            label = "Süper Otomobil"
        }
    }
}

-- Blip Oluşturma
CreateThread(function()
    for _, dealership in pairs(dealerships) do
        local blip = AddBlipForCoord(dealership.coords)
        SetBlipSprite(blip, dealership.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, dealership.blip.scale)
        SetBlipColour(blip, dealership.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(dealership.blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Araç Satın Alma Menüsü
function OpenDealershipMenu(dealership)
    local elements = {}
    
    for _, vehicle in pairs(dealership.vehicles) do
        table.insert(elements, {
            title = vehicle.label,
            description = "Fiyat: $" .. vehicle.price,
            event = "aendir:client:SelectVehicle",
            args = {
                dealership = dealership,
                vehicle = vehicle
            }
        })
    end
    
    lib.registerContext({
        id = 'dealership_menu',
        title = dealership.name,
        options = elements
    })
    
    lib.showContext('dealership_menu')
end

-- Araç Seçme
RegisterNetEvent('aendir:client:SelectVehicle', function(data)
    local dealership = data.dealership
    local vehicle = data.vehicle
    
    local elements = {
        {
            title = "Satın Al",
            description = "Fiyat: $" .. vehicle.price,
            event = "aendir:client:BuyVehicle",
            args = {
                dealership = dealership,
                vehicle = vehicle
            }
        },
        {
            title = "Test Sürüşü",
            description = "Ücretsiz test sürüşü yapın",
            event = "aendir:client:TestDrive",
            args = {
                dealership = dealership,
                vehicle = vehicle
            }
        }
    }
    
    lib.registerContext({
        id = 'vehicle_options',
        title = vehicle.label,
        menu = 'dealership_menu',
        options = elements
    })
    
    lib.showContext('vehicle_options')
end)

-- Araç Satın Alma
RegisterNetEvent('aendir:client:BuyVehicle', function(data)
    local dealership = data.dealership
    local vehicle = data.vehicle
    
    TriggerServerEvent('aendir:server:BuyVehicle', {
        model = vehicle.model,
        price = vehicle.price
    })
end)

-- Test Sürüşü
RegisterNetEvent('aendir:client:TestDrive', function(data)
    if isTestDriving then return end
    
    local dealership = data.dealership
    local vehicle = data.vehicle
    
    -- Araç Spawn Etme
    local hash = GetHashKey(vehicle.model)
    RequestModel(hash)
    
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    
    local spawnCoords = vector4(dealership.coords.x + 5.0, dealership.coords.y, dealership.coords.z, dealership.coords.w)
    testDriveVehicle = CreateVehicle(hash, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, true, false)
    
    -- Araç Özellikleri
    SetEntityAsMissionEntity(testDriveVehicle, true, true)
    SetVehicleOnGroundProperly(testDriveVehicle)
    SetVehicleDoorsLocked(testDriveVehicle, 1)
    
    -- Test Sürüşü Başlatma
    isTestDriving = true
    currentVehicle = vehicle
    
    -- Bildirim
    QBCore.Functions.Notify('Test sürüşü başladı! 2 dakika içinde geri dönün.', 'primary')
    
    -- Timer
    SetTimeout(120000, function() -- 2 dakika
        if isTestDriving then
            EndTestDrive()
        end
    end)
end)

-- Test Sürüşü Bitirme
function EndTestDrive()
    if not isTestDriving then return end
    
    isTestDriving = false
    
    if DoesEntityExist(testDriveVehicle) then
        DeleteEntity(testDriveVehicle)
        testDriveVehicle = nil
    end
    
    currentVehicle = nil
    
    QBCore.Functions.Notify('Test sürüşü bitti!', 'error')
end

-- Showroom Noktalarını Kontrol Etme
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, dealership in pairs(dealerships) do
            local distance = #(coords - dealership.coords)
            
            if distance < 2.0 then
                DrawText3D(dealership.coords.x, dealership.coords.y, dealership.coords.z + 1.0, '~g~E~w~ - ' .. dealership.name)
                
                if IsControlJustPressed(0, 38) then -- E tuşu
                    OpenDealershipMenu(dealership)
                end
            end
        end
    end
end)

-- Yardımcı Fonksiyonlar
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0+0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end 