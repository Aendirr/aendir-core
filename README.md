# Aendir Core

Aendir Core, FiveM için geliştirilmiş modern ve kapsamlı bir roleplay framework'üdür.

## Özellikler

### 1. Karakter Sistemi
- Çoklu karakter desteği
- Detaylı karakter bilgileri
- Karakter oluşturma/düzenleme
- Karakter silme
- Karakter seçme

### 2. Whitelist Sistemi
- Discord entegrasyonu
- Teamspeak entegrasyonu
- Yaş kontrolü
- Başvuru sistemi
- Otomatik onay/red sistemi

### 3. Banka Sistemi
- Çoklu banka lokasyonları
- ATM'ler
- Para transferi
- Hesap yönetimi
- Kredi sistemi

### 4. Araç Sistemi
- Garaj sistemi
- Araç modifiye
- Araç sigorta
- Araç kiralama
- Araç satın alma
- Araç kategorileri:
  - Polis Araçları
  - Ambulans Araçları
  - Taksi Araçları
  - Sivil Araçlar
  - SUV Araçlar
  - Spor Araçlar
  - Motosikletler

### 5. Ev Sistemi
- Ev tipleri:
  - Daire
  - Ev
  - Malikane
- Depolama sistemi
- Ev satın alma/kiralama
- Ev içi etkileşimler
- Garaj entegrasyonu

### 6. İşletme Sistemi
- İşletme tipleri
- İşletme yönetimi
- Çalışan sistemi
- Envanter yönetimi
- Para yönetimi

### 7. Envanter Sistemi
- Ağırlık sistemi
- Slot sistemi
- Eşya tipleri:
  - Silahlar
  - Yiyecekler
  - İçecekler
  - Medikal
  - Araçlar
  - Diğer
- Kullanım sistemi
- Transfer sistemi

### 8. Yetenek Sistemi
- Güç
- Dayanıklılık
- Sürüş
- Ateş Etme
- Seviye sistemi
- Tecrübe sistemi

### 9. Başarı Sistemi
- Başarı kategorileri
- Ödül sistemi
- İlerleme takibi
- Bildirim sistemi

### 10. Görev Sistemi
- Görev tipleri
- İlerleme sistemi
- Ödül sistemi
- Görev takibi

### 11. Log Sistemi
- Detaylı log kayıtları
- Log kategorileri
- Log filtreleme
- Log arşivleme

### 12. Admin Sistemi
- Admin komutları
- Yetki sistemi
- Log sistemi
- Oyuncu yönetimi

## Kurulum

1. Dosyaları `resources` klasörüne kopyalayın
2. `server.cfg` dosyasına şu satırı ekleyin:
```cfg
ensure aendir-core
```

3. Veritabanını oluşturun:
```bash
mysql -u root -p < database/schema.sql
mysql -u root -p aendir < database/items.sql
mysql -u root -p aendir < database/vehicles.sql
```

4. `config.lua` dosyasını düzenleyin:
- Sunucu ayarlarını
- Discord webhook URL'sini
- Teamspeak bilgilerini

## Gereksinimler

- FiveM Server
- MySQL Server
- Discord Bot
- Teamspeak Server

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