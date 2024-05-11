fx_version 'adamant'
game 'gta5'

description 'UKB-VehicleShop'

version '1.10.1'

server_scripts {
	'Config/config.lua',
	'Source/server/server.lua'
}

client_scripts {
	'Config/config.lua',
	'Source/client/client.lua'
}

ui_page 'http://localhost:5173/'

files {
	'interface/index.html',
	'interface/*'
}


