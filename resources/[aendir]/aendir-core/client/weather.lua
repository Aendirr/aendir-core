-- Hava Durumu
local Weather = {
    -- Hava Durumu Tipleri
    Types = {
        Clear = "CLEAR",
        Clouds = "CLOUDS",
        Rain = "RAIN",
        Thunder = "THUNDER",
        Snow = "SNOW",
        Fog = "FOG",
        Wind = "WIND",
        Sandstorm = "SANDSTORM"
    },
    
    -- Hava Durumu Ayarları
    Settings = {
        -- Zaman Ayarları
        Time = {
            Day = 12,
            Night = 0,
            Dawn = 6,
            Dusk = 18
        },
        
        -- Hava Durumu Geçiş Ayarları
        Transition = {
            Duration = 30, -- Saniye
            Interval = 300 -- Saniye
        }
    }
}

-- Hava Durumu Değiştirme
function AendirCore.Functions.SetWeather(weather, transition)
    if transition then
        SetWeatherTypeOverTime(weather, transition)
    else
        SetWeatherTypeNow(weather)
    end
end

-- Zaman Değiştirme
function AendirCore.Functions.SetTime(hour, minute, transition)
    if transition then
        NetworkOverrideClockTime(hour, minute, 0)
        SetTimecycleModifier("default")
        SetTimecycleModifierStrength(1.0)
    else
        NetworkOverrideClockTime(hour, minute, 0)
    end
end

-- Hava Durumu Geçişi
function AendirCore.Functions.TransitionWeather(weather)
    AendirCore.Functions.SetWeather(weather, Weather.Settings.Transition.Duration)
end

-- Zaman Geçişi
function AendirCore.Functions.TransitionTime(hour, minute)
    AendirCore.Functions.SetTime(hour, minute, true)
end

-- Hava Durumu Olayları
RegisterNetEvent('aendir:client:SetWeather', function(weather, transition)
    AendirCore.Functions.SetWeather(weather, transition)
end)

RegisterNetEvent('aendir:client:SetTime', function(hour, minute, transition)
    AendirCore.Functions.SetTime(hour, minute, transition)
end)

RegisterNetEvent('aendir:client:TransitionWeather', function(weather)
    AendirCore.Functions.TransitionWeather(weather)
end)

RegisterNetEvent('aendir:client:TransitionTime', function(hour, minute)
    AendirCore.Functions.TransitionTime(hour, minute)
end)

-- Hava Durumu Komutları
RegisterCommand('weather', function(source, args)
    if args[1] then
        local weather = args[1]:upper()
        if Weather.Types[weather] then
            AendirCore.Functions.SetWeather(Weather.Types[weather])
        else
            AendirCore.Functions.Notify('Geçersiz hava durumu!', 'error')
        end
    else
        AendirCore.Functions.Notify('Hava durumu belirtmelisiniz!', 'error')
    end
end)

RegisterCommand('time', function(source, args)
    if args[1] and args[2] then
        local hour = tonumber(args[1])
        local minute = tonumber(args[2])
        if hour and minute and hour >= 0 and hour <= 23 and minute >= 0 and minute <= 59 then
            AendirCore.Functions.SetTime(hour, minute)
        else
            AendirCore.Functions.Notify('Geçersiz zaman!', 'error')
        end
    else
        AendirCore.Functions.Notify('Saat ve dakika belirtmelisiniz!', 'error')
    end
end)

-- Hava Durumu Menüsü
RegisterCommand('weathermenu', function()
    local elements = {}
    
    for k, v in pairs(Weather.Types) do
        table.insert(elements, {
            label = k,
            value = v
        })
    end
    
    lib.registerContext({
        id = 'weather_menu',
        title = 'Hava Durumu Menüsü',
        options = elements
    })
    
    lib.showContext('weather_menu')
end)

-- Hava Durumu Menü Seçimi
lib.registerCallback('aendir:client:WeatherMenuSelect', function(data)
    AendirCore.Functions.SetWeather(data.value)
end)

-- Hava Durumu Döngüsü
CreateThread(function()
    while true do
        Wait(Weather.Settings.Transition.Interval * 1000)
        
        local weathers = {}
        for k, v in pairs(Weather.Types) do
            table.insert(weathers, v)
        end
        
        local random = math.random(1, #weathers)
        AendirCore.Functions.TransitionWeather(weathers[random])
    end
end) 