fx_version 'adamant'
game 'gta5'
description 'D-Logging from Deun Services'
version '1.0'
ui_page 'html/main.html'

lua54 'yes'

shared_script { 'log.lua' }


exports {
  'getLog'
}

server_exports {
  'getLog'
}
