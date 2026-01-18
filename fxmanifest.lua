fx_version 'cerulean'
lua54 'yes'
game 'gta5'

description 'Fivem Department Car Garage Script By FM Gaming'
version '1.0.0'

shared_script {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'bridge/client.lua',
    'client/**.lua'
}

server_scripts {
    'server/**.lua'
}