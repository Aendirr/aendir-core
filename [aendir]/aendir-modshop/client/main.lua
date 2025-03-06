local QBCore = exports['qb-core']:GetCoreObject()
local currentVehicle = nil
local currentMod = nil
local currentCategory = nil

-- Blip Oluşturma
CreateThread(function()
    for _, shop in pairs(Config.ModShops) do
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

-- Modifiye Menüsü
function OpenModMenu(vehicle)
    if not vehicle then return end
    
    currentVehicle = vehicle
    local plate = GetVehicleNumberPlateText(vehicle)
    
    QBCore.Functions.TriggerCallback('aendir:server:CheckVehicleOwnership', function(owned)
        if owned then
            local elements = {}
            
            for _, category in pairs(Config.ModShops[1].categories) do
                table.insert(elements, {
                    title = category.name,
                    description = "Modifiye kategorisini aç",
                    event = "aendir:client:OpenModCategory",
                    args = {
                        category = category
                    }
                })
            end
            
            lib.registerContext({
                id = 'mod_menu',
                title = 'Modifiye Menüsü',
                options = elements
            })
            
            lib.showContext('mod_menu')
        else
            QBCore.Functions.Notify('Bu araç size ait değil!', 'error')
        end
    end, plate)
end

-- Kategori Menüsü
RegisterNetEvent('aendir:client:OpenModCategory', function(data)
    if not currentVehicle then return end
    
    currentCategory = data.category
    local elements = {}
    local numMods = GetNumVehicleMods(currentVehicle, data.category.id)
    
    for i = -1, numMods - 1 do
        local modName = GetModTextLabel(currentVehicle, data.category.id, i)
        if modName ~= "" then
            table.insert(elements, {
                title = modName,
                description = "Bu modifikasyonu uygula",
                event = "aendir:client:ApplyModification",
                args = {
                    modIndex = i
                }
            })
        end
    end
    
    lib.registerContext({
        id = 'mod_category',
        title = data.category.name,
        menu = 'mod_menu',
        options = elements
    })
    
    lib.showContext('mod_category')
end)

-- Modifiye Uygulama
RegisterNetEvent('aendir:client:ApplyModification', function(data)
    if not currentVehicle or not currentCategory then return end
    
    local plate = GetVehicleNumberPlateText(currentVehicle)
    local modIndex = data.modIndex
    local price = Config.Prices[currentCategory.name:lower()]
    
    QBCore.Functions.TriggerCallback('aendir:server:ApplyModification', function(success)
        if success then
            SetVehicleMod(currentVehicle, currentCategory.id, modIndex, false)
            QBCore.Functions.Notify('Modifiye başarıyla uygulandı!', 'success')
        else
            QBCore.Functions.Notify('Yeterli paranız yok!', 'error')
        end
    end, plate, currentCategory.id, modIndex, price)
end)

-- Modifiye Menüsünü Aç
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, shop in pairs(Config.ModShops) do
            local distance = #(coords - shop.coords)
            
            if distance < 10.0 then
                DrawMarker(1, shop.coords.x, shop.coords.y, shop.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 2.0 then
                    if IsControlJustPressed(0, 38) then -- E tuşu
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        if vehicle ~= 0 then
                            OpenModMenu(vehicle)
                        else
                            QBCore.Functions.Notify('Bir araçta olmalısınız!', 'error')
                        end
                    end
                end
            end
        end
    end
end) 