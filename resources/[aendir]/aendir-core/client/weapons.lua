-- Silahlar
local Weapons = {
    -- Silah Tipleri
    Types = {
        Pistol = "WEAPON_PISTOL",
        SMG = "WEAPON_SMG",
        Rifle = "WEAPON_RIFLE",
        Shotgun = "WEAPON_SHOTGUN",
        Sniper = "WEAPON_SNIPER",
        Melee = "WEAPON_MELEE",
        Explosive = "WEAPON_EXPLOSIVE"
    },
    
    -- Silah Ayarları
    Settings = {
        -- Mermi Ayarları
        Ammo = {
            Pistol = 12,
            SMG = 30,
            Rifle = 30,
            Shotgun = 8,
            Sniper = 10,
            Melee = 0,
            Explosive = 1
        },
        
        -- Hasar Ayarları
        Damage = {
            Pistol = 25,
            SMG = 20,
            Rifle = 30,
            Shotgun = 40,
            Sniper = 100,
            Melee = 15,
            Explosive = 100
        },
        
        -- Menzil Ayarları
        Range = {
            Pistol = 50.0,
            SMG = 100.0,
            Rifle = 150.0,
            Shotgun = 30.0,
            Sniper = 300.0,
            Melee = 2.0,
            Explosive = 10.0
        }
    }
}

-- Silah Verme
function AendirCore.Functions.GiveWeapon(weapon, ammo, hidden)
    if HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) then
        SetPedAmmo(PlayerPedId(), GetHashKey(weapon), ammo)
    else
        GiveWeaponToPed(PlayerPedId(), GetHashKey(weapon), ammo, hidden, true)
    end
end

-- Silah Alma
function AendirCore.Functions.RemoveWeapon(weapon)
    RemoveWeaponFromPed(PlayerPedId(), GetHashKey(weapon))
end

-- Silah Mermisi
function AendirCore.Functions.SetWeaponAmmo(weapon, ammo)
    SetPedAmmo(PlayerPedId(), GetHashKey(weapon), ammo)
end

-- Silah Hasarı
function AendirCore.Functions.SetWeaponDamage(weapon, damage)
    SetWeaponDamageModifier(GetHashKey(weapon), damage)
end

-- Silah Menzili
function AendirCore.Functions.SetWeaponRange(weapon, range)
    SetWeaponRangeModifier(GetHashKey(weapon), range)
end

-- Silah Olayları
RegisterNetEvent('aendir:client:GiveWeapon', function(weapon, ammo, hidden)
    AendirCore.Functions.GiveWeapon(weapon, ammo, hidden)
end)

RegisterNetEvent('aendir:client:RemoveWeapon', function(weapon)
    AendirCore.Functions.RemoveWeapon(weapon)
end)

RegisterNetEvent('aendir:client:SetWeaponAmmo', function(weapon, ammo)
    AendirCore.Functions.SetWeaponAmmo(weapon, ammo)
end)

RegisterNetEvent('aendir:client:SetWeaponDamage', function(weapon, damage)
    AendirCore.Functions.SetWeaponDamage(weapon, damage)
end)

RegisterNetEvent('aendir:client:SetWeaponRange', function(weapon, range)
    AendirCore.Functions.SetWeaponRange(weapon, range)
end)

-- Silah Komutları
RegisterCommand('giveweapon', function(source, args)
    if args[1] then
        local weapon = args[1]
        local ammo = tonumber(args[2]) or Weapons.Settings.Ammo[weapon] or 0
        local hidden = args[3] == 'true'
        
        AendirCore.Functions.GiveWeapon(weapon, ammo, hidden)
    else
        AendirCore.Functions.Notify('Silah adı belirtmelisiniz!', 'error')
    end
end)

RegisterCommand('removeweapon', function(source, args)
    if args[1] then
        local weapon = args[1]
        AendirCore.Functions.RemoveWeapon(weapon)
    else
        AendirCore.Functions.Notify('Silah adı belirtmelisiniz!', 'error')
    end
end)

RegisterCommand('setammo', function(source, args)
    if args[1] and args[2] then
        local weapon = args[1]
        local ammo = tonumber(args[2])
        if ammo then
            AendirCore.Functions.SetWeaponAmmo(weapon, ammo)
        else
            AendirCore.Functions.Notify('Geçersiz mermi sayısı!', 'error')
        end
    else
        AendirCore.Functions.Notify('Silah adı ve mermi sayısı belirtmelisiniz!', 'error')
    end
end)

-- Silah Menüsü
RegisterCommand('weaponmenu', function()
    local elements = {}
    
    for k, v in pairs(Weapons.Types) do
        table.insert(elements, {
            label = k,
            value = v
        })
    end
    
    lib.registerContext({
        id = 'weapon_menu',
        title = 'Silah Menüsü',
        options = elements
    })
    
    lib.showContext('weapon_menu')
end)

-- Silah Menü Seçimi
lib.registerCallback('aendir:client:WeaponMenuSelect', function(data)
    local weapon = data.value
    local ammo = Weapons.Settings.Ammo[weapon] or 0
    
    AendirCore.Functions.GiveWeapon(weapon, ammo, false)
end)

-- Silah Döngüsü
CreateThread(function()
    while true do
        Wait(1000)
        
        local ped = PlayerPedId()
        for k, v in pairs(Weapons.Types) do
            if HasPedGotWeapon(ped, GetHashKey(v), false) then
                local ammo = GetAmmoInPedWeapon(ped, GetHashKey(v))
                if ammo <= 0 then
                    AendirCore.Functions.Notify('Merminiz bitti!', 'warning')
                end
            end
        end
    end
end) 