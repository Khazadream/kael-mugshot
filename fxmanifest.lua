fx_version 'cerulean'
game 'gta5'
lua54 'yes'
 
description 'A Mugshot Script For Police Job '
version '1.2.0'

shared_script {
	"@ox_lib/init.lua",
	'config.lua'
}

client_scripts {
	'client/**.lua'
}

server_scripts {
	'server/**.lua'
}