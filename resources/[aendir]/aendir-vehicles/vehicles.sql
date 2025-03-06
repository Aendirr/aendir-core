CREATE TABLE IF NOT EXISTS `vehicles` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `plate` varchar(8) NOT NULL,
    `owner` varchar(50) NOT NULL,
    `model` varchar(50) NOT NULL,
    `price` int(11) NOT NULL DEFAULT 0,
    `stored` tinyint(1) NOT NULL DEFAULT 1,
    `impounded` tinyint(1) NOT NULL DEFAULT 0,
    `insured` tinyint(1) NOT NULL DEFAULT 0,
    `tracker` tinyint(1) NOT NULL DEFAULT 0,
    `fuel` float NOT NULL DEFAULT 100.0,
    `damage` longtext NOT NULL,
    `properties` longtext NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `plate` (`plate`),
    KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `vehicle_logs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `plate` varchar(8) NOT NULL,
    `owner` varchar(50) NOT NULL,
    `action` varchar(50) NOT NULL,
    `data` longtext NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    KEY `plate` (`plate`),
    KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci; 