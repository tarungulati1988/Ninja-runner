
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require("jsonReadWrite")

local widget = require( "widget" )
local button

	local function onBackBtnRelease()
	
		-- go to menu1.lua scene
		storyboard.gotoScene( "menu")
		
		return true	-- indicates successful touch
	end

	local storyOptions =
	{
		effect = "crossFade",
		time = 500,
		params = { level = "", replay = ""}
	}

	

	local buttonHandler = function( event )	
		
		--local temp = event.target.id + 1
		--print("button pressed: ", event.target.id, temp)
		local levelSelectorFilePath = "levelOptions.json"
		local readTable = readJson(levelSelectorFilePath)
		--print(readTable["1"])
		for key, value in pairs(readTable) do
			--print("in the for loop of the level button handler--------"..event.target.id..key..readTable[key])
			for k, v in pairs(value) do
				if event.target.id == tonumber(k) then
					storyOptions.params.level = value[k]
					storyOptions.params.levelID = tonumber(key)
				end
			end
		end	

		
		--if require("loadsave").loadTable("temp")==nil then storyOptions.params.replay = nil else storyOptions.params.replay = "temp" end
		print(storyOptions.params.replay)

		require("score")
		--print(selectReplay(storyOptions.params.levelID,nil))
		 local replayContent=selectReplay(storyOptions.params.levelID)
		if replayContent== nil then 
			storyOptions.params.replay = nil 
		else
			storyOptions.params.replay = "score.json"
			storyOptions.params.replayContent =selectReplay(storyOptions.params.levelID)
		end
		print("replay value",storyOptions.params.replay)
		print(storyOptions.params.levelID)
	

		print("level being passed is: "..storyOptions.params.level)
		storyboard.gotoScene( "game", storyOptions)
		--t.text = "id = " .. event.target.id .. ", phase = " .. event.phase
	 
	end

-- Called immediately after scene has moved onscreen:
--[[function scene:enterScene( event )
	local group = self.view

end]]


function scene:willEnterScene( event )

	local group = self.view

	-- display a background image
	local background = display.newImageRect( "images/ninjaHome.jpg", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0

	local propertiesFilePath = "properties.json"
	local readPropsTable = readJson(propertiesFilePath)
	
	local musicEnabled

	if readPropsTable.music == "yes" then
		musicEnabled = true
	else
		musicEnabled = false
	end

	if musicEnabled then
		media.stopSound()
		media.playSound( "audio/ninja-game-music.mp3", true ) -- Plays the background music in a loop
	else
		media.stopSound()
	end  

	local text = display.newText( "Select Level", 0, 0, default, 50 )
	text.x, text.y = display.contentCenterX, 70

	backButton = widget.newButton{
		default = "images/left_2.png",
		over = "images/left_2.png",
		onRelease = onBackBtnRelease,
		labelColor = { default={255}, over={128} },
		id = "back",
		--label = "Go Back",
		fontSize = 16,
		--width=150, height=45,
	}

	backButton.x=55; backButton.y=540

	group:insert(background)
	group:insert(text)
	group:insert(backButton)

	local current
	local levels = {}
	--local temp = 0
	for i=0,3 do
		for j=1,5 do
			current = (i*5) + j
			--[[levels[current] = widget.newButton{
												label = current,
												id = current,
												default = "images/circle-icon.png",
												over = "images/circle-icon.png",
												onRelease = buttonHandler,
												emboss = true
												--width=64, height=64
												}
			levels[current].x = 170 + (j*100)
			levels[current].y = 180 + (i*100)]]
			local levelSelectorFilePath = "levelOptions.json"
			local readTable = readJson(levelSelectorFilePath)
			for key, value in pairs(readTable) do
				for k, v in pairs(value) do
					if current == tonumber(k) then
						if value.lock == "no" then
							--print("34242342342342342343242332")
							levels[current] = widget.newButton{
												label = current,
												id = current,
												default = "images/Ninja-icon.png",
												over = "images/Ninja-icon.png",
												onRelease = buttonHandler,
												labelColor = { default = { 255, 255, 255}}
												--emboss = true
												--width=64, height=64
												}
							levels[current].x = 170 + (j*100)
							levels[current].y = 180 + (i*100)
							--levels[current].isVisible = true
							--levels[current].isActive = true
							--print("button is---------------------", levels[value[k]])
						else
							--print("3424234234234234234324233asdsdssdasdsd2")
							levels[current] = widget.newButton{
												--label = current,
												id = current,
												default = "images/lockIcon64x64.png",
												over = "images/lockIcon64x64.png",
												--onRelease = buttonHandler,
												emboss = true
												--width=64, height=64
												}
							levels[current].x = 170 + (j*100)
							levels[current].y = 180 + (i*100)
							--levels[current].isVisible = false
							--levels[current].isActive = false
							--levels[current].label = 'kkks'
						end
					end
				end
			end	
			--levels[current].isActive = false
			--print("button is---------------------", levels[current])
			group:insert(levels[current])
		end
	end



	

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	storyboard.purgeScene(scene)
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	--print("in here!!!")
	if  button3 then
		button3:removeSelf()	-- widgets must be manually removed
		button3 = nil
	end
end

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "willEnterScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
--scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------


return scene