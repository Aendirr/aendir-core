local QBCore = exports['qb-core']:GetCoreObject()
local currentVehicle = nil
local modCategories = {
    {name = "Spoiler", id = 0},
    {name = "Ön Tampon", id = 1},
    {name = "Arka Tampon", id = 2},
    {name = "Yan Paneller", id = 3},
    {name = "Egzoz", id = 4},
    {name = "Kafes", id = 5},
    {name = "Radyatör", id = 6},
    {name = "Çamurluk", id = 7},
    {name = "Kaput", id = 8},
    {name = "Çatı", id = 10},
    {name = "Motor", id = 11},
    {name = "Frenler", id = 12},
    {name = "Transmisyon", id = 13},
    {name = "Korna", id = 14},
    {name = "Süspansiyon", id = 15},
    {name = "Zırh", id = 16},
    {name = "Turbo", id = 18},
    {name = "Xenon", id = 22},
    {name = "Tekerlekler", id = 23},
    {name = "Renk", id = 25},
    {name = "Aksesuarlar", id = 27},
    {name = "Plaka", id = 28},
    {name = "Neon", id = 29},
    {name = "Cam", id = 30},
    {name = "Livery", id = 31},
    {name = "Extra", id = 32}
}

-- Modifiye Noktaları
local modShops = {
    {
        name = "LS Customs",
        coords = vector3(-347.4, -133.0, 39.0),
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.8,
            label = "LS Customs"
        }
    },
    {
        name = "Benny's Original",
        coords = vector3(-205.7, -1312.7, 31.1),
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.8,
            label = "Benny's Original"
        }
    },
    {
        name = "Mors Mutual",
        coords = vector3(-273.8, -955.8, 31.2),
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.8,
            label = "Mors Mutual"
        }
    }
}

-- Blip Oluşturma
CreateThread(function()
    for _, shop in pairs(modShops) do
        local blip = AddBlipForCoord(shop.coords)
        SetBlipSprite(blip, shop.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, shop.blip.scale)
        SetBlipColour(blip, shop.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(shop.blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Modifiye Menüsü
function OpenModShop(shop)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        QBCore.Functions.Notify('Bir araçta olmalısınız!', 'error')
        return
    end
    
    currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    
    local elements = {}
    
    for _, category in pairs(modCategories) do
        table.insert(elements, {
            title = category.name,
            description = "Araç " .. category.name:lower() .. " modifikasyonları",
            event = "aendir:client:OpenModCategory",
            args = {
                category = category,
                shop = shop
            }
        })
    end
    
    lib.registerContext({
        id = 'modshop_menu',
        title = shop.name,
        options = elements
    })
    
    lib.showContext('modshop_menu')
end

-- Modifiye Kategorisi
RegisterNetEvent('aendir:client:OpenModCategory', function(data)
    local category = data.category
    local shop = data.shop
    
    local elements = {}
    local numMods = GetNumVehicleMods(currentVehicle, category.id)
    
    for i = -1, numMods - 1 do
        local modName = GetModTextLabel(currentVehicle, category.id, i)
        local modPrice = GetModPrice(category.id, i)
        
        table.insert(elements, {
            title = modName or "Stok",
            description = "Fiyat: $" .. modPrice,
            event = "aendir:client:ApplyMod",
            args = {
                category = category,
                modIndex = i,
                price = modPrice
            }
        })
    end
    
    lib.registerContext({
        id = 'mod_category',
        title = category.name,
        menu = 'modshop_menu',
        options = elements
    })
    
    lib.showContext('mod_category')
end)

-- Modifiye Uygulama
RegisterNetEvent('aendir:client:ApplyMod', function(data)
    local category = data.category
    local modIndex = data.modIndex
    local price = data.price
    
    TriggerServerEvent('aendir:server:ApplyMod', {
        category = category,
        modIndex = modIndex,
        price = price
    })
end)

-- Modifiye Noktalarını Kontrol Etme
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, shop in pairs(modShops) do
            local distance = #(coords - shop.coords)
            
            if distance < 2.0 then
                DrawText3D(shop.coords.x, shop.coords.y, shop.coords.z + 1.0, '~g~E~w~ - ' .. shop.name)
                
                if IsControlJustPressed(0, 38) then -- E tuşu
                    OpenModShop(shop)
                end
            end
        end
    end
end)

-- Yardımcı Fonksiyonlar
function GetModPrice(category, modIndex)
    local basePrice = 1000
    local multiplier = 1.0
    
    if category.id == 11 then -- Motor
        multiplier = 2.0
    elseif category.id == 12 then -- Frenler
        multiplier = 1.5
    elseif category.id == 13 then -- Transmisyon
        multiplier = 1.5
    elseif category.id == 15 then -- Süspansiyon
        multiplier = 1.2
    elseif category.id == 16 then -- Zırh
        multiplier = 2.0
    elseif category.id == 18 then -- Turbo
        multiplier = 3.0
    end
    
    return math.floor(basePrice * multiplier * (modIndex + 1))
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0+0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end 