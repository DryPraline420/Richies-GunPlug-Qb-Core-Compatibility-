RICHIE'S ROOM - GUNPLUG (QB-Core)

What it does
- Players with the job name set in config.lua (default: "gunplug") can run the command (default: /tgunplug)
  to receive a random weapon bundle.
- Each character can claim once per week (tracked in the database).

Dependencies
- qb-core
- oxmysql
- Inventory:
  - qb-inventory (supported) OR
  - ox_inventory (supported)

IMPORTANT (qb-inventory item names)
This script gives items using the names in Config.gunData (e.g. "WEAPON_P226").
For qb-inventory, those items MUST exist in qb-core/shared/items.lua.

The script tries common variants automatically:
1) "WEAPON_P226" (as-is)
2) "weapon_p226" (weapon_ + lowercase)
3) "weapon_p226" (if item is WEAPON_* style)

If your server uses different names, either:
- rename entries in Config.gunData to match your item names, OR
- add matching items to qb-core/shared/items.lua

Setup
1) Install resource
   - Drop the folder "richies-gunplug" into your resources
   - Add to server.cfg:
       ensure richies-gunplug

2) Database
   - Import: gunplug_usage.sql

3) Job
   - Ensure you have a QB job named "gunplug" (or change Config.JobName)
   - Give your players that job so they can claim.

4) Admin permission (optional)
   - Allows /resetgunplug [playerId]
   - Add to server.cfg:
       add_ace group.admin command.resetgunplug allow

Commands
- /tgunplug  (or change Config.Command)
- /resetgunplug [playerId] (ace permission required)

Config
- config.lua:
   JobName, Command, WeaponsPerWeek, Inventory, and weapon lists.
