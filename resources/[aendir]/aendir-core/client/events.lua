-- Oyuncu Yükleme
RegisterNetEvent('aendir:client:OnPlayerLoaded', function(data)
    PlayerData = data
    PlayerLoaded = true
    
    -- Karakter Modelini Yükle
    local model = GetHashKey(Config.DefaultModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    
    -- Karakter Pozisyonunu Ayarla
    local coords = vector4(data.position.x, data.position.y, data.position.z, data.position.w)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    SetEntityHeading(PlayerPedId(), coords.w)
    
    -- Ekran Efektleri
    DoScreenFadeIn(1000)
    ShutdownLoadingScreen()
    
    -- Bildirim
    AendirCore.Functions.ShowNotification('Sunucuya hoş geldiniz!', 'success')
end)

-- Oyuncu Çıkış
RegisterNetEvent('aendir:client:OnPlayerUnload', function()
    PlayerData = {}
    PlayerLoaded = false
    
    -- Ekran Efektleri
    DoScreenFadeOut(1000)
    
    -- Bildirim
    AendirCore.Functions.ShowNotification('Sunucudan çıkış yapıldı!', 'info')
end)

-- Para Değişimi
RegisterNetEvent('aendir:client:OnMoneyChange', function(type, amount, isMinus)
    if isMinus then
        PlayerData.money[type] = PlayerData.money[type] - amount
    else
        PlayerData.money[type] = PlayerData.money[type] + amount
    end
    
    -- Bildirim
    AendirCore.Functions.ShowNotification(string.format('%s %s %s', isMinus and '-' or '+', amount, type), isMinus and 'error' or 'success')
end)

-- Meslek Değişimi
RegisterNetEvent('aendir:client:OnJobUpdate', function(job)
    PlayerData.job = job
    
    -- Bildirim
    AendirCore.Functions.ShowNotification(string.format('Mesleğiniz güncellendi: %s', Config.Jobs[job.name].label), 'info')
end)

-- Çete Değişimi
RegisterNetEvent('aendir:client:OnGangUpdate', function(gang)
    PlayerData.gang = gang
    
    -- Bildirim
    AendirCore.Functions.ShowNotification(string.format('Çeteniz güncellendi: %s', Config.Gangs[gang.name].label), 'info')
end)

-- Eşya Ekleme
RegisterNetEvent('aendir:client:OnItemAdd', function(item, amount, info)
    -- Envanter sistemi eklendiğinde buraya kod eklenecek
    
    -- Bildirim
    AendirCore.Functions.ShowNotification(string.format('%sx %s eklendi', amount, item), 'success')
end)

-- Eşya Silme
RegisterNetEvent('aendir:client:OnItemRemove', function(item, amount)
    -- Envanter sistemi eklendiğinde buraya kod eklenecek
    
    -- Bildirim
    AendirCore.Functions.ShowNotification(string.format('%sx %s silindi', amount, item), 'error')
end)

-- Ölüm
RegisterNetEvent('aendir:client:OnDeath', function()
    PlayerData.metadata.isdead = true
    
    -- Bildirim
    AendirCore.Functions.ShowNotification('Öldünüz!', 'error')
end)

-- Son Durum
RegisterNetEvent('aendir:client:OnLastStand', function()
    PlayerData.metadata.inlaststand = true
    
    -- Bildirim
    AendirCore.Functions.ShowNotification('Son durumdasınız!', 'warning')
end)

-- Canlanma
RegisterNetEvent('aendir:client:OnRevive', function()
    PlayerData.metadata.isdead = false
    PlayerData.metadata.inlaststand = false
    
    -- Bildirim
    AendirCore.Functions.ShowNotification('Canlandınız!', 'success')
end)

-- Hapishane
RegisterNetEvent('aendir:client:OnJail', function(jailTime)
    PlayerData.metadata.jail = jailTime
    
    -- Bildirim
    AendirCore.Functions.ShowNotification(string.format('%d dakika hapishanedesiniz!', jailTime), 'error')
end)

-- Hapishaneden Çıkış
RegisterNetEvent('aendir:client:OnJailRelease', function()
    PlayerData.metadata.jail = 0
    
    -- Bildirim
    AendirCore.Functions.ShowNotification('Hapishaneden çıktınız!', 'success')
end)

-- Telefon
RegisterNetEvent('aendir:client:OnPhoneCall', function(number)
    -- Telefon sistemi eklendiğinde buraya kod eklenecek
    
    -- Bildirim
    AendirCore.Functions.ShowNotification(string.format('Arayan: %s', number), 'info')
end)

-- SMS
RegisterNetEvent('aendir:client:OnSMS', function(number, message)
    -- Telefon sistemi eklendiğinde buraya kod eklenecek
    
    -- Bildirim
    AendirCore.Functions.ShowNotification(string.format('SMS: %s', number), 'info')
end)

-- Discord
RegisterNetEvent('aendir:client:OnDiscord', function(message)
    -- Discord sistemi eklendiğinde buraya kod eklenecek
    
    -- Bildirim
    AendirCore.Functions.ShowNotification('Yeni Discord mesajı!', 'info')
end) 