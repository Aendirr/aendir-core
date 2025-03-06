# Aendir Core Framework

Aendir Core Framework, FiveM için geliştirilmiş kapsamlı bir oyun çerçevesidir. Bu framework, gerçekçi bir hayat simülasyonu sunmak için tasarlanmıştır.

## Özellikler

### Araç Sistemi

#### Araç Satın Alma
- Farklı araç kategorileri (Premium, Lüks, Ekonomik)
- Test sürüşü imkanı
- Özel plaka sistemi
- Araç satış sistemi
- Araç fiyatlandırma sistemi

#### Araç Modifiye
- Kapsamlı modifiye kategorileri
  - Spoiler
  - Tamponlar
  - Yan Paneller
  - Egzoz
  - Kafes
  - Radyatör
  - Çamurluk
  - Kaput
  - Çatı
  - Motor
  - Frenler
  - Transmisyon
  - Korna
  - Süspansiyon
  - Zırh
  - Turbo
  - Xenon
  - Tekerlekler
  - Renk
  - Aksesuarlar
  - Plaka
  - Neon
  - Cam
  - Livery
  - Extra
- Modifiye fiyatlandırma sistemi
- Modifiye kaydetme ve yükleme
- Modifiye logları

#### Araç Garaj
- Çoklu garaj noktaları
- Araç çekme sistemi
- Araç park etme
- Garaj yönetimi
- Garaj logları

#### Araç Yakıt
- Gerçekçi yakıt tüketimi
- Yakıt istasyonları
- Yakıt doldurma sistemi
- Yakıt kontrolü
- Yakıt logları

#### Araç Hasar
- Detaylı hasar sistemi
- Tamir sistemi
- Sigorta sistemi
- Hasar kaydetme
- Hasar logları

#### Araç Takip
- Takip cihazı sistemi
- Gerçek zamanlı takip
- Takip yönetimi
- Takip logları

#### Genel Özellikler
- Motor kontrolü (M tuşu)
- Kilit sistemi (U tuşu)
- Plaka sistemi
- Log sistemi
- Bildirim sistemi

## Kurulum

### FiveM Sunucusu Kurulumu

1. FiveM Sunucusu Kurulumu:
```bash
# Sunucu klasörü oluştur
mkdir fivem-server
cd fivem-server

# FiveM Sunucu Artifacts'ı indir
wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/latest/fx.tar.xz

# Arşivi çıkart
tar xf fx.tar.xz

# Çalıştırma izinlerini ver
chmod +x run.sh
```

2. Veritabanı Kurulumu:
```bash
# MySQL kurulumu
sudo apt update
sudo apt install mysql-server

# MySQL'i başlat
sudo systemctl start mysql
sudo systemctl enable mysql

# Veritabanı oluştur
sudo mysql -u root -p
```

MySQL konsolunda:
```sql
CREATE DATABASE aendir;
USE aendir;

# Veritabanı tablolarını oluştur
source /path/to/aendir-core/database/schema.sql
source /path/to/aendir-core/database/items.sql
source /path/to/aendir-core/database/vehicles.sql
```

3. Resource Kurulumu:
```bash
# Resources klasörü oluştur
mkdir -p resources

# Aendir Core'u kopyala
cp -r /path/to/aendir-core resources/

# Bağımlılıkları kur
cd resources
git clone https://github.com/overextended/ox_lib.git
git clone https://github.com/overextended/oxmysql.git
```

4. Server.cfg Düzenleme:
```cfg
# Server.cfg dosyasını düzenle
nano server.cfg
```

Aşağıdaki satırları ekle:
```cfg
# Veritabanı Bağlantısı
set mysql_connection_string "mysql://user:password@localhost/aendir?charset=utf8mb4"

# Resource Sıralaması
ensure oxmysql
ensure ox_lib
ensure aendir-core

# Sunucu Ayarları
set sv_hostname "Aendir Core"
set sv_maxclients 32
set sv_scriptHookAllowed 0
set sv_cheats 0
```

5. Sunucuyu Başlatma:
```bash
# Sunucuyu başlat
./run.sh
```

### Veritabanı Tabloları

### vehicles
```sql
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) NOT NULL,
  `plate` varchar(8) NOT NULL,
  `model` varchar(50) NOT NULL,
  `price` int(11) NOT NULL,
  `stored` tinyint(1) NOT NULL DEFAULT 1,
  `insured` tinyint(1) NOT NULL DEFAULT 0,
  `tracker` tinyint(1) NOT NULL DEFAULT 0,
  `position` text NOT NULL,
  `properties` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### logs
```sql
CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `details` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## Bağımlılıklar

- ox_lib
- oxmysql

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

## İletişim

- Discord: [Aendir](https://discord.gg/aendir)
- Website: [www.aendir.com](https://www.aendir.com)
- Teamspeak: ts.aendir.com

## Katkıda Bulunma

1. Bu depoyu fork edin
2. Yeni bir branch oluşturun (`git checkout -b feature/yeniOzellik`)
3. Değişikliklerinizi commit edin (`git commit -am 'Yeni özellik eklendi'`)
4. Branch'inizi push edin (`git push origin feature/yeniOzellik`)
5. Pull Request oluşturun 