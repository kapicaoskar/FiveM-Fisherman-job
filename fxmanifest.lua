fx_version 'cerulean'
game 'gta5'

author 'MetroBoomin.vue'
description 'Fisherman job'


client_scripts {
    'Config.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/client.lua',
}

server_script 'server/server.lua'

shared_scripts {
    '@es_extended/imports.lua'
}


ui_page "public/index.html"

files {
    'public/index.html',
    'public/style.css',
    'public/script.js',
    'public/ryba.png',
    'public/siec.png'
}
