local QBCore = exports['qb-core']:GetCoreObject()
local currentVehicle = nil
local isRefueling = false

-- Yakıt İstasyonları
local fuelStations = {
    {
        name = "Legion Square",
        coords = vector3(-724.6, -935.1, 19.2),
        blip = {
            sprite = 361,
            color = 1,
            scale = 0.8,
            label = "Yakıt İstasyonu"
        }
    },
    {
        name = "Grove Street",
        coords = vector3(-70.2, -1761.8, 29.5),
        blip = {
            sprite = 361,
            color = 1,
            scale = 0.8,
            label = "Yakıt İstasyonu"
        }
    },
    {
        name = "Mirror Park",
        coords = vector3(1039.8, -2671.1, 39.5),
        blip = {
            sprite = 361,
            color = 1,
            scale = 0.8,
            label = "Yakıt İstasyonu"
        }
    },
    {
        name = "Sandy Shores",
        coords = vector3(1039.8, -2671.1, 39.5),
        blip = {
            sprite = 361,
            color = 1,
            scale = 0.8,
            label = "Yakıt İstasyonu"
        }
    },
    {
        name = "Paleto Bay",
        coords = vector3(-70.2, -1761.8, 29.5),
        blip = {
            sprite = 361,
            color = 1,
            scale = 0.8,
            label = "Yakıt İstasyonu"
        }
    }
}

-- Blip Oluşturma
CreateThread(function()
    for _, station in pairs(fuelStations) do
        local blip = AddBlipForCoord(station.coords)
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
function StartRefueling(station)
    if isRefueling then return end
    
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        QBCore.Functions.Notify('Bir araçta olmalısınız!', 'error')
        return
    end
    
    currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local plate = GetVehicleNumberPlateText(currentVehicle)
    
    -- Araç Kontrolü
    QBCore.Functions.TriggerCallback('aendir:server:CheckVehicleOwnership', function(owned)
        if owned then
            isRefueling = true
            
            -- Animasyon
            local playerPed = PlayerPedId()
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
            
            -- Progress Bar
            QBCore.Functions.Progressbar("refueling", "Yakıt dolduruluyor...", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                ClearPedTasks(playerPed)
                TriggerServerEvent('aendir:server:RefuelVehicle', plate)
                isRefueling = false
                currentVehicle = nil
            end, function() -- Cancel
                ClearPedTasks(playerPed)
                isRefueling = false
                currentVehicle = nil
            end)
        else
            QBCore.Functions.Notify('Bu araç size ait değil!', 'error')
        end
    end, plate)
end

-- Yakıt İstasyonlarını Kontrol Etme
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, station in pairs(fuelStations) do
            local distance = #(coords - station.coords)
            
            if distance < 2.0 then
                DrawText3D(station.coords.x, station.coords.y, station.coords.z + 1.0, '~g~E~w~ - Yakıt Doldur')
                
                if IsControlJustPressed(0, 38) then -- E tuşu
                    StartRefueling(station)
                end
            end
        end
    end
end)

-- Yakıt Tüketimi
CreateThread(function()
    while true do
        Wait(1000)
        
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local plate = GetVehicleNumberPlateText(vehicle)
            
            -- Yakıt Tüketimi
            local fuel = GetVehicleFuelLevel(vehicle)
            local speed = GetEntitySpeed(vehicle)
            local consumption = 0.0
            
            if speed > 0 then
                consumption = speed * 0.0001
            end
            
            local newFuel = fuel - consumption
            
            if newFuel < 0 then
                newFuel = 0
            end
            
            SetVehicleFuelLevel(vehicle, newFuel)
            
            -- Yakıt Bittiğinde
            if newFuel <= 0 then
                SetVehicleEngineOn(vehicle, false, true, true)
                QBCore.Functions.Notify('Yakıtınız bitti!', 'error')
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