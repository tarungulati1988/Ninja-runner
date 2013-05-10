local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require("game")

local jumpchannel = jumpChannel

local widget = require( "widget" )

-- Slider listener
local function sliderListener( event )
    local slider = event.target
    local value = event.value

    print( "Slider at " .. value .. "%" )
	
	print("sound value is  :")
	--audio.setVolume(value/100,{jumpChannel})
	audio.stop({channel = backgroundMusic})

end



local function onOKBtnPress()
	
	storyboard.gotoScene( "menu", storyOptions)--,slideLeft,500)--, storyOptions )
	
	return true	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
end


function scene:createScene( event )
	local group = self.view
	
	slider = widget.newSlider
	{
    	top = 200,
    	left = 50,
    	listener = sliderListener
	}


	OKBtn = widget.newButton{
		default="images/Playbtn.png",
		
		onPress = onOKBtnPress	-- event listener function

	}
	OKBtn:setReferencePoint( display.CenterReferencePoint )
	OKBtn.x = 85
	OKBtn.y = 290
	

	group:insert(slider)
	group:insert(OKBtn)

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	
	storyboard:purgeScene(scene)
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	slider:removeSelf()
	slider = nil
	OKBtn:removeSelf()
	OKBtn = nil
end

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