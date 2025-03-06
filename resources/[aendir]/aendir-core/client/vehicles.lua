-- Araçlar
local Vehicles = {
    -- Araç Tipleri
    Types = {
        Car = "car",
        Bike = "bike",
        Boat = "boat",
        Helicopter = "helicopter",
        Plane = "plane",
        Train = "train",
        Submarine = "submarine"
    },
    
    -- Araç Ayarları
    Settings = {
        -- Yakıt Ayarları
        Fuel = {
            Consumption = 0.1, -- Her saniye tüketilen yakıt
            Warning = 20, -- Uyarı seviyesi
            Empty = 0 -- Boş seviye
        },
        
        -- Hasar Ayarları
        Damage = {
            Engine = 1000, -- Motor hasarı limiti
            Body = 1000, -- Gövde hasarı limiti
            Warning = 500 -- Uyarı seviyesi
        },
        
        -- Kapı Ayarları
        Doors = {
            Locked = true, -- Başlangıçta kilitli
            AutoLock = true -- Otomatik kilit
        }
    }
}

-- Araç Oluşturma
function AendirCore.Functions.SpawnVehicle(model, coords, heading, plate, color, mods)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleNumberPlateText(vehicle, plate)
    SetVehicleColours(vehicle, color.primary, color.secondary)
    
    if mods then
        for k, v in pairs(mods) do
            SetVehicleMod(vehicle, k, v, false)
        end
    end
    
    SetModelAsNoLongerNeeded(model)
    return vehicle
end

-- Araç Silme
function AendirCore.Functions.DeleteVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
end

-- Araç Kilitleme
function AendirCore.Functions.LockVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        SetVehicleDoorsLocked(vehicle, 2)
    end
end

-- Araç Kilidi Açma
function AendirCore.Functions.UnlockVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        SetVehicleDoorsLocked(vehicle, 1)
    end
end

-- Araç Kapısı Açma/Kapama
function AendirCore.Functions.ToggleVehicleDoor(vehicle, door)
    if DoesEntityExist(vehicle) then
        if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
            SetVehicleDoorShut(vehicle, door, false)
        else
            SetVehicleDoorOpen(vehicle, door, false, false)
        end
    end
end

-- Araç Motoru Açma/Kapama
function AendirCore.Functions.ToggleVehicleEngine(vehicle)
    if DoesEntityExist(vehicle) then
        if GetIsVehicleEngineRunning(vehicle) then
            SetVehicleEngineOn(vehicle, false, true, true)
        else
            SetVehicleEngineOn(vehicle, true, true, true)
        end
    end
end

-- Araç Yakıtı
function AendirCore.Functions.SetVehicleFuel(vehicle, fuel)
    if DoesEntityExist(vehicle) then
        SetVehicleFuelLevel(vehicle, fuel)
    end
end

-- Araç Hasarı
function AendirCore.Functions.SetVehicleDamage(vehicle, engine, body)
    if DoesEntityExist(vehicle) then
        SetVehicleEngineHealth(vehicle, engine)
        SetVehicleBodyHealth(vehicle, body)
    end
end

-- Araç Modifikasyonları
function AendirCore.Functions.SetVehicleMods(vehicle, mods)
    if DoesEntityExist(vehicle) then
        for k, v in pairs(mods) do
            SetVehicleMod(vehicle, k, v, false)
        end
    end
end

-- Araç Olayları
RegisterNetEvent('aendir:client:SpawnVehicle', function(model, coords, heading, plate, color, mods)
    AendirCore.Functions.SpawnVehicle(model, coords, heading, plate, color, mods)
end)

RegisterNetEvent('aendir:client:DeleteVehicle', function(vehicle)
    AendirCore.Functions.DeleteVehicle(vehicle)
end)

RegisterNetEvent('aendir:client:LockVehicle', function(vehicle)
    AendirCore.Functions.LockVehicle(vehicle)
end)

RegisterNetEvent('aendir:client:UnlockVehicle', function(vehicle)
    AendirCore.Functions.UnlockVehicle(vehicle)
end)

RegisterNetEvent('aendir:client:ToggleVehicleDoor', function(vehicle, door)
    AendirCore.Functions.ToggleVehicleDoor(vehicle, door)
end)

RegisterNetEvent('aendir:client:ToggleVehicleEngine', function(vehicle)
    AendirCore.Functions.ToggleVehicleEngine(vehicle)
end)

RegisterNetEvent('aendir:client:SetVehicleFuel', function(vehicle, fuel)
    AendirCore.Functions.SetVehicleFuel(vehicle, fuel)
end)

RegisterNetEvent('aendir:client:SetVehicleDamage', function(vehicle, engine, body)
    AendirCore.Functions.SetVehicleDamage(vehicle, engine, body)
end)

RegisterNetEvent('aendir:client:SetVehicleMods', function(vehicle, mods)
    AendirCore.Functions.SetVehicleMods(vehicle, mods)
end)

-- Araç Komutları
RegisterCommand('spawnvehicle', function(source, args)
    if args[1] then
        local model = args[1]
        local coords = GetEntityCoords(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())
        local plate = args[2] or "AENDIR"
        local color = {primary = 0, secondary = 0}
        local mods = {}
        
        AendirCore.Functions.SpawnVehicle(model, coords, heading, plate, color, mods)
    else
        AendirCore.Functions.Notify('Araç modeli belirtmelisiniz!', 'error')
    end
end)

RegisterCommand('deletevehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        AendirCore.Functions.DeleteVehicle(vehicle)
    else
        AendirCore.Functions.Notify('Bir araçta değilsiniz!', 'error')
    end
end)

RegisterCommand('lockvehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        AendirCore.Functions.LockVehicle(vehicle)
    else
        AendirCore.Functions.Notify('Bir araçta değilsiniz!', 'error')
    end
end)

RegisterCommand('unlockvehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        AendirCore.Functions.UnlockVehicle(vehicle)
    else
        AendirCore.Functions.Notify('Bir araçta değilsiniz!', 'error')
    end
end)

-- Araç Menüsü
RegisterCommand('vehiclemenu', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        local elements = {
            {
                label = 'Motoru Aç/Kapat',
                value = 'engine'
            },
            {
                label = 'Kilitle/Kilit Aç',
                value = 'lock'
            },
            {
                label = 'Kapıları Aç/Kapat',
                value = 'doors'
            },
            {
                label = 'Yakıt Durumu',
                value = 'fuel'
            },
            {
                label = 'Hasar Durumu',
                value = 'damage'
            }
        }
        
        lib.registerContext({
            id = 'vehicle_menu',
            title = 'Araç Menüsü',
            options = elements
        })
        
        lib.showContext('vehicle_menu')
    else
        AendirCore.Functions.Notify('Bir araçta değilsiniz!', 'error')
    end
end)

-- Araç Menü Seçimi
lib.registerCallback('aendir:client:VehicleMenuSelect', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        if data.value == 'engine' then
            AendirCore.Functions.ToggleVehicleEngine(vehicle)
        elseif data.value == 'lock' then
            if GetVehicleDoorLockStatus(vehicle) == 2 then
                AendirCore.Functions.UnlockVehicle(vehicle)
            else
                AendirCore.Functions.LockVehicle(vehicle)
            end
        elseif data.value == 'doors' then
            for i = 0, 5 do
                AendirCore.Functions.ToggleVehicleDoor(vehicle, i)
            end
        elseif data.value == 'fuel' then
            local fuel = GetVehicleFuelLevel(vehicle)
            AendirCore.Functions.Notify('Yakıt Durumu: ' .. fuel .. '%', 'info')
        elseif data.value == 'damage' then
            local engine = GetVehicleEngineHealth(vehicle)
            local body = GetVehicleBodyHealth(vehicle)
            AendirCore.Functions.Notify('Motor Durumu: ' .. engine .. '%', 'info')
            AendirCore.Functions.Notify('Gövde Durumu: ' .. body .. '%', 'info')
        end
    end
end)

-- Araç Döngüsü
CreateThread(function()
    while true do
        Wait(1000)
        
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle ~= 0 then
            -- Yakıt Tüketimi
            if GetIsVehicleEngineRunning(vehicle) then
                local fuel = GetVehicleFuelLevel(vehicle)
                if fuel > 0 then
                    SetVehicleFuelLevel(vehicle, fuel - Vehicles.Settings.Fuel.Consumption)
                    if fuel <= Vehicles.Settings.Fuel.Warning then
                        AendirCore.Functions.Notify('Yakıt azalıyor!', 'warning')
                    end
                else
                    SetVehicleEngineOn(vehicle, false, true, true)
                    AendirCore.Functions.Notify('Yakıt bitti!', 'error')
                end
            end
            
            -- Hasar Kontrolü
            local engine = GetVehicleEngineHealth(vehicle)
            local body = GetVehicleBodyHealth(vehicle)
            if engine <= Vehicles.Settings.Damage.Warning or body <= Vehicles.Settings.Damage.Warning then
                AendirCore.Functions.Notify('Araç hasarlı!', 'warning')
            end
        end
    end
end) 