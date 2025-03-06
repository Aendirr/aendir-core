# Aendir Core Framework

Aendir Core Framework, FiveM için geliştirilmiş modern ve kapsamlı bir core framework'tür.

## Özellikler

- Karakter Sistemi
- Envanter Sistemi
- Para Sistemi
- Meslek Sistemi
- Çete Sistemi
- Araç Sistemi
- Mülk Sistemi
- İşletme Sistemi
- Silah Sistemi
- Anti-Cheat Sistemi
- Whitelist Sistemi
- Log Sistemi

## Gereksinimler

- FiveM Server
- MySQL Database
- ox_lib
- oxmysql

## Kurulum

1. Dosyaları `resources/[aendir]/aendir-core` klasörüne kopyalayın
2. `server.cfg` dosyasına aşağıdaki satırı ekleyin:
```cfg
ensure aendir-core
```
3. Veritabanı tablolarını oluşturun:
```sql
CREATE TABLE IF NOT EXISTS players (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50) UNIQUE,
    name VARCHAR(50),
    money JSON,
    job JSON,
    gang JSON,
    items JSON,
    vehicles JSON,
    properties JSON,
    businesses JSON,
    weapons JSON,
    meta JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50),
    name VARCHAR(50),
    model VARCHAR(50),
    components JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (citizenid) REFERENCES players(citizenid)
);

CREATE TABLE IF NOT EXISTS vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50),
    plate VARCHAR(8),
    model VARCHAR(50),
    stored BOOLEAN DEFAULT FALSE,
    garage VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (citizenid) REFERENCES players(citizenid)
);

CREATE TABLE IF NOT EXISTS properties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50),
    type VARCHAR(50),
    price INT,
    coords JSON,
    interior JSON,
    storage JSON,
    garage JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (citizenid) REFERENCES players(citizenid)
);

CREATE TABLE IF NOT EXISTS businesses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50),
    type VARCHAR(50),
    price INT,
    coords JSON,
    interior JSON,
    storage JSON,
    register JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (citizenid) REFERENCES players(citizenid)
);

CREATE TABLE IF NOT EXISTS bans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50),
    name VARCHAR(50),
    reason TEXT,
    admin VARCHAR(50),
    expires TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS whitelist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50),
    name VARCHAR(50),
    added_by VARCHAR(50),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS pending_whitelist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50),
    name VARCHAR(50),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50),
    message TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Kullanım

### Karakter Sistemi
```lua
-- Karakter Oluşturma
TriggerEvent('aendir:server:CreateCharacter', {
    name = 'John Doe',
    model = 'a_m_y_business_03',
    components = {
        [0] = {drawable = 0, texture = 0},
        [1] = {drawable = 0, texture = 0},
        [2] = {drawable = 0, texture = 0},
        [3] = {drawable = 0, texture = 0},
        [4] = {drawable = 0, texture = 0},
        [5] = {drawable = 0, texture = 0},
        [6] = {drawable = 0, texture = 0},
        [7] = {drawable = 0, texture = 0},
        [8] = {drawable = 0, texture = 0},
        [9] = {drawable = 0, texture = 0},
        [10] = {drawable = 0, texture = 0},
        [11] = {drawable = 0, texture = 0}
    }
})

-- Karakter Silme
TriggerEvent('aendir:server:DeleteCharacter', 'citizenid')

-- Karakter Seçme
TriggerEvent('aendir:server:SelectCharacter', 'citizenid')

-- Karakter Güncelleme
TriggerEvent('aendir:server:UpdateCharacter', {
    citizenid = 'citizenid',
    name = 'John Doe',
    model = 'a_m_y_business_03',
    components = {
        [0] = {drawable = 0, texture = 0},
        [1] = {drawable = 0, texture = 0},
        [2] = {drawable = 0, texture = 0},
        [3] = {drawable = 0, texture = 0},
        [4] = {drawable = 0, texture = 0},
        [5] = {drawable = 0, texture = 0},
        [6] = {drawable = 0, texture = 0},
        [7] = {drawable = 0, texture = 0},
        [8] = {drawable = 0, texture = 0},
        [9] = {drawable = 0, texture = 0},
        [10] = {drawable = 0, texture = 0},
        [11] = {drawable = 0, texture = 0}
    }
})
```

### Envanter Sistemi
```lua
-- Eşya Ekleme
TriggerEvent('aendir:server:AddItem', 'item_name', 1)

-- Eşya Silme
TriggerEvent('aendir:server:RemoveItem', 'item_name', 1)

-- Eşya Kullanma
TriggerEvent('aendir:server:UseItem', 'item_name')

-- Eşya Transfer
TriggerEvent('aendir:server:TransferItem', 'item_name', 1, 'target_id')

-- Eşya Satma
TriggerEvent('aendir:server:SellItem', 'item_name', 1)

-- Eşya Alma
TriggerEvent('aendir:server:BuyItem', 'item_name', 1)
```

### Para Sistemi
```lua
-- Para Ekleme
TriggerEvent('aendir:server:AddMoney', 'cash', 1000)

-- Para Silme
TriggerEvent('aendir:server:RemoveMoney', 'cash', 1000)

-- Para Transfer
TriggerEvent('aendir:server:TransferMoney', 'cash', 1000, 'target_id')
```

### Meslek Sistemi
```lua
-- Meslek Atama
TriggerEvent('aendir:server:SetJob', 'police', 'cadet')

-- Meslek Silme
TriggerEvent('aendir:server:RemoveJob')
```

### Çete Sistemi
```lua
-- Çete Atama
TriggerEvent('aendir:server:SetGang', 'ballas', 'recruit')

-- Çete Silme
TriggerEvent('aendir:server:RemoveGang')
```

### Araç Sistemi
```lua
-- Araç Çıkarma
TriggerEvent('aendir:server:SpawnVehicle', 'vehicle_model')

-- Araç Garaja Koyma
TriggerEvent('aendir:server:StoreVehicle', 'plate')

-- Araç Satma
TriggerEvent('aendir:server:SellVehicle', 'plate')

-- Araç Sigorta
TriggerEvent('aendir:server:InsureVehicle', 'plate')

-- Araç Modifiye
TriggerEvent('aendir:server:ModifyVehicle', 'plate')
```

### Mülk Sistemi
```lua
-- Mülk Satın Alma
TriggerEvent('aendir:server:BuyProperty', 'property_id')

-- Mülk Satma
TriggerEvent('aendir:server:SellProperty', 'property_id')

-- Mülk Kirala
TriggerEvent('aendir:server:RentProperty', 'property_id')

-- Kira İptal
TriggerEvent('aendir:server:CancelRent', 'property_id')
```

### İşletme Sistemi
```lua
-- İşletme Satın Alma
TriggerEvent('aendir:server:BuyBusiness', 'business_id')

-- İşletme Satma
TriggerEvent('aendir:server:SellBusiness', 'business_id')

-- Çalışan Ekleme
TriggerEvent('aendir:server:AddEmployee', 'business_id', 'target_id')

-- Çalışan Silme
TriggerEvent('aendir:server:RemoveEmployee', 'business_id', 'target_id')
```

### Silah Sistemi
```lua
-- Silah Ekleme
TriggerEvent('aendir:server:AddWeapon', 'weapon_name', 100)

-- Silah Silme
TriggerEvent('aendir:server:RemoveWeapon', 'weapon_name')

-- Mermi Ekleme
TriggerEvent('aendir:server:AddAmmo', 'weapon_name', 100)
```

### Anti-Cheat Sistemi
```lua
-- Whitelist Ekleme
TriggerEvent('aendir:server:AddToWhitelist', 'target_id')

-- Whitelist Silme
TriggerEvent('aendir:server:RemoveFromWhitelist', 'target_id')

-- İhlal Listesi
TriggerEvent('aendir:server:GetViolations', 'target_id')

-- İhlal Temizleme
TriggerEvent('aendir:server:ClearViolations', 'target_id')
```

### Whitelist Sistemi
```lua
-- Whitelist Talebi
TriggerEvent('aendir:server:RequestWhitelist')

-- Whitelist Kabul
TriggerEvent('aendir:server:AcceptWhitelist', 'target_id')

-- Whitelist Red
TriggerEvent('aendir:server:RejectWhitelist', 'target_id')
```

### Log Sistemi
```lua
-- Log Ekleme
TriggerEvent('aendir:server:Log', 'type', 'action', 'message')

-- Log Temizleme
TriggerEvent('aendir:server:ClearLogs')

-- Log Görüntüleme
TriggerEvent('aendir:server:ShowLogs', 'type')

-- Log Dışa Aktarma
TriggerEvent('aendir:server:ExportLogs')
```

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın. 