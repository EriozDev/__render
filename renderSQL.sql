CREATE TABLE render_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id VARCHAR(24) NOT NULL UNIQUE,
    license VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    discord VARCHAR(255),
    player_group VARCHAR(50),
    date_connected DATE NOT NULL,
    time_connected TIME NOT NULL
);

CREATE TABLE `render_bans` (
  `banid` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `licenseid` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `accountid` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `targetName` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `sourceName` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `timeat` int NOT NULL,
  `expiration` int NOT NULL,
  `permanent` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE `render_bans_history` (
  `banid` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `licenseid` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `accountid` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `targetName` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `sourceName` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `timeat` int NOT NULL,
  `expiration` int NOT NULL,
  `permanent` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;