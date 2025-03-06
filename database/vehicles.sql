-- Araçlar tablosu
CREATE TABLE IF NOT EXISTS vehicle_models (
    id INT AUTO_INCREMENT PRIMARY KEY,
    model VARCHAR(50) UNIQUE,
    label VARCHAR(255),
    category VARCHAR(50),
    price INT,
    max_speed FLOAT,
    acceleration FLOAT,
    braking FLOAT,
    handling FLOAT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Varsayılan araçlar
INSERT INTO vehicle_models (model, label, category, price, max_speed, acceleration, braking, handling) VALUES
-- Sivil Araçlar
('blista', 'Blista', 'compact', 15000, 120.0, 7.0, 6.0, 7.0),
('sultan', 'Sultan', 'sports', 45000, 160.0, 8.5, 7.5, 8.5),
('tailgater', 'Tailgater', 'sedans', 35000, 140.0, 7.5, 7.0, 7.5),
('schafter3', 'Schafter', 'sedans', 40000, 150.0, 8.0, 7.5, 8.0),

-- SUV Araçlar
('granger', 'Granger', 'suvs', 55000, 130.0, 7.0, 7.0, 7.0),
('huntley', 'Huntley', 'suvs', 65000, 150.0, 8.0, 7.5, 7.5),
('patriot', 'Patriot', 'suvs', 35000, 120.0, 6.5, 6.5, 6.5),

-- Spor Araçlar
('adder', 'Adder', 'super', 1000000, 200.0, 10.0, 9.0, 9.0),
('zentorno', 'Zentorno', 'super', 950000, 195.0, 9.5, 8.5, 8.5),
('t20', 'T20', 'super', 900000, 190.0, 9.0, 8.0, 8.0),

-- Motosikletler
('bati', 'Bati 801', 'motorcycles', 15000, 160.0, 8.5, 7.0, 8.0),
('hakuchou', 'Suzuki Hayabusa', 'motorcycles', 55000, 180.0, 9.0, 7.5, 8.5),
('sanchez', 'Sanchez', 'motorcycles', 5000, 120.0, 6.5, 6.0, 7.0),

-- Polis Araçları
('police', 'Police Cruiser', 'emergency', 0, 160.0, 8.0, 8.0, 8.0),
('police2', 'Police Buffalo', 'emergency', 0, 170.0, 8.5, 8.5, 8.5),
('police3', 'Police Interceptor', 'emergency', 0, 180.0, 9.0, 9.0, 9.0),

-- Ambulans Araçları
('ambulance', 'Ambulance', 'emergency', 0, 140.0, 7.0, 7.0, 7.0),
('ambulance2', 'Ambulance 2', 'emergency', 0, 150.0, 7.5, 7.5, 7.5),

-- Ticari Araçlar
('boxville', 'Boxville', 'vans', 35000, 100.0, 5.0, 6.0, 5.0),
('speedo', 'Speedo', 'vans', 25000, 120.0, 6.0, 6.5, 6.0),
('youga', 'Youga', 'vans', 30000, 110.0, 5.5, 6.0, 5.5); 