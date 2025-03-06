-- Meslekler
local Jobs = {
    -- Meslek Tipleri
    Types = {
        -- Polis
        Police = {
            Name = "Polis",
            Grades = {
                {name = "Stajyer", payment = 1000},
                {name = "Memur", payment = 2000},
                {name = "Komiser", payment = 3000},
                {name = "Başkomiser", payment = 4000},
                {name = "Emniyet Müdürü", payment = 5000}
            }
        },
        
        -- Doktor
        Doctor = {
            Name = "Doktor",
            Grades = {
                {name = "Stajyer", payment = 1000},
                {name = "Doktor", payment = 2000},
                {name = "Uzman", payment = 3000},
                {name = "Başhekim", payment = 4000}
            }
        },
        
        -- Mekanik
        Mechanic = {
            Name = "Mekanik",
            Grades = {
                {name = "Çırak", payment = 1000},
                {name = "Usta", payment = 2000},
                {name = "Kalfa", payment = 3000},
                {name = "Patron", payment = 4000}
            }
        },
        
        -- Taksi
        Taxi = {
            Name = "Taksi",
            Grades = {
                {name = "Şoför", payment = 1000},
                {name = "Patron", payment = 2000}
            }
        },
        
        -- İşsiz
        Unemployed = {
            Name = "İşsiz",
            Grades = {
                {name = "İşsiz", payment = 0}
            }
        }
    },
    
    -- Meslek Ayarları
    Settings = {
        -- Maaş Ayarları
        Payment = {
            Interval = 3600, -- Saniye
            Multiplier = 1.0 -- Çarpan
        },
        
        -- Meslek Değiştirme
        Change = {
            Cooldown = 300, -- Saniye
            Cost = 1000 -- Ücret
        }
    }
}

-- Meslek Verme
function AendirCore.Functions.SetJob(job, grade)
    TriggerServerEvent('aendir:server:SetJob', job, grade)
end

-- Meslek Alma
function AendirCore.Functions.RemoveJob()
    TriggerServerEvent('aendir:server:RemoveJob')
end

-- Meslek Olayları
RegisterNetEvent('aendir:client:SetJob', function(job, grade)
    local ped = PlayerPedId()
    
    -- Kıyafet Değiştirme
    if job == "Police" then
        if grade == 1 then
            SetPedComponentVariation(ped, 11, 55, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 2 then
            SetPedComponentVariation(ped, 11, 55, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 3 then
            SetPedComponentVariation(ped, 11, 55, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 4 then
            SetPedComponentVariation(ped, 11, 55, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        elseif grade == 5 then
            SetPedComponentVariation(ped, 11, 55, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 35, 0, 0)
            SetPedComponentVariation(ped, 6, 25, 0, 0)
        end
    elseif job == "Doctor" then
        if grade == 1 then
            SetPedComponentVariation(ped, 11, 250, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 96, 0, 0)
            SetPedComponentVariation(ped, 6, 51, 0, 0)
        elseif grade == 2 then
            SetPedComponentVariation(ped, 11, 250, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 96, 0, 0)
            SetPedComponentVariation(ped, 6, 51, 0, 0)
        elseif grade == 3 then
            SetPedComponentVariation(ped, 11, 250, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 96, 0, 0)
            SetPedComponentVariation(ped, 6, 51, 0, 0)
        elseif grade == 4 then
            SetPedComponentVariation(ped, 11, 250, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 96, 0, 0)
            SetPedComponentVariation(ped, 6, 51, 0, 0)
        end
    elseif job == "Mechanic" then
        if grade == 1 then
            SetPedComponentVariation(ped, 11, 251, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 96, 0, 0)
            SetPedComponentVariation(ped, 6, 51, 0, 0)
        elseif grade == 2 then
            SetPedComponentVariation(ped, 11, 251, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 96, 0, 0)
            SetPedComponentVariation(ped, 6, 51, 0, 0)
        elseif grade == 3 then
            SetPedComponentVariation(ped, 11, 251, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 96, 0, 0)
            SetPedComponentVariation(ped, 6, 51, 0, 0)
        elseif grade == 4 then
            SetPedComponentVariation(ped, 11, 251, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 96, 0, 0)
            SetPedComponentVariation(ped, 6, 51, 0, 0)
        end
    elseif job == "Taxi" then
        if grade == 1 then
            SetPedComponentVariation(ped, 11, 252, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 96, 0, 0)
            SetPedComponentVariation(ped, 6, 51, 0, 0)
        elseif grade == 2 then
            SetPedComponentVariation(ped, 11, 252, 0, 0)
            SetPedComponentVariation(ped, 3, 85, 0, 0)
            SetPedComponentVariation(ped, 4, 96, 0, 0)
            SetPedComponentVariation(ped, 6, 51, 0, 0)
        end
    end
    
    AendirCore.Functions.Notify('Mesleğiniz değiştirildi: ' .. Jobs.Types[job].Name .. ' - ' .. Jobs.Types[job].Grades[grade].name, 'success')
end)

RegisterNetEvent('aendir:client:RemoveJob', function()
    local ped = PlayerPedId()
    
    -- Kıyafet Sıfırlama
    SetPedComponentVariation(ped, 11, 15, 0, 0)
    SetPedComponentVariation(ped, 3, 15, 0, 0)
    SetPedComponentVariation(ped, 4, 15, 0, 0)
    SetPedComponentVariation(ped, 6, 15, 0, 0)
    
    AendirCore.Functions.Notify('Mesleğiniz kaldırıldı!', 'error')
end)

-- Meslek Komutları
RegisterCommand('setjob', function(source, args)
    if args[1] and args[2] then
        local job = args[1]
        local grade = tonumber(args[2])
        if grade then
            AendirCore.Functions.SetJob(job, grade)
        else
            AendirCore.Functions.Notify('Geçersiz rütbe!', 'error')
        end
    else
        AendirCore.Functions.Notify('Meslek adı ve rütbe belirtmelisiniz!', 'error')
    end
end)

RegisterCommand('removejob', function(source, args)
    if args[1] then
        local job = args[1]
        AendirCore.Functions.RemoveJob()
    else
        AendirCore.Functions.Notify('Meslek adı belirtmelisiniz!', 'error')
    end
end)

-- Meslek Menüsü
RegisterCommand('jobmenu', function()
    local elements = {}
    
    for k, v in pairs(Jobs.Types) do
        for k2, v2 in pairs(v.Grades) do
            table.insert(elements, {
                label = v.Name .. ' - ' .. v2.name,
                value = {
                    job = k,
                    grade = k2
                }
            })
        end
    end
    
    lib.registerContext({
        id = 'job_menu',
        title = 'Meslek Menüsü',
        options = elements
    })
    
    lib.showContext('job_menu')
end)

-- Meslek Menü Seçimi
lib.registerCallback('aendir:client:JobMenuSelect', function(data)
    local job = data.value.job
    local grade = data.value.grade
    
    AendirCore.Functions.SetJob(job, grade)
end)

-- Maaş Döngüsü
CreateThread(function()
    while true do
        Wait(Jobs.Settings.Payment.Interval * 1000)
        
        local job = AendirCore.Functions.GetPlayerJob()
        if job then
            local grade = AendirCore.Functions.GetPlayerJobGrade()
            local payment = Jobs.Types[job].Grades[grade].payment * Jobs.Settings.Payment.Multiplier
            
            TriggerServerEvent('aendir:server:GiveMoney', payment)
            AendirCore.Functions.Notify('Maaşınız yatırıldı: $' .. payment, 'success')
        end
    end
end) 