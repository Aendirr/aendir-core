local QBCore = exports['qb-core']:GetCoreObject()
local currentGarage = nil
local currentVehicle = nil

-- Garaj Noktaları
local garages = {
    {
        name = "Legion Square",
        coords = vector3(215.8, -810.2, 30.7),
        spawn = vector4(213.8, -809.2, 30.7, 144.5),
        blip = {
            sprite = 357,
            color = 3,
            scale = 0.8,
            label = "Legion Square Garaj"
        }
    },
    {
        name = "Pillbox",
        coords = vector3(273.7, -344.1, 44.9),
        spawn = vector4(270.7, -342.1, 44.9, 161.5),
        blip = {
            sprite = 357,
            color = 3,
            scale = 0.8,
            label = "Pillbox Garaj"
        }
    },
    {
        name = "LSPD",
        coords = vector3(458.7, -1017.4, 28.1),
        spawn = vector4(458.7, -1017.4, 28.1, 90.0),
        blip = {
            sprite = 357,
            color = 3,
            scale = 0.8,
            label = "LSPD Garaj"
        }
    },
    {
        name = "Sandy Shores",
        coords = vector3(1737.6, 3711.2, 34.1),
        spawn = vector4(1737.6, 3711.2, 34.1, 21.5),
        blip = {
            sprite = 357,
            color = 3,
            scale = 0.8,
            label = "Sandy Shores Garaj"
        }
    },
    {
        name = "Paleto Bay",
        coords = vector3(-275.5, 6635.8, 7.4),
        spawn = vector4(-275.5, 6635.8, 7.4, 49.5),
        blip = {
            sprite = 357,
            color = 3,
            scale = 0.8,
            label = "Paleto Bay Garaj"
        }
    }
}

-- Blip Oluşturma
CreateThread(function()
    for _, garage in pairs(garages) do
        local blip = AddBlipForCoord(garage.coords)
        SetBlipSprite(blip, garage.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, garage.blip.scale)
        SetBlipColour(blip, garage.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(garage.blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Garaj Menüsü
function OpenGarageMenu(garage)
    currentGarage = garage
    
    QBCore.Functions.TriggerCallback('aendir:server:GetPlayerVehicles', function(vehicles)
        local elements = {}
        
        for _, vehicle in pairs(vehicles) do
            local status = vehicle.stored and "Garajda" or "Dışarıda"
            local fuel = vehicle.properties.fuel
            
            table.insert(elements, {
                title = vehicle.plate,
                description = string.format("Model: %s\nDurum: %s\nYakıt: %d%%", vehicle.model, status, fuel),
                event = "aendir:client:VehicleAction",
                args = {
                    vehicle = vehicle,
                    garage = garage
                }
            })
        end
        
        lib.registerContext({
            id = 'garage_menu',
            title = garage.name,
            options = elements
        })
        
        lib.showContext('garage_menu')
    end)
end

-- Araç İşlemleri
RegisterNetEvent('aendir:client:VehicleAction', function(data)
    local vehicle = data.vehicle
    local garage = data.garage
    
    local elements = {}
    
    if vehicle.stored then
        table.insert(elements, {
            title = "Aracı Çıkar",
            description = "Aracınızı garajdan çıkarın",
            event = "aendir:client:TakeOutVehicle",
            args = {
                vehicle = vehicle,
                garage = garage
            }
        })
    else
        table.insert(elements, {
            title = "Aracı Park Et",
            description = "Aracınızı garaja park edin",
            event = "aendir:client:StoreVehicle",
            args = {
                vehicle = vehicle,
                garage = garage
            }
        })
    end
    
    table.insert(elements, {
        title = "Aracı Sat",
        description = "Aracınızı satın",
        event = "aendir:client:SellVehicle",
        args = {
            vehicle = vehicle
        }
    })
    
    lib.registerContext({
        id = 'vehicle_action',
        title = vehicle.plate,
        menu = 'garage_menu',
        options = elements
    })
    
    lib.showContext('vehicle_action')
end)

-- Araç Çıkarma
RegisterNetEvent('aendir:client:TakeOutVehicle', function(data)
    local vehicle = data.vehicle
    local garage = data.garage
    
    -- Araç Spawn Etme
    local hash = GetHashKey(vehicle.model)
    RequestModel(hash)
    
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    
    local spawnCoords = garage.spawn
    currentVehicle = CreateVehicle(hash, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, true, false)
    
    -- Araç Özellikleri
    SetEntityAsMissionEntity(currentVehicle, true, true)
    SetVehicleOnGroundProperly(currentVehicle)
    SetVehicleDoorsLocked(currentVehicle, 1)
    
    -- Modifiye Yükleme
    TriggerServerEvent('aendir:server:LoadVehicleMods', vehicle.plate)
    
    -- Veritabanı Güncelleme
    TriggerServerEvent('aendir:server:UpdateVehicleStatus', vehicle.plate, false)
    
    -- Bildirim
    QBCore.Functions.Notify('Aracınız hazır!', 'success')
end)

-- Araç Park Etme
RegisterNetEvent('aendir:client:StoreVehicle', function(data)
    local vehicle = data.vehicle
    local garage = data.garage
    
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        QBCore.Functions.Notify('Bir araçta olmalısınız!', 'error')
        return
    end
    
    local playerPed = PlayerPedId()
    local currentVehicle = GetVehiclePedIsIn(playerPed, false)
    local plate = GetVehicleNumberPlateText(currentVehicle)
    
    if plate == vehicle.plate then
        -- Araç Silme
        DeleteEntity(currentVehicle)
        
        -- Veritabanı Güncelleme
        TriggerServerEvent('aendir:server:UpdateVehicleStatus', plate, true)
        
        -- Bildirim
        QBCore.Functions.Notify('Aracınız garaja park edildi!', 'success')
    else
        QBCore.Functions.Notify('Bu araç size ait değil!', 'error')
    end
end)

-- Araç Satma
RegisterNetEvent('aendir:client:SellVehicle', function(data)
    local vehicle = data.vehicle
    
    local elements = {
        {
            title = "Satışı Onayla",
            description = "Aracınızı satmak istediğinize emin misiniz?",
            event = "aendir:client:ConfirmSale",
            args = {
                vehicle = vehicle
            }
        }
    }
    
    lib.registerContext({
        id = 'confirm_sale',
        title = "Satış Onayı",
        menu = 'vehicle_action',
        options = elements
    })
    
    lib.showContext('confirm_sale')
end)

-- Satış Onayı
RegisterNetEvent('aendir:client:ConfirmSale', function(data)
    local vehicle = data.vehicle
    
    TriggerServerEvent('aendir:server:SellVehicle', vehicle.plate)
end)

-- Garaj Noktalarını Kontrol Etme
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, garage in pairs(garages) do
            local distance = #(coords - garage.coords)
            
            if distance < 2.0 then
                DrawText3D(garage.coords.x, garage.coords.y, garage.coords.z + 1.0, '~g~E~w~ - ' .. garage.name)
                
                if IsControlJustPressed(0, 38) then -- E tuşu
                    OpenGarageMenu(garage)
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