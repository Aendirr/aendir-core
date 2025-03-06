-- Araçlar Tablosu
CREATE TABLE IF NOT EXISTS `vehicles` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `plate` varchar(8) NOT NULL,
    `model` varchar(50) NOT NULL,
    `stored` tinyint(1) NOT NULL DEFAULT 0,
    `impounded` tinyint(1) NOT NULL DEFAULT 0,
    `fuel` float NOT NULL DEFAULT 100.0,
    `bodyHealth` float NOT NULL DEFAULT 1000.0,
    `engineHealth` float NOT NULL DEFAULT 1000.0,
    `mods` longtext NOT NULL,
    `coords` longtext NOT NULL,
    `heading` float NOT NULL DEFAULT 0.0,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Araç Sigortaları Tablosu
CREATE TABLE IF NOT EXISTS `vehicle_insurance` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `plate` varchar(8) NOT NULL,
    `insured` tinyint(1) NOT NULL DEFAULT 0,
    `start_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `end_date` timestamp NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `plate` (`plate`),
    FOREIGN KEY (`plate`) REFERENCES `vehicles` (`plate`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Araç Takip Tablosu
CREATE TABLE IF NOT EXISTS `vehicle_trackers` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `plate` varchar(8) NOT NULL,
    `tracked` tinyint(1) NOT NULL DEFAULT 0,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `plate` (`plate`),
    FOREIGN KEY (`plate`) REFERENCES `vehicles` (`plate`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Araç Çekme Tablosu
CREATE TABLE IF NOT EXISTS `vehicle_impounds` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `plate` varchar(8) NOT NULL,
    `impound_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `release_date` timestamp NOT NULL,
    `fee` int(11) NOT NULL DEFAULT 0,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `plate` (`plate`),
    FOREIGN KEY (`plate`) REFERENCES `vehicles` (`plate`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Araç Logları Tablosu
CREATE TABLE IF NOT EXISTS `vehicle_logs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `plate` varchar(8) NOT NULL,
    `action` varchar(50) NOT NULL,
    `details` text NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`plate`) REFERENCES `vehicles` (`plate`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 