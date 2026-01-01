-- NOTE: Removed ReaperV4 bypass dependency for portability.
lua54 'yes'

fx_version 'cerulean'
game 'gta5'

author 'Richiez Room Conversion Done By JWT-CXTMS-JimmyWangTang'
description 'QB-Core Gunplug Script (qb-inventory + ox_inventory support)'
version '1.0.0'

shared_script 'config.lua'
client_scripts {
    'client/main.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}
