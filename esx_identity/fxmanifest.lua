fx_version 'bodacious'

game 'gta5'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@vrp/lib/utils.lua',
	'server.lua'
}

client_script 'client.lua'


ui_page 'html/index.html'

files {
	'html/index.html',
	'html/css/*',
	'html/font/*',
	'html/img/*',
	'html/js/bootstrap.min.js',
	'html/js/imagesloaded.pkgd.min.js',
	'html/js/jquery-3.5.0.min.js',
	'html/js/main.js',
	'html/js/popper.min.js',
	'html/js/script.js',
	'html/js/validator.min.js',
	'html/webfonts/*'
}