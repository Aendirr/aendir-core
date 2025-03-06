-- Bildirimler
local Notifications = {
    -- Bildirim Tipleri
    Types = {
        Success = "success",
        Error = "error",
        Info = "info",
        Warning = "warning"
    },
    
    -- Bildirim Ayarları
    Settings = {
        -- Pozisyon
        Position = {
            X = 0.5,
            Y = 0.1
        },
        
        -- Süre
        Duration = 5000, -- Milisaniye
        
        -- Animasyon
        Animation = {
            Enabled = true,
            Duration = 500 -- Milisaniye
        }
    }
}

-- Bildirim Gönderme
function AendirCore.Functions.Notify(message, type)
    if type == Notifications.Types.Success then
        lib.notify({
            title = 'Başarılı',
            description = message,
            type = 'success',
            position = 'top',
            duration = Notifications.Settings.Duration
        })
    elseif type == Notifications.Types.Error then
        lib.notify({
            title = 'Hata',
            description = message,
            type = 'error',
            position = 'top',
            duration = Notifications.Settings.Duration
        })
    elseif type == Notifications.Types.Info then
        lib.notify({
            title = 'Bilgi',
            description = message,
            type = 'info',
            position = 'top',
            duration = Notifications.Settings.Duration
        })
    elseif type == Notifications.Types.Warning then
        lib.notify({
            title = 'Uyarı',
            description = message,
            type = 'warning',
            position = 'top',
            duration = Notifications.Settings.Duration
        })
    end
end

-- Bildirim Olayları
RegisterNetEvent('aendir:client:Notify', function(message, type)
    AendirCore.Functions.Notify(message, type)
end)

-- Bildirim Komutları
RegisterCommand('notify', function(source, args)
    if args[1] and args[2] then
        local type = args[1]
        local message = args[2]
        AendirCore.Functions.Notify(message, type)
    else
        AendirCore.Functions.Notify('Bildirim tipi ve mesaj belirtmelisiniz!', 'error')
    end
end)

-- Bildirim Menüsü
RegisterCommand('notifymenu', function()
    local elements = {
        {
            label = 'Başarılı',
            value = Notifications.Types.Success
        },
        {
            label = 'Hata',
            value = Notifications.Types.Error
        },
        {
            label = 'Bilgi',
            value = Notifications.Types.Info
        },
        {
            label = 'Uyarı',
            value = Notifications.Types.Warning
        }
    }
    
    lib.registerContext({
        id = 'notification_menu',
        title = 'Bildirim Menüsü',
        options = elements
    })
    
    lib.showContext('notification_menu')
end)

-- Bildirim Menü Seçimi
lib.registerCallback('aendir:client:NotificationMenuSelect', function(data)
    local type = data.value
    local input = lib.inputDialog('Bildirim', {
        {type = 'input', label = 'Mesaj', description = 'Bildirim mesajı', required = true}
    })
    
    if input then
        local message = input[1]
        AendirCore.Functions.Notify(message, type)
    end
end)

-- Bildirim Döngüsü
CreateThread(function()
    while true do
        Wait(1000)
        
        -- Bildirim Animasyonu
        if Notifications.Settings.Animation.Enabled then
            -- Animasyon Kodu
        end
    end
end) 