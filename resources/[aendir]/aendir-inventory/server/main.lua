-- Envanter verilerini al
RegisterNetEvent('aendir-inventory:server:GetInventory')
AddEventHandler('aendir-inventory:server:GetInventory', function()
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    MySQL.query('SELECT * FROM ?? WHERE ?? = ?', {
        Config.Database.table,
        Config.Database.columns.identifier,
        identifier
    }, function(result)
        if result[1] then
            local inventory = json.decode(result[1][Config.Database.columns.items])
            local weight = result[1][Config.Database.columns.weight]
            
            TriggerClientEvent('aendir-inventory:client:UpdateInventory', source, inventory, weight)
        else
            -- Yeni envanter oluştur
            MySQL.insert('INSERT INTO ?? (??, ??, ??) VALUES (?, ?, ?)', {
                Config.Database.table,
                Config.Database.columns.identifier,
                Config.Database.columns.items,
                Config.Database.columns.weight,
                identifier,
                json.encode({}),
                Config.DefaultWeight
            })
            
            TriggerClientEvent('aendir-inventory:client:UpdateInventory', source, {}, Config.DefaultWeight)
        end
    end)
end)

-- Eşya kullan
RegisterNetEvent('aendir-inventory:server:UseItem')
AddEventHandler('aendir-inventory:server:UseItem', function(item, index)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    MySQL.query('SELECT * FROM ?? WHERE ?? = ?', {
        Config.Database.table,
        Config.Database.columns.identifier,
        identifier
    }, function(result)
        if result[1] then
            local inventory = json.decode(result[1][Config.Database.columns.items])
            local weight = result[1][Config.Database.columns.weight]
            
            if inventory[index] and inventory[index].name == item.name then
                local itemConfig = Config.Items[item.name]
                
                if itemConfig and itemConfig.usable then
                    if itemConfig.type == 'weapon' then
                        -- Silah kullanma
                        local weaponConfig = Config.Weapons[item.name]
                        if weaponConfig then
                            GiveWeaponToPed(GetPlayerPed(source), GetHashKey(weaponConfig.model), weaponConfig.ammo, false, true)
                            TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Silahı kullandınız', 'success')
                        end
                    else
                        -- Normal eşya kullanma
                        TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Eşyayı kullandınız', 'success')
                    end
                    
                    -- Eşyayı sil
                    table.remove(inventory, index)
                    weight = weight - itemConfig.weight
                    
                    -- Veritabanını güncelle
                    MySQL.update('UPDATE ?? SET ?? = ?, ?? = ? WHERE ?? = ?', {
                        Config.Database.table,
                        Config.Database.columns.items,
                        json.encode(inventory),
                        Config.Database.columns.weight,
                        weight,
                        Config.Database.columns.identifier,
                        identifier
                    })
                    
                    -- Envanteri güncelle
                    TriggerClientEvent('aendir-inventory:client:UpdateInventory', source, inventory, weight)
                else
                    TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Bu eşya kullanılamaz', 'error')
                end
            else
                TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Eşya bulunamadı', 'error')
            end
        end
    end)
end)

-- Eşya transfer et
RegisterNetEvent('aendir-inventory:server:TransferItem')
AddEventHandler('aendir-inventory:server:TransferItem', function(item, index)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    -- Transfer menüsünü göster
    TriggerClientEvent('aendir-inventory:client:ShowTransferMenu', source, item, index)
end)

-- Eşya sat
RegisterNetEvent('aendir-inventory:server:SellItem')
AddEventHandler('aendir-inventory:server:SellItem', function(item, index)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    MySQL.query('SELECT * FROM ?? WHERE ?? = ?', {
        Config.Database.table,
        Config.Database.columns.identifier,
        identifier
    }, function(result)
        if result[1] then
            local inventory = json.decode(result[1][Config.Database.columns.items])
            local weight = result[1][Config.Database.columns.weight]
            
            if inventory[index] and inventory[index].name == item.name then
                local itemConfig = Config.Items[item.name]
                
                if itemConfig then
                    -- Para ekle
                    local price = itemConfig.price or 0
                    TriggerEvent('aendir-core:server:AddMoney', source, price)
                    
                    -- Eşyayı sil
                    table.remove(inventory, index)
                    weight = weight - itemConfig.weight
                    
                    -- Veritabanını güncelle
                    MySQL.update('UPDATE ?? SET ?? = ?, ?? = ? WHERE ?? = ?', {
                        Config.Database.table,
                        Config.Database.columns.items,
                        json.encode(inventory),
                        Config.Database.columns.weight,
                        weight,
                        Config.Database.columns.identifier,
                        identifier
                    })
                    
                    -- Envanteri güncelle
                    TriggerClientEvent('aendir-inventory:client:UpdateInventory', source, inventory, weight)
                    TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Eşyayı sattınız: $' .. price, 'success')
                end
            else
                TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Eşya bulunamadı', 'error')
            end
        end
    end)
end)

-- Silahı çıkar
RegisterNetEvent('aendir-inventory:server:UnequipWeapon')
AddEventHandler('aendir-inventory:server:UnequipWeapon', function(item, index)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    MySQL.query('SELECT * FROM ?? WHERE ?? = ?', {
        Config.Database.table,
        Config.Database.columns.identifier,
        identifier
    }, function(result)
        if result[1] then
            local inventory = json.decode(result[1][Config.Database.columns.items])
            local weight = result[1][Config.Database.columns.weight]
            
            if inventory[index] and inventory[index].name == item.name then
                local itemConfig = Config.Items[item.name]
                
                if itemConfig and itemConfig.type == 'weapon' then
                    -- Silahı çıkar
                    local weaponConfig = Config.Weapons[item.name]
                    if weaponConfig then
                        RemoveWeaponFromPed(GetPlayerPed(source), GetHashKey(weaponConfig.model))
                        TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Silahı çıkardınız', 'success')
                    end
                else
                    TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Bu bir silah değil', 'error')
                end
            else
                TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Eşya bulunamadı', 'error')
            end
        end
    end)
end)

-- Eşya ver
RegisterCommand(Config.Commands.giveitem, function(source, args)
    if source == 0 then return end -- Konsol komutu değil
    
    local target = tonumber(args[1])
    local itemName = args[2]
    local count = tonumber(args[3]) or 1
    
    if not target or not itemName or not count then
        TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Kullanım: /giveitem [id] [eşya] [miktar]', 'error')
        return
    end
    
    local itemConfig = Config.Items[itemName]
    if not itemConfig then
        TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Geçersiz eşya', 'error')
        return
    end
    
    local targetIdentifier = GetPlayerIdentifier(target)
    if not targetIdentifier then
        TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Oyuncu bulunamadı', 'error')
        return
    end
    
    MySQL.query('SELECT * FROM ?? WHERE ?? = ?', {
        Config.Database.table,
        Config.Database.columns.identifier,
        targetIdentifier
    }, function(result)
        if result[1] then
            local inventory = json.decode(result[1][Config.Database.columns.items])
            local weight = result[1][Config.Database.columns.weight]
            
            -- Eşyayı ekle
            table.insert(inventory, {
                name = itemName,
                count = count
            })
            
            weight = weight + (itemConfig.weight * count)
            
            -- Veritabanını güncelle
            MySQL.update('UPDATE ?? SET ?? = ?, ?? = ? WHERE ?? = ?', {
                Config.Database.table,
                Config.Database.columns.items,
                json.encode(inventory),
                Config.Database.columns.weight,
                weight,
                Config.Database.columns.identifier,
                targetIdentifier
            })
            
            -- Envanteri güncelle
            TriggerClientEvent('aendir-inventory:client:UpdateInventory', target, inventory, weight)
            TriggerClientEvent('aendir-inventory:client:ShowNotification', target, count .. 'x ' .. itemConfig.label .. ' aldınız', 'success')
            TriggerClientEvent('aendir-inventory:client:ShowNotification', source, count .. 'x ' .. itemConfig.label .. ' verdiniz', 'success')
        end
    end)
end)

-- Eşya sil
RegisterCommand(Config.Commands.removeitem, function(source, args)
    if source == 0 then return end -- Konsol komutu değil
    
    local target = tonumber(args[1])
    local itemName = args[2]
    local count = tonumber(args[3]) or 1
    
    if not target or not itemName or not count then
        TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Kullanım: /removeitem [id] [eşya] [miktar]', 'error')
        return
    end
    
    local itemConfig = Config.Items[itemName]
    if not itemConfig then
        TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Geçersiz eşya', 'error')
        return
    end
    
    local targetIdentifier = GetPlayerIdentifier(target)
    if not targetIdentifier then
        TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Oyuncu bulunamadı', 'error')
        return
    end
    
    MySQL.query('SELECT * FROM ?? WHERE ?? = ?', {
        Config.Database.table,
        Config.Database.columns.identifier,
        targetIdentifier
    }, function(result)
        if result[1] then
            local inventory = json.decode(result[1][Config.Database.columns.items])
            local weight = result[1][Config.Database.columns.weight]
            
            -- Eşyayı bul ve sil
            local found = false
            for i = #inventory, 1, -1 do
                if inventory[i].name == itemName then
                    if inventory[i].count > count then
                        inventory[i].count = inventory[i].count - count
                    else
                        table.remove(inventory, i)
                    end
                    found = true
                    break
                end
            end
            
            if found then
                weight = weight - (itemConfig.weight * count)
                
                -- Veritabanını güncelle
                MySQL.update('UPDATE ?? SET ?? = ?, ?? = ? WHERE ?? = ?', {
                    Config.Database.table,
                    Config.Database.columns.items,
                    json.encode(inventory),
                    Config.Database.columns.weight,
                    weight,
                    Config.Database.columns.identifier,
                    targetIdentifier
                })
                
                -- Envanteri güncelle
                TriggerClientEvent('aendir-inventory:client:UpdateInventory', target, inventory, weight)
                TriggerClientEvent('aendir-inventory:client:ShowNotification', target, count .. 'x ' .. itemConfig.label .. ' silindi', 'error')
                TriggerClientEvent('aendir-inventory:client:ShowNotification', source, count .. 'x ' .. itemConfig.label .. ' sildiniz', 'success')
            else
                TriggerClientEvent('aendir-inventory:client:ShowNotification', source, 'Oyuncuda bu eşya yok', 'error')
            end
        end
    end)
end) 