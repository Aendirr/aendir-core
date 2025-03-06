-- Eşyalar tablosu
CREATE TABLE IF NOT EXISTS items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE,
    label VARCHAR(255),
    description TEXT,
    weight FLOAT DEFAULT 1.0,
    type VARCHAR(50),
    usable BOOLEAN DEFAULT false,
    unique BOOLEAN DEFAULT false,
    shouldClose BOOLEAN DEFAULT false,
    combinable JSON,
    image VARCHAR(255),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Varsayılan eşyalar
INSERT INTO items (name, label, description, weight, type, usable, unique, shouldClose, image) VALUES
-- Yiyecekler
('bread', 'Ekmek', 'Taze pişmiş ekmek', 0.5, 'food', true, false, true, 'bread.png'),
('water', 'Su', 'Temiz içme suyu', 0.5, 'drink', true, false, true, 'water.png'),
('coffee', 'Kahve', 'Sıcak kahve', 0.5, 'drink', true, false, true, 'coffee.png'),
('sandwich', 'Sandviç', 'Lezzetli sandviç', 0.5, 'food', true, false, true, 'sandwich.png'),

-- İlaçlar
('bandage', 'Bandaj', 'Yaraları sarmak için bandaj', 0.1, 'medical', true, false, true, 'bandage.png'),
('medkit', 'Medkit', 'Acil durum medkit', 1.0, 'medical', true, false, true, 'medkit.png'),
('painkillers', 'Ağrı Kesici', 'Ağrı kesici ilaç', 0.1, 'medical', true, false, true, 'painkillers.png'),

-- Silahlar
('weapon_pistol', 'Tabanca', 'Standart tabanca', 1.0, 'weapon', false, true, false, 'pistol.png'),
('weapon_rifle', 'Tüfek', 'Standart tüfek', 2.0, 'weapon', false, true, false, 'rifle.png'),
('weapon_knife', 'Bıçak', 'Keskin bıçak', 0.5, 'weapon', false, true, false, 'knife.png'),

-- Araç Eşyaları
('repairkit', 'Tamir Seti', 'Araç tamir seti', 2.0, 'vehicle', true, false, true, 'repairkit.png'),
('lockpick', 'Maymuncuk', 'Araç kilidi açma aleti', 0.1, 'vehicle', true, false, true, 'lockpick.png'),
('phone', 'Telefon', 'Akıllı telefon', 0.5, 'electronics', true, false, true, 'phone.png'),

-- Meslek Eşyaları
('handcuffs', 'Kelepçe', 'Polis kelepçesi', 1.0, 'police', true, false, true, 'handcuffs.png'),
('radio', 'Telsiz', 'İletişim telsizi', 0.5, 'police', true, false, true, 'radio.png'),
('badge', 'Rozet', 'Polis rozeti', 0.1, 'police', false, true, false, 'badge.png'),

-- Üretim Malzemeleri
('iron', 'Demir', 'Ham demir', 1.0, 'material', false, false, false, 'iron.png'),
('steel', 'Çelik', 'İşlenmiş çelik', 1.0, 'material', false, false, false, 'steel.png'),
('wood', 'Odun', 'Ham odun', 1.0, 'material', false, false, false, 'wood.png'),

-- Evcil Hayvan Eşyaları
('dog_food', 'Köpek Maması', 'Köpekler için mama', 1.0, 'pet', true, false, true, 'dog_food.png'),
('cat_food', 'Kedi Maması', 'Kediler için mama', 1.0, 'pet', true, false, true, 'cat_food.png'),
('pet_toy', 'Evcil Hayvan Oyuncağı', 'Evcil hayvanlar için oyuncak', 0.5, 'pet', true, false, true, 'pet_toy.png'); 