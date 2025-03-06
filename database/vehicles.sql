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

-- Varsayılan araçlar
INSERT INTO vehicles (owner, plate, model, stored, garage, position, properties) VALUES
-- Polis Araçları
(NULL, 'POLICE1', 'police', true, 'police_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),
(NULL, 'POLICE2', 'police2', true, 'police_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),
(NULL, 'POLICE3', 'police3', true, 'police_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),

-- Ambulans Araçları
(NULL, 'AMBULAN', 'ambulance', true, 'ambulance_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),
(NULL, 'AMBULAN2', 'ambulance2', true, 'ambulance_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),

-- Taksi Araçları
(NULL, 'TAXI1', 'taxi', true, 'taxi_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),
(NULL, 'TAXI2', 'taxi2', true, 'taxi_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),

-- Sivil Araçlar
(NULL, 'CIVIL1', 'blista', true, 'civil_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),
(NULL, 'CIVIL2', 'brioso', true, 'civil_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),
(NULL, 'CIVIL3', 'issi2', true, 'civil_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),

-- SUV Araçlar
(NULL, 'SUV1', 'baller', true, 'suv_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),
(NULL, 'SUV2', 'granger', true, 'suv_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),
(NULL, 'SUV3', 'huntley', true, 'suv_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),

-- Spor Araçlar
(NULL, 'SPORT1', '9f', true, 'sport_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),
(NULL, 'SPORT2', 'adder', true, 'sport_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),
(NULL, 'SPORT3', 'zentorno', true, 'sport_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),

-- Motosikletler
(NULL, 'MOTO1', 'bati', true, 'moto_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),
(NULL, 'MOTO2', 'hakuchou', true, 'moto_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'),
(NULL, 'MOTO3', 'thrust', true, 'moto_garage', '{"x": 442.0, "y": -1024.0, "z": 28.5, "w": 90.0}', '{"fuel": 100.0, "body": 1000.0, "engine": 1000.0, "mods": {}}'); 