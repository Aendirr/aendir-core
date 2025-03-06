local QBCore = exports['qb-core']:GetCoreObject()
local currentVehicle = nil
local isRepairing = false

-- Tamir Noktaları
local repairShops = {
    {
        name = "LS Customs",
        coords = vector3(-347.4, -133.0, 39.0),
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.8,
            label = "LS Customs"
        }
    },
    {
        name = "Benny's Original",
        coords = vector3(-205.7, -1312.7, 31.1),
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.8,
            label = "Benny's Original"
        }
    },
    {
        name = "Mors Mutual",
        coords = vector3(-273.8, -955.8, 31.2),
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.8,
            label = "Mors Mutual"
        }
    }
}

-- Blip Oluşturma
CreateThread(function()
    for _, shop in pairs(repairShops) do
        local blip = AddBlipForCoord(shop.coords)
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
function OpenRepairMenu(shop)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        QBCore.Functions.Notify('Bir araçta olmalısınız!', 'error')
        return
    end
    
    currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local plate = GetVehicleNumberPlateText(currentVehicle)
    
    -- Araç Kontrolü
    QBCore.Functions.TriggerCallback('aendir:server:CheckVehicleOwnership', function(owned)
        if owned then
            local bodyHealth = GetVehicleBodyHealth(currentVehicle)
            local engineHealth = GetVehicleEngineHealth(currentVehicle)
            local price = CalculateRepairPrice(bodyHealth, engineHealth)
            
            local elements = {
                {
                    title = "Tamir Et",
                    description = string.format("Fiyat: $%s\nGövde: %d%%\nMotor: %d%%", 
                        price,
                        math.floor(bodyHealth / 10),
                        math.floor(engineHealth / 10)
                    ),
                    event = "aendir:client:RepairVehicle",
                    args = {
                        plate = plate,
                        price = price
                    }
                }
            }
            
            lib.registerContext({
                id = 'repair_menu',
                title = shop.name,
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
    
    isRepairing = true
    
    -- Animasyon
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
    
    -- Progress Bar
    QBCore.Functions.Progressbar("repairing", "Araç tamir ediliyor...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(playerPed)
        TriggerServerEvent('aendir:server:RepairVehicle', data.plate, data.price)
        isRepairing = false
        currentVehicle = nil
    end, function() -- Cancel
        ClearPedTasks(playerPed)
        isRepairing = false
        currentVehicle = nil
    end)
end)

-- Tamir Noktalarını Kontrol Etme
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, shop in pairs(repairShops) do
            local distance = #(coords - shop.coords)
            
            if distance < 2.0 then
                DrawText3D(shop.coords.x, shop.coords.y, shop.coords.z + 1.0, '~g~E~w~ - ' .. shop.name)
                
                if IsControlJustPressed(0, 38) then -- E tuşu
                    OpenRepairMenu(shop)
                end
            end
        end
    end
end)

-- Hasar Sistemi
CreateThread(function()
    while true do
        Wait(1000)
        
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local plate = GetVehicleNumberPlateText(vehicle)
            
            -- Hasar Kontrolü
            local bodyHealth = GetVehicleBodyHealth(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            
            -- Hasar Kaydetme
            if bodyHealth < 1000.0 or engineHealth < 1000.0 then
                TriggerServerEvent('aendir:server:UpdateVehicleDamage', plate, bodyHealth, engineHealth)
            end
            
            -- Motor Durumu
            if engineHealth < 300.0 then
                SetVehicleEngineOn(vehicle, false, true, true)
                QBCore.Functions.Notify('Motor arızası!', 'error')
            end
        end
    end
end)

-- Yardımcı Fonksiyonlar
function CalculateRepairPrice(bodyHealth, engineHealth)
    local basePrice = 1000
    local bodyDamage = (1000 - bodyHealth) / 10
    local engineDamage = (1000 - engineHealth) / 10
    
    return math.floor(basePrice + (bodyDamage + engineDamage) * 100)
end

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