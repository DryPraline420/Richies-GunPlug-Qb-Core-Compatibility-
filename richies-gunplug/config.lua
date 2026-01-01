Config = {
    Framework = 'QB',
    JobName = 'gunplug',
    -- Chat command players will use: /gunplug
    Command = 'gunplug',
    WeaponsPerWeek = 12,
    Inventory = 'auto', -- 'auto' | 'qb' | 'ox'
    -- qb-inventory NOTE:
    -- If your weapon items are not named exactly like the entries in gunData (e.g. "WEAPON_P226"),
    -- the script will try common variants (lowercase / weapon_p226). If none exist, add items in qb-core.
    -- ## TEMPLATE TO USE ##        
    --handGuns = {
            --semis = {
                --'WEAPON_GLOCK41',

            --},

            --fullies = {
                --'WEAPON_BLUEGLOCKS',
            --},
        --},

    --
    resetDates = {
        { weekday = 1, hour = 0, minute = 0 },
    },
    gunData = {
        handGuns = {
            semis = {
                'WEAPON_GLOCK41',

            },

            fullies = {
                'WEAPON_BLUEGLOCKS',
            },
        },

        rifles = {
            semis = {
                'WEAPON_DMK18',
            },

            fullies = {
                'WEAPON_RAM7',
            },
        },

        shotguns = {
            semis = {
                'WEAPON_R590',
            },

            fullies = {
                'WEAPON_M500',
            },
        },

        melee = {
            misc = {
                'WEAPON_CHAIR',
                'WEAPON_AXE',
            },
        },
    },
    tiers = {
        ['gunplug'] = {
            uses = 2,
            rifles = { fullies = 2, semis = 2 }, -- can set any amount of weapons you want :D Example 2, = 2 semi-rifles and 2 fullies if set to 3 or 4 or 5 then pleayer receives that amount
            handGuns = { fullies = 2, semis = 2 },
            shotguns = { semis = 2 } 
        }
    },
    cooldown = 2,
}
