--[[

This is the loading file which will be used to transition between scenes. The advantages of using this file are

-- We will easily be able to clear the memory by purging entire scenes on exit (Necessary for restart level)
-- Display cool animations while users wait for levels to load

-- We are going to use the options that are passed by the showOverlay call through game.lua to decide how this file will behave.

]]

local storyboard = require "storyboard"
local scene = storyboard.newScene()

local storyOptions
local loadingbackground

function scene:enterScene( event )
    
    -- loading background
    local params = event.params
	
    loadingbackground = display.newImageRect("images/loading.jpg",  display.contentWidth, display.contentHeight)
    loadingbackground.x = display.contentWidth / 2
    loadingbackground.y = display.contentHeight / 2
    
 
 	 storyOptions =
	{
		effect = "crossFade",
		time = 500,
		params = { level = "", replay = ""}
	}
	
	if params.selection == "replay" then
		storyOptions.params.selection = "replay"
		local M = require("loadsave")
		storyOptions.params.replayContent = M.loadTable("temp")
	end
	storyOptions.params.level = params.level

	--[[

		The below code is a crude way used to go to the next level. Needs refinement as we go ahead.
	]]
	if params.selection == "next" then
		if storyOptions.params.level == "level0" then
			storyOptions.params.level = "level1"
			elseif storyOptions.params.level == "level1" then
			storyOptions.params.level = "level2"
			elseif storyOptions.params.level == "level2" then
			storyOptions.params.level = "level3"
			elseif storyOptions.params.level == "level3" then
			storyOptions.params.level = "level4"
		end
	end


	if require("loadsave").loadTable("temp")==nil then storyOptions.params.replay = nil else storyOptions.params.replay = "temp" end

    -- instantiate scene
    timer.performWithDelay( 1000, createActualScene )
end
 
function createActualScene()

    storyboard.gotoScene("game",storyOptions)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view


    loadingbackground:removeSelf()
    loadingbackground = nil

	storyboard.purgeScene(scene)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
end




-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "enterScene", scene )


-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )




return scene 