-- Eşya fonksiyonları
local Items = {}

-- Eşya ekle
function Items.AddItem(source, item, count)
    TriggerEvent('aendir-inventory:server:AddItem', source, item, count)
end

-- Eşya sil
function Items.RemoveItem(source, item, count)
    TriggerEvent('aendir-inventory:server:RemoveItem', source, item, count)
end

-- Eşya kontrol et
function Items.HasItem(source, item, count)
    return exports['aendir-inventory']:HasItem(source, item, count)
end

-- Eşya sayısını al
function Items.GetItemCount(source, item)
    return exports['aendir-inventory']:GetItemCount(source, item)
end

-- Eşya bilgilerini al
function Items.GetItemData(item)
    return exports['aendir-inventory']:GetItemData(item)
end

-- Eşya kullan
function Items.UseItem(source, item)
    TriggerEvent('aendir-inventory:server:UseItem', source, item)
end

return Items 