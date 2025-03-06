local QBCore = exports['qb-core']:GetCoreObject()
local trackedVehicles = {}
local isTracking = false

-- Takip Menüsü
function OpenTrackerMenu()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        QBCore.Functions.Notify('Bir araçta olmalısınız!', 'error')
        return
    end
    
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local plate = GetVehicleNumberPlateText(vehicle)
    
    -- Araç Kontrolü
    QBCore.Functions.TriggerCallback('aendir:server:CheckVehicleOwnership', function(owned)
        if owned then
            local elements = {
                {
                    title = "Takip Cihazı Tak",
                    description = "Araca takip cihazı takın",
                    event = "aendir:client:InstallTracker",
                    args = {
                        plate = plate
                    }
                },
                {
                    title = "Takip Cihazı Çıkar",
                    description = "Araçtan takip cihazı çıkarın",
                    event = "aendir:client:RemoveTracker",
                    args = {
                        plate = plate
                    }
                }
            }
            
            lib.registerContext({
                id = 'tracker_menu',
                title = "Takip Sistemi",
                options = elements
            })
            
            lib.showContext('tracker_menu')
        else
            QBCore.Functions.Notify('Bu araç size ait değil!', 'error')
        end
    end, plate)
end

-- Takip Cihazı Takma
RegisterNetEvent('aendir:client:InstallTracker', function(data)
    local plate = data.plate
    
    -- Eşya Kontrolü
    QBCore.Functions.TriggerCallback('aendir:server:CheckItem', function(hasItem)
        if hasItem then
            -- Animasyon
            local playerPed = PlayerPedId()
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
            
            -- Progress Bar
            QBCore.Functions.Progressbar("installing_tracker", "Takip cihazı takılıyor...", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                ClearPedTasks(playerPed)
                TriggerServerEvent('aendir:server:InstallTracker', plate)
            end, function() -- Cancel
                ClearPedTasks(playerPed)
            end)
        else
            QBCore.Functions.Notify('Takip cihazınız yok!', 'error')
        end
    end, 'tracker')
end)

-- Takip Cihazı Çıkarma
RegisterNetEvent('aendir:client:RemoveTracker', function(data)
    local plate = data.plate
    
    -- Animasyon
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
    
    -- Progress Bar
    QBCore.Functions.Progressbar("removing_tracker", "Takip cihazı çıkarılıyor...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(playerPed)
        TriggerServerEvent('aendir:server:RemoveTracker', plate)
    end, function() -- Cancel
        ClearPedTasks(playerPed)
    end)
end)

-- Takip Sistemi
RegisterNetEvent('aendir:client:StartTracking', function(plate)
    if trackedVehicles[plate] then return end
    
    trackedVehicles[plate] = true
    isTracking = true
    
    -- Blip Oluşturma
    local blip = AddBlipForEntity(GetVehicleByPlate(plate))
    SetBlipSprite(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Takip Edilen Araç: " .. plate)
    EndTextCommandSetBlipName(blip)
    
    -- Bildirim
    QBCore.Functions.Notify('Araç takip ediliyor!', 'success')
end)

-- Takip Sistemi Durdurma
RegisterNetEvent('aendir:client:StopTracking', function(plate)
    if not trackedVehicles[plate] then return end
    
    trackedVehicles[plate] = nil
    
    -- Blip Silme
    local blip = GetBlipFromEntity(GetVehicleByPlate(plate))
    if DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
    
    -- Bildirim
    QBCore.Functions.Notify('Araç takibi durduruldu!', 'error')
end)

-- Takip Sistemi Güncelleme
CreateThread(function()
    while true do
        Wait(1000)
        
        if isTracking then
            for plate, _ in pairs(trackedVehicles) do
                local vehicle = GetVehicleByPlate(plate)
                if DoesEntityExist(vehicle) then
                    -- Blip Güncelleme
                    local blip = GetBlipFromEntity(vehicle)
                    if DoesBlipExist(blip) then
                        local coords = GetEntityCoords(vehicle)
                        SetBlipCoords(blip, coords.x, coords.y, coords.z)
                    end
                end
            end
        end
    end
end)

-- Yardımcı Fonksiyonlar
function GetVehicleByPlate(plate)
    local vehicles = GetGamePool('CVehicle')
    
    for _, vehicle in ipairs(vehicles) do
        if GetVehicleNumberPlateText(vehicle) == plate then
            return vehicle
        end
    end
    
    return nil
end

-- Komutlar
RegisterCommand('tracker', function()
    OpenTrackerMenu()
end) 