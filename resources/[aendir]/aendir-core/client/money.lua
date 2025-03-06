-- Para
local Money = {
    -- Para Tipleri
    Types = {
        Cash = "cash",
        Bank = "bank",
        Black = "black"
    },
    
    -- Para Ayarları
    Settings = {
        -- Başlangıç Parası
        StartingMoney = {
            Cash = 1000,
            Bank = 5000,
            Black = 0
        },
        
        -- Para Limitleri
        Limits = {
            Cash = 100000,
            Bank = 1000000,
            Black = 1000000
        }
    }
}

-- Para Verme
function AendirCore.Functions.GiveMoney(type, amount)
    TriggerServerEvent('aendir:server:GiveMoney', type, amount)
end

-- Para Alma
function AendirCore.Functions.RemoveMoney(type, amount)
    TriggerServerEvent('aendir:server:RemoveMoney', type, amount)
end

-- Para Olayları
RegisterNetEvent('aendir:client:MoneyUpdated', function(type, amount)
    if type == Money.Types.Cash then
        AendirCore.Functions.Notify('Nakit: $' .. amount, 'success')
    elseif type == Money.Types.Bank then
        AendirCore.Functions.Notify('Banka: $' .. amount, 'success')
    elseif type == Money.Types.Black then
        AendirCore.Functions.Notify('Kara Para: $' .. amount, 'success')
    end
end)

-- Para Komutları
RegisterCommand('givemoney', function(source, args)
    if args[1] and args[2] then
        local type = args[1]
        local amount = tonumber(args[2])
        if amount then
            AendirCore.Functions.GiveMoney(type, amount)
        else
            AendirCore.Functions.Notify('Geçersiz miktar!', 'error')
        end
    else
        AendirCore.Functions.Notify('Para tipi ve miktar belirtmelisiniz!', 'error')
    end
end)

RegisterCommand('removemoney', function(source, args)
    if args[1] and args[2] then
        local type = args[1]
        local amount = tonumber(args[2])
        if amount then
            AendirCore.Functions.RemoveMoney(type, amount)
        else
            AendirCore.Functions.Notify('Geçersiz miktar!', 'error')
        end
    else
        AendirCore.Functions.Notify('Para tipi ve miktar belirtmelisiniz!', 'error')
    end
end)

-- Para Menüsü
RegisterCommand('moneymenu', function()
    local elements = {
        {
            label = 'Nakit',
            value = Money.Types.Cash
        },
        {
            label = 'Banka',
            value = Money.Types.Bank
        },
        {
            label = 'Kara Para',
            value = Money.Types.Black
        }
    }
    
    lib.registerContext({
        id = 'money_menu',
        title = 'Para Menüsü',
        options = elements
    })
    
    lib.showContext('money_menu')
end)

-- Para Menü Seçimi
lib.registerCallback('aendir:client:MoneyMenuSelect', function(data)
    local type = data.value
    local input = lib.inputDialog('Para İşlemi', {
        {type = 'number', label = 'Miktar', description = 'İşlem yapılacak miktar', required = true}
    })
    
    if input then
        local amount = input[1]
        if amount then
            local elements = {
                {
                    label = 'Para Ver',
                    value = 'give'
                },
                {
                    label = 'Para Al',
                    value = 'remove'
                }
            }
            
            lib.registerContext({
                id = 'money_action_menu',
                title = 'Para İşlemi',
                options = elements
            })
            
            lib.showContext('money_action_menu')
            
            lib.registerCallback('aendir:client:MoneyActionMenuSelect', function(data)
                if data.value == 'give' then
                    AendirCore.Functions.GiveMoney(type, amount)
                elseif data.value == 'remove' then
                    AendirCore.Functions.RemoveMoney(type, amount)
                end
            end)
        else
            AendirCore.Functions.Notify('Geçersiz miktar!', 'error')
        end
    end
end)

-- Para Döngüsü
CreateThread(function()
    while true do
        Wait(1000)
        
        local cash = AendirCore.Functions.GetPlayerMoney(Money.Types.Cash)
        local bank = AendirCore.Functions.GetPlayerMoney(Money.Types.Bank)
        local black = AendirCore.Functions.GetPlayerMoney(Money.Types.Black)
        
        -- Para Limitleri
        if cash > Money.Settings.Limits.Cash then
            AendirCore.Functions.RemoveMoney(Money.Types.Cash, cash - Money.Settings.Limits.Cash)
            AendirCore.Functions.GiveMoney(Money.Types.Bank, cash - Money.Settings.Limits.Cash)
            AendirCore.Functions.Notify('Nakit limiti aşıldı! Fazla para bankaya yatırıldı.', 'warning')
        end
        
        if bank > Money.Settings.Limits.Bank then
            AendirCore.Functions.RemoveMoney(Money.Types.Bank, bank - Money.Settings.Limits.Bank)
            AendirCore.Functions.Notify('Banka limiti aşıldı!', 'warning')
        end
        
        if black > Money.Settings.Limits.Black then
            AendirCore.Functions.RemoveMoney(Money.Types.Black, black - Money.Settings.Limits.Black)
            AendirCore.Functions.Notify('Kara para limiti aşıldı!', 'warning')
        end
    end
end) 