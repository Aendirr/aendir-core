-- İşletmeler
local AendirCore = exports['aendir-core']:GetCoreObject()

-- İşletme Oluşturma
RegisterNetEvent('aendir:server:CreateBusiness', function(data)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        AendirCore.Functions.CreateBusiness(data)
        TriggerClientEvent('aendir:client:Notify', source, 'İşletme oluşturuldu!', 'success')
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- İşletme Silme
RegisterNetEvent('aendir:server:DeleteBusiness', function(id)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local business = AendirCore.Functions.GetBusiness(id)
        if business and business.owner == player.citizenid then
            AendirCore.Functions.DeleteBusiness(id)
            TriggerClientEvent('aendir:client:Notify', source, 'İşletme silindi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu işletmeye erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- İşletme Güncelleme
RegisterNetEvent('aendir:server:UpdateBusiness', function(id, data)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local business = AendirCore.Functions.GetBusiness(id)
        if business and business.owner == player.citizenid then
            AendirCore.Functions.UpdateBusiness(id, data)
            TriggerClientEvent('aendir:client:Notify', source, 'İşletme güncellendi!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu işletmeye erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- İşletme Satın Alma
RegisterNetEvent('aendir:server:BuyBusiness', function(id)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local business = AendirCore.Functions.GetBusiness(id)
        if business and not business.owner then
            if AendirCore.Functions.RemoveMoney(license, 'bank', business.price) then
                business.owner = player.citizenid
                AendirCore.Functions.UpdateBusiness(id, business)
                TriggerClientEvent('aendir:client:Notify', source, 'İşletme satın alındı!', 'success')
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Yetersiz para!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu işletme zaten satılmış!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- İşletme Satma
RegisterNetEvent('aendir:server:SellBusiness', function(id)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local business = AendirCore.Functions.GetBusiness(id)
        if business and business.owner == player.citizenid then
            AendirCore.Functions.AddMoney(license, 'bank', business.price)
            business.owner = nil
            AendirCore.Functions.UpdateBusiness(id, business)
            TriggerClientEvent('aendir:client:Notify', source, 'İşletme satıldı!', 'success')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu işletmeye erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- İşletme Çalışan Ekleme
RegisterNetEvent('aendir:server:AddEmployee', function(id, target, grade)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local business = AendirCore.Functions.GetBusiness(id)
        if business and business.owner == player.citizenid then
            local targetPlayer = AendirCore.Functions.GetPlayer(target)
            if targetPlayer then
                if not business.employees then
                    business.employees = {}
                end
                
                table.insert(business.employees, {
                    citizenid = targetPlayer.citizenid,
                    grade = grade
                })
                
                AendirCore.Functions.UpdateBusiness(id, business)
                TriggerClientEvent('aendir:client:Notify', source, 'Çalışan eklendi!', 'success')
            else
                TriggerClientEvent('aendir:client:Notify', source, 'Çalışan bulunamadı!', 'error')
            end
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu işletmeye erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- İşletme Çalışan Silme
RegisterNetEvent('aendir:server:RemoveEmployee', function(id, target)
    local source = source
    local license = GetPlayerIdentifier(source, 'license')
    local player = AendirCore.Functions.GetPlayer(license)
    
    if player then
        local business = AendirCore.Functions.GetBusiness(id)
        if business and business.owner == player.citizenid then
            if business.employees then
                for i, employee in ipairs(business.employees) do
                    if employee.citizenid == target then
                        table.remove(business.employees, i)
                        AendirCore.Functions.UpdateBusiness(id, business)
                        TriggerClientEvent('aendir:client:Notify', source, 'Çalışan silindi!', 'success')
                        return
                    end
                end
            end
            TriggerClientEvent('aendir:client:Notify', source, 'Çalışan bulunamadı!', 'error')
        else
            TriggerClientEvent('aendir:client:Notify', source, 'Bu işletmeye erişiminiz yok!', 'error')
        end
    else
        TriggerClientEvent('aendir:client:Notify', source, 'Oyuncu bulunamadı!', 'error')
    end
end)

-- İşletme Maaş Ödemesi
CreateThread(function()
    while true do
        Wait(Config.BusinessPaymentInterval or 3600000) -- 1 saat
        
        local businesses = MySQL.query.await('SELECT * FROM businesses WHERE owner IS NOT NULL')
        for _, business in ipairs(businesses) do
            if business.employees then
                for _, employee in ipairs(business.employees) do
                    local player = AendirCore.Functions.GetPlayer(employee.citizenid)
                    if player then
                        local payment = Config.BusinessGrades[employee.grade].payment
                        if payment > 0 then
                            AendirCore.Functions.AddMoney(employee.citizenid, 'bank', payment)
                            TriggerClientEvent('aendir:client:Notify', AendirCore.Functions.GetPlayerByCitizenId(employee.citizenid), 'Maaşınız yatırıldı: $' .. payment, 'success')
                        end
                    end
                end
            end
        end
    end
end) 