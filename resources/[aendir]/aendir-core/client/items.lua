-- Eşyalar
local Items = {
    -- Eşya Tipleri
    Types = {
        -- Silahlar
        Weapons = {
            Pistol = "weapon_pistol",
            SMG = "weapon_smg",
            Rifle = "weapon_rifle",
            Shotgun = "weapon_shotgun",
            Sniper = "weapon_sniper"
        },
        
        -- Mermiler
        Ammo = {
            Pistol = "ammo_pistol",
            SMG = "ammo_smg",
            Rifle = "ammo_rifle",
            Shotgun = "ammo_shotgun",
            Sniper = "ammo_sniper"
        },
        
        -- Yiyecekler
        Food = {
            Bread = "bread",
            Water = "water",
            Coffee = "coffee",
            Sandwich = "sandwich",
            Burger = "burger"
        },
        
        -- İçecekler
        Drinks = {
            Water = "water",
            Coffee = "coffee",
            Beer = "beer",
            Wine = "wine",
            Soda = "soda"
        },
        
        -- İlaçlar
        Medical = {
            Bandage = "bandage",
            Medkit = "medkit",
            Painkillers = "painkillers",
            FirstAid = "firstaid"
        },
        
        -- Araçlar
        Vehicles = {
            RepairKit = "repairkit",
            FuelCan = "fuelcan",
            Lockpick = "lockpick"
        },
        
        -- Diğer
        Misc = {
            Phone = "phone",
            Keys = "keys",
            Money = "money",
            ID = "id"
        }
    },
    
    -- Eşya Ayarları
    Settings = {
        -- Maksimum Ağırlık
        MaxWeight = 50.0,
        
        -- Maksimum Eşya Sayısı
        MaxItems = 100,
        
        -- Maksimum Yığın Sayısı
        MaxStack = 50,
        
        -- Kullanılabilir Eşyalar
        UsableItems = {
            -- Yiyecekler
            bread = function()
                TriggerEvent('aendir:client:UseFood', 'bread', 25)
            end,
            water = function()
                TriggerEvent('aendir:client:UseDrink', 'water', 25)
            end,
            coffee = function()
                TriggerEvent('aendir:client:UseDrink', 'coffee', 15)
            end,
            sandwich = function()
                TriggerEvent('aendir:client:UseFood', 'sandwich', 35)
            end,
            burger = function()
                TriggerEvent('aendir:client:UseFood', 'burger', 45)
            end,
            
            -- İçecekler
            beer = function()
                TriggerEvent('aendir:client:UseDrink', 'beer', 20)
            end,
            wine = function()
                TriggerEvent('aendir:client:UseDrink', 'wine', 25)
            end,
            soda = function()
                TriggerEvent('aendir:client:UseDrink', 'soda', 15)
            end,
            
            -- İlaçlar
            bandage = function()
                TriggerEvent('aendir:client:UseMedical', 'bandage', 25)
            end,
            medkit = function()
                TriggerEvent('aendir:client:UseMedical', 'medkit', 50)
            end,
            painkillers = function()
                TriggerEvent('aendir:client:UseMedical', 'painkillers', 15)
            end,
            firstaid = function()
                TriggerEvent('aendir:client:UseMedical', 'firstaid', 35)
            end,
            
            -- Araçlar
            repairkit = function()
                TriggerEvent('aendir:client:UseVehicle', 'repairkit')
            end,
            fuelcan = function()
                TriggerEvent('aendir:client:UseVehicle', 'fuelcan')
            end,
            lockpick = function()
                TriggerEvent('aendir:client:UseVehicle', 'lockpick')
            end
        }
    }
}

-- Eşya Verme
function AendirCore.Functions.GiveItem(item, amount, slot)
    TriggerServerEvent('aendir:server:GiveItem', item, amount, slot)
end

-- Eşya Alma
function AendirCore.Functions.RemoveItem(item, amount)
    TriggerServerEvent('aendir:server:RemoveItem', item, amount)
end

-- Eşya Kullanma
function AendirCore.Functions.UseItem(item)
    if Items.Settings.UsableItems[item] then
        Items.Settings.UsableItems[item]()
    else
        AendirCore.Functions.Notify('Bu eşya kullanılamaz!', 'error')
    end
end

-- Eşya Olayları
RegisterNetEvent('aendir:client:UseFood', function(item, health)
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    
    if health < 200 then
        SetEntityHealth(ped, health + health)
        AendirCore.Functions.Notify('Yemek yediniz!', 'success')
    else
        AendirCore.Functions.Notify('Aç değilsiniz!', 'error')
    end
end)

RegisterNetEvent('aendir:client:UseDrink', function(item, thirst)
    local ped = PlayerPedId()
    local thirst = GetPlayerThirst(ped)
    
    if thirst < 100 then
        SetPlayerThirst(ped, thirst + thirst)
        AendirCore.Functions.Notify('İçecek içtiniz!', 'success')
    else
        AendirCore.Functions.Notify('Susamadınız!', 'error')
    end
end)

RegisterNetEvent('aendir:client:UseMedical', function(item, health)
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    
    if health < 200 then
        SetEntityHealth(ped, health + health)
        AendirCore.Functions.Notify('İlaç kullandınız!', 'success')
    else
        AendirCore.Functions.Notify('Sağlıklısınız!', 'error')
    end
end)

RegisterNetEvent('aendir:client:UseVehicle', function(item)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        if item == 'repairkit' then
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            AendirCore.Functions.Notify('Aracı tamir ettiniz!', 'success')
        elseif item == 'fuelcan' then
            SetVehicleFuelLevel(vehicle, 100.0)
            AendirCore.Functions.Notify('Araca yakıt doldurdunuz!', 'success')
        elseif item == 'lockpick' then
            if GetVehicleDoorLockStatus(vehicle) == 2 then
                SetVehicleDoorsLocked(vehicle, 1)
                AendirCore.Functions.Notify('Aracın kilidini açtınız!', 'success')
            else
                AendirCore.Functions.Notify('Araç zaten açık!', 'error')
            end
        end
    else
        AendirCore.Functions.Notify('Bir araçta değilsiniz!', 'error')
    end
end)

-- Eşya Komutları
RegisterCommand('giveitem', function(source, args)
    if args[1] and args[2] then
        local item = args[1]
        local amount = tonumber(args[2])
        if amount then
            AendirCore.Functions.GiveItem(item, amount)
        else
            AendirCore.Functions.Notify('Geçersiz miktar!', 'error')
        end
    else
        AendirCore.Functions.Notify('Eşya adı ve miktar belirtmelisiniz!', 'error')
    end
end)

RegisterCommand('removeitem', function(source, args)
    if args[1] and args[2] then
        local item = args[1]
        local amount = tonumber(args[2])
        if amount then
            AendirCore.Functions.RemoveItem(item, amount)
        else
            AendirCore.Functions.Notify('Geçersiz miktar!', 'error')
        end
    else
        AendirCore.Functions.Notify('Eşya adı ve miktar belirtmelisiniz!', 'error')
    end
end)

RegisterCommand('useitem', function(source, args)
    if args[1] then
        local item = args[1]
        AendirCore.Functions.UseItem(item)
    else
        AendirCore.Functions.Notify('Eşya adı belirtmelisiniz!', 'error')
    end
end)

-- Eşya Menüsü
RegisterCommand('itemmenu', function()
    local elements = {}
    
    for k, v in pairs(Items.Types) do
        for k2, v2 in pairs(v) do
            table.insert(elements, {
                label = k2,
                value = v2
            })
        end
    end
    
    lib.registerContext({
        id = 'item_menu',
        title = 'Eşya Menüsü',
        options = elements
    })
    
    lib.showContext('item_menu')
end)

-- Eşya Menü Seçimi
lib.registerCallback('aendir:client:ItemMenuSelect', function(data)
    local item = data.value
    AendirCore.Functions.UseItem(item)
end) 