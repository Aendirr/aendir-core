# Aendir Core Framework

Aendir Core, FiveM için geliştirilmiş kapsamlı bir roleplay framework'üdür.

## Özellikler

### 🎮 Temel Sistemler
- Çoklu karakter desteği
- Gelişmiş karakter özelleştirme
- Detaylı envanter sistemi
- Gerçekçi ekonomi sistemi
- Dinamik meslek sistemi
- Ev ve işletme sistemi
- Araç sistemi
- Çete sistemi

### 🏠 Ev Sistemi
- Ev satın alma/satma
- Ev faturaları
- Ev deposu
- Güvenlik sistemleri
- Kamera sistemleri
- Mobilya sistemi

### 🚗 Araç Sistemi
- Araç kayıt sistemi
- Modifikasyon sistemi
- Hasar sistemi
- Yakıt sistemi
- Sigorta sistemi
- Takip sistemi
- Garaj sistemi

### 💼 Meslek Sistemi
- Polis
- Paramedik
- Mekanik
- Ve daha fazlası...
- Her meslek için:
  - Rütbe sistemi
  - Maaş sistemi
  - Eşya sistemi
  - Görev sistemi
  - Vardiya sistemi

### 🎯 Diğer Özellikler
- Başarı sistemi
- Görev sistemi
- Yetenek sistemi
- Evcil hayvan sistemi
- Üretim sistemi
- Balıkçılık sistemi
- Avcılık sistemi
- Madencilik sistemi
- Üretim sistemi
- Telefon sistemi
- Banka sistemi
- Mağaza sistemi

## Kurulum

1. Dosyaları `resources` klasörüne kopyalayın
2. `server.cfg` dosyasına ekleyin:
   ```cfg
   ensure aendir-core
   ```
3. Veritabanını kurun:
   ```sql
   source database/schema.sql
   source database/items.sql
   source database/vehicles.sql
   ```
4. Veritabanı bağlantı bilgilerini güncelleyin:
   ```lua
   MySQL.connect({
       host = 'localhost',
       user = 'root',
       password = '',
       database = 'aendir_core'
   })
   ```

## Gereksinimler
- FiveM Server
- MySQL
- ox_lib
- oxmysql

## Komutlar

### Genel Komutlar
- `/help` - Yardım menüsü
- `/stats` - İstatistikler
- `/skills` - Yetenekler

### Araç Komutları
- `/araclarim` - Araçlarım menüsü
- `/modmenu` - Modifikasyon menüsü

### Ev Komutları
- `/evlerim` - Evlerim menüsü

### Meslek Komutları
- `/meslekler` - Meslekler menüsü

## Tuş Atamaları
- F6 - Araçlarım menüsü
- F7 - Modifikasyon menüsü
- F8 - Evlerim menüsü
- F9 - Meslekler menüsü

## Lisans
Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

## Destek
Herhangi bir sorun veya öneriniz için GitHub üzerinden issue açabilirsiniz.

## Katkıda Bulunma
1. Bu depoyu fork edin
2. Yeni bir branch oluşturun (`git checkout -b feature/yeniOzellik`)
3. Değişikliklerinizi commit edin (`git commit -am 'Yeni özellik eklendi'`)
4. Branch'inizi push edin (`git push origin feature/yeniOzellik`)
5. Pull Request oluşturun 