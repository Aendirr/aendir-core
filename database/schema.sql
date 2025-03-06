-- Veritabanı oluşturma
CREATE DATABASE IF NOT EXISTS aendir;
USE aendir;

-- Kullanıcılar tablosu
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50) NOT NULL UNIQUE,
    license VARCHAR(50) NOT NULL,
    name VARCHAR(50) NOT NULL,
    money JSON NOT NULL,
    charinfo JSON NOT NULL,
    job JSON NOT NULL,
    gang JSON NOT NULL,
    position JSON NOT NULL,
    metadata JSON NOT NULL,
    inventory JSON NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Karakterler tablosu
CREATE TABLE IF NOT EXISTS characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    dateofbirth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    height INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Whitelist tablosu
CREATE TABLE IF NOT EXISTS whitelist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50) NOT NULL,
    name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    discord VARCHAR(50) NOT NULL,
    teamspeak VARCHAR(50) NOT NULL,
    experience TEXT NOT NULL,
    status ENUM('pending', 'accepted', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (identifier) REFERENCES users(identifier) ON DELETE CASCADE
);

-- Evler tablosu
CREATE TABLE IF NOT EXISTS houses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner VARCHAR(50) DEFAULT NULL,
    label VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    type VARCHAR(20) NOT NULL,
    position JSON NOT NULL,
    garage_position JSON NOT NULL,
    storage_position JSON NOT NULL,
    storage_size INT NOT NULL,
    storage_items JSON NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner) REFERENCES users(identifier) ON DELETE SET NULL
);

-- İşletmeler tablosu
CREATE TABLE IF NOT EXISTS businesses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner VARCHAR(50) DEFAULT NULL,
    label VARCHAR(50) NOT NULL,
    type VARCHAR(20) NOT NULL,
    price INT NOT NULL,
    position JSON NOT NULL,
    inventory JSON NOT NULL,
    money INT NOT NULL DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner) REFERENCES users(identifier) ON DELETE SET NULL
);

-- Araçlar tablosu
CREATE TABLE IF NOT EXISTS vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner VARCHAR(50) DEFAULT NULL,
    plate VARCHAR(8) NOT NULL UNIQUE,
    model VARCHAR(50) NOT NULL,
    stored BOOLEAN NOT NULL DEFAULT true,
    garage VARCHAR(50) DEFAULT NULL,
    position JSON NOT NULL,
    properties JSON NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner) REFERENCES users(identifier) ON DELETE SET NULL
);

-- Yetenekler tablosu
CREATE TABLE IF NOT EXISTS skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50) NOT NULL,
    strength INT NOT NULL DEFAULT 0,
    stamina INT NOT NULL DEFAULT 0,
    driving INT NOT NULL DEFAULT 0,
    shooting INT NOT NULL DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (identifier) REFERENCES users(identifier) ON DELETE CASCADE
);

-- Başarılar tablosu
CREATE TABLE IF NOT EXISTS achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50) NOT NULL,
    achievement_id VARCHAR(50) NOT NULL,
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (identifier) REFERENCES users(identifier) ON DELETE CASCADE
);

-- Görevler tablosu
CREATE TABLE IF NOT EXISTS quests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50) NOT NULL,
    quest_type VARCHAR(50) NOT NULL,
    quest_id VARCHAR(50) NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT false,
    completed_at TIMESTAMP NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (identifier) REFERENCES users(identifier) ON DELETE CASCADE
);

-- Loglar tablosu
CREATE TABLE IF NOT EXISTS logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    identifier VARCHAR(50) NOT NULL,
    action VARCHAR(50) NOT NULL,
    details JSON NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- İndeksler
CREATE INDEX idx_users_identifier ON users(identifier);
CREATE INDEX idx_characters_user_id ON characters(user_id);
CREATE INDEX idx_whitelist_identifier ON whitelist(identifier);
CREATE INDEX idx_houses_owner ON houses(owner);
CREATE INDEX idx_businesses_owner ON businesses(owner);
CREATE INDEX idx_vehicles_owner ON vehicles(owner);
CREATE INDEX idx_vehicles_plate ON vehicles(plate);
CREATE INDEX idx_skills_identifier ON skills(identifier);
CREATE INDEX idx_achievements_identifier ON achievements(identifier);
CREATE INDEX idx_quests_identifier ON quests(identifier);
CREATE INDEX idx_logs_type ON logs(type);
CREATE INDEX idx_logs_identifier ON logs(identifier); 