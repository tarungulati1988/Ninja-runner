require("jsonReadWrite")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local json = require("json")
local M = require("loadsave")

fileName = "score.json"



local widget = require( "widget" )
local button



local function exitHighscore()
	Runtime:removeEventListener("tap",exitHighscore)
	storyboard.gotoScene( "menu")
	return true	
end
	

-- Called immediately after scene has moved onscreen:
function scene:willEnterScene( event )
	local group = self.view
	Runtime:addEventListener("tap",exitHighscore)
end


function scene:enterScene( event )

	local group = self.view
	local scoreFontSize = 25
	local scoreFontName = "Ninja Naruto"

	local scoreOriginX = 530
	local scoreOriginY = 90

	
	display.setDefault("textColor",216,207,82)

	-- display a background image
	local background = display.newImageRect( "images/highscore.jpg", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0


	-- the below code serially displays the highscores
	-- without checking for which level it is printing
	-- this is based on the assumption that you can 
	-- play the next level only when you have played all
	-- previous level. 
	-- also assuming that level scores are written serially
	-- in the score.json file

	
	
	t = nil
	t = M.loadTable(fileName)
	local step = 0
	local i=0


	scoreText = {}
	if t then 
		for k,v in pairs(t["scoredata"]) do
			i=i+1
			scoreText[i] = display.newText( v["highscore"], scoreOriginX, scoreOriginY+step, scoreFontName, scoreFontSize)			
			step = step+60
		
		end
	end
		

	local highscoreText= {}

	highscoreText.highscore = display.newText( "High Scores", 120, 50, "Ninja Naruto", 30 )
	highscoreText[1] = display.newText( "level 1", 360, 90, "Ninja Naruto", 25 )
	highscoreText[2] = display.newText( "level 2", 360, 150, "Ninja Naruto", 25 )
	highscoreText[3] = display.newText( "level 3", 360, 210, "Ninja Naruto", 25 )
	highscoreText[4] = display.newText( "level 4", 360, 270, "Ninja Naruto", 25 )


	highscoreText.totalscore = display.newText( "Total Score", 330, 390, "Ninja Naruto", 25 )
	
	
	group:insert(background)

	group:insert(highscoreText.highscore)
	group:insert(highscoreText.totalscore)

	for i in ipairs(highscoreText) do
		group:insert(highscoreText[i])
	end

	for i in ipairs(scoreText) do
		group:insert(scoreText[i])
	end

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	storyboard:purgeScene(scene)
	
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	storyboard:purgeScene(scene)

	
end

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "willEnterScene", scene )

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