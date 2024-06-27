fx_version 'adamant'
game 'gta5'

description 'UKB-VehicleShop'

version '1.10.1'

server_scripts {
	'Config/base.config.lua',
	'Config/keys.config.lua',
	'Config/default.config.lua',
	'Config/vehicle.config.lua',
	'Source/server/server.lua'
}

client_scripts {
	'Config/base.config.lua',
	'Config/keys.config.lua',
	'Config/default.config.lua',
	'Config/setting.config.lua',
	'Config/vehicle.config.lua',
	'Source/client/client.lua'
}

ui_page 'interface/index.html'
-- ui_page 'http://localhost:5173/'

files {
	'interface/index.html',
	'interface/*.js',
	'interface/*.css',
	'interface/assets/*.png',
	'interface/assets/*.jpg',
	'interface/assets/car/*.png',
	'interface/assets/car/*.jpg',
}


