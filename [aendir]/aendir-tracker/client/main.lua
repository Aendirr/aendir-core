local QBCore = exports['qb-core']:GetCoreObject()
local trackedVehicles = {}
local isTracking = false

-- Takip Menüsü
function OpenTrackerMenu(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    
    QBCore.Functions.TriggerCallback('aendir:server:CheckVehicleOwnership', function(owned)
        if owned then
            local elements = {}
            
            QBCore.Functions.TriggerCallback('aendir:server:CheckVehicleTracker', function(hasTracker)
                if hasTracker then
                    table.insert(elements, {
                        title = "Takibi Başlat",
                        description = "Aracı takip etmeye başla",
                        event = "aendir:client:StartTracking",
                        args = {
                            plate = plate
                        }
                    })
                else
                    table.insert(elements, {
                        title = "Takip Cihazı Tak",
                        description = string.format("Takip cihazı tak (Ücret: $%d)", Config.TrackerPrice),
                        event = "aendir:client:InstallTracker",
                        args = {
                            plate = plate
                        }
                    })
                end
            end, plate)
            
            lib.registerContext({
                id = 'tracker_menu',
                title = 'Takip Menüsü',
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
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    if plate ~= data.plate then return end
    
    -- Animasyon
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
    
    -- Progress Bar
    if lib.progressBar({
        duration = 5000,
        label = 'Takip Cihazı Takılıyor...'
    }) then
        -- Takip Cihazı Takma
        QBCore.Functions.TriggerCallback('aendir:server:InstallTracker', function(success)
            if success then
                QBCore.Functions.Notify('Takip cihazı takıldı!', 'success')
            else
                QBCore.Functions.Notify('Yeterli paranız yok!', 'error')
            end
        end, plate)
    end
    
    ClearPedTasks(playerPed)
end)

-- Takip Cihazı Çıkarma
RegisterNetEvent('aendir:client:RemoveTracker', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    if plate ~= data.plate then return end
    
    -- Animasyon
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
    
    -- Progress Bar
    if lib.progressBar({
        duration = 5000,
        label = 'Takip Cihazı Çıkarılıyor...'
    }) then
        -- Takip Cihazı Çıkarma
        QBCore.Functions.TriggerCallback('aendir:server:RemoveTracker', function(success)
            if success then
                QBCore.Functions.Notify('Takip cihazı çıkarıldı!', 'success')
            else
                QBCore.Functions.Notify('Bir hata oluştu!', 'error')
            end
        end, plate)
    end
    
    ClearPedTasks(playerPed)
end)

-- Takibi Başlat
RegisterNetEvent('aendir:client:StartTracking', function(data)
    local plate = data.plate
    
    if not trackedVehicles[plate] then
        trackedVehicles[plate] = {
            blip = nil,
            vehicle = nil
        }
        
        -- Blip Oluştur
        local blip = AddBlipForEntity(trackedVehicles[plate].vehicle)
        SetBlipSprite(blip, Config.TrackerBlip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.TrackerBlip.scale)
        SetBlipColour(blip, Config.TrackerBlip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.TrackerBlip.label)
        EndTextCommandSetBlipName(blip)
        
        trackedVehicles[plate].blip = blip
        isTracking = true
        
        QBCore.Functions.Notify('Takip başlatıldı!', 'success')
    else
        QBCore.Functions.Notify('Bu araç zaten takip ediliyor!', 'error')
    end
end)

-- Takibi Durdur
RegisterNetEvent('aendir:client:StopTracking', function(data)
    local plate = data.plate
    
    if trackedVehicles[plate] then
        if trackedVehicles[plate].blip then
            RemoveBlip(trackedVehicles[plate].blip)
        end
        
        trackedVehicles[plate] = nil
        isTracking = false
        
        QBCore.Functions.Notify('Takip durduruldu!', 'success')
    else
        QBCore.Functions.Notify('Bu araç takip edilmiyor!', 'error')
    end
end)

-- Takip Menüsünü Aç
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        if IsControlJustPressed(0, 38) then -- E tuşu
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle ~= 0 then
                OpenTrackerMenu(vehicle)
            end
        end
    end
end)

-- Takip Güncelleme
CreateThread(function()
    while true do
        Wait(1000)
        
        if isTracking then
            for plate, data in pairs(trackedVehicles) do
                local vehicle = GetVehicleByPlate(plate)
                
                if vehicle then
                    local coords = GetEntityCoords(vehicle)
                    SetBlipCoords(data.blip, coords.x, coords.y, coords.z)
                else
                    -- Araç bulunamadı, takibi durdur
                    TriggerEvent('aendir:client:StopTracking', {plate = plate})
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