-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn
local avatarSelect
-- 'onRelease' event listener for playBtn

local storyOptions =
{
	effect = "crossFade",
	time = 500,
	params = { level = "level1"}
}

local function onPlayBtnPress()
	-- go to level1.lua scene
	storyboard.gotoScene( "levelSelect", storyOptions)--,slideLeft,500)--, storyOptions )
	
	return true	-- indicates successful touch
end


local function onHighscoreBtnPress()
	
	storyboard.gotoScene( "highscore", storyOptions)--,slideLeft,500)--, storyOptions )
	return true	-- indicates successful touch
end


local function avatarSelectScreen()
	print ("SELECT")
	local options =
		{
		    effect = "fade",
		    time = 400,
		    isModal = true,
		    params = { level = "Avatar" }
		}

  		storyboard.showOverlay("overlay_scene",options)
end

local function settingsBtnListener()
	print ("in settings button listener-----------------")
	local options =
		{
		    effect = "fade",
		    time = 400,
		    isModal = true,
		    params = { level = "settings" }
		}

  		storyboard.showOverlay("overlay_scene",options)
end



-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	

	-- display a background image
	local background = display.newImageRect( "images/background.jpg", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	
	-- avatarSelect = widget.newButton{
	-- 	label="",
	-- 	default="images/avatar.png",
	-- 	over="images/avatar.png",
	-- 	width=120, height=120,
	-- 	onPress = avatarSelectScreen	-- event listener function
	-- }

	-- avatarSelect:setReferencePoint(display.TopLeftReferencePoint)
	-- avatarSelect.x = 850
	-- avatarSelect.y = 460



	avatarSelect = widget.newButton{
		label="",
		default="images/buttons/btnAvatar.png",
		--over="images/avatar.png",
		--width=120, height=120,
		onPress = avatarSelectScreen	-- event listener function
	}
	avatarSelect.x = 90
	avatarSelect.y = 400



	--display.setDefault("textColor",255,255,255)

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		default="images/buttons/btnPlay.png",
		
		onPress = onPlayBtnPress	-- event listener function

	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = 85
	playBtn.y = 295

	highscoreBtn = widget.newButton{
		default="images/buttons/btnHighscore.png",
		onPress = onHighscoreBtnPress	-- event listener function

	}
	highscoreBtn:setReferencePoint( display.CenterReferencePoint )
	highscoreBtn.x = 125
	highscoreBtn.y = 345



	settingsBtn = widget.newButton{
        label="",
        default="images/buttons/btnOptions.png",
        --over="images/avatar.png",
        --width=120, height=120,
        onPress = settingsBtnListener    -- event listener function
    }
    settingsBtn.x = 97
    settingsBtn.y = 450




	
	-- create/position logo/title image on upper-half of the screen
	--[[local titleLogo = display.newImageRect( "images/logo1.png", 528, 84 )
	titleLogo:setReferencePoint( display.CenterReferencePoint )
	titleLogo.x = display.contentWidth * 0.5 - 200
	titleLogo.y = 100
	
	avatarSelect = widget.newButton{
		label="",
		default="images/ninjaIcon.png",
		over="images/ninjaIcon.png",
		--width=120, height=120,
		onPress = avatarSelectScreen	-- event listener function
	}

	avatarSelect:setReferencePoint(display.TopLeftReferencePoint)
	avatarSelect.x = 850
	avatarSelect.y = 460
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Play Now",
		fontSize = 50,
		labelColor = { default={255}, over={128} },
		default="images/button.png",
		over="images/button-over.png",
		width=308, height=80,
		onPress = onPlayBtnPress	-- event listener function

	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125
	

	--settings button

	settingsBtn = widget.newButton{
		label="",
		default="images/settingsIcon48x48.png",
		over="images/settingsIcon48x48.png",
		--width=120, height=120,
		onPress = settingsBtnListener	-- event listener function
	}

	--settingsBtn:setReferencePoint(display.TopLeftReferencePoint)
	settingsBtn.x = 45
	settingsBtn.y = 540]]


	-- all display objects must be inserted into group
	group:insert( background )
	--group:insert( titleLogo )
	group:insert( avatarSelect )
	group:insert( playBtn )
	group:insert( highscoreBtn )
	group:insert( settingsBtn )
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	

	-- media.playSound( "audio/one_simple_idea.mp3", true )
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	avatarSelect:removeSelf()
	avatarSelect = nil
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
	highscoreBtn:removeSelf()
	highscoreBtn = nil
	settingsBtn:removeSelf()
	settingsBtn = nil

end


function scene:overlayBegan( event )
    print( "The overlay scene is showing: " .. event.sceneName )
end
scene:addEventListener( "overlayBegan" )

--

function scene:overlayEnded( event )
    print( "The following overlay scene was removed: " .. event.sceneName )
end
scene:addEventListener( "overlayEnded" )


-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene