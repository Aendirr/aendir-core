-- İlerleme Çubuğu
local Progress = {
    -- İlerleme Çubuğu Ayarları
    Settings = {
        -- Pozisyon
        Position = {
            X = 0.5,
            Y = 0.95
        },
        
        -- Boyut
        Size = {
            Width = 0.2,
            Height = 0.03
        },
        
        -- Renk
        Color = {
            Background = {0, 0, 0, 200},
            Bar = {255, 255, 255, 255},
            Text = {255, 255, 255, 255}
        },
        
        -- Animasyon
        Animation = {
            Enabled = true,
            Duration = 500 -- Milisaniye
        }
    }
}

-- İlerleme Çubuğu Başlatma
function AendirCore.Functions.StartProgress(title, duration, canCancel)
    if canCancel == nil then
        canCancel = true
    end
    
    if Progress.Settings.Animation.Enabled then
        -- Animasyon Başlatma
    end
    
    lib.progressBar({
        duration = duration,
        label = title,
        useWhileDead = false,
        canCancel = canCancel,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'anim@heists@ornate_bank@hack',
            clip = 'hack_loop'
        }
    })
end

-- İlerleme Çubuğu Durdurma
function AendirCore.Functions.StopProgress()
    if Progress.Settings.Animation.Enabled then
        -- Animasyon Durdurma
    end
end

-- İlerleme Çubuğu Olayları
RegisterNetEvent('aendir:client:StartProgress', function(title, duration, canCancel)
    AendirCore.Functions.StartProgress(title, duration, canCancel)
end)

RegisterNetEvent('aendir:client:StopProgress', function()
    AendirCore.Functions.StopProgress()
end)

-- İlerleme Çubuğu Komutları
RegisterCommand('progress', function(source, args)
    if args[1] and args[2] then
        local title = args[1]
        local duration = tonumber(args[2])
        if duration then
            AendirCore.Functions.StartProgress(title, duration)
        else
            AendirCore.Functions.Notify('Geçersiz süre!', 'error')
        end
    else
        AendirCore.Functions.Notify('Başlık ve süre belirtmelisiniz!', 'error')
    end
end)

-- İlerleme Çubuğu Menüsü
RegisterCommand('progressmenu', function()
    local input = lib.inputDialog('İlerleme Çubuğu', {
        {type = 'input', label = 'Başlık', description = 'İlerleme çubuğu başlığı', required = true},
        {type = 'number', label = 'Süre', description = 'İlerleme çubuğu süresi (ms)', required = true}
    })
    
    if input then
        local title = input[1]
        local duration = input[2]
        if duration then
            AendirCore.Functions.StartProgress(title, duration)
        else
            AendirCore.Functions.Notify('Geçersiz süre!', 'error')
        end
    end
end)

-- İlerleme Çubuğu Döngüsü
CreateThread(function()
    while true do
        Wait(1000)
        
        -- İlerleme Çubuğu Animasyonu
        if Progress.Settings.Animation.Enabled then
            -- Animasyon Kodu
        end
    end
end) 