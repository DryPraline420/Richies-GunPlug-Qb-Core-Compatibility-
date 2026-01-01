local QBCore = exports['qb-core']:GetCoreObject()

-- =====================================
-- Richie’s Room GunPlug (QB-Core)
-- Weekly weapon bundle for a job (Config.JobName)
-- Supports qb-inventory and ox_inventory.
-- =====================================

local function notify(src, msg, msgType)
    -- msgType: 'primary' | 'success' | 'error'
    -- Prefer ox_lib notifications when available, otherwise fall back to QB notify.
    if GetResourceState('ox_lib') == 'started' then
        local t = (msgType == 'error' and 'error') or (msgType == 'success' and 'success') or 'inform'
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Gunplug',
            description = msg,
            type = t,
        })
        return
    end

    TriggerClientEvent('QBCore:Notify', src, msg, msgType or 'primary')
end

local function getCurrentWeek()
    return tonumber(os.date('%U'))
end

local function getAvailableWeapons()
    local weapons = {}
    for _, types in pairs(Config.gunData) do
        for _, list in pairs(types) do
            for _, weapon in ipairs(list) do
                weapons[#weapons + 1] = weapon
            end
        end
    end
    return weapons
end

local function resolveInventory()
    if Config.Inventory and Config.Inventory ~= 'auto' then
        return Config.Inventory
    end

    if GetResourceState('ox_inventory') == 'started' then
        return 'ox'
    end
    -- qb-inventory (and most qb inventory forks) rely on QBCore player functions
    return 'qb'
end

local function resolveQBItemName(item)
    -- qb uses item names in lowercase most of the time. Weapon items are often "weapon_pistol", etc.
    if QBCore.Shared.Items[item] then return item end

    local lower = string.lower(item)
    if QBCore.Shared.Items[lower] then return lower end

    if string.sub(item, 1, 7) == 'WEAPON_' then
        local maybe = 'weapon_' .. string.lower(string.sub(item, 8))
        if QBCore.Shared.Items[maybe] then return maybe end
    end

    return nil
end

local function addItem(src, item, amount)
    local inv = resolveInventory()

    if inv == 'ox' then
        return exports.ox_inventory:AddItem(src, item, amount)
    end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end

    local itemName = resolveQBItemName(item)
    if not itemName then
        -- If ox_inventory is running, fall back so the server still works even if QB item isn't defined
        if GetResourceState('ox_inventory') == 'started' then
            return exports.ox_inventory:AddItem(src, item, amount)
        end
        return false, ('Item not found in QBCore.Shared.Items: %s'):format(item)
    end

    local ok = Player.Functions.AddItem(itemName, amount)
    if ok then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'add', amount)
        return true
    end

    return false
end

local function canUseGunplug(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end
    local job = Player.PlayerData.job
    return job and job.name == Config.JobName
end

local function givePlayerWeapons(src)
    if not canUseGunplug(src) then
        notify(src, 'You do not have permission to use this.', 'error')
        return
    end

    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    local result = MySQL.Sync.fetchAll('SELECT last_week FROM gunplug_usage WHERE citizenid = ?', { citizenid })
    local lastWeek = result[1] and result[1].last_week or 0
    local currentWeek = getCurrentWeek()

    if lastWeek == currentWeek then
        notify(src, 'You have already received your weapons this week.', 'error')
        return
    end

    local available = getAvailableWeapons()
    local success = true
    local failReason

    for _ = 1, (Config.WeaponsPerWeek or 12) do
        local weapon = available[math.random(1, #available)]
        local ok, reason = addItem(src, weapon, 1)
        if not ok then
            success = false
            failReason = reason
            break
        end
    end

    if not success then
        notify(src, 'Failed to give weapons. Check item names in your inventory.', 'error')
        if failReason then
            print(('[richies-gunplug] AddItem failed: %s'):format(failReason))
        end
        return
    end

    MySQL.Sync.execute([[ 
        INSERT INTO gunplug_usage (citizenid, last_week)
        VALUES (?, ?)
        ON DUPLICATE KEY UPDATE last_week = VALUES(last_week)
    ]], { citizenid, currentWeek })

    notify(src, ('You received %d random weapons for this week!'):format(Config.WeaponsPerWeek or 12), 'success')
end

RegisterNetEvent('richies-gunplug:requestWeapons', function()
    givePlayerWeapons(source)
end)

-- Server-side command as a fallback (works even if the client script is stopped)
RegisterCommand(Config.Command or 'gunplug', function(src)
    if src == 0 then
        print('^1This command can only be used in-game.^7')
        return
    end
    givePlayerWeapons(src)
end, false)

-- Admin reset command: /resetgunplug [playerId]
RegisterCommand('resetgunplug', function(src, args)
    if src ~= 0 and not IsPlayerAceAllowed(src, 'command.resetgunplug') then
        notify(src, 'You do not have permission to use this command.', 'error')
        return
    end

    local targetId = tonumber(args[1] or '')
    if not targetId then
        if src == 0 then
            print('^1Usage: /resetgunplug [playerId]^7')
        else
            notify(src, 'Usage: /resetgunplug [playerId]', 'error')
        end
        return
    end

    local Target = QBCore.Functions.GetPlayer(targetId)
    if not Target then
        if src == 0 then
            print('Player not found.')
        else
            notify(src, 'Player not found.', 'error')
        end
        return
    end

    local citizenid = Target.PlayerData.citizenid
    MySQL.Async.execute('UPDATE gunplug_usage SET last_week = 0 WHERE citizenid = ?', { citizenid }, function(rows)
        if rows > 0 then
            if src == 0 then
                print(('Reset gunplug usage for %s (%s)'):format(Target.PlayerData.name or 'player', citizenid))
            else
                notify(src, ('Reset gunplug usage for %s'):format(Target.PlayerData.charinfo.firstname or 'player'), 'success')
            end
            notify(targetId, 'Your gunplug cooldown has been reset by an admin.', 'success')
        else
            if src == 0 then
                print('No record found for this player.')
            else
                notify(src, 'No record found for this player.', 'error')
            end
        end
    end)
end, true)

CreateThread(function()
    Wait(1000)
    print('^2--------------------------------------------------^7')
    print('^2  Richie’s Room GunPlug is now loaded! (QB-Core)^7')
    print(('^2  Job Registered: %s^7'):format(Config.JobName or 'gunplug'))
    print('^2--------------------------------------------------^7')
end)
