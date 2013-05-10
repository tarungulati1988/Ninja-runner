-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

--require("test.LunaTest.lunatest")
--lunatest.suite("test.LunaTest.suite-map")
--lunatest.suite("test.LunaTest.suite-game")
--lunatest.suite("test.LunaTest.suite-loadsave")
--lunatest.suite("test.LunaTest.suite-jsonReadWrite")
--lunatest.run()

-- include the Corona "storyboard" module

local storyboard = require "storyboard"
-- load menu screen



storyboard.gotoScene( "menu" )