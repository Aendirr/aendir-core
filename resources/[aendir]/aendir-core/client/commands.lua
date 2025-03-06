-- NoClip
local NoClip = false

RegisterNetEvent('aendir:client:ToggleNoClip', function()
    NoClip = not NoClip
    local ped = PlayerPedId()
    
    if NoClip then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if NoClip then
            local ped = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(ped))
            local dx, dy, dz = GetCamDirection()
            local speed = 0.5
            
            if IsControlPressed(0, 32) then -- W
                x = x + speed * dx
                y = y + speed * dy
                z = z + speed * dz
            end
            
            if IsControlPressed(0, 33) then -- S
                x = x - speed * dx
                y = y - speed * dy
                z = z - speed * dz
            end
            
            if IsControlPressed(0, 34) then -- A
                x = x - speed * dy
                y = y + speed * dx
            end
            
            if IsControlPressed(0, 35) then -- D
                x = x + speed * dy
                y = y - speed * dx
            end
            
            if IsControlPressed(0, 22) then -- Space
                z = z + speed
            end
            
            if IsControlPressed(0, 36) then -- Ctrl
                z = z - speed
            end
            
            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
        end
    end
end)

-- GodMode
local GodMode = false

RegisterNetEvent('aendir:client:ToggleGodMode', function()
    GodMode = not GodMode
    local ped = PlayerPedId()
    
    if GodMode then
        SetEntityInvincible(ped, true)
        SetPlayerInvincible(PlayerId(), true)
        SetPedCanRagdoll(ped, false)
        ClearPedBloodDamage(ped)
        ResetPedVisibleDamage(ped)
    else
        SetEntityInvincible(ped, false)
        SetPlayerInvincible(PlayerId(), false)
        SetPedCanRagdoll(ped, true)
    end
end)

-- Invisible
local Invisible = false

RegisterNetEvent('aendir:client:ToggleInvisible', function()
    Invisible = not Invisible
    local ped = PlayerPedId()
    
    if Invisible then
        SetEntityVisible(ped, false, false)
    else
        SetEntityVisible(ped, true, false)
    end
end)

-- Yardımcı Fonksiyonlar
function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end
    
    return x, y, z
end 