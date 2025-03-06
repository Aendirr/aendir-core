local Aendir = exports['aendir-core']:GetCoreObject()

local currentVehicle = nil
local isInVehicle = false
local isModifying = false
local isRefueling = false

-- Araç çıkarma
RegisterNetEvent('aendir:client:SpawnVehicle', function(plate, vehicle)
    local model = GetHashKey(vehicle.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local spawnPoint = nil
    for _, garage in pairs(Config.Garage.public) do
        if #(GetEntityCoords(PlayerPedId()) - garage.coords) < 10.0 then
            spawnPoint = garage.spawn
            break
        end
    end

    if not spawnPoint then
        TriggerEvent('aendir:client:Notification', 'error', 'Garaj noktası bulunamadı!')
        return
    end

    local veh = CreateVehicle(model, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.w, true, false)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleNumberPlateText(veh, plate)
    SetVehicleOnGroundProperly(veh)
    SetVehicleFuelLevel(veh, vehicle.fuel)
    SetVehicleBodyHealth(veh, vehicle.body)
    SetVehicleEngineHealth(veh, vehicle.engine)

    if vehicle.mods then
        for modType, modIndex in pairs(vehicle.mods) do
            SetVehicleMod(veh, tonumber(modType), modIndex, false)
        end
    end

    currentVehicle = veh
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
end)

-- Araç modifikasyon
RegisterNetEvent('aendir:client:UpdateVehicleMods', function(plate, mods)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if not veh then return end

    if GetVehicleNumberPlateText(veh) ~= plate then
        TriggerEvent('aendir:client:Notification', 'error', 'Bu araç sizin değil!')
        return
    end

    for modType, modIndex in pairs(mods) do
        SetVehicleMod(veh, tonumber(modType), modIndex, false)
    end
end)

-- Araç hasar sistemi
CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            local plate = GetVehicleNumberPlateText(veh)
            
            local body = GetVehicleBodyHealth(veh)
            local engine = GetVehicleEngineHealth(veh)

            TriggerServerEvent('aendir:server:UpdateVehicleDamage', plate, body, engine)
        end
    end
end)

-- Araç yakıt sistemi
CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            local plate = GetVehicleNumberPlateText(veh)
            
            local fuel = GetVehicleFuelLevel(veh)
            TriggerServerEvent('aendir:server:UpdateVehicleFuel', plate, fuel)
        end
    end
end)

-- Yakıt istasyonu
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for _, station in pairs(Config.Fuel.stations) do
            local distance = #(coords - station.coords)
            if distance < 10.0 then
                DrawMarker(1, station.coords.x, station.coords.y, station.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 2.0 and IsPedInAnyVehicle(ped, false) and not isRefueling then
                    local veh = GetVehiclePedIsIn(ped, false)
                    if IsControlJustPressed(0, 38) then -- E tuşu
                        isRefueling = true
                        local fuel = GetVehicleFuelLevel(veh)
                        local cost = (100 - fuel) * Config.Fuel.price
                        
                        TriggerServerEvent('aendir:server:RefuelVehicle', GetVehicleNumberPlateText(veh), cost)
                        SetVehicleFuelLevel(veh, 100.0)
                        
                        Wait(2000)
                        isRefueling = false
                    end
                end
            end
        end
    end
end)

-- Araç modifikasyon menüsü
RegisterNetEvent('aendir:client:OpenModMenu', function()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return end

    local veh = GetVehiclePedIsIn(ped, false)
    local plate = GetVehicleNumberPlateText(veh)

    lib.registerContext({
        id = 'vehicle_mod_menu',
        title = 'Araç Modifikasyon',
        options = {
            {
                title = 'Motor',
                description = 'Motor performansını artır',
                onSelect = function()
                    local currentMod = GetVehicleMod(veh, 11)
                    if currentMod < GetNumVehicleMods(veh, 11) - 1 then
                        SetVehicleMod(veh, 11, currentMod + 1, false)
                        TriggerServerEvent('aendir:server:UpdateVehicleMods', plate, {[11] = currentMod + 1})
                    end
                end
            },
            {
                title = 'Frenler',
                description = 'Fren performansını artır',
                onSelect = function()
                    local currentMod = GetVehicleMod(veh, 12)
                    if currentMod < GetNumVehicleMods(veh, 12) - 1 then
                        SetVehicleMod(veh, 12, currentMod + 1, false)
                        TriggerServerEvent('aendir:server:UpdateVehicleMods', plate, {[12] = currentMod + 1})
                    end
                end
            },
            {
                title = 'Şanzıman',
                description = 'Şanzıman performansını artır',
                onSelect = function()
                    local currentMod = GetVehicleMod(veh, 13)
                    if currentMod < GetNumVehicleMods(veh, 13) - 1 then
                        SetVehicleMod(veh, 13, currentMod + 1, false)
                        TriggerServerEvent('aendir:server:UpdateVehicleMods', plate, {[13] = currentMod + 1})
                    end
                end
            }
        }
    })

    lib.showContext('vehicle_mod_menu')
end)

-- Araç listesi menüsü
RegisterNetEvent('aendir:client:ShowVehicles', function(vehicles)
    local options = {}

    for _, vehicle in pairs(vehicles) do
        table.insert(options, {
            title = vehicle.model,
            description = string.format('Plaka: %s\nYakıt: %s%%\nDurum: %s', 
                vehicle.plate, 
                vehicle.fuel,
                vehicle.stored and 'Garajda' or 'Dışarıda'
            ),
            onSelect = function()
                if vehicle.stored then
                    TriggerServerEvent('aendir:server:SpawnVehicle', vehicle.plate)
                else
                    TriggerEvent('aendir:client:Notification', 'error', 'Bu araç zaten dışarıda!')
                end
            end
        })
    end

    lib.registerContext({
        id = 'vehicle_list_menu',
        title = 'Araçlarım',
        options = options
    })

    lib.showContext('vehicle_list_menu')
end)

-- Komutlar
RegisterCommand('araclarim', function()
    TriggerServerEvent('aendir:server:GetVehicles')
end)

RegisterCommand('modmenu', function()
    TriggerEvent('aendir:client:OpenModMenu')
end)

-- Keybinds
RegisterKeyMapping('araclarim', 'Araçlarım menüsünü aç', 'keyboard', 'F6')
RegisterKeyMapping('modmenu', 'Modifikasyon menüsünü aç', 'keyboard', 'F7') 