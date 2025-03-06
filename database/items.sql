-- Eşyalar tablosu
CREATE TABLE IF NOT EXISTS items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    label VARCHAR(50) NOT NULL,
    description TEXT,
    type VARCHAR(20) NOT NULL,
    weight FLOAT NOT NULL DEFAULT 1.0,
    usable BOOLEAN NOT NULL DEFAULT false,
    stackable BOOLEAN NOT NULL DEFAULT true,
    closeonuse BOOLEAN NOT NULL DEFAULT true,
    unique BOOLEAN NOT NULL DEFAULT false,
    image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Varsayılan eşyalar
INSERT INTO items (name, label, description, type, weight, usable, stackable, closeonuse, unique, image) VALUES
-- Silahlar
('weapon_pistol', 'Pistol', 'Standart tabanca', 'weapon', 2.0, false, false, true, true, 'weapon_pistol.png'),
('weapon_smg', 'SMG', 'Hafif makineli tüfek', 'weapon', 3.0, false, false, true, true, 'weapon_smg.png'),
('weapon_rifle', 'Rifle', 'Tüfek', 'weapon', 4.0, false, false, true, true, 'weapon_rifle.png'),

-- Yiyecekler
('bread', 'Ekmek', 'Taze ekmek', 'food', 0.5, true, true, true, false, 'bread.png'),
('sandwich', 'Sandviç', 'Lezzetli sandviç', 'food', 0.5, true, true, true, false, 'sandwich.png'),
('hamburger', 'Hamburger', 'Fast food hamburger', 'food', 0.5, true, true, true, false, 'hamburger.png'),

-- İçecekler
('water', 'Su', 'Temiz su', 'drink', 0.5, true, true, true, false, 'water.png'),
('cola', 'Kola', 'Soğuk kola', 'drink', 0.5, true, true, true, false, 'cola.png'),
('coffee', 'Kahve', 'Sıcak kahve', 'drink', 0.5, true, true, true, false, 'coffee.png'),

-- Medikal
('bandage', 'Bandaj', 'Yara bandajı', 'medical', 0.3, true, true, true, false, 'bandage.png'),
('firstaid', 'İlk Yardım', 'İlk yardım çantası', 'medical', 0.5, true, true, true, false, 'firstaid.png'),
('painkillers', 'Ağrı Kesici', 'Ağrı kesici ilaç', 'medical', 0.3, true, true, true, false, 'painkillers.png'),

-- Araçlar
('phone', 'Telefon', 'Akıllı telefon', 'misc', 0.5, true, false, true, true, 'phone.png'),
('sim_card', 'SIM Kart', 'Telefon SIM kartı', 'misc', 0.1, false, false, true, true, 'sim_card.png'),
('keys', 'Anahtar', 'Araç anahtarı', 'misc', 0.1, false, false, true, true, 'keys.png'),

-- Diğer
('money', 'Para', 'Nakit para', 'misc', 0.0, false, true, false, false, 'money.png'),
('black_money', 'Kara Para', 'Kara para', 'misc', 0.0, false, true, false, false, 'black_money.png'),
('gold', 'Altın', 'Değerli altın', 'misc', 1.0, false, true, false, false, 'gold.png'); 