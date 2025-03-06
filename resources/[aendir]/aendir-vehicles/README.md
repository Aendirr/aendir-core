# Aendir Araç Sistemi

Bu script, FiveM sunucuları için gelişmiş bir araç yönetim sistemi sunar. Aendir Core framework'ü üzerine inşa edilmiştir.

## Özellikler

### Araç Yönetimi
- Araç oluşturma ve silme
- Garaj sistemi
- Çekme sistemi
- Sigorta sistemi
- Modifiye sistemi

### Araç Özellikleri
- Yakıt sistemi
- Hasar sistemi
- Takip sistemi
- Kilit sistemi
- Motor kontrolü

### Konumlar
- Garajlar
- Çekme noktaları
- Modifiye dükkanları
- Yakıt istasyonları
- Tamir noktaları
- Sigorta ofisleri

## Gereksinimler

- [Aendir Core](https://github.com/aendir/aendir-core)
- [ox_lib](https://github.com/overextended/ox_lib)
- [oxmysql](https://github.com/overextended/oxmysql)

## Kurulum

1. Scripti `resources/[aendir]` klasörüne indirin
2. `vehicles.sql` dosyasını veritabanınıza import edin
3. `server.cfg` dosyasına `ensure aendir-vehicles` ekleyin
4. Sunucuyu yeniden başlatın

## Kullanım

### Araç Kontrolleri
- `M` - Motor çalıştırma/durdurma
- `U` - Kilit açma/kapama

### Garaj
- Garaj noktalarına yaklaşın
- Menüyü açın
- Araç çıkarın veya garaja alın

### Modifiye
- Modifiye dükkanlarına yaklaşın
- Menüyü açın
- İstediğiniz modifikasyonu seçin

### Yakıt
- Yakıt istasyonlarına yaklaşın
- Yakıt doldurun

### Tamir
- Tamir noktalarına yaklaşın
- Aracınızı tamir edin

### Sigorta
- Sigorta ofislerine yaklaşın
- Aracınızı sigortalayın

## Yapılandırma

Tüm ayarlar `config.lua` dosyasında bulunmaktadır:

- Araç ayarları
- Ücretler
- Konumlar
- Bildirimler
- Progress bar
- Blip ve marker ayarları

## Veritabanı

### vehicles Tablosu
- Araç bilgileri
- Durum bilgileri
- Özellikler
- Zaman damgaları

### vehicle_logs Tablosu
- Araç işlemleri
- Log kayıtları
- Zaman damgaları

## Lisans

Bu script MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

## Destek

Herhangi bir sorun veya öneriniz için GitHub üzerinden issue açabilirsiniz.

## Katkıda Bulunma

1. Bu depoyu fork edin
2. Yeni bir branch oluşturun (`git checkout -b feature/yeniOzellik`)
3. Değişikliklerinizi commit edin (`git commit -am 'Yeni özellik eklendi'`)
4. Branch'inizi push edin (`git push origin feature/yeniOzellik`)
5. Pull Request oluşturun 