# Aendir Core Veritabanı

Bu klasör, Aendir Core framework'ü için gerekli veritabanı dosyalarını içerir.

## Dosyalar

- `schema.sql`: Ana veritabanı şeması ve tabloları
- `items.sql`: Eşya sistemi için tablolar ve varsayılan eşyalar
- `vehicles.sql`: Araç sistemi için tablolar ve varsayılan araçlar

## Kurulum

1. MySQL veritabanınızda aşağıdaki komutları sırasıyla çalıştırın:
   ```sql
   source schema.sql
   source items.sql
   source vehicles.sql
   ```

2. Veritabanı bağlantı bilgilerinizi `server/main.lua` dosyasında güncelleyin:
   ```lua
   MySQL.ready(function()
       MySQL.connect({
           host = 'localhost',
           user = 'root',
           password = '',
           database = 'aendir_core'
       })
   end)
   ```

## Tablolar

### players
- Oyuncu bilgileri
- Para ve envanter
- Meslek ve çete bilgileri
- Karakter bilgileri

### vehicles
- Araç bilgileri
- Araç durumu
- Modifikasyonlar
- Sigorta ve takip

### houses
- Ev bilgileri
- Ev sahipliği
- Ev envanteri
- Güvenlik sistemleri

### businesses
- İşletme bilgileri
- Çalışanlar
- Envanter
- Gelir/gider

### gangs
- Çete bilgileri
- Üyeler
- Bölge kontrolü
- Rütbeler

### items
- Eşya bilgileri
- Özellikler
- Kullanım
- Kombinasyon

### vehicle_models
- Araç modelleri
- Özellikler
- Fiyatlar
- Kategoriler

## Güncelleme

Veritabanını güncellemek için:

1. Yeni SQL dosyası oluşturun: `database/updates/YYYYMMDD_description.sql`
2. Güncelleme kodlarını bu dosyaya ekleyin
3. Güncellemeyi çalıştırın:
   ```sql
   source updates/YYYYMMDD_description.sql
   ``` 