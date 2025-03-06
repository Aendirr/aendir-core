# Aendir Inventory System

Aendir Inventory System, FiveM sunucuları için gelişmiş bir envanter sistemidir. Modern ve kullanıcı dostu bir arayüz ile birlikte gelir.

## Özellikler

- Modern ve kullanıcı dostu arayüz
- Sürükle-bırak desteği
- Ağırlık sistemi
- Eşya kullanma
- Eşya transfer etme
- Eşya satma
- Silah sistemi
- Bildirim sistemi
- İlerleme çubuğu
- Veritabanı entegrasyonu

## Gereksinimler

- FiveM Server
- MySQL Database
- ox_lib
- oxmysql

## Kurulum

1. Dosyaları `resources/[aendir]/aendir-inventory` klasörüne kopyalayın
2. `server.cfg` dosyasına aşağıdaki satırı ekleyin:
```cfg
ensure aendir-inventory
```

3. Veritabanı tablosunu oluşturun:
```sql
CREATE TABLE IF NOT EXISTS `player_inventory` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(60) NOT NULL,
    `items` longtext NOT NULL,
    `weight` float NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## Kullanım

### Komutlar

- `/inventory` - Envanteri aç/kapat
- `/giveitem [id] [eşya] [miktar]` - Oyuncuya eşya ver
- `/removeitem [id] [eşya] [miktar]` - Oyuncudan eşya sil

### Tuşlar

- `TAB` - Envanteri aç/kapat
- `ESC` - Envanteri kapat

### Eşya İşlemleri

- Eşyayı kullanmak için üzerine tıklayın ve "Kullan" seçeneğini seçin
- Eşyayı transfer etmek için üzerine tıklayın ve "Transfer Et" seçeneğini seçin
- Eşyayı satmak için üzerine tıklayın ve "Sat" seçeneğini seçin
- Silahı çıkarmak için üzerine tıklayın ve "Silahı Çıkar" seçeneğini seçin

## Yapılandırma

`config.lua` dosyasından aşağıdaki ayarları özelleştirebilirsiniz:

- Maksimum ağırlık
- Maksimum slot sayısı
- Eşya özellikleri
- Silah özellikleri
- Bildirim ayarları
- İlerleme çubuğu ayarları
- Veritabanı ayarları
- Komut ayarları
- Tuş ayarları

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın. 