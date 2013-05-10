-----------------------------------------------------------------------------------------
--
-- store2.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget = require( "widget" )
local populator = require("storePopulator")
local scene = storyboard.newScene()
local pageScroll
local pageScroll2
local pageScroll3
local coinTotal
local powerUpDetails = {}

--load scenetemplate.lua
--storyboard.gotoScene( "scenetemplate" )

-- These are the functions triggered by the buttons
-- 'onRelease' event listener for backBtn
local function onBackBtnRelease()
	
	-- go to menu1.lua scene
	storyboard.gotoScene( "menu1")
	
	return true	-- indicates successful touch
end

local function on( ... )
	-- body
end

local function onPrevRelease()
--	
	if i>1 then
    --moving the pagescroll out of the screen and fading it out
	transition.to( pageScroll, { time=500, x=(pageScroll.x + 480), y= pageScroll.y } )
--
--	-- fly in the new page scroll
	transition.to( pageScroll2, { time=500, x=(pageScroll2.x + 480), y= pageScroll2.y } )
--
--	-- fly in the new page scroll
	transition.to( pageScroll3, { time=500, x=(pageScroll3.x + 480), y= pageScroll3.y } )
--	
	i=i-1
	powerVal.text="Value:"..powerUpDetails[i][1]
	powerCost.text="Cost:"..powerUpDetails[i][4]
	powerDescription.text=powerUpDetails[i][2]
	return true	-- indicates successful touch
	end
--	
end
local function onNextRelease()
--	
	if i<3 then
--	--moving the pagescroll out of the screen and fading it out
	transition.to( pageScroll, { time=500, x=(pageScroll.x - 480), y= pageScroll.y } )
--
--	-- fly in the new page scroll
	transition.to( pageScroll2, { time=500, x=(pageScroll2.x - 480), y= pageScroll2.y } )
--
--	-- fly in the new page scroll
	transition.to( pageScroll3, { time=500, x=(pageScroll3.x - 480), y= pageScroll3.y } )
--	
	i=i+1
	powerVal.text="Value:"..powerUpDetails[i][1]
	powerCost.text="Cost:"..powerUpDetails[i][4]
	powerDescription.text=powerUpDetails[i][2]
	return true	-- indicates successful touch
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	coinTotal = populator.getTotalCoins()
	print(coinTotal.."===========>Total no. of coins available")
	powerUpDetails = populator.getPowerUp()
	print(powerUpDetails[3][2])
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
i=1
--> Hiding the status bar using setStatusBar
display.setStatusBar( display.HiddenStatusBar )

--Adding the background layer first
local background = display.newImageRect( "images/storebg2.png", display.contentWidth, display.contentHeight )
background:setReferencePoint( display.TopLeftReferencePoint )
background.x, background.y = 0, 0
	

--Adding the title for the store
local title = display.newImage("images/title1.png")
--title.height = display.contentWidth*0.20
title.x = display.contentWidth/2
title.y = display.contentHeight*0.15

--Adding the bottom floor
local floor = display.newImage("images/stoneground.png")
floor.width=display.contentHeight*2
floor.height=display.contentWidth*0.30
floor.x=display.contentHeight*0.5
floor.y = display.contentHeight*.95

--Adding the right sword
	local rightSword = widget.newButton{
		default = "swordright.png",
		--over = "swordleft.png"
		onRelease = onNextRelease,
		labelColor = { default={0,0,255}, over={128} },
		id = "next",
		label = "NEXT",
		fontSize = 25,
		width=220, height=120,
		}	
		rightSword.x = display.contentWidth *0.75
		rightSword.y = display.contentHeight/2

--Adding the left sword
	--local leftSword = display.newImage("swordleft.png")
	local leftSword = widget.newButton{
		default = "swordleft.png",
		--over = "swordleft.png"
		onRelease = onPrevRelease,
		labelColor = { default={0,0,255}, over={128} },
		id = "prev",
		label = "PREV",
		fontSize = 25,
		width=220, height=120,
		}	
		leftSword.x= display.contentWidth *0.25
		leftSword.y = display.contentHeight/2


powerVal = display.newText( "Value:"..powerUpDetails[i][1], 0, 0, default, 25 )
powerVal:setTextColor(255,0,0)
powerVal.x = display.contentWidth/2 
powerVal.y = display.contentHeight*.42

powerCost = display.newText( "Cost:"..powerUpDetails[i][4], 0, 0, default, 25 )
powerCost:setTextColor(255,0,0)
powerCost.x = display.contentWidth/2 
powerCost.y = display.contentHeight*.50

powerDescription = display.newText( powerUpDetails[i][2], 0, 0, default, 20 )
powerDescription:setTextColor(255,0,0)
powerDescription.x = display.contentWidth/2 
powerDescription.y = display.contentHeight*.58

--.."==="..powerUpDetails[2][2].."==="..powerUpDetails[2][4],
--Adding the page scroll for the first power-up
pageScroll = display.newImage("pagescroll.png")
pageScroll.x = display.contentWidth/2 
pageScroll.y = display.contentHeight/2

--Adding the page scroll for the second power-up
pageScroll2 = display.newImage("pagescroll.png")
pageScroll2.x = display.contentWidth/2 + 480
pageScroll2.y = display.contentHeight/2
--pageScroll2.alpha = 0.0

--Adding the page scroll for the third power-up
pageScroll3 = display.newImage("pagescroll.png")
pageScroll3.x = display.contentWidth/2 + 960
pageScroll3.y = display.contentHeight/2
--pageScroll3.alpha = 0.0

--moving the pagescroll out of the screen and fading it out
	--transition.to( pageScroll, { time=1500, x=(pageScroll.x - 480), y= pageScroll.y } )

	-- fly in the new page scroll
	--transition.to( pageScroll2, { time=500, delay=750, x=(pageScroll2.x - 480), y= pageScroll2.y } )

	-- fly in the new page scroll
	--transition.to( pageScroll3, { time=500, delay=1500, x=(pageScroll3.x - 960), y= pageScroll3.y } )

local backButton = widget.newButton{
		default = "buttonRed.png",
		over = "buttonRedOver.png",
		onRelease = onBackBtnRelease,
		labelColor = { default={255}, over={128} },
		id = "back",
		label = "Go Back",
		fontSize = 16,
		width=150, height=60,
	}
	backButton.y = display.contentHeight*.8
	backButton.x = display.contentWidth *0.25
	
	local buyButton = widget.newButton{
		default = "buttonRed.png",
		over = "buttonRedOver.png",
		--onRelease = populator.buyItem(i),
		labelColor = { default={255}, over={128} },
		id = "buy",
		label = "BUY",
		fontSize = 16,
		width=150, height=60,
	}
	buyButton.y = display.contentHeight*.8
	buyButton.x = display.contentWidth *0.5	

	local avatarButton = widget.newButton{
		default = "buttonRed.png",
		over = "buttonRedOver.png",
		--onRelease = onBackBtnRelease,
		labelColor = { default={255}, over={128} },
		id = "avatar",
		label = "NINJA",
		fontSize = 16,
		width=150, height=60,
	}
	avatarButton.y = display.contentHeight*.8
	avatarButton.x = display.contentWidth *0.75
		
	group:insert( background )
	group:insert(title)
	group:insert(floor)
	group:insert(rightSword)
	group:insert(leftSword)
	group:insert(pageScroll)
	group:insert(pageScroll2)
	group:insert(pageScroll3)
	group:insert(powerVal)
	group:insert(powerCost)
	group:insert(powerDescription)
	group:insert(backButton)
	group:insert(buyButton)
	group:insert(avatarButton)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )

end


-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
scene:addEventListener( "destroyScene", scene )


-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
--scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene