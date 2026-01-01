-- QB-Core version
-- Stores cooldown per-character using citizenid
CREATE TABLE IF NOT EXISTS `gunplug_usage` (
  `citizenid` VARCHAR(64) NOT NULL,
  `last_week` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
