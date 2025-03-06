local Aendir = exports['aendir-core']:GetCoreObject()

local currentHouse = nil
local isInHouse = false
local isViewingCameras = false

-- Ev satın alma menüsü
RegisterNetEvent('aendir:client:ShowHouseMenu', function(houseId)
    local house = Aendir.Houses[houseId]
    if not house then return end

    lib.registerContext({
        id = 'house_menu',
        title = 'Ev Menüsü',
        options = {
            {
                title = 'Ev Bilgileri',
                description = string.format('Fiyat: $%s\nKonum: %s', house.price, house.location.name)
            },
            {
                title = 'Satın Al',
                description = 'Bu evi satın al',
                onSelect = function()
                    TriggerServerEvent('aendir:server:BuyHouse', houseId)
                end
            },
            {
                title = 'Sat',
                description = 'Bu evi sat',
                onSelect = function()
                    TriggerServerEvent('aendir:server:SellHouse', houseId)
                end
            },
            {
                title = 'Depo',
                description = 'Ev deposunu aç',
                onSelect = function()
                    TriggerEvent('aendir:client:OpenHouseStorage', houseId)
                end
            },
            {
                title = 'Güvenlik',
                description = 'Güvenlik ayarlarını aç',
                onSelect = function()
                    TriggerEvent('aendir:client:OpenSecurityMenu', houseId)
                end
            }
        }
    })

    lib.showContext('house_menu')
end)

-- Ev deposu menüsü
RegisterNetEvent('aendir:client:OpenHouseStorage', function(houseId)
    local house = Aendir.Houses[houseId]
    if not house then return end

    lib.registerContext({
        id = 'house_storage',
        title = 'Ev Deposu',
        options = {
            {
                title = 'Eşya Depola',
                description = 'Envanterinizden eşya depolayın',
                onSelect = function()
                    TriggerEvent('aendir:client:OpenDepositMenu', houseId)
                end
            },
            {
                title = 'Eşya Al',
                description = 'Depodan eşya alın',
                onSelect = function()
                    TriggerEvent('aendir:client:OpenRetrieveMenu', houseId)
                end
            }
        }
    })

    lib.showContext('house_storage')
end)

-- Ev depolama menüsü
RegisterNetEvent('aendir:client:OpenDepositMenu', function(houseId)
    local options = {}

    for item, data in pairs(PlayerData.inventory) do
        if data.amount > 0 then
            table.insert(options, {
                title = item,
                description = string.format('Miktar: %s', data.amount),
                onSelect = function()
                    local input = lib.inputDialog('Eşya Depola', {
                        {type = 'number', label = 'Miktar', description = 'Depolamak istediğiniz miktar', required = true}
                    })

                    if input then
                        local amount = input[1]
                        if amount > 0 and amount <= data.amount then
                            TriggerServerEvent('aendir:server:StoreItem', houseId, item, amount)
                        end
                    end
                end
            })
        end
    end

    lib.registerContext({
        id = 'deposit_menu',
        title = 'Eşya Depola',
        options = options
    })

    lib.showContext('deposit_menu')
end)

-- Ev eşya alma menüsü
RegisterNetEvent('aendir:client:OpenRetrieveMenu', function(houseId)
    local house = Aendir.Houses[houseId]
    if not house then return end

    local options = {}

    for i, item in ipairs(house.inventory) do
        table.insert(options, {
            title = item.item,
            description = string.format('Miktar: %s', item.amount),
            onSelect = function()
                local input = lib.inputDialog('Eşya Al', {
                    {type = 'number', label = 'Miktar', description = 'Almak istediğiniz miktar', required = true}
                })

                if input then
                    local amount = input[1]
                    if amount > 0 and amount <= item.amount then
                        TriggerServerEvent('aendir:server:RetrieveItem', houseId, i, amount)
                    end
                end
            end
        })
    end

    lib.registerContext({
        id = 'retrieve_menu',
        title = 'Eşya Al',
        options = options
    })

    lib.showContext('retrieve_menu')
end)

-- Ev güvenlik menüsü
RegisterNetEvent('aendir:client:OpenSecurityMenu', function(houseId)
    local house = Aendir.Houses[houseId]
    if not house then return end

    lib.registerContext({
        id = 'security_menu',
        title = 'Güvenlik Ayarları',
        options = {
            {
                title = 'Alarm Sistemi',
                description = house.alarm and 'Alarm sistemi aktif' or 'Alarm sistemi devre dışı',
                onSelect = function()
                    TriggerServerEvent('aendir:server:ToggleAlarm', houseId)
                end
            },
            {
                title = 'Kamera Sistemi',
                description = house.camera and 'Kamera sistemi aktif' or 'Kamera sistemi devre dışı',
                onSelect = function()
                    TriggerServerEvent('aendir:server:ToggleCamera', houseId)
                end
            },
            {
                title = 'Kamera Görüntüsü',
                description = 'Kamera görüntülerini izle',
                onSelect = function()
                    TriggerEvent('aendir:client:ViewCameras', houseId)
                end
            }
        }
    })

    lib.showContext('security_menu')
end)

-- Ev kamera görüntüsü
RegisterNetEvent('aendir:client:ViewCameras', function(houseId)
    local house = Aendir.Houses[houseId]
    if not house or not house.camera then return end

    isViewingCameras = true
    local cameraIndex = 1
    local cameras = house.cameras

    CreateThread(function()
        while isViewingCameras do
            Wait(0)
            local camera = cameras[cameraIndex]
            if camera then
                DrawMarker(1, camera.x, camera.y, camera.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, true, 2, false, nil, nil, false)
                
                if IsControlJustPressed(0, 38) then -- E tuşu
                    cameraIndex = cameraIndex + 1
                    if cameraIndex > #cameras then
                        cameraIndex = 1
                    end
                end

                if IsControlJustPressed(0, 177) then -- BACKSPACE tuşu
                    isViewingCameras = false
                end
            end
        end
    end)
end)

-- Ev listesi
RegisterNetEvent('aendir:client:ShowHouses', function(houses)
    local options = {}

    for _, house in pairs(houses) do
        table.insert(options, {
            title = house.location.name,
            description = string.format('Fiyat: $%s\nAlarm: %s\nKamera: %s', 
                house.price,
                house.alarm and 'Aktif' or 'Devre Dışı',
                house.camera and 'Aktif' or 'Devre Dışı'
            ),
            onSelect = function()
                TriggerEvent('aendir:client:ShowHouseMenu', house.id)
            end
        })
    end

    lib.registerContext({
        id = 'house_list',
        title = 'Evlerim',
        options = options
    })

    lib.showContext('house_list')
end)

-- Ev blipleri
CreateThread(function()
    for id, house in pairs(Config.Housing.houses) do
        local blip = AddBlipForCoord(house.coords.x, house.coords.y, house.coords.z)
        SetBlipSprite(blip, 40)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(house.name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Ev etkileşimleri
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for id, house in pairs(Config.Housing.houses) do
            local distance = #(coords - house.coords)
            if distance < 10.0 then
                DrawMarker(1, house.coords.x, house.coords.y, house.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 2.0 then
                    if IsControlJustPressed(0, 38) then -- E tuşu
                        TriggerEvent('aendir:client:ShowHouseMenu', id)
                    end
                end
            end
        end
    end
end)

-- Komutlar
RegisterCommand('evlerim', function()
    TriggerServerEvent('aendir:server:GetHouses')
end)

-- Keybinds
RegisterKeyMapping('evlerim', 'Evlerim menüsünü aç', 'keyboard', 'F8') 