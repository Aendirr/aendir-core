local QBCore = exports['qb-core']:GetCoreObject()
local currentHeist = nil
local isRobbing = false
local copsCalled = false

-- Hırsızlık Noktaları
local heistLocations = {
    {
        name = "Mağaza Soygunu",
        coords = vector3(24.03, -1347.63, 29.5),
        type = "store",
        requiredCops = 2,
        reward = {
            min = 5000,
            max = 15000,
            items = {
                {name = "money", amount = {min = 1000, max = 5000}},
                {name = "gold", amount = {min = 1, max = 3}},
                {name = "diamond", amount = {min = 1, max = 2}}
            }
        },
        time = 300, -- 5 dakika
        blip = {
            sprite = 156,
            color = 1,
            scale = 0.8,
            label = "Mağaza"
        }
    },
    {
        name = "Banka Soygunu",
        coords = vector3(253.85, 225.86, 101.88),
        type = "bank",
        requiredCops = 4,
        reward = {
            min = 10000,
            max = 30000,
            items = {
                {name = "money", amount = {min = 5000, max = 15000}},
                {name = "gold", amount = {min = 3, max = 8}},
                {name = "diamond", amount = {min = 2, max = 5}}
            }
        },
        time = 600, -- 10 dakika
        blip = {
            sprite = 156,
            color = 1,
            scale = 0.8,
            label = "Banka"
        }
    },
    {
        name = "Silah Mağazası Soygunu",
        coords = vector3(22.09, -1107.28, 29.8),
        type = "gunstore",
        requiredCops = 3,
        reward = {
            min = 8000,
            max = 20000,
            items = {
                {name = "money", amount = {min = 3000, max = 8000}},
                {name = "weapon_pistol", amount = {min = 1, max = 2}},
                {name = "ammo", amount = {min = 50, max = 100}}
            }
        },
        time = 450, -- 7.5 dakika
        blip = {
            sprite = 156,
            color = 1,
            scale = 0.8,
            label = "Silah Mağazası"
        }
    }
}

-- Blip Oluşturma
CreateThread(function()
    for _, location in pairs(heistLocations) do
        local blip = AddBlipForCoord(location.coords)
        SetBlipSprite(blip, location.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, location.blip.scale)
        SetBlipColour(blip, location.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(location.blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Hırsızlık Başlatma
function StartHeist(location)
    if isRobbing then return end
    
    QBCore.Functions.TriggerCallback('aendir:server:CheckCops', function(cops)
        if cops >= location.requiredCops then
            isRobbing = true
            currentHeist = location
            
            -- Animasyon
            local playerPed = PlayerPedId()
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
            
            -- Progress Bar
            QBCore.Functions.Progressbar("robbing", "Soygun yapılıyor...", location.time, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                ClearPedTasks(playerPed)
                TriggerServerEvent('aendir:server:CompleteHeist', location)
                isRobbing = false
                currentHeist = nil
            end, function() -- Cancel
                ClearPedTasks(playerPed)
                isRobbing = false
                currentHeist = nil
            end)
            
            -- Polis Bildirimi
            if not copsCalled then
                copsCalled = true
                TriggerServerEvent('aendir:server:AlertPolice', location)
            end
        else
            QBCore.Functions.Notify('Yeterli polis yok!', 'error')
        end
    end)
end

-- Hırsızlık Noktalarını Kontrol Etme
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, location in pairs(heistLocations) do
            local distance = #(coords - location.coords)
            
            if distance < 2.0 then
                DrawText3D(location.coords.x, location.coords.y, location.coords.z + 1.0, '~g~E~w~ - ' .. location.name)
                
                if IsControlJustPressed(0, 38) then -- E tuşu
                    StartHeist(location)
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