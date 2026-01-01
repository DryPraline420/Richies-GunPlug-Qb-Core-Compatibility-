-- Add these items to qb-core/shared/items.lua (or your items file)
-- Names MUST match what you use in Config.gunData (or change Config.gunData to match your names)
--
-- NOTE: This is only a snippet/template. You may need to adjust:
--  - image
--  - unique
--  - useable
--  - description
--  - weapon hash handling (depending on your weapon pack)

-- Example entries (keep the keys unique)
-- ['weapon_p226'] = { name = 'weapon_p226', label = 'P226', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_pistol.png', unique = true, useable = false, shouldClose = true, description = 'P226' },
-- ['weapon_ar15'] = { name = 'weapon_ar15', label = 'AR-15', weight = 1000, type = 'weapon', ammotype = 'AMMO_RIFLE', image = 'weapon_assaultrifle.png', unique = true, useable = false, shouldClose = true, description = 'AR-15' },

-- If you prefer using WEAPON_* item names in qb-core, you can define them like:
-- ['weapon_p226'] is recommended, but this also works if your inventory supports it:
-- ['WEAPON_P226'] = { name = 'WEAPON_P226', label = 'P226', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_pistol.png', unique = true, useable = false, shouldClose = true, description = 'P226' },
