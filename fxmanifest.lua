fx_version 'adamant'
game 'gta5'

description 'UKB-VehicleShop'
auther 'UKB - DEVELOPER'

version '1.0.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'Config/base.config.lua',
	'Config/keys.config.lua',
	'Config/default.config.lua',
	'Config/vehicle.config.lua',
	'Config/Quries.config.lua',
	'Config/function/server.function.lua',
	'Source/server/server.lua'
}

client_scripts {
	'Config/base.config.lua',
	'Config/keys.config.lua',
	'Config/default.config.lua',
	'Config/setting.config.lua',
	'Config/vehicle.config.lua',
	'Source/client/classes.lua',
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


