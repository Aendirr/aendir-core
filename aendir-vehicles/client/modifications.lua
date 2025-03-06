local AendirCore = exports['aendir-core']:GetCoreObject()

-- Modifikasyon Sistemi
local modShops = {
    {x = -347.291, y = -133.0, z = 39.009},
    {x = -1155.536, y = -2007.183, z = 13.180},
    {x = -731.105, y = -283.263, z = 36.848},
    {x = -275.522, y = 6225.835, z = 31.485},
    {x = 191.979, y = -3030.733, z = 5.907},
    {x = 1174.76, y = 2640.925, z = 37.754},
    {x = 1108.72, y = -778.105, z = 58.289},
    {x = 937.237, y = -970.38, z = 39.569},
    {x = 540.409, y = -183.651, z = 54.481},
    {x = -211.55, y = -1324.55, z = 31.089}
}

-- Modifikasyon Dükkanı Blip'leri
CreateThread(function()
    for _, shop in ipairs(modShops) do
        local blip = AddBlipForCoord(shop.x, shop.y, shop.z)
        SetBlipSprite(blip, 446)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 5)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Modifikasyon Dükkanı')
        EndTextCommandSetBlipName(blip)
    end
end)

-- Modifikasyon Dükkanı Marker'ları
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, shop in ipairs(modShops) do
            local distance = #(coords - vector3(shop.x, shop.y, shop.z))
            
            if distance < 10.0 then
                DrawMarker(1, shop.x, shop.y, shop.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 3.0 then
                    if IsPedInAnyVehicle(playerPed, false) then
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        local plate = GetVehicleNumberPlateText(vehicle)
                        
                        AendirCore.Functions.ShowHelpText('~INPUT_CONTEXT~ Modifikasyon Menüsü')
                        
                        if IsControlJustPressed(0, 38) then -- E tuşu
                            OpenModificationMenu(plate)
                        end
                    else
                        AendirCore.Functions.ShowHelpText('Bir araçta olmalısınız')
                    end
                end
            end
        end
    end
end)

-- Modifikasyon Menüsü
function OpenModificationMenu(plate)
    lib.registerContext({
        id = 'vehicle_modification_menu',
        title = 'Modifikasyon Menüsü',
        options = {
            {
                title = 'Motor',
                description = 'Motor modifikasyonları',
                onSelect = function()
                    OpenModificationCategory(plate, 'engine')
                end
            },
            {
                title = 'Frenler',
                description = 'Fren modifikasyonları',
                onSelect = function()
                    OpenModificationCategory(plate, 'brakes')
                end
            },
            {
                title = 'Şanzıman',
                description = 'Şanzıman modifikasyonları',
                onSelect = function()
                    OpenModificationCategory(plate, 'transmission')
                end
            },
            {
                title = 'Süspansiyon',
                description = 'Süspansiyon modifikasyonları',
                onSelect = function()
                    OpenModificationCategory(plate, 'suspension')
                end
            },
            {
                title = 'Turbo',
                description = 'Turbo modifikasyonları',
                onSelect = function()
                    OpenModificationCategory(plate, 'turbo')
                end
            },
            {
                title = 'Görünüm',
                description = 'Görünüm modifikasyonları',
                onSelect = function()
                    OpenModificationCategory(plate, 'cosmetics')
                end
            }
        }
    })
    
    lib.showContext('vehicle_modification_menu')
end

-- Modifikasyon Kategori Menüsü
function OpenModificationCategory(plate, category)
    local vehicle = GetVehicleByPlate(plate)
    if not DoesEntityExist(vehicle) then return end
    
    local options = {}
    local modCount = GetNumVehicleMods(vehicle, GetModType(category))
    
    for i = -1, modCount - 1 do
        local modName = GetModTextLabel(vehicle, GetModType(category), i)
        if modName ~= nil then
            table.insert(options, {
                title = modName,
                description = 'Bu modifikasyonu uygula',
                onSelect = function()
                    TriggerServerEvent('aendir:server:ApplyModification', plate, category, i)
                end
            })
        end
    end
    
    lib.registerContext({
        id = 'vehicle_modification_category_menu',
        title = string.format('%s Modifikasyonları', GetCategoryName(category)),
        options = options
    })
    
    lib.showContext('vehicle_modification_category_menu')
end

-- Yardımcı Fonksiyonlar
function GetModType(category)
    local modTypes = {
        engine = 11,
        brakes = 12,
        transmission = 13,
        suspension = 15,
        turbo = 18,
        cosmetics = 0
    }
    return modTypes[category]
end

function GetCategoryName(category)
    local names = {
        engine = 'Motor',
        brakes = 'Frenler',
        transmission = 'Şanzıman',
        suspension = 'Süspansiyon',
        turbo = 'Turbo',
        cosmetics = 'Görünüm'
    }
    return names[category]
end

-- Modifikasyon Durumu Senkronizasyonu
RegisterNetEvent('aendir:client:SyncVehicleModification', function(plate, category, modIndex)
    local vehicle = GetVehicleByPlate(plate)
    if DoesEntityExist(vehicle) then
        if category == 'turbo' then
            ToggleVehicleMod(vehicle, 18, modIndex == 1)
        else
            SetVehicleMod(vehicle, GetModType(category), modIndex, false)
        end
    end
end) 