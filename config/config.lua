Config = {}

Config.Framework = "Aendir-Core"
Config.Debug = true -- Hata ayıklama için

-- Database Config
Config.Database = {
    type = "mysql", -- mysql / sqlite
    host = "127.0.0.1",
    username = "root",
    password = "",
    database = "aendir_core"
}

-- Başlangıç Parası
Config.StartingMoney = 5000
