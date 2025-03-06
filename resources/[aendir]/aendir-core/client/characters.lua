-- Karakterler
local Characters = {
    -- Karakter Ayarları
    Settings = {
        -- Maksimum Karakter Sayısı
        MaxCharacters = 4,
        
        -- İsim Ayarları
        Name = {
            MinLength = 3,
            MaxLength = 20,
            AllowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
        },
        
        -- Başlangıç Görünümü
        StartingAppearance = {
            Model = "mp_m_freemode_01",
            Components = {
                {component = 11, drawable = 15, texture = 0},
                {component = 3, drawable = 15, texture = 0},
                {component = 4, drawable = 15, texture = 0},
                {component = 6, drawable = 15, texture = 0}
            }
        }
    }
}

-- Karakter Oluşturma
function AendirCore.Functions.CreateCharacter(data)
    TriggerServerEvent('aendir:server:CreateCharacter', data)
end

-- Karakter Silme
function AendirCore.Functions.DeleteCharacter(id)
    TriggerServerEvent('aendir:server:DeleteCharacter', id)
end

-- Karakter Güncelleme
function AendirCore.Functions.UpdateCharacter(id, data)
    TriggerServerEvent('aendir:server:UpdateCharacter', id, data)
end

-- Karakter Seçme
function AendirCore.Functions.SelectCharacter(id)
    TriggerServerEvent('aendir:server:SelectCharacter', id)
end

-- Karakter Olayları
RegisterNetEvent('aendir:client:CharacterCreated', function(data)
    local ped = PlayerPedId()
    
    -- Model Yükleme
    RequestModel(GetHashKey(data.model or Characters.Settings.StartingAppearance.Model))
    while not HasModelLoaded(GetHashKey(data.model or Characters.Settings.StartingAppearance.Model)) do
        Wait(0)
    end
    
    -- Karakter Oluşturma
    SetPlayerModel(PlayerId(), GetHashKey(data.model or Characters.Settings.StartingAppearance.Model))
    ped = PlayerPedId()
    
    -- Görünüm Ayarlama
    if data.components then
        for k, v in pairs(data.components) do
            SetPedComponentVariation(ped, v.component, v.drawable, v.texture, 0)
        end
    else
        for k, v in pairs(Characters.Settings.StartingAppearance.Components) do
            SetPedComponentVariation(ped, v.component, v.drawable, v.texture, 0)
        end
    end
    
    AendirCore.Functions.Notify('Karakteriniz oluşturuldu!', 'success')
end)

RegisterNetEvent('aendir:client:CharacterDeleted', function(id)
    AendirCore.Functions.Notify('Karakteriniz silindi!', 'error')
end)

RegisterNetEvent('aendir:client:CharacterUpdated', function(id, data)
    local ped = PlayerPedId()
    
    -- Görünüm Güncelleme
    if data.components then
        for k, v in pairs(data.components) do
            SetPedComponentVariation(ped, v.component, v.drawable, v.texture, 0)
        end
    end
    
    AendirCore.Functions.Notify('Karakteriniz güncellendi!', 'success')
end)

RegisterNetEvent('aendir:client:CharacterSelected', function(data)
    local ped = PlayerPedId()
    
    -- Model Yükleme
    RequestModel(GetHashKey(data.model))
    while not HasModelLoaded(GetHashKey(data.model)) do
        Wait(0)
    end
    
    -- Karakter Seçme
    SetPlayerModel(PlayerId(), GetHashKey(data.model))
    ped = PlayerPedId()
    
    -- Görünüm Ayarlama
    if data.components then
        for k, v in pairs(data.components) do
            SetPedComponentVariation(ped, v.component, v.drawable, v.texture, 0)
        end
    end
    
    AendirCore.Functions.Notify('Karakteriniz seçildi!', 'success')
end)

-- Karakter Komutları
RegisterCommand('createcharacter', function(source, args)
    if args[1] then
        local name = args[1]
        if string.len(name) >= Characters.Settings.Name.MinLength and string.len(name) <= Characters.Settings.Name.MaxLength then
            local valid = true
            for i = 1, string.len(name) do
                if not string.find(Characters.Settings.Name.AllowedChars, string.sub(name, i, i)) then
                    valid = false
                    break
                end
            end
            if valid then
                local data = {
                    name = name,
                    model = Characters.Settings.StartingAppearance.Model,
                    components = Characters.Settings.StartingAppearance.Components
                }
                AendirCore.Functions.CreateCharacter(data)
            else
                AendirCore.Functions.Notify('Geçersiz karakter!', 'error')
            end
        else
            AendirCore.Functions.Notify('İsim uzunluğu geçersiz!', 'error')
        end
    else
        AendirCore.Functions.Notify('İsim belirtmelisiniz!', 'error')
    end
end)

RegisterCommand('deletecharacter', function(source, args)
    if args[1] then
        local id = tonumber(args[1])
        if id then
            AendirCore.Functions.DeleteCharacter(id)
        else
            AendirCore.Functions.Notify('Geçersiz ID!', 'error')
        end
    else
        AendirCore.Functions.Notify('ID belirtmelisiniz!', 'error')
    end
end)

RegisterCommand('selectcharacter', function(source, args)
    if args[1] then
        local id = tonumber(args[1])
        if id then
            AendirCore.Functions.SelectCharacter(id)
        else
            AendirCore.Functions.Notify('Geçersiz ID!', 'error')
        end
    else
        AendirCore.Functions.Notify('ID belirtmelisiniz!', 'error')
    end
end)

-- Karakter Menüsü
RegisterCommand('charactermenu', function()
    local elements = {
        {
            label = 'Yeni Karakter',
            value = 'create'
        },
        {
            label = 'Karakter Sil',
            value = 'delete'
        },
        {
            label = 'Karakter Seç',
            value = 'select'
        }
    }
    
    lib.registerContext({
        id = 'character_menu',
        title = 'Karakter Menüsü',
        options = elements
    })
    
    lib.showContext('character_menu')
end)

-- Karakter Menü Seçimi
lib.registerCallback('aendir:client:CharacterMenuSelect', function(data)
    if data.value == 'create' then
        local input = lib.inputDialog('Yeni Karakter', {
            {type = 'input', label = 'İsim', description = 'Karakterinizin ismi', required = true}
        })
        
        if input then
            local name = input[1]
            if string.len(name) >= Characters.Settings.Name.MinLength and string.len(name) <= Characters.Settings.Name.MaxLength then
                local valid = true
                for i = 1, string.len(name) do
                    if not string.find(Characters.Settings.Name.AllowedChars, string.sub(name, i, i)) then
                        valid = false
                        break
                    end
                end
                if valid then
                    local data = {
                        name = name,
                        model = Characters.Settings.StartingAppearance.Model,
                        components = Characters.Settings.StartingAppearance.Components
                    }
                    AendirCore.Functions.CreateCharacter(data)
                else
                    AendirCore.Functions.Notify('Geçersiz karakter!', 'error')
                end
            else
                AendirCore.Functions.Notify('İsim uzunluğu geçersiz!', 'error')
            end
        end
    elseif data.value == 'delete' then
        local input = lib.inputDialog('Karakter Sil', {
            {type = 'number', label = 'ID', description = 'Silinecek karakterin ID\'si', required = true}
        })
        
        if input then
            local id = input[1]
            AendirCore.Functions.DeleteCharacter(id)
        end
    elseif data.value == 'select' then
        local input = lib.inputDialog('Karakter Seç', {
            {type = 'number', label = 'ID', description = 'Seçilecek karakterin ID\'si', required = true}
        })
        
        if input then
            local id = input[1]
            AendirCore.Functions.SelectCharacter(id)
        end
    end
end) 