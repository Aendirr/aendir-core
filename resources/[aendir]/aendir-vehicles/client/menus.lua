local AendirCore = exports['aendir-core']:GetCoreObject()

-- Menü Fonksiyonları
local function OpenGarageMenu(vehicles)
    local elements = {}
    
    for _, vehicle in ipairs(vehicles) do
        table.insert(elements, {
            title = vehicle.model,
            description = string.format('Plaka: %s\nDurum: %s', vehicle.plate, vehicle.stored and 'Garajda' or 'Dışarıda'),
            onSelect = function()
                if vehicle.stored then
                    TriggerServerEvent('aendir:server:SpawnVehicle', vehicle.plate)
                else
                    TriggerServerEvent('aendir:server:StoreVehicle', vehicle.plate)
                end
            end
        })
    end
    
    lib.registerContext({
        id = 'garage_menu',
        title = 'Garaj',
        options = elements
    })
    
    lib.showContext('garage_menu')
end

local function OpenImpoundMenu(vehicles)
    local elements = {}
    
    for _, vehicle in ipairs(vehicles) do
        table.insert(elements, {
            title = vehicle.model,
            description = string.format('Plaka: %s\nÜcret: $%s', vehicle.plate, Config.Vehicles.Prices.impound),
            onSelect = function()
                TriggerServerEvent('aendir:server:RetrieveImpoundedVehicle', vehicle.plate)
            end
        })
    end
    
    lib.registerContext({
        id = 'impound_menu',
        title = 'Araç Çekme',
        options = elements
    })
    
    lib.showContext('impound_menu')
end

local function OpenInsuranceMenu(vehicles)
    local elements = {}
    
    for _, vehicle in ipairs(vehicles) do
        table.insert(elements, {
            title = vehicle.model,
            description = string.format('Plaka: %s\nÜcret: $%s', vehicle.plate, Config.Vehicles.Prices.insurance),
            onSelect = function()
                TriggerServerEvent('aendir:server:InsureVehicle', vehicle.plate)
            end
        })
    end
    
    lib.registerContext({
        id = 'insurance_menu',
        title = 'Sigorta',
        options = elements
    })
    
    lib.showContext('insurance_menu')
end

local function OpenModShopMenu(vehicle)
    local elements = {}
    
    for category, label in pairs(Config.Vehicles.Categories) do
        table.insert(elements, {
            title = label,
            description = string.format('Ücret: $%s', Config.Vehicles.Prices.modshop[category]),
            onSelect = function()
                TriggerServerEvent('aendir:server:ApplyModification', vehicle.plate, category)
            end
        })
    end
    
    lib.registerContext({
        id = 'modshop_menu',
        title = 'Modifiye Dükkanı',
        options = elements
    })
    
    lib.showContext('modshop_menu')
end

local function OpenVehicleMenu(vehicle)
    local elements = {
        {
            title = 'Araç Bilgileri',
            description = string.format('Plaka: %s\nModel: %s\nYakıt: %.1f%%\nHasar: %.1f%%', 
                vehicle.plate, vehicle.model, vehicle.fuel, vehicle.damage),
            disabled = true
        },
        {
            title = 'Motor',
            description = isEngineRunning and 'Motoru Durdur' or 'Motoru Çalıştır',
            onSelect = function()
                ToggleEngine(vehicle)
            end
        },
        {
            title = 'Kilit',
            description = isLocked and 'Kilidi Aç' or 'Kilidi Kapat',
            onSelect = function()
                ToggleLock(vehicle)
            end
        },
        {
            title = 'Kapılar',
            description = 'Kapıları Aç/Kapat',
            onSelect = function()
                ToggleDoors(vehicle)
            end
        },
        {
            title = 'Tamir',
            description = string.format('Tamir Et ($%s)', Config.Vehicles.Prices.repair),
            onSelect = function()
                TriggerServerEvent('aendir:server:RepairVehicle', vehicle.plate)
            end
        }
    }
    
    lib.registerContext({
        id = 'vehicle_menu',
        title = 'Araç Menüsü',
        options = elements
    })
    
    lib.showContext('vehicle_menu')
end

-- Menü Tetikleyicileri
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        -- Garaj Menüsü
        for _, garage in ipairs(Config.Vehicles.Garages) do
            if #(coords - garage.coords) < 3.0 then
                if IsControlJustPressed(0, 38) then -- E tuşu
                    TriggerServerEvent('aendir:server:GetPlayerVehicles')
                end
            end
        end
        
        -- Çekme Menüsü
        local impound = Config.Vehicles.Impound
        if #(coords - impound.coords) < 3.0 then
            if IsControlJustPressed(0, 38) then -- E tuşu
                TriggerServerEvent('aendir:server:GetImpoundedVehicles')
            end
        end
        
        -- Modifiye Menüsü
        for _, modshop in ipairs(Config.Vehicles.ModShops) do
            if #(coords - modshop.coords) < 3.0 then
                if IsControlJustPressed(0, 38) then -- E tuşu
                    local vehicle = AendirCore.Functions.GetCurrentVehicle()
                    if vehicle then
                        OpenModShopMenu(vehicle)
                    end
                end
            end
        end
        
        -- Sigorta Menüsü
        for _, insurance in ipairs(Config.Vehicles.InsuranceOffices) do
            if #(coords - insurance.coords) < 3.0 then
                if IsControlJustPressed(0, 38) then -- E tuşu
                    TriggerServerEvent('aendir:server:GetPlayerVehicles')
                end
            end
        end
        
        -- Araç Menüsü
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if IsControlJustPressed(0, 244) then -- M tuşu
                OpenVehicleMenu(vehicle)
            end
        end
    end
end)

-- Menü Eventleri
RegisterNetEvent('aendir:client:OpenGarageMenu', OpenGarageMenu)
RegisterNetEvent('aendir:client:OpenImpoundMenu', OpenImpoundMenu)
RegisterNetEvent('aendir:client:OpenInsuranceMenu', OpenInsuranceMenu)
RegisterNetEvent('aendir:client:OpenModShopMenu', OpenModShopMenu)
RegisterNetEvent('aendir:client:OpenVehicleMenu', OpenVehicleMenu) 