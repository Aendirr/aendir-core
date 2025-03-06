-- Yardımcı Fonksiyonlar
function ShowNotification(message, type)
    if Config.Notifications.Position == "top-right" then
        lib.notify({
            title = 'Aendir Core',
            description = message,
            type = type,
            duration = Config.Notifications.Duration
        })
    end
end

function ShowProgressBar(label)
    if lib.progressBar({
        duration = Config.ProgressBar.Duration,
        label = label,
        position = Config.ProgressBar.Position
    }) then
        return true
    end
    return false
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function GetVehicleByPlate(plate)
    local vehicles = GetGamePool('CVehicle')
    
    for _, vehicle in ipairs(vehicles) do
        if GetVehicleNumberPlateText(vehicle) == plate then
            return vehicle
        end
    end
    
    return nil
end

function CreateBlip(coords, sprite, color, scale, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

function DrawMarker(coords)
    DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
end

function IsNearCoords(coords, distance)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    return #(playerCoords - coords) < distance
end

function IsInVehicle()
    local playerPed = PlayerPedId()
    return IsPedInAnyVehicle(playerPed, false)
end

function GetCurrentVehicle()
    local playerPed = PlayerPedId()
    return GetVehiclePedIsIn(playerPed, false)
end

function GetVehiclePlate(vehicle)
    return GetVehicleNumberPlateText(vehicle)
end

function IsVehicleOwner(plate)
    local result = false
    QBCore.Functions.TriggerCallback('aendir:server:CheckVehicleOwnership', function(owned)
        result = owned
    end, plate)
    return result
end

-- Exports
exports('ShowNotification', ShowNotification)
exports('ShowProgressBar', ShowProgressBar)
exports('DrawText3D', DrawText3D)
exports('GetVehicleByPlate', GetVehicleByPlate)
exports('CreateBlip', CreateBlip)
exports('DrawMarker', DrawMarker)
exports('IsNearCoords', IsNearCoords)
exports('IsInVehicle', IsInVehicle)
exports('GetCurrentVehicle', GetCurrentVehicle)
exports('GetVehiclePlate', GetVehiclePlate)
exports('IsVehicleOwner', IsVehicleOwner) 