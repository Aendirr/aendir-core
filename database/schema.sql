-- Veritabanı oluşturma
CREATE DATABASE IF NOT EXISTS aendir_core;
USE aendir_core;

-- Oyuncular tablosu
CREATE TABLE IF NOT EXISTS players (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50) UNIQUE,
    cid INT DEFAULT 1,
    license VARCHAR(255) UNIQUE,
    name VARCHAR(255),
    money JSON,
    charinfo JSON,
    job VARCHAR(50) DEFAULT NULL,
    job_grade INT DEFAULT 0,
    gang VARCHAR(50) DEFAULT NULL,
    gang_grade INT DEFAULT 0,
    position JSON,
    metadata JSON,
    inventory JSON,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Araçlar tablosu
CREATE TABLE IF NOT EXISTS vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plate VARCHAR(50) UNIQUE,
    model VARCHAR(50),
    owner VARCHAR(50),
    stored BOOLEAN DEFAULT true,
    fuel FLOAT DEFAULT 100.0,
    body FLOAT DEFAULT 1000.0,
    engine FLOAT DEFAULT 1000.0,
    insurance BOOLEAN DEFAULT true,
    tracker BOOLEAN DEFAULT false,
    mods JSON,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Evler tablosu
CREATE TABLE IF NOT EXISTS houses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner VARCHAR(50),
    price INT,
    location JSON,
    inventory JSON,
    alarm BOOLEAN DEFAULT false,
    camera BOOLEAN DEFAULT false,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- İşletmeler tablosu
CREATE TABLE IF NOT EXISTS businesses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner VARCHAR(50),
    name VARCHAR(255),
    type VARCHAR(50),
    price INT,
    employees JSON,
    inventory JSON,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Çeteler tablosu
CREATE TABLE IF NOT EXISTS gangs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    type VARCHAR(50),
    leader VARCHAR(50),
    members JSON,
    territory JSON,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Başarılar tablosu
CREATE TABLE IF NOT EXISTS achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50),
    achievement VARCHAR(50),
    completed BOOLEAN DEFAULT false,
    completed_at TIMESTAMP NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Görevler tablosu
CREATE TABLE IF NOT EXISTS quests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50),
    quest VARCHAR(50),
    progress JSON,
    completed BOOLEAN DEFAULT false,
    completed_at TIMESTAMP NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Yetenekler tablosu
CREATE TABLE IF NOT EXISTS skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50),
    skill VARCHAR(50),
    level INT DEFAULT 0,
    xp INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Evcil hayvanlar tablosu
CREATE TABLE IF NOT EXISTS pets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner VARCHAR(50),
    type VARCHAR(50),
    name VARCHAR(255),
    health FLOAT DEFAULT 100.0,
    happiness FLOAT DEFAULT 100.0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Üretim tablosu
CREATE TABLE IF NOT EXISTS production (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner VARCHAR(50),
    type VARCHAR(50),
    item VARCHAR(50),
    amount INT DEFAULT 0,
    quality FLOAT DEFAULT 100.0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
); 