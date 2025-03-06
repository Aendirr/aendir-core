local isInventoryOpen = false
local currentInventory = {}
local currentWeight = 0
local maxWeight = Config.MaxWeight

-- Envanteri aç
function OpenInventory()
    if isInventoryOpen then return end
    
    isInventoryOpen = true
    SetNuiFocus(true, true)
    
    -- Envanter verilerini al
    TriggerServerEvent('aendir-inventory:server:GetInventory')
end

-- Envanteri kapat
function CloseInventory()
    if not isInventoryOpen then return end
    
    isInventoryOpen = false
    SetNuiFocus(false, false)
    
    SendNUIMessage({
        type = 'closeInventory'
    })
end

-- Envanter verilerini güncelle
RegisterNetEvent('aendir-inventory:client:UpdateInventory')
AddEventHandler('aendir-inventory:client:UpdateInventory', function(inventory, weight)
    currentInventory = inventory
    currentWeight = weight
    
    SendNUIMessage({
        type = 'updateInventory',
        inventory = currentInventory,
        weight = currentWeight,
        maxWeight = maxWeight
    })
end)

-- Eşya kullan
RegisterNUICallback('useItem', function(data, cb)
    local item = data.item
    local index = data.index
    
    TriggerServerEvent('aendir-inventory:server:UseItem', item, index)
    cb('ok')
end)

-- Eşya transfer et
RegisterNUICallback('transferItem', function(data, cb)
    local item = data.item
    local index = data.index
    
    TriggerServerEvent('aendir-inventory:server:TransferItem', item, index)
    cb('ok')
end)

-- Eşya sat
RegisterNUICallback('sellItem', function(data, cb)
    local item = data.item
    local index = data.index
    
    TriggerServerEvent('aendir-inventory:server:SellItem', item, index)
    cb('ok')
end)

-- Silahı çıkar
RegisterNUICallback('unequipWeapon', function(data, cb)
    local item = data.item
    local index = data.index
    
    TriggerServerEvent('aendir-inventory:server:UnequipWeapon', item, index)
    cb('ok')
end)

-- Envanteri kapat
RegisterNUICallback('closeInventory', function(data, cb)
    CloseInventory()
    cb('ok')
end)

-- Komut kaydı
RegisterCommand(Config.Commands.inventory, function()
    OpenInventory()
end, false)

-- Tuş kaydı
RegisterKeyMapping(Config.Commands.inventory, 'Envanteri Aç/Kapat', 'keyboard', Config.Keys.inventory)

-- Bildirim göster
RegisterNetEvent('aendir-inventory:client:ShowNotification')
AddEventHandler('aendir-inventory:client:ShowNotification', function(message, type)
    SendNUIMessage({
        type = 'showNotification',
        message = message,
        notificationType = type
    })
end)

-- İlerleme çubuğu göster
RegisterNetEvent('aendir-inventory:client:ShowProgress')
AddEventHandler('aendir-inventory:client:ShowProgress', function(message)
    SendNUIMessage({
        type = 'showProgress',
        message = message
    })
end)

-- İlerleme çubuğu gizle
RegisterNetEvent('aendir-inventory:client:HideProgress')
AddEventHandler('aendir-inventory:client:HideProgress', function()
    SendNUIMessage({
        type = 'hideProgress'
    })
end)

-- ESC tuşu ile kapatma
CreateThread(function()
    while true do
        Wait(0)
        if isInventoryOpen then
            if IsControlJustReleased(0, 177) then -- 177 = BACKSPACE
                CloseInventory()
            end
        end
    end
end) 