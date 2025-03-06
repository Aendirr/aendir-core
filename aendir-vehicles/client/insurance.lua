local AendirCore = exports['aendir-core']:GetCoreObject()

-- Sigorta Sistemi
local insuranceOffices = {
    {x = -273.001, y = -955.954, z = 31.223},
    {x = -724.619, y = -935.1631, z = 19.213},
    {x = -526.019, y = -1211.003, z = 18.184},
    {x = -70.2148, y = -1761.792, z = 29.534},
    {x = 265.648, y = -1261.309, z = 29.292},
    {x = 819.653, y = -1027.883, z = 26.403},
    {x = 1208.951, y = -1402.567, z = 35.224},
    {x = 1181.381, y = -330.847, z = 69.316},
    {x = 620.843, y = 269.100, z = 103.089},
    {x = 2581.321, y = 362.039, z = 108.468}
}

-- Sigorta Ofisi Blip'leri
CreateThread(function()
    for _, office in ipairs(insuranceOffices) do
        local blip = AddBlipForCoord(office.x, office.y, office.z)
        SetBlipSprite(blip, 498)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Sigorta Ofisi')
        EndTextCommandSetBlipName(blip)
    end
end)

-- Sigorta Ofisi Marker'ları
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, office in ipairs(insuranceOffices) do
            local distance = #(coords - vector3(office.x, office.y, office.z))
            
            if distance < 10.0 then
                DrawMarker(1, office.x, office.y, office.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 3.0 then
                    if IsPedInAnyVehicle(playerPed, false) then
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        local plate = GetVehicleNumberPlateText(vehicle)
                        
                        AendirCore.Functions.ShowHelpText('~INPUT_CONTEXT~ Sigorta İşlemleri')
                        
                        if IsControlJustPressed(0, 38) then -- E tuşu
                            OpenInsuranceMenu(plate)
                        end
                    else
                        AendirCore.Functions.ShowHelpText('Bir araçta olmalısınız')
                    end
                end
            end
        end
    end
end)

-- Sigorta Menüsü
function OpenInsuranceMenu(plate)
    lib.registerContext({
        id = 'vehicle_insurance_menu',
        title = 'Sigorta İşlemleri',
        options = {
            {
                title = 'Sigorta Yaptır',
                description = 'Aracınızı sigortalatın',
                onSelect = function()
                    TriggerServerEvent('aendir:server:InsureVehicle', plate)
                end
            },
            {
                title = 'Sigorta İptal',
                description = 'Aracınızın sigortasını iptal edin',
                onSelect = function()
                    TriggerServerEvent('aendir:server:CancelInsurance', plate)
                end
            },
            {
                title = 'Sigorta Durumu',
                description = 'Aracınızın sigorta durumunu kontrol edin',
                onSelect = function()
                    TriggerServerEvent('aendir:server:CheckInsurance', plate)
                end
            }
        }
    })
    
    lib.showContext('vehicle_insurance_menu')
end

-- Sigorta Durumu Senkronizasyonu
RegisterNetEvent('aendir:client:SyncVehicleInsurance', function(plate, insured)
    local vehicle = GetVehicleByPlate(plate)
    if DoesEntityExist(vehicle) then
        if insured then
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)
            SetVehicleNeedsToBeHotwired(vehicle, false)
        else
            SetVehicleHasBeenOwnedByPlayer(vehicle, false)
            SetVehicleNeedsToBeHotwired(vehicle, true)
        end
    end
end)

-- Sigorta Bildirimleri
RegisterNetEvent('aendir:client:InsuranceNotification', function(message, type)
    AendirCore.Functions.ShowNotification(message, type)
end)