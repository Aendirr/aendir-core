-- Sesler
local Sounds = {
    -- Araç Sesleri
    Vehicles = {
        Engine = {
            Start = "veh@std@ds@base",
            Stop = "veh@std@ds@base",
            Rev = "veh@std@ds@base",
            Horn = "veh@std@ds@base"
        },
        Doors = {
            Open = "veh@std@ds@base",
            Close = "veh@std@ds@base",
            Lock = "veh@std@ds@base",
            Unlock = "veh@std@ds@base"
        },
        Damage = {
            Light = "veh@std@ds@base",
            Medium = "veh@std@ds@base",
            Heavy = "veh@std@ds@base"
        },
        Fuel = {
            Low = "veh@std@ds@base",
            Empty = "veh@std@ds@base",
            Refuel = "veh@std@ds@base"
        }
    },
    
    -- Silah Sesleri
    Weapons = {
        Pistol = {
            Shoot = "weapon@pistol@",
            Reload = "weapon@pistol@",
            Empty = "weapon@pistol@"
        },
        SMG = {
            Shoot = "weapon@smg@",
            Reload = "weapon@smg@",
            Empty = "weapon@smg@"
        },
        Rifle = {
            Shoot = "weapon@rifle@",
            Reload = "weapon@rifle@",
            Empty = "weapon@rifle@"
        },
        Shotgun = {
            Shoot = "weapon@shotgun@",
            Reload = "weapon@shotgun@",
            Empty = "weapon@shotgun@"
        },
        Sniper = {
            Shoot = "weapon@sniper@",
            Reload = "weapon@sniper@",
            Empty = "weapon@sniper@"
        }
    },
    
    -- Emote Sesleri
    Emotes = {
        Wave = "anim@heists@prison_heiststation@cop_reactions",
        ThumbsUp = "anim@heists@prison_heiststation@cop_reactions",
        ThumbsDown = "anim@heists@prison_heiststation@cop_reactions",
        Clap = "anim@heists@prison_heiststation@cop_reactions",
        Shrug = "anim@heists@prison_heiststation@cop_reactions"
    },
    
    -- Bildirim Sesleri
    Notifications = {
        Success = "HUD_FRONTEND_DEFAULT_SOUNDSET",
        Error = "HUD_FRONTEND_DEFAULT_SOUNDSET",
        Info = "HUD_FRONTEND_DEFAULT_SOUNDSET",
        Warning = "HUD_FRONTEND_DEFAULT_SOUNDSET"
    }
}

-- Ses Oynatma
function AendirCore.Functions.PlaySound(dict, sound, volume)
    RequestSoundSet(dict)
    while not HasSoundSetLoaded(dict) do
        Wait(0)
    end
    PlaySoundFrontend(-1, sound, dict, false)
    SetSoundVolume(-1, volume or 0.5)
end

-- Ses Durdurma
function AendirCore.Functions.StopSound()
    StopSound(-1)
end

-- Araç Sesleri
RegisterNetEvent('aendir:client:PlayVehicleSound', function(type, sound)
    if type == 'engine' then
        if sound == 'start' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Engine.Start, "start", 0.5)
        elseif sound == 'stop' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Engine.Stop, "stop", 0.5)
        elseif sound == 'rev' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Engine.Rev, "rev", 0.5)
        elseif sound == 'horn' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Engine.Horn, "horn", 0.5)
        end
    elseif type == 'doors' then
        if sound == 'open' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Doors.Open, "open", 0.5)
        elseif sound == 'close' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Doors.Close, "close", 0.5)
        elseif sound == 'lock' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Doors.Lock, "lock", 0.5)
        elseif sound == 'unlock' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Doors.Unlock, "unlock", 0.5)
        end
    elseif type == 'damage' then
        if sound == 'light' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Damage.Light, "light", 0.5)
        elseif sound == 'medium' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Damage.Medium, "medium", 0.5)
        elseif sound == 'heavy' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Damage.Heavy, "heavy", 0.5)
        end
    elseif type == 'fuel' then
        if sound == 'low' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Fuel.Low, "low", 0.5)
        elseif sound == 'empty' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Fuel.Empty, "empty", 0.5)
        elseif sound == 'refuel' then
            AendirCore.Functions.PlaySound(Sounds.Vehicles.Fuel.Refuel, "refuel", 0.5)
        end
    end
end)

-- Silah Sesleri
RegisterNetEvent('aendir:client:PlayWeaponSound', function(type, sound)
    if type == 'pistol' then
        if sound == 'shoot' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.Pistol.Shoot, "shoot", 0.5)
        elseif sound == 'reload' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.Pistol.Reload, "reload", 0.5)
        elseif sound == 'empty' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.Pistol.Empty, "empty", 0.5)
        end
    elseif type == 'smg' then
        if sound == 'shoot' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.SMG.Shoot, "shoot", 0.5)
        elseif sound == 'reload' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.SMG.Reload, "reload", 0.5)
        elseif sound == 'empty' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.SMG.Empty, "empty", 0.5)
        end
    elseif type == 'rifle' then
        if sound == 'shoot' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.Rifle.Shoot, "shoot", 0.5)
        elseif sound == 'reload' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.Rifle.Reload, "reload", 0.5)
        elseif sound == 'empty' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.Rifle.Empty, "empty", 0.5)
        end
    elseif type == 'shotgun' then
        if sound == 'shoot' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.Shotgun.Shoot, "shoot", 0.5)
        elseif sound == 'reload' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.Shotgun.Reload, "reload", 0.5)
        elseif sound == 'empty' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.Shotgun.Empty, "empty", 0.5)
        end
    elseif type == 'sniper' then
        if sound == 'shoot' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.Sniper.Shoot, "shoot", 0.5)
        elseif sound == 'reload' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.Sniper.Reload, "reload", 0.5)
        elseif sound == 'empty' then
            AendirCore.Functions.PlaySound(Sounds.Weapons.Sniper.Empty, "empty", 0.5)
        end
    end
end)

-- Emote Sesleri
RegisterNetEvent('aendir:client:PlayEmoteSound', function(type)
    if type == 'wave' then
        AendirCore.Functions.PlaySound(Sounds.Emotes.Wave, "wave", 0.5)
    elseif type == 'thumbsup' then
        AendirCore.Functions.PlaySound(Sounds.Emotes.ThumbsUp, "thumbsup", 0.5)
    elseif type == 'thumbsdown' then
        AendirCore.Functions.PlaySound(Sounds.Emotes.ThumbsDown, "thumbsdown", 0.5)
    elseif type == 'clap' then
        AendirCore.Functions.PlaySound(Sounds.Emotes.Clap, "clap", 0.5)
    elseif type == 'shrug' then
        AendirCore.Functions.PlaySound(Sounds.Emotes.Shrug, "shrug", 0.5)
    end
end)

-- Bildirim Sesleri
RegisterNetEvent('aendir:client:PlayNotificationSound', function(type)
    if type == 'success' then
        AendirCore.Functions.PlaySound(Sounds.Notifications.Success, "success", 0.5)
    elseif type == 'error' then
        AendirCore.Functions.PlaySound(Sounds.Notifications.Error, "error", 0.5)
    elseif type == 'info' then
        AendirCore.Functions.PlaySound(Sounds.Notifications.Info, "info", 0.5)
    elseif type == 'warning' then
        AendirCore.Functions.PlaySound(Sounds.Notifications.Warning, "warning", 0.5)
    end
end) 