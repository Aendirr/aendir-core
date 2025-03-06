local AendirCore = exports['aendir-core']:GetCoreObject()

local currentVehicle = nil
local isEngineRunning = false
local isLocked = false
local fuelLevel = 100.0
local damageLevel = 100.0

-- Araç Kontrolleri
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            
            -- Motor Kontrolü
            if IsControlJustPressed(0, 244) then -- M tuşu
                ToggleEngine(vehicle)
            end
            
            -- Kilit Kontrolü
            if IsControlJustPressed(0, 303) then -- U tuşu
                ToggleLock(vehicle)
            end
            
            -- Yakıt Tüketimi
            if isEngineRunning then
                local speed = GetEntitySpeed(vehicle)
                local fuelConsumption = Config.Vehicles.FuelConsumption * (speed / 100)
                fuelLevel = fuelLevel - fuelConsumption
                
                if fuelLevel <= 0 then
                    SetVehicleEngineOn(vehicle, false, true, true)
                    isEngineRunning = false
                    AendirCore.Functions.ShowNotification('Yakıt bitti!', 'error')
                end
                
                SetVehicleFuelLevel(vehicle, fuelLevel)
            end
            
            -- Hasar Sistemi
            local bodyHealth = GetVehicleBodyHealth(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            
            if bodyHealth < Config.Vehicles.MaxBodyHealth or engineHealth < Config.Vehicles.MaxEngineHealth then
                damageLevel = (bodyHealth + engineHealth) / 2
                TriggerServerEvent('aendir:server:UpdateVehicleDamage', GetVehicleNumberPlateText(vehicle), damageLevel)
            end
        end
    end
end)

-- Motor Kontrolü
function ToggleEngine(vehicle)
    if not isEngineRunning then
        SetVehicleEngineOn(vehicle, true, true, true)
        isEngineRunning = true
        AendirCore.Functions.ShowNotification('Motor çalıştırıldı', 'success')
    else
        SetVehicleEngineOn(vehicle, false, true, true)
        isEngineRunning = false
        AendirCore.Functions.ShowNotification('Motor durduruldu', 'info')
    end
end

-- Kilit Kontrolü
function ToggleLock(vehicle)
    if not isLocked then
        SetVehicleDoorsLocked(vehicle, 2)
        isLocked = true
        AendirCore.Functions.ShowNotification('Araç kilitlendi', 'success')
    else
        SetVehicleDoorsLocked(vehicle, 0)
        isLocked = false
        AendirCore.Functions.ShowNotification('Araç kilit açıldı', 'info')
    end
end

-- Yakıt Sistemi
RegisterNetEvent('aendir:client:RefuelVehicle', function(amount)
    local vehicle = AendirCore.Functions.GetCurrentVehicle()
    if not vehicle then return end
    
    if AendirCore.Functions.ShowProgressBar('Yakıt dolduruluyor...', 5000) then
        fuelLevel = math.min(fuelLevel + amount, Config.Vehicles.MaxFuel)
        SetVehicleFuelLevel(vehicle, fuelLevel)
        AendirCore.Functions.ShowNotification('Yakıt dolduruldu', 'success')
    end
end)

-- Hasar Sistemi
RegisterNetEvent('aendir:client:RepairVehicle', function()
    local vehicle = AendirCore.Functions.GetCurrentVehicle()
    if not vehicle then return end
    
    if AendirCore.Functions.ShowProgressBar('Araç tamir ediliyor...', 5000) then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true, true)
        damageLevel = 100.0
        AendirCore.Functions.ShowNotification('Araç tamir edildi', 'success')
    end
end)

-- Takip Sistemi
RegisterNetEvent('aendir:client:StartTracking', function(plate)
    local vehicle = AendirCore.Functions.GetVehicleByPlate(plate)
    if not vehicle then return end
    
    CreateThread(function()
        while true do
            Wait(1000)
            if DoesEntityExist(vehicle) then
                local coords = GetEntityCoords(vehicle)
                TriggerServerEvent('aendir:server:UpdateVehicleLocation', plate, coords)
            else
                break
            end
        end
    end)
end)

-- Garaj Sistemi
RegisterNetEvent('aendir:client:OpenGarageMenu', function(vehicles)
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
end)

-- Çekme Sistemi
RegisterNetEvent('aendir:client:OpenImpoundMenu', function(vehicles)
    local elements = {}
    
    for _, vehicle in ipairs(vehicles) do
        table.insert(elements, {
            title = vehicle.model,
            description = string.format('Plaka: %s\nÜcret: $%s', vehicle.plate, Config.Vehicles.ImpoundCost),
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
end)

-- Sigorta Sistemi
RegisterNetEvent('aendir:client:OpenInsuranceMenu', function(vehicles)
    local elements = {}
    
    for _, vehicle in ipairs(vehicles) do
        table.insert(elements, {
            title = vehicle.model,
            description = string.format('Plaka: %s\nÜcret: $%s', vehicle.plate, Config.Vehicles.InsuranceCost),
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
end)

-- Modifiye Sistemi
RegisterNetEvent('aendir:client:OpenModShop', function(vehicle)
    local elements = {}
    
    for category, label in pairs(Config.Items.Categories) do
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
end)