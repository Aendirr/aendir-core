-- Araçlar Tablosu
CREATE TABLE IF NOT EXISTS `vehicles` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `plate` varchar(8) NOT NULL,
    `owner` varchar(50) NOT NULL,
    `model` varchar(50) NOT NULL,
    `price` int(11) NOT NULL,
    `stored` tinyint(1) NOT NULL DEFAULT 0,
    `impounded` tinyint(1) NOT NULL DEFAULT 0,
    `insured` tinyint(1) NOT NULL DEFAULT 0,
    `tracker` tinyint(1) NOT NULL DEFAULT 0,
    `fuel` float NOT NULL DEFAULT 100.0,
    `damage` text NOT NULL,
    `properties` text NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Loglar Tablosu
CREATE TABLE IF NOT EXISTS `logs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `type` varchar(50) NOT NULL,
    `identifier` varchar(50) NOT NULL,
    `action` varchar(255) NOT NULL,
    `details` text NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 