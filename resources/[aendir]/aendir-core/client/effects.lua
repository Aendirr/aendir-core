-- Efektler
local Effects = {
    -- Parçacık Efektleri
    Particles = {
        -- Araç Efektleri
        Vehicle = {
            Exhaust = "core",
            Smoke = "core",
            Fire = "core",
            Sparks = "core",
            Water = "core"
        },
        -- Silah Efektleri
        Weapon = {
            Muzzle = "core",
            Impact = "core",
            Tracer = "core",
            Shell = "core"
        },
        -- Çevre Efektleri
        Environment = {
            Rain = "core",
            Snow = "core",
            Fog = "core",
            Wind = "core"
        }
    },
    
    -- Ekran Efektleri
    Screen = {
        -- Kamera Efektleri
        Camera = {
            Shake = "core",
            Blur = "core",
            Flash = "core",
            NightVision = "core"
        },
        -- HUD Efektleri
        HUD = {
            Damage = "core",
            Health = "core",
            Armor = "core",
            Stamina = "core"
        }
    }
}

-- Parçacık Efekti Oluşturma
function AendirCore.Functions.CreateParticle(dict, name, coords, rotation, scale, duration)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Wait(0)
    end
    UseParticleFxAssetNextCall(dict)
    local particle = StartParticleFxLoopedAtCoord(name, coords.x, coords.y, coords.z, rotation.x, rotation.y, rotation.z, scale, false, false, false)
    SetParticleFxLoopedAlpha(particle, 1.0)
    SetParticleFxLoopedColour(particle, 1.0, 1.0, 1.0, 0)
    if duration then
        SetTimeout(duration, function()
            StopParticleFxLooped(particle, 0)
            RemoveParticleFx(particle, 0)
        end)
    end
    return particle
end

-- Parçacık Efekti Durdurma
function AendirCore.Functions.StopParticle(particle)
    StopParticleFxLooped(particle, 0)
    RemoveParticleFx(particle, 0)
end

-- Ekran Efekti Oluşturma
function AendirCore.Functions.CreateScreenEffect(effect, duration)
    if effect == 'shake' then
        ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
    elseif effect == 'blur' then
        StartScreenEffect("DeathFailOut", 0, true)
    elseif effect == 'flash' then
        StartScreenEffect("DeathFailOut", 0, true)
    elseif effect == 'nightvision' then
        SetNightvision(true)
    end
    
    if duration then
        SetTimeout(duration, function()
            if effect == 'shake' then
                StopGameplayCamShaking()
            elseif effect == 'blur' then
                StopScreenEffect("DeathFailOut")
            elseif effect == 'flash' then
                StopScreenEffect("DeathFailOut")
            elseif effect == 'nightvision' then
                SetNightvision(false)
            end
        end)
    end
end

-- Ekran Efekti Durdurma
function AendirCore.Functions.StopScreenEffect(effect)
    if effect == 'shake' then
        StopGameplayCamShaking()
    elseif effect == 'blur' then
        StopScreenEffect("DeathFailOut")
    elseif effect == 'flash' then
        StopScreenEffect("DeathFailOut")
    elseif effect == 'nightvision' then
        SetNightvision(false)
    end
end

-- Araç Efektleri
RegisterNetEvent('aendir:client:CreateVehicleEffect', function(type, coords, rotation, scale, duration)
    if type == 'exhaust' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Vehicle.Exhaust, "exhaust", coords, rotation, scale, duration)
    elseif type == 'smoke' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Vehicle.Smoke, "smoke", coords, rotation, scale, duration)
    elseif type == 'fire' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Vehicle.Fire, "fire", coords, rotation, scale, duration)
    elseif type == 'sparks' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Vehicle.Sparks, "sparks", coords, rotation, scale, duration)
    elseif type == 'water' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Vehicle.Water, "water", coords, rotation, scale, duration)
    end
end)

-- Silah Efektleri
RegisterNetEvent('aendir:client:CreateWeaponEffect', function(type, coords, rotation, scale, duration)
    if type == 'muzzle' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Weapon.Muzzle, "muzzle", coords, rotation, scale, duration)
    elseif type == 'impact' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Weapon.Impact, "impact", coords, rotation, scale, duration)
    elseif type == 'tracer' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Weapon.Tracer, "tracer", coords, rotation, scale, duration)
    elseif type == 'shell' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Weapon.Shell, "shell", coords, rotation, scale, duration)
    end
end)

-- Çevre Efektleri
RegisterNetEvent('aendir:client:CreateEnvironmentEffect', function(type, coords, rotation, scale, duration)
    if type == 'rain' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Environment.Rain, "rain", coords, rotation, scale, duration)
    elseif type == 'snow' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Environment.Snow, "snow", coords, rotation, scale, duration)
    elseif type == 'fog' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Environment.Fog, "fog", coords, rotation, scale, duration)
    elseif type == 'wind' then
        AendirCore.Functions.CreateParticle(Effects.Particles.Environment.Wind, "wind", coords, rotation, scale, duration)
    end
end)

-- Kamera Efektleri
RegisterNetEvent('aendir:client:CreateCameraEffect', function(type, duration)
    if type == 'shake' then
        AendirCore.Functions.CreateScreenEffect('shake', duration)
    elseif type == 'blur' then
        AendirCore.Functions.CreateScreenEffect('blur', duration)
    elseif type == 'flash' then
        AendirCore.Functions.CreateScreenEffect('flash', duration)
    elseif type == 'nightvision' then
        AendirCore.Functions.CreateScreenEffect('nightvision', duration)
    end
end)

-- HUD Efektleri
RegisterNetEvent('aendir:client:CreateHUDEffect', function(type, duration)
    if type == 'damage' then
        AendirCore.Functions.CreateScreenEffect('damage', duration)
    elseif type == 'health' then
        AendirCore.Functions.CreateScreenEffect('health', duration)
    elseif type == 'armor' then
        AendirCore.Functions.CreateScreenEffect('armor', duration)
    elseif type == 'stamina' then
        AendirCore.Functions.CreateScreenEffect('stamina', duration)
    end
end) 