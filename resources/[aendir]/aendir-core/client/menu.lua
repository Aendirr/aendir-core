-- Menü
local AendirCore = exports['aendir-core']:GetCoreObject()

-- Değişkenler
local isMenuOpen = false
local currentMenu = nil
local menuItems = {}

-- Menü Fonksiyonları
local function OpenMenu(menu)
    if not isMenuOpen then
        isMenuOpen = true
        currentMenu = menu
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'openMenu',
            menu = menu,
            items = menuItems[menu]
        })
    end
end

local function CloseMenu()
    if isMenuOpen then
        isMenuOpen = false
        currentMenu = nil
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = 'closeMenu'
        })
    end
end

-- Menü Tanımlamaları
menuItems.main = {
    {
        title = 'Karakter',
        description = 'Karakter menüsünü aç',
        icon = 'user',
        action = function()
            TriggerEvent('aendir:client:OpenCharacterMenu')
        end
    },
    {
        title = 'Envanter',
        description = 'Envanter menüsünü aç',
        icon = 'box',
        action = function()
            TriggerEvent('aendir:client:OpenInventory')
        end
    },
    {
        title = 'Telefon',
        description = 'Telefon menüsünü aç',
        icon = 'phone',
        action = function()
            TriggerEvent('aendir:client:OpenPhone')
        end
    },
    {
        title = 'Araç',
        description = 'Araç menüsünü aç',
        icon = 'car',
        action = function()
            TriggerEvent('aendir:client:OpenVehicleMenu')
        end
    },
    {
        title = 'Mülk',
        description = 'Mülk menüsünü aç',
        icon = 'home',
        action = function()
            TriggerEvent('aendir:client:OpenPropertyMenu')
        end
    },
    {
        title = 'İşletme',
        description = 'İşletme menüsünü aç',
        icon = 'briefcase',
        action = function()
            TriggerEvent('aendir:client:OpenBusinessMenu')
        end
    }
}

menuItems.vehicle = {
    {
        title = 'Araç Çıkar',
        description = 'Garajdan araç çıkar',
        icon = 'car',
        action = function()
            TriggerEvent('aendir:client:SpawnVehicle')
        end
    },
    {
        title = 'Araç Garaja Koy',
        description = 'Aracı garaja koy',
        icon = 'warehouse',
        action = function()
            TriggerEvent('aendir:client:StoreVehicle')
        end
    },
    {
        title = 'Araç Sat',
        description = 'Aracı sat',
        icon = 'money-bill',
        action = function()
            TriggerEvent('aendir:client:SellVehicle')
        end
    },
    {
        title = 'Araç Sigorta',
        description = 'Araç sigortası yaptır',
        icon = 'shield-alt',
        action = function()
            TriggerEvent('aendir:client:InsureVehicle')
        end
    },
    {
        title = 'Araç Modifiye',
        description = 'Aracı modifiye et',
        icon = 'tools',
        action = function()
            TriggerEvent('aendir:client:ModifyVehicle')
        end
    }
}

menuItems.property = {
    {
        title = 'Mülk Satın Al',
        description = 'Mülk satın al',
        icon = 'home',
        action = function()
            TriggerEvent('aendir:client:BuyProperty')
        end
    },
    {
        title = 'Mülk Sat',
        description = 'Mülk sat',
        icon = 'money-bill',
        action = function()
            TriggerEvent('aendir:client:SellProperty')
        end
    },
    {
        title = 'Mülk Kirala',
        description = 'Mülk kirala',
        icon = 'key',
        action = function()
            TriggerEvent('aendir:client:RentProperty')
        end
    },
    {
        title = 'Kira İptal',
        description = 'Kira sözleşmesini iptal et',
        icon = 'times',
        action = function()
            TriggerEvent('aendir:client:CancelRent')
        end
    }
}

menuItems.business = {
    {
        title = 'İşletme Satın Al',
        description = 'İşletme satın al',
        icon = 'store',
        action = function()
            TriggerEvent('aendir:client:BuyBusiness')
        end
    },
    {
        title = 'İşletme Sat',
        description = 'İşletme sat',
        icon = 'money-bill',
        action = function()
            TriggerEvent('aendir:client:SellBusiness')
        end
    },
    {
        title = 'Çalışan Ekle',
        description = 'İşletmeye çalışan ekle',
        icon = 'user-plus',
        action = function()
            TriggerEvent('aendir:client:AddEmployee')
        end
    },
    {
        title = 'Çalışan Sil',
        description = 'İşletmeden çalışan sil',
        icon = 'user-minus',
        action = function()
            TriggerEvent('aendir:client:RemoveEmployee')
        end
    }
}

-- Events
RegisterNetEvent('aendir:client:OpenMenu', function(menu)
    OpenMenu(menu)
end)

RegisterNetEvent('aendir:client:CloseMenu', function()
    CloseMenu()
end)

-- NUI Callbacks
RegisterNUICallback('selectMenuItem', function(data, cb)
    if menuItems[currentMenu] and menuItems[currentMenu][data.index] then
        menuItems[currentMenu][data.index].action()
    end
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    CloseMenu()
    cb('ok')
end)

-- Komutlar
RegisterCommand('menu', function()
    if not isMenuOpen then
        OpenMenu('main')
    else
        CloseMenu()
    end
end, false)

-- Tuş Ataması
RegisterKeyMapping('menu', 'Menüyü Aç/Kapat', 'keyboard', 'F5')

-- Threads
CreateThread(function()
    while true do
        Wait(0)
        if isMenuOpen then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 265, true)
            DisableControlAction(0, 266, true)
            DisableControlAction(0, 267, true)
            DisableControlAction(0, 268, true)
            DisableControlAction(0, 269, true)
            DisableControlAction(0, 270, true)
            DisableControlAction(0, 271, true)
            DisableControlAction(0, 272, true)
            DisableControlAction(0, 273, true)
            DisableControlAction(0, 274, true)
            DisableControlAction(0, 275, true)
        end
    end
end) 