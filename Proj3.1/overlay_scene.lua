----------------------------------------------------------------------------------
--[[

        This file will be used to create all kinds of overlay scenes whenever the user needs to make a special choice.

        (Currently used for displaying the pause menu)

        -- Possibly advertisements??
        -- Alerts!
]]
----------------------------------------------------------------------------------
   
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
 local widget = require ("widget")


require("jsonReadWrite")

local shadedRect
local restartLevelBtn
local levelSelectBtn
local resumeGameBtn
local nextLevelBtn
local currLevel
local numberOfSheets
local inTransition = false
local count = 1     
local avatarType = "ninja-sheet"
local pageScroll = {}

--[[

    This function checks the application folder to look for a file based on the filename passed.

    Returns True if it exists and false if it doesn't
]]
local function fileExists (fileName)
    assert(fileName, "fileName is missing")
    local base = base --or system.ResourceDirectory
    local filePath = system.pathForFile( fileName, base )
    local exists = false

     if (filePath) then -- file may exist. won't know until you open it
        local fileHandle = io.open( filePath, "r" )
        if (fileHandle) then -- nil if no file found
          exists = true
          io.close(fileHandle)
        end
     end

     return (exists)
end

 local function onSelect (event)

    storyboard.hideOverlay()

    --[[
        Code to save selected avatar to file HERE !!

    ]]
    if inTransition == false then
    
    local writeTable = {}
    local file = ""..avatarType..count..".png"
    local filepath = "properties.json"
    writeTable.avatar = file
    writeJson(writeTable, filepath)

    print("count -----------+","images/"..avatarType..count..".png" )
    
    end

 end 


--[[

    The functions onPrevRelease and onNextRelease transition the choice of avatars on and off the screen.
]]
local unlockTransition = function( obj )
        
        obj.selected = true
        inTransition = false
end

 local function onPrevRelease()
--  

    if inTransition == false then
        if count > 1 then
        inTransition = true
        count = count - 1
        for i = 1, numberOfSheets , 1 do
            
            transition.to( pageScroll[i], { time=500, x=(pageScroll[i].x + 350), y= pageScroll[i].y, onComplete = unlockTransition } )

            end
     end
 end
    return true -- indicates successful touch
end

local function onNextRelease()
--  

     if inTransition == false then
        if count < numberOfSheets then
        inTransition = true
        count = count + 1
        for i = 1, numberOfSheets , 1 do
            
            transition.to( pageScroll[i], { time=500, x=(pageScroll[i].x - 350), y= pageScroll[i].y, onComplete = unlockTransition } )

            end
    end
end
    return true -- indicates successful touch
end


--[[

        The selectionHandler decides which screen to move on to based on the id of the button pressed
]]
function selectionHandler(event)
  
    local storyOptions =
        {
            effect = "crossFade",
            time = 500,
            params = { level = currLevel,selection = ""}
        }

    if event.target.id == "resumeGameBtn" then
        storyboard.hideOverlay()
        pauseButton.isActive = true
        pauseButton.isVisible = true
        Runtime:addEventListener("tap", start)


    elseif event.target.id == "restartLevelBtn" then
   
        storyboard.hideOverlay()
        storyboard.gotoScene("loadingScreen", storyOptions)


    elseif event.target.id == "levelSelectBtn" then
      
        storyboard.hideOverlay()
        storyboard.gotoScene( "levelSelect", storyOptions)

    elseif event.target.id == "replayLevelBtn" then
        storyOptions.params.selection = "replay"
        storyboard.hideOverlay()
        storyboard.gotoScene("loadingScreen", storyOptions)
        
    elseif event.target.id == "nextlevelBtn" then
       
        storyOptions.params.selection = "next"
        storyboard.hideOverlay()
        storyboard.gotoScene("loadingScreen", storyOptions)   
    end

end


function backBtnListener()
    
        -- go to menu1.lua scene

        storyboard.gotoScene( "menu")
        
        return true -- indicates successful touch
end

function sfxVolumeBtnListener()
    
        sfxVolumeBtn:removeSelf()
        local propertiesFilePath = "properties.json"
        local readPropsTable = readJson(propertiesFilePath)
        if readPropsTable.sfx == "yes" then
            readPropsTable.sfx = "no"
            writeJson(readPropsTable, propertiesFilePath)
            sfxVolumeBtn = widget.newButton{
                                            --label="Back",
                                            default="images/buttons/cross.png",
                                            over="images/buttons/cross.png",
                                            --width=120, height=120,
                                            onPress = sfxVolumeBtnListener   -- event listener function
                                            }
        else
            readPropsTable.sfx = "yes"
            writeJson(readPropsTable, propertiesFilePath)
            sfxVolumeBtn = widget.newButton{
                                            --label="Back",
                                            default="images/buttons/ok.png",
                                            over="images/buttons/ok.png",
                                            --width=120, height=120,
                                            onPress = sfxVolumeBtnListener   -- event listener function
                                            }
        end

        sfxVolumeBtn.x = 355
        sfxVolumeBtn.y = 420

        return true -- indicates successful touch
end

function musicBtnListener()
    
        musicBtn:removeSelf()
        local propertiesFilePath = "properties.json"
        local readPropsTable = readJson(propertiesFilePath)
        if readPropsTable.music == "yes" then
            readPropsTable.music = "no"
            writeJson(readPropsTable, propertiesFilePath)

            musicBtn = widget.newButton{
                                                --label="Back",
                                                default="images/buttons/cross.png",
                                                over="images/buttons/cross.png",
                                                --width=120, height=120,
                                                onPress = musicBtnListener   -- event listener function
                                        }
        else
            readPropsTable.music = "yes"
            writeJson(readPropsTable, propertiesFilePath)
            musicBtn = widget.newButton{
                                                --label="Back",
                                                default="images/buttons/ok.png",
                                                over="images/buttons/ok.png",
                                                --width=120, height=120,
                                                onPress = musicBtnListener   -- event listener function
                                        }
        end

        musicBtn.x = 355
        musicBtn.y = 320

        return true -- indicates successful touch
end


function selfGhostPlayBtnListener()
    
        selfGhostPlayBtn:removeSelf()
        local propertiesFilePath = "properties.json"
        local readPropsTable = readJson(propertiesFilePath)
        if readPropsTable.selfGhostPlay == "yes" then
            readPropsTable.selfGhostPlay = "no"
            writeJson(readPropsTable, propertiesFilePath)
            selfGhostPlayBtn = widget.newButton{
                                                --label="Back",
                                                default="images/buttons/cross.png",
                                                over="images/buttons/cross.png",
                                                --width=120, height=120,
                                                onPress = selfGhostPlayBtnListener   -- event listener function
                                                }
        else
            readPropsTable.selfGhostPlay = "yes"
            writeJson(readPropsTable, propertiesFilePath)
            selfGhostPlayBtn = widget.newButton{
                                                --label="Back",
                                                default="images/buttons/ok.png",
                                                over="images/buttons/ok.png",
                                                --width=120, height=120,
                                                onPress = selfGhostPlayBtnListener   -- event listener function
                                                }
        end

        selfGhostPlayBtn.x = 355
        selfGhostPlayBtn.y = 220

        return true -- indicates successful touch
end


function scene:enterScene( event )
        local group = self.view

        local params = event.params
        print("the current level is ", params.level)
        currLevel = params.level
        shadedRect = display.newRect(0,0,960,640)
        shadedRect:setFillColor(0,0,0,255)
        shadedRect.alpha = 0.25

        if params.level == "settings" then
            --print("current level is: ----------", currLevel)
            --print("something old!! something new!! something from the jurassic period...wrathchildddd!!!!!")

            shadedRect.alpha = 0.95

            local propertiesFilePath = "properties.json"
            local readPropsTable = readJson(propertiesFilePath)
            --print("------------------------------read properties table:  ", readPropsTable.music)

            settingsText = display.newText( "Settings", 0, 0, default, 50 )
            settingsText.x, settingsText.y = display.contentCenterX, 70

            selfGhostPlayText = display.newText( "Ghost Play", 0, 0, default, 40 )
            selfGhostPlayText.x = 150
            selfGhostPlayText.y = 220

            if readPropsTable.selfGhostPlay == "yes" then
                selfGhostPlayBtn = widget.newButton{
                                                --label="Back",
                                                default="images/buttons/ok.png",
                                                over="images/buttons/ok.png",
                                                --width=120, height=120,
                                                onPress = selfGhostPlayBtnListener   -- event listener function
                                                }
            else
                selfGhostPlayBtn = widget.newButton{
                                                --label="Back",
                                                default="images/buttons/cross.png",
                                                over="images/buttons/cross.png",
                                                --width=120, height=120,
                                                onPress = selfGhostPlayBtnListener   -- event listener function
                                                }
            end

            selfGhostPlayBtn.x = 355
            selfGhostPlayBtn.y = 220

            musicText = display.newText( "Music", 0, 0, default, 40 )
            musicText.x = 110
            musicText.y = 320

            if readPropsTable.music == "yes" then
                musicBtn = widget.newButton{
                                                --label="Back",
                                                default="images/buttons/ok.png",
                                                over="images/buttons/ok.png",
                                                --width=120, height=120,
                                                onPress = musicBtnListener   -- event listener function
                                                }
            else
                musicBtn = widget.newButton{
                                                --label="Back",
                                                default="images/buttons/cross.png",
                                                over="images/buttons/cross.png",
                                                --width=120, height=120,
                                                onPress = musicBtnListener   -- event listener function
                                                }
            end

            musicBtn.x = 355
            musicBtn.y = 320

            sfxVolumeText = display.newText( "SFX Volume", 0, 0, default, 40 )
            sfxVolumeText.x = 170
            sfxVolumeText.y = 420

            if readPropsTable.sfx == "yes" then
                sfxVolumeBtn = widget.newButton{
                                                --label="Back",
                                                default="images/buttons/ok.png",
                                                over="images/buttons/ok.png",
                                                --width=120, height=120,
                                                onPress = sfxVolumeBtnListener   -- event listener function
                                                }
            else
                sfxVolumeBtn = widget.newButton{
                                                --label="Back",
                                                default="images/buttons/cross.png",
                                                over="images/buttons/cross.png",
                                                --width=120, height=120,
                                                onPress = sfxVolumeBtnListener   -- event listener function
                                                }
            end

            sfxVolumeBtn.x = 355
            sfxVolumeBtn.y = 420
            --back button-----


            backBtn = widget.newButton{
                                            --label="Back",
                                            default="images/left_2.png",
                                            over="images/left_2.png",
                                            --width=120, height=120,
                                            onPress = backBtnListener   -- event listener function
                                            }

            backBtn.x = 55
            backBtn.y = 540
            


        elseif params.level == "Avatar" then  

            --[[  This condition will bring on the Avatar selection screen as the overlay ]]

        ---------------------------------------------------------------------------------

            shadedRect.alpha = 0.95
            


            local sequenceData = {name = "runright", start = 2, count = 3, loopDirection = "bounce", time = 400, loopCount = 0}

            
            numberOfSheets = 0

            for i = 1, 10, 1 do
                    if fileExists ("images/"..avatarType..i..".png") then 
                        

                        imageSheet= graphics.newImageSheet("images/"..avatarType..i..".png", {width = 64, height = 64, numFrames = 20})
                        pageScroll[i] = display.newSprite( imageSheet, sequenceData )
                        pageScroll[i]:scale(2,2)
                        pageScroll[i].x = display.contentWidth/2 + i*350 - 350
                        pageScroll[i].y = display.contentHeight/2

                        pageScroll[i]:play()
                        numberOfSheets = numberOfSheets + 1
                    end
            end


            selectButton = widget.newButton{
                    default="images/button.png",
                    over="images/button-over.png",
                    labelColor = { default={255}, over={128} },
                    id = "Select",
                    label = "Select",
                    fontSize = 16,
                    width=308, height=80,
                    onPress = onSelect    -- event listener function
                }
            selectButton.y = display.contentHeight - 125
            selectButton.x = display.contentWidth*0.5
         
            rightSword = widget.newButton{
                default = "images/right.png",
                onPress = onNextRelease,
                labelColor = { default={255}, over={128} },
                id = "next",
                fontSize = 40,
                width=220, height=120
            }   
            rightSword.x = display.contentWidth/2 + 250
            rightSword.y = 300

            leftSword = widget.newButton{
                default = "images/left.png",
                onPress = onPrevRelease,
                labelColor = { default={255}, over={128} },
                id = "prev",
                fontSize = 40,
                width=220, height=120,
            }   
            leftSword.x= display.contentWidth/2 - 250
            leftSword.y = 300
        ------------------------------------------------------------------------------------------
            else 
                

                if params.overlayType == "paused" then


                    pauseBackground = display.newImageRect( "images/pauseStrip.png", display.contentWidth, 200 )
                    pauseBackground.x = 475
                    pauseBackground.y = 325

                    resumeGameBtn = widget.newButton{
                                                            default = "images/buttons/btnResume.png",
                                                            --over = "images/nextlevelbtn@2x.png",
                                                            onPress = selectionHandler,
                                                            id = "resumeGameBtn",

                                                            }
                    resumeGameBtn.x = 450; resumeGameBtn.y = 360        
                    resumeGameBtn.isActive = true
                    resumeGameBtn.isVisible = true
					
					
                    restartLevelBtn = widget.newButton{
                                                        default = "images/buttons/btnRestart.png",
                                                        --over = "images/restartbtn@2x.png",
                                                        onPress = selectionHandler,
                                                        id = "restartLevelBtn",
                                                        lvl = params.level
                                                        }

                elseif params.overlayType == "youwin" then

                    pauseBackground = display.newImageRect( "images/winStrip.png", display.contentWidth, 200 )
                    pauseBackground.x = 475
                    pauseBackground.y = 325

                    local levelSelectorFilePath = "levelOptions.json"
                    local readTable = readJson(levelSelectorFilePath)
                    local tempKey
                    for key, value in pairs(readTable) do
                        for k, v in pairs(value) do
                            if params.level == v then
                                tempKey = tonumber(k) + 1
                                break

                            end
                           
                        end
                         
                    end
                    if readTable[tostring(tempKey)].lock == "yes" then
                        readTable[tostring(tempKey)].lock = "no"
                    end
                    writeJson(readTable, levelSelectorFilePath)


                    nextlevelBtn = widget.newButton{
                                                            default = "images/buttons/btnNext.png",
                                                           -- over = "images/nextlevelbtn@2x.png",
                                                            onPress = selectionHandler,
                                                            id = "nextlevelBtn",

                                                            }
                    nextlevelBtn.x = 450; nextlevelBtn.y = 360        
                    nextlevelBtn.isActive = true
                    nextlevelBtn.isVisible = true

                    restartLevelBtn = widget.newButton{
                                                        default = "images/buttons/btnReplay.png",
                                                        over = "images/buttons/btnReplay.png",
                                                        onPress = selectionHandler,
                                                        id = "replayLevelBtn",
                                                        lvl = params.level
                                                        }
                elseif params.overlayType == "youlose" then

                    pauseBackground = display.newImageRect( "images/loseStrip.png", display.contentWidth, 200 )
                    pauseBackground.x = 475
                    pauseBackground.y = 325

                    local levelSelectorFilePath = "levelOptions.json"
                    local readTable = readJson(levelSelectorFilePath)
                    local tempKey
                    for key, value in pairs(readTable) do
                        for k, v in pairs(value) do
                            if params.level == v then
                                tempKey = tonumber(k) + 1
                                break

                            end
                           
                        end
                         
                    end
                  
                    if readTable[tostring(tempKey)].lock == "yes" then
                        readTable[tostring(tempKey)].lock = "no"
                    end
                    writeJson(readTable, levelSelectorFilePath)


                  --[[  nextlevelBtn = widget.newButton{
                                                            default = "images/buttons/btnNext.png",
                                                           -- over = "images/nextlevelbtn@2x.png",
                                                            onPress = selectionHandler,
                                                            id = "nextlevelBtn",

                                                            }
                    nextlevelBtn.x = 450; nextlevelBtn.y = 360        
                    nextlevelBtn.isActive = true
                    nextlevelBtn.isVisible = true
]]
                    restartLevelBtn = widget.newButton{
                                                        default = "images/buttons/btnRestart.png",
                                                        over = "images/buttons/btnRestart.png",
                                                        onPress = selectionHandler,
                                                        id = "restartLevelBtn",
                                                        lvl = params.level
                                                        }
                
                end

                restartLevelBtn.x = 650; restartLevelBtn.y = 360        
                restartLevelBtn.isActive = true
                restartLevelBtn.isVisible = true

                levelSelectBtn = widget.newButton{
                                                    default = "images/buttons/btnLevel.png",
                                                    --over = "images/menubtn@2x.png",
                                                    onPress = selectionHandler,
                                                    id = "levelSelectBtn",
                                                    }
                        
                levelSelectBtn.x = 250; levelSelectBtn.y = 360        
                levelSelectBtn.isActive = true
                levelSelectBtn.isVisible = true

                pauseButton.isActive = false
                pauseButton.isVisible = false


        end

end
 
-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
        local group = self.view

end

 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
      
        if currLevel == "settings" then
            --print("in here too--------------##########################")
            settingsText:removeSelf()
            settingsText = nil
            selfGhostPlayText:removeSelf()
            selfGhostPlayText = nil
            selfGhostPlayBtn:removeSelf()
            selfGhostPlayBtn = nil
            musicText:removeSelf()
            musicText = nil
            musicBtn:removeSelf()
            musicBtn = nil
            sfxVolumeText:removeSelf()
            sfxVolumeText = nil
            sfxVolumeBtn:removeSelf()
            sfxVolumeBtn = nil
            backBtn:removeSelf()
            backBtn = nil
      
        elseif currLevel == "Avatar" then
                rightSword:removeSelf()
                rightSword = nil
                leftSword:removeSelf()
                leftSword = nil
                selectButton:removeSelf()
                selectButton = nil
                pageScroll[1]:removeSelf()
                pageScroll[1] = nil
                pageScroll[2]:removeSelf()
                pageScroll[2] = nil
                
        else
				if(pauseBackground~= nil) then
					pauseBackground:removeSelf()
				end
                pauseBackground = nil
                if resumeGameBtn then
                    resumeGameBtn:removeSelf()
                    resumeGameBtn = nil
                elseif nextlevelBtn then
                    nextlevelBtn:removeSelf()
                    nextlevelBtn = nil
                end
				if (restartLevelBtn ~= nil) then
					restartLevelBtn:removeSelf()
				end
                restartLevelBtn = nil
				if (levelSelectBtn ~= nil) then
					levelSelectBtn:removeSelf()
				end
                levelSelectBtn = nil
                
        end
				if(shadedRect ~= nil) then
					shadedRect:removeSelf()
				end
                shadedRect = nil
                storyboard.purgeScene(scene)

end
 
-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
        local group = self.view
end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view
  
end
 
-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
        local group = self.view
        local overlay_scene = event.sceneName  -- overlay scene name
  
end
 
-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
        local group = self.view
        local overlay_scene = event.sceneName  -- overlay scene name
        
end
 
 
 
 
-- "createScene" event is dispatched if scene's view does not exist
-- scene:addEventListener( "createScene", scene )
 
-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )
 
-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )
 
-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )
 
-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )
 
-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )
 
-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )
 
-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )
 
---------------------------------------------------------------------------------
 
return scene