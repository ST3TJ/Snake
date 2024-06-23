print('Starting the environment setup...')

SETUP = {
    WINERROR = false,
    ADDONS = true,
    DEBUG = true,
}

ffi = require('ffi')
require('lib/_G')
require('lib/vector')
require('lib/color')
require('lib/cdef')
printd('The basic libraries have been launched successfully')

math = require('lib/math')
enums = require('lib/enums')

callbacks = require('lib/callbacks')
http = require('lib/http')
engine = require('lib/engine')
keyboard = require('lib/keyboard')
utf8 = require('utf8')
winerror = require('lib/winerror')
printd('Libraries launched successfully')

screen = engine.get_screen_size()
window = engine.get_window_size()

--#region: addons
if SETUP.ADDONS then
    gui = require('addons/gui')
    printd("Addons launched successfully")
end

printd('Environment is settuped')