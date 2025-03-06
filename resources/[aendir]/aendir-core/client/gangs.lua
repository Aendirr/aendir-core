-- Çeteler
local Gangs = {
    -- Çete Tipleri
    Types = {
        -- Mafya
        Mafia = {
            Name = "Mafya",
            Grades = {
                {name = "Üye", payment = 1000},
                {name = "Küçük Patron", payment = 2000},
                {name = "Patron", payment = 3000},
                {name = "Don", payment = 4000}
            }
        },
        
        -- Kartel
        Cartel = {
            Name = "Kartel",
            Grades = {
                {name = "Üye", payment = 1000},
                {name = "Küçük Patron", payment = 2000},
                {name = "Patron", payment = 3000},
                {name = "Don", payment = 4000}
            }
        },
        
        -- Yakuza
        Yakuza = {
            Name = "Yakuza",
            Grades = {
                {name = "Üye", payment = 1000},
                {name = "Küçük Patron", payment = 2000},
                {name = "Patron", payment = 3000},
                {name = "Oyabun", payment = 4000}
            }
        },
        
        -- Çete
        Gang = {
            Name = "Çete",
            Grades = {
                {name = "Üye", payment = 1000},
                {name = "Küçük Patron", payment = 2000},
                {name = "Patron", payment = 3000}
            }
        },
        
        -- Çetesiz
        None = {
            Name = "Çetesiz",
            Grades = {
                {name = "Çetesiz", payment = 0}
            }
        }
    },
    
    -- Çete Ayarları
    Settings = {
        -- Maaş Ayarları
        Payment = {
            Interval = 3600, -- Saniye
            Multiplier = 1.0 -- Çarpan
        },
        
        -- Çete Değiştirme
        Change = {
            Cooldown = 300, -- Saniye
            Cost = 1000 -- Ücret
        }
    }
}

-- Çete Verme
function AendirCore.Functions.SetGang(gang, grade)
    TriggerServerEvent('aendir:server:SetGang', gang, grade)
end

-- Çete Alma
function AendirCore.Functions.RemoveGang()
    TriggerServerEvent('aendir:server:RemoveGang')
end

-- Çete Olayları
RegisterNetEvent('aendir:client:SetGang', function(gang, grade)
    local ped = PlayerPedId()
    
    -- Kıyafet Değiştirme
    if gang == "Mafia" then
        if grade == 1 then
            SetPedComponentVariation(ped, 11, 150, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 2 then
            SetPedComponentVariation(ped, 11, 150, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 3 then
            SetPedComponentVariation(ped, 11, 150, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 4 then
            SetPedComponentVariation(ped, 11, 150, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        end
    elseif gang == "Cartel" then
        if grade == 1 then
            SetPedComponentVariation(ped, 11, 151, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 2 then
            SetPedComponentVariation(ped, 11, 151, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 3 then
            SetPedComponentVariation(ped, 11, 151, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 4 then
            SetPedComponentVariation(ped, 11, 151, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        end
    elseif gang == "Yakuza" then
        if grade == 1 then
            SetPedComponentVariation(ped, 11, 152, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 2 then
            SetPedComponentVariation(ped, 11, 152, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 3 then
            SetPedComponentVariation(ped, 11, 152, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 4 then
            SetPedComponentVariation(ped, 11, 152, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        end
    elseif gang == "Gang" then
        if grade == 1 then
            SetPedComponentVariation(ped, 11, 153, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 2 then
            SetPedComponentVariation(ped, 11, 153, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 3 then
            SetPedComponentVariation(ped, 11, 153, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        end
    end
    
    AendirCore.Functions.Notify('Çeteniz değiştirildi: ' .. Gangs.Types[gang].Name .. ' - ' .. Gangs.Types[gang].Grades[grade].name, 'success')
end)

RegisterNetEvent('aendir:client:RemoveGang', function()
    local ped = PlayerPedId()
    
    -- Kıyafet Sıfırlama
    SetPedComponentVariation(ped, 11, 15, 0, 0)
    SetPedComponentVariation(ped, 3, 15, 0, 0)
    SetPedComponentVariation(ped, 4, 15, 0, 0)
    SetPedComponentVariation(ped, 6, 15, 0, 0)
    
    AendirCore.Functions.Notify('Çeteniz kaldırıldı!', 'error')
end)

-- Çete Komutları
RegisterCommand('setgang', function(source, args)
    if args[1] and args[2] then
        local gang = args[1]
        local grade = tonumber(args[2])
        if grade then
            AendirCore.Functions.SetGang(gang, grade)
        else
            AendirCore.Functions.Notify('Geçersiz rütbe!', 'error')
        end
    else
        AendirCore.Functions.Notify('Çete adı ve rütbe belirtmelisiniz!', 'error')
    end
end)

RegisterCommand('removegang', function(source, args)
    if args[1] then
        local gang = args[1]
        AendirCore.Functions.RemoveGang()
    else
        AendirCore.Functions.Notify('Çete adı belirtmelisiniz!', 'error')
    end
end)

-- Çete Menüsü
RegisterCommand('gangmenu', function()
    local elements = {}
    
    for k, v in pairs(Gangs.Types) do
        for k2, v2 in pairs(v.Grades) do
            table.insert(elements, {
                label = v.Name .. ' - ' .. v2.name,
                value = {
                    gang = k,
                    grade = k2
                }
            })
        end
    end
    
    lib.registerContext({
        id = 'gang_menu',
        title = 'Çete Menüsü',
        options = elements
    })
    
    lib.showContext('gang_menu')
end)

-- Çete Menü Seçimi
lib.registerCallback('aendir:client:GangMenuSelect', function(data)
    local gang = data.value.gang
    local grade = data.value.grade
    
    AendirCore.Functions.SetGang(gang, grade)
end)

-- Maaş Döngüsü
CreateThread(function()
    while true do
        Wait(Gangs.Settings.Payment.Interval * 1000)
        
        local gang = AendirCore.Functions.GetPlayerGang()
        if gang then
            local grade = AendirCore.Functions.GetPlayerGangGrade()
            local payment = Gangs.Types[gang].Grades[grade].payment * Gangs.Settings.Payment.Multiplier
            
            TriggerServerEvent('aendir:server:GiveMoney', payment)
            AendirCore.Functions.Notify('Maaşınız yatırıldı: $' .. payment, 'success')
        end
    end
end) 