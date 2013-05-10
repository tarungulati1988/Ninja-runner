-- include the Corona "storyboard" module
 
local widget = require ("widget")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()


require("jsonReadWrite")
local filepath = "properties.json"
local temp 
local avatar

-- 3.0.1.11, rename move to move_focus, and put ghost:move outside the move engine into the mainLoop
--	Add a replay control variable.
local isReplay

local time
local currLevel
--	V2.4.3
--	variable for replay and ghost player
--	will be initialized in init by loading a replay file
--	will be called in move engine for the movement display (will perform a generalMove, because the player is always centralized)
--	will be called in collision engine for the collisions (will perform the same as player's collision)
--	will be called in mainLoop for possible actions
local ghost
local isEnd = false
--	V2.4.3
--	actionList for replay use
--	the actionList will be the list of time=action pairs
--	will be used in tab function for record
--	will be used in mainLoop to save the replay file
local file
--	v2.4.3
--	the replayFile is the table read from the replay file
--	will be used in mainLoop to load the actions
--	will be used in init to generate the ghost
local replayFile
local needToSave
local screen
-- doneDying will be used to detect that the effect on death is completed
local doneDying 
-- startTime will keep track of the timer in game
local startTime
local jumpSound

--jumpSound = audio.loadSound("audio/ninja-jump.wav") --Loads sound for jump sequence
--backgroundMusic = audio.loadStream("audio/ninja-game-music2.mp3")

--audio.play(backgroundMusic,{loops = -1})


local player
local livings
local iv
local sheet
local isBegin
local background
local touchstart
local ghostTouchStart


--	v3.2 : rewind
--	CAUTION: this version of rewind does not handle object! That is to say, this is a pure movement rewind
--	CAUTION: ghost is not taken care of
--	Spelling it right NOW!
local inRewind		--	used in mainLoop to distinguish normal game & rewind
local rewindCount	-- for slowing down when rewinding
local rewindTime = 1000 --	counted by times in mainLoop
local availRewindTime = 1000
local rewindTable	--	a table saving information for rewind functionality
local rewindStart
local rewindShadow1, rewindShadow2, rewindShadowCount


function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end



function abs1(v)
	local result
	if v==0 then result = 0 else result= v/math.abs(v)end
	return result
end

function makeObj(i,j,screen,collideFunc)
	local obj ={}
	obj.x = (j)*tileWidth
	obj.y = (i)*tileHeight
	obj.image ={}
	obj.image.x = obj.x - (screen.offsetX+1)*tileWidth -screen.offsetPx
	obj.image.y = obj.y - (screen.offsetY+1)*tileHeight - screen.offsetPy
	obj.collide = collideFunc
	return obj
end

----------------------------------------------------------------------------
-- for move_focus


-- checks if the player is out of screen
function player_outofbounds(player,screen)
	if(player.image.x < 0 
		or player.image.x > screen.screenWidth*tileWidth 
		or player.image.y < 0 
		or player.image.y > screen.screenHeight*tileHeight) then 
		return true
	else
		return false	
	end
end

-- check horizontal movement of player
function isPlayer_moving_horizontally(player,screen)
	if ((screen.focusX-player.image.x)*player.directionX > 0 )   -- moving towards the center
		or (screen.offsetX*tileWidth+screen.offsetPx<=0 
			and player.directionX*player.speedX<0)              -- reaching the left edge
		or (screen.offsetX+screen.screenWidth>=mapWidth 
			and player.directionX*player.speedY>0) then
		return true
	else
		return false
	end
end

-- check vertical movement of player
function isPlayer_moving_vertically(player,screen)
	if (screen.focusY-player.image.y)*player.directionY > 0  -- moving towards the center
		or  (screen.offsetY*tileHeight+screen.offsetPy<=0 
				and player.directionY*player.speedY<0)   -- reaching the top edge
		or  (screen.offsetY+screen.screenHeight>=mapHeight 
				and player.directionY*player.speedY>0) then
		return true
	else
		return false
	end
end

----------------------------------------------------------------------------

function move_focus(player,screen)
--	movement engine
	screen.isMovingX = false
	screen.isMovingY = false
--	print(screen.offsetX,screen.offsetY,screen.offsetPx,screen.offsetPy)
--  basic logic:
--      calculate the center to decide whether is screen or the character is moving;
--          if the player is moving, call player:move(...), and iterates the livings table: for i,v in ipair(livings) do v:move(...) end
--          else update the screen, and also iterates the livings table as above

--print(player.image.x, screen.screenWidth*tileWidth,player.image.y, screen.screenHeight*tileHeight)
	if(player_outofbounds(player,screen)) then return end

	--handle the horizontal first
	if (player.directionX ~= 0 and player.speedX ~= 0) then
		--cases that the screen doesn't move
		if (isPlayer_moving_horizontally(player,screen)) then 			--reaching the right edge
			screen.isMovingX = false
		else
			-- screen is moving
			screen.isMovingX = true
			screen.offsetPx = screen.offsetPx + player.directionX * player.speedX
		
			-- caution: using if/else here (instead of while loop), assuming one adjustment only is needed
			if (screen.offsetPx >= tileWidth) then
				-- reload the screen & relocate the images   
				screen.offsetPx = screen.offsetPx - tileWidth
				screen.offsetX = screen.offsetX + 1   
				for i,v in ipairs(screen) do
					for j,vv in ipairs(v) do
						if (j == 1 and vv ~= nil and vv~=0) then
--							print("remove Px>Width",i,j,vv.image,vv.image.x, vv.image.y,vv.x,vv.y)
							screen[i][j].image:removeSelf()
							screen[i][j]=0
						end
						if (j < screen.screenWidth) then  
							screen[i][j]=screen[i][j+1]
						else      
							local temp=iv.map["tile"][i+screen.offsetY][j+screen.offsetX]
							if temp ~= nil and temp>0 then 
								local obj = {}
								obj.x = (j+screen.offsetX)*tileWidth
								obj.y = (i+screen.offsetY)*tileHeight
								obj.image = display.newSprite(sheet,iv.map["image"][temp])
								obj.image.x = (j-1)*tileWidth - screen.offsetPx
								obj.image.y = (i-1) * tileHeight - screen.offsetPy
								obj.move = generalMove
								obj.collide = generalCollide
--								print("creat obj",i,j,obj.image,obj.image.x,obj.image.y,screen.offsetX,screen.offsetY,screen.offsetPx,screen.offsetPy)
								screen[i][j] = obj
--[[
for i,v in ipairs(screen) do
	for j,vv in ipairs(v) do
		if vv~=0 and vv~=nil then
			print(i,j,vv.image.x,vv.image.y)
		end
	end
end]]
								--print(screen.offsetX,screen.offsetY,screen.offsetPx,screen.offsetPy,screen[i][j-1].y,obj.y,screen[i][j-1].image.y,obj.image.y)
							else
								screen[i][j] = 0
							end   
						end
					end
				end
			elseif (screen.offsetPx <0) and screen.offsetX>0 then
				screen.offsetPx = screen.offsetPx + tileWidth
				screen.offsetX = screen.offsetX -1
				local temp
				for i,v in ipairs(screen) do
					for j, vv in ipairs(v) do
						if (j == screen.screenWidth and vv~=nil and vv~=0) then 
--							print("remove self Px<0",i,j,vv.image)
						screen[i][j].image:removeSelf()
						screen[i][j] = 0 
						end
						if j>1 then
							local temp2 = vv
							screen[i][j] = temp
							temp = temp2
						else
							temp = screen[i][j]
							local temp2=iv.map["tile"][i+screen.offsetY][j+screen.offsetX]
							if temp2 ~= nil and  temp2>0 then
								local obj = {}
								obj.x = (j+screen.offsetX)*tileWidth
								obj.y = (i+screen.offsetY)*tileHeight
								obj.image = display.newSprite(sheet,iv.map["image"][temp2])
								obj.image.x = (j-1)*tileWidth - screen.offsetPx
								obj.image.y = (i-1) * tileHeight - screen.offsetPy
								obj.move = generalMove
								obj.collide = generalCollide
								screen[i][j] = obj
							else
								screen[i][j] = 0
							end
						end
					end
				end
			end   
			
		end
	end

	--then do the vertical
	if(player.directionY ~=0 and player.speedY ~=0) then
		--cases that the screen doesn't move
		if (isPlayer_moving_vertically(player,screen)) then 			--reaching the bottom edge
			screen.isMovingY = false
		else
			-- screen is moving
			screen.isMovingY = true
			screen.offsetPy = screen.offsetPy + player.directionY * player.speedY
			
			-- caution: using if/else here (instead of while loop), assuming one adjustment only is needed
			if (screen.offsetPy >= tileHeight) then
				-- reload the screen & relocate the images
				screen.offsetPy = screen.offsetPy - tileHeight
				screen.offsetY = screen.offsetY + 1
				for i,v in ipairs(screen) do
					for j,vv in ipairs(v) do
						if (i == 1 and vv ~= nil and vv~=0) then
	--						print("remove self Py>tileHeight",i,j,vv.image)
							screen[i][j].image:removeSelf()
							screen[i][j]=0
						end
						
						if (i < screen.screenHeight) then
							screen[i][j]=screen[i+1][j]
							--if screen[i][j]~=0 then print(screen[i][j+1].image.x,screen[i][j+1].x,screen.offsetX*tileWidth,screen.offsetPx)end
						else
							local temp=iv.map["tile"][i+screen.offsetY][j+screen.offsetX]
							if temp~= nil and temp>0 then
								local obj = {}
								obj.x = (j+screen.offsetX)*tileWidth
								obj.y = (i+screen.offsetY)*tileHeight
								obj.image = display.newSprite(sheet,iv.map["image"][temp])
								obj.image.x = (j-1)*tileWidth - screen.offsetPx
								obj.image.y = (i-1) * tileHeight - screen.offsetPy
								obj.move = generalMove
								obj.collide = generalCollide
								screen[i][j] = obj
							else
								screen[i][j] = 0
							end
						end
					end
				end
			 elseif (screen.offsetPy <0) and screen.offsetY>0 then
				screen.offsetPy = screen.offsetPy + tileHeight
				screen.offsetY = screen.offsetY -1
				for i=screen.screenHeight, 1, -1 do
					for j=1,screen.screenWidth,1 do
						local vv=screen[i][j]
						if (i == screen.screenHeight and vv~=nil and vv~=0) then
		--					print("remove self Py<0",i,j,vv.image)
							screen[i][j].image:removeSelf()
							screen[i][j]=0
						end
						if i>1 then
							screen[i][j]=screen[i-1][j]
						else
							local temp2=iv.map["tile"][i+screen.offsetY][j+screen.offsetX]
							if temp2 ~= nil and temp2>0 then
								local obj = {}
								obj.x = (j+screen.offsetX)*tileWidth
								obj.y = (i+screen.offsetY)*tileHeight
								obj.image = display.newSprite(sheet,iv.map["image"][temp2])
								obj.image.x = (j-1)*tileWidth - screen.offsetPx
								obj.image.y = (i-1) * tileHeight - screen.offsetPy
								obj.move = generalMove
								obj.collide = generalCollide
		--						print("create obj",i,j,obj.image,obj.image.x, obj.image.y)
								screen[i][j] = obj
							else
								screen[i][j] = 0
							end
						end
					end
				end
			end
		end
	end
	
	-- iterating the screen and the livings to move everythings
	player:move(player, screen)
	
	for i,v in ipairs(screen) do
		for j,vv in ipairs(v) do
			if vv ~= nil and vv ~= 0 then
				--print(screen.offsetPx,screen.offsetPy,i,j,vv.image)
				--print(i,j,vv.image,vv.image.x,vv.image.y,vv.x,vv.y)
				vv:move(player,screen)
			end
		end
	end
	
	for i,v in ipairs(livings) do
		v:move(player,screen)
	--print("in move livings", #livings, i, v.x,v.y,v.image.x,v.image.y)
	end
	

end

-----------------------------------------------------------------
-- for collide_beta
function isPlayerFalling(player,screen,n1,m1)
	if (screen[n1+1] ~= nil and 										-- 	if it's the last row, there's no way to fall
		((player.status == "run" and 									--	if the player is running,
		(screen[n1+1][m1] == nil or screen[n1+1][m1] == 0)and			--	and there's nothing beneath, or
		(math.round((player.image.x+screen.offsetPx)*100)/100 == (m1 -1) * iv.tileWidth or
		screen[n1+1][m1+abs1(player.directionX*player.speedX)]==nil or
		screen[n1+1][m1+abs1(player.directionX*player.speedX)]==0)) or
		(player.status == "stick" and									--	player is sticking and
		(screen[n1][m1+abs1(player.directionX)] == nil or 			--	there's nothing to stick
		screen[n1][m1+abs1(player.directionX)] == 0) and
		(screen[n1+1][m1+abs1(player.directionX)] == nil or 			--	there's nothing to stick
		screen[n1+1][m1+abs1(player.directionX)] == 0)))) then
		return true
	else
		return false
	end
end


function collide_beta (player)
	
	if screen == nil or player.status == "dead" or player.status == "victory" then
		print ("can't collide",screen, player.status)
		return
	end 
		
	--	WARNING: the coordinates system might have a fatal error
	--	The coordinates are calculated not start with 0 but with 64
	local m1 = math.floor(math.round((player.image.x+screen.offsetPx)*100)/100 / iv.tileWidth)+1
	local n1 = math.floor(math.round((player.image.y+screen.offsetPy)*100)/100 / iv.tileHeight)+1
	
	if (screen[n1] == nil) then print("invalid n1",n1,n1+1,iv.tileHeight,player.image.x,screen.offsetPx) return end
		
--	print(player.speedX,player.speedY)
--print("in collide",player.image.x,screen.offsetPx,player.image.y,screen.offsetPy, n1,m1,iv.map.tile[n1][m1],iv.map.tile[n1+1][m1],iv.map.tile[n1][m1+1],iv.map.tile[n1+1][m1+1],player.status)	
	--	set fall mechanism
	if (isPlayerFalling(player,screen,n1,m1)) then
		print("set fall", screen.offsetX,screen.offsetY,screen.offsetPx,screen.offsetPy,player.image.x, player.image.y,player.status,n1,m1)
		player.directionY = 1
		player.status = "fall"
	--	player.speedX = player.speedX / 2
		player.speedY = 0
		--	reset player's sprite
		local ix,iy = player.image.x,player.image.y
		player.image:removeSelf()
		local d
		if abs1(player.directionX)>=0 then d="right" else d="left" end
		player.image = display.newSprite(player.imageSheet, player.sequenceData["jump" .. d])
		player.image.x,player.image.y = ix,iy
		player.image:play()
		print(player.image,player.image.x,player.image.y)
		player.currentSprite = "jump"..d
	end
	
	--	CAUSION:
	--	noting that each collision may change the player's position, i.e. the n1 and m1 may not accurate now.
	--	therefore, if we keep using the old n1 and m1, we might collide with the wrong tiles.
	
	--	CAUSION:
	--	generalCollide does not check speed. 
	--	That is to say, if player is overlapping at the left side and is running left, the generalCollide will stil change the player's speed
	--	That being said, we need to check carefully to aviod a same tile to be collided twice.
	
	--	relying on the generalCollide will do isColliding/isOverlapping check
	--	the engine just need to call the collide function without checking
	--	noting that we need to build a mock object inorder to call generalCollide
	
	for i=-1,2 do
		for j=-1,2 do
			if screen[n1+i] ~= nil and screen[n1+i][m1+j] ~= nil and screen[n1+i][m1+j] ~= 0 then
--print(n1+i,m1+j)
				screen[n1+i][m1+j]:collide(player,screen)
			end
		end
	end
	
	for i,v in ipairs(livings) do
		if (v.isVisible or true) then
--	print("livings",i,v)
			v:collide(player,screen)
		end
	end

end

--	v3.2 : rewind
--	this function will be called in normal game in order to record necessary information for rewind
function writeRewind()
	--	rewindTable should not be nil
	if rewindTable then
		local n = math.mod(time, rewindTime)
		if rewindTable[n+1] == nil then
			rewindTable[n+1] = {}
		end
		rewindTable[n+1].x = player.x
		rewindTable[n+1].y = player.y
		rewindTable[n+1].offsetX = screen.offsetX * iv.tileWidth + screen.offsetPx
		rewindTable[n+1].offsetY = screen.offsetY * iv.tileHeight + screen.offsetPy
		rewindTable[n+1].speedX = player.speedX
		rewindTable[n+1].speedY = player.speedY
		rewindTable[n+1].directionX = player.directionX
		rewindTable[n+1].directionY = player.directionY
		rewindTable[n+1].status = player.status
		rewindTable[n+1].currentSprite = player.currentSprite
	else
		print("weird, rewindTable is nil")
	end
end


--	v3.2 : rewind
--	exact same parts in move_focus
function relocate_screen(player,screen)
-- caution: using if/else here (instead of while loop), assuming one adjustment only is needed
	if (screen.offsetPx >= tileWidth) then
		-- reload the screen & relocate the images   
--print("-----------------------------------screen.offsetPx >= tileWidth")
		screen.offsetPx = screen.offsetPx - tileWidth
		screen.offsetX = screen.offsetX + 1   
		for i,v in ipairs(screen) do
			for j,vv in ipairs(v) do
				if (j == 1 and vv ~= nil and vv~=0) then
--							print("remove Px>Width",i,j,vv.image,vv.image.x, vv.image.y,vv.x,vv.y)
					screen[i][j].image:removeSelf()
					screen[i][j]=0
				end
				if (j < screen.screenWidth) then  
					screen[i][j]=screen[i][j+1]
				else      
					local temp=iv.map["tile"][i+screen.offsetY][j+screen.offsetX]
					if temp ~= nil and temp>0 then 
						local obj = {}
						obj.x = (j+screen.offsetX)*tileWidth
						obj.y = (i+screen.offsetY)*tileHeight
						obj.image = display.newSprite(sheet,iv.map["image"][temp])
						obj.image.x = (j-1)*tileWidth - screen.offsetPx
						obj.image.y = (i-1) * tileHeight - screen.offsetPy
						obj.move = generalMove
						obj.collide = generalCollide
--								print("creat obj",i,j,obj.image,obj.image.x,obj.image.y,screen.offsetX,screen.offsetY,screen.offsetPx,screen.offsetPy)
						screen[i][j] = obj
--[[
for i,v in ipairs(screen) do
for j,vv in ipairs(v) do
if vv~=0 and vv~=nil then
	print(i,j,vv.image.x,vv.image.y)
end
end
end]]
						--print(screen.offsetX,screen.offsetY,screen.offsetPx,screen.offsetPy,screen[i][j-1].y,obj.y,screen[i][j-1].image.y,obj.image.y)
					else
						screen[i][j] = 0
					end   
				end
			end
		end
	elseif (screen.offsetPx <0) and screen.offsetX>0 then
--print("-----------------------------------(screen.offsetPx <0) and screen.offsetX>0")
		screen.offsetPx = screen.offsetPx + tileWidth
		screen.offsetX = screen.offsetX -1
		local temp
		for i,v in ipairs(screen) do
			for j, vv in ipairs(v) do
				if (j == screen.screenWidth and vv~=nil and vv~=0) then 
--							print("remove self Px<0",i,j,vv.image)
				screen[i][j].image:removeSelf()
				screen[i][j] = 0 
				end
				if j>1 then
					local temp2 = vv
					screen[i][j] = temp
					temp = temp2
				else
					temp = screen[i][j]
					local temp2=iv.map["tile"][i+screen.offsetY][j+screen.offsetX]
					if temp2 ~= nil and  temp2>0 then
						local obj = {}
						obj.x = (j+screen.offsetX)*tileWidth
						obj.y = (i+screen.offsetY)*tileHeight
						obj.image = display.newSprite(sheet,iv.map["image"][temp2])
						obj.image.x = (j-1)*tileWidth - screen.offsetPx
						obj.image.y = (i-1) * tileHeight - screen.offsetPy
						obj.move = generalMove
						obj.collide = generalCollide
--								print("creat obj",i,j,obj.image,obj.image.x,obj.image.y,screen.offsetX,screen.offsetY,screen.offsetPx,screen.offsetPy)
						screen[i][j] = obj
						--[[
for i,v in ipairs(screen) do
for j,vv in ipairs(v) do
if vv~=0 and vv~=nil then
	print(i,j,vv.image.x,vv.image.y)
end
end
end]]
					else
						screen[i][j] = 0
					end
				end
			end
		end
	end   
	
-- caution: using if/else here (instead of while loop), assuming one adjustment only is needed
	if (screen.offsetPy >= tileHeight) then
--print("-----------------------------------(screen.offsetPy >= tileHeight)")
		-- reload the screen & relocate the images
		screen.offsetPy = screen.offsetPy - tileHeight
		screen.offsetY = screen.offsetY + 1
		for i,v in ipairs(screen) do
			for j,vv in ipairs(v) do
				if (i == 1 and vv ~= nil and vv~=0) then
--						print("remove self Py>tileHeight",i,j,vv.image)
					screen[i][j].image:removeSelf()
					screen[i][j]=0
				end
				
				if (i < screen.screenHeight) then
					screen[i][j]=screen[i+1][j]
					--if screen[i][j]~=0 then print(screen[i][j+1].image.x,screen[i][j+1].x,screen.offsetX*tileWidth,screen.offsetPx)end
				else
					local temp=iv.map["tile"][i+screen.offsetY][j+screen.offsetX]
					if temp~= nil and temp>0 then
						local obj = {}
						obj.x = (j+screen.offsetX)*tileWidth
						obj.y = (i+screen.offsetY)*tileHeight
						obj.image = display.newSprite(sheet,iv.map["image"][temp])
						obj.image.x = (j-1)*tileWidth - screen.offsetPx
						obj.image.y = (i-1) * tileHeight - screen.offsetPy
						obj.move = generalMove
						obj.collide = generalCollide
						screen[i][j] = obj
					else
						screen[i][j] = 0
					end
				end
			end
		end
	 elseif (screen.offsetPy <0) and screen.offsetY>0 then
--print("-----------------------------------(screen.offsetPy <0) and screen.offsetY>0")
		screen.offsetPy = screen.offsetPy + tileHeight
		screen.offsetY = screen.offsetY -1
		for i=screen.screenHeight, 1, -1 do
			for j=1,screen.screenWidth,1 do
				local vv=screen[i][j]
				if (i == screen.screenHeight and vv~=nil and vv~=0) then
--					print("remove self Py<0",i,j,vv.image)
					screen[i][j].image:removeSelf()
					screen[i][j]=0
				end
				if i>1 then
					screen[i][j]=screen[i-1][j]
				else
					local temp2=iv.map["tile"][i+screen.offsetY][j+screen.offsetX]
					if temp2 ~= nil and temp2>0 then
						local obj = {}
						obj.x = (j+screen.offsetX)*tileWidth
						obj.y = (i+screen.offsetY)*tileHeight
						obj.image = display.newSprite(sheet,iv.map["image"][temp2])
						obj.image.x = (j-1)*tileWidth - screen.offsetPx
						obj.image.y = (i-1) * tileHeight - screen.offsetPy
						obj.move = generalMove
						obj.collide = generalCollide
--						print("create obj",i,j,obj.image,obj.image.x, obj.image.y)
						screen[i][j] = obj
					else
						screen[i][j] = 0
					end
				end
			end
		end
	end
end


--	v3.2 : rewind
--	this function will read information in rewindTable, and try to reappear the scenario
function readRewind()
	time = time - 1
	availRewindTime = availRewindTime - 1
	local n = math.mod(time, rewindTime) + 1
	local n1 = math.mod(time+3, rewindTime) + 1
	local n2 = math.mod(time+6, rewindTime) + 1
	--	reappear player
	if rewindTable[n] == nil then return end
	local v = rewindTable[n]
	local ns = math.modf(rewindShadowCount, 7) + 1
--print(player.x,v.x,player.y,v.y,player.status,v.status,screen.offsetX*screen.screenWidth+screen.offsetPx,v.offsetX,screen.offsetY*screen.screenHeight+screen.offsetPy,v.offsetY,player.currentSprite,v.currentSprite)

	if rewindStart - time == 3 then
		rewindShadow1 = {}
		rewindShadow1.image = display.newSprite(player.imageSheet, player.sequenceData[rewindTable[n1].currentSprite .. "rewind"])
		rewindShadow1.x = rewindTable[n1].x
		rewindShadow1.y = rewindTable[n1].y
		rewindShadow1.currentSprite = rewindTable[n1].currentSprite
		rewindShadow1.image.alpha = 0.5
	elseif rewindStart - time == 6 then
		rewindShadow2 = {}
		rewindShadow2.image = display.newSprite(player.imageSheet, player.sequenceData[rewindTable[n2].currentSprite .. "rewind"])
		rewindShadow2.x = rewindTable[n2].x
		rewindShadow2.y = rewindTable[n2].y
		rewindShadow2.currentSprite = rewindTable[n2].currentSprite
		rewindShadow2.image.alpha = 0.25
	end

	
	player.x = rewindTable[n].x
	player.y = rewindTable[n].y
	if rewindShadow1 then
		if rewindShadow1.currentSprite ~= rewindTable[n1].currentSprite then
			local x,y = rewindShadow1.image.x, rewindShadow1.image.y
			rewindShadow1.image:removeSelf()
			rewindShadow1.image = display.newSprite(player.imageSheet, player.sequenceData[rewindTable[n1].currentSprite .. "rewind"])
			rewindShadow1.image.x,rewindShadow1.image.y = x , y
			rewindShadow1.image.alpha = 0.5
			rewindShadow1.image:play()
			rewindShadow1.currentSprite = rewindTable[n1].currentSprite
		end
		rewindShadow1.x = rewindTable[n1].x
		rewindShadow1.y = rewindTable[n1].y
	end
	if rewindShadow2 then
		if rewindShadow2.currentSprite ~= rewindTable[n2].currentSprite then
			local x,y = rewindShadow2.image.x, rewindShadow2.image.y
			rewindShadow2.image:removeSelf()
			rewindShadow2.image = display.newSprite(player.imageSheet, player.sequenceData[rewindTable[n2].currentSprite .. "rewind"])
			rewindShadow2.image.x,rewindShadow2.image.y = x , y
			rewindShadow2.image.alpha = 0.25
			rewindShadow2.image:play()
			rewindShadow2.currentSprite = rewindTable[n2].currentSprite
		end
		rewindShadow2.x = rewindTable[n2].x
		rewindShadow2.y = rewindTable[n2].y
	end
	if player.currentSprite ~= rewindTable[n].currentSprite then
		local x,y = player.image.x, player.image.y
		player.image:removeSelf()
		player.image = display.newSprite(player.imageSheet, player.sequenceData[rewindTable[n].currentSprite .. "rewind"])
		player.image.x,player.image.y = x , y
		player.image:play()
		player.currentSprite = rewindTable[n].currentSprite
	end
	--	information like speed, status, direction do not need to reset during the rewinding time
	
	--	reappear the screen
	local ox,oy = screen.offsetX * iv.tileWidth + screen.offsetPx - rewindTable[n].offsetX, screen.offsetY * iv.tileHeight + screen.offsetPy - rewindTable[n].offsetY
	screen.offsetPx = screen.offsetPx - ox
	screen.offsetPy = screen.offsetPy - oy
--print(v.offsetX,v.offsetY,ox,oy,screen.offsetX,screen.offsetPx,screen.offsetY,screen.offsetPy)
	relocate_screen(player,screen)
	generalMove(player,player,screen)
	if rewindShadow1 then generalMove(rewindShadow1,rewindShadow1,screen) end
	if rewindShadow2 then generalMove(rewindShadow2,rewindShadow2,screen) end
	if ghost then generalMove(ghost,ghost,screen) end	
	
	for i,v in ipairs(screen) do
		for j,vv in ipairs(v) do
			if vv ~= nil and vv ~= 0 then
				--print(screen.offsetPx,screen.offsetPy,i,j,vv.image)
				--print(i,j,vv.image,vv.image.x,vv.image.y,vv.x,vv.y)
				vv:move(player,screen)
			end
		end
	end
	
	for i,vvv in ipairs(livings) do
		generalMove(vvv,vvv,screen)
	end
	
	--	clear the action file
	if file and file.actionList then
		if file.actionList[time] then
			file.actionList[time] = nil
		end
	end
end


--	v3.01
--	ghostCollide is problematic. The reasons are as follows
--	1. Previous version cannot handle the situation when the ghost and the player are not in the same screen (because it's using screen to collide). To deal with it, we should either maintain a ghost map or check the map file every time. 
--	******************************************************************************************************************
--	**	CAUSION: if things like ice is added into the map, ghost play will have to maintain a ghost map!       		**
--	******************************************************************************************************************
--	2. Some objects may also need to collide with the ghost as well. For now it's handled by passing a third parameter isGhost. May change for later use
function ghostCollide(player,screen, iv, isReplay)
	
	if iv == nil or iv.map.tile == nil or player.status == "dead" or player.status == "victory" then
		print ("can't collide",iv, player.status)
		return
	end 
		
	--	WARNING: the coordinates system might have a fatal error
	--	The coordinates are calculated not start with 0 but with 64
	local m1 = math.floor(math.round(player.x*100)/100 / iv.tileWidth)
	local n1 = math.floor(math.round(player.y*100)/100 / iv.tileHeight)
	
	if (iv.map.tile[n1] == nil) then return end
--print("in ghost collide",player.x, player.y, n1,m1,iv.map.tile[n1][m1],iv.map.tile[n1+1][m1],iv.map.tile[n1][m1+1],iv.map.tile[n1+1][m1+1],player.status)	

	--	set fall mechanism
	if (iv.map.tile[n1+1] ~= nil and 										-- 	if it's the last row, there's no way to fall
		((player.status == "run" and 										--	if the player is running,
		(iv.map.tile[n1+1][m1] == nil or iv.map.tile[n1+1][m1] == 0) and	--	and there's nothing beneath, 
		(math.round(player.x*100)/100 == (m1-1)*iv.tileWidth or				
		iv.map.tile[n1+1][m1+abs1(player.directionX*player.speedX)]==nil or
		iv.map.tile[n1+1][m1+abs1(player.directionX*player.speedX)]==0)) or		
		(player.status == "stick" and										--	player is sticking and
		(iv.map.tile[n1][m1+abs1(player.directionX)] == nil or 				--	there's nothing to stick
		iv.map.tile[n1][m1+abs1(player.directionX)] == 0) and
		(iv.map.tile[n1+1][m1+abs1(player.directionX)] == nil or 			--	there's nothing to stick
		iv.map.tile[n1+1][m1+abs1(player.directionX)] == 0)))) then
		print("ghost set fall", screen.offsetX,screen.offsetY,screen.offsetPx,screen.offsetPy,player.speedX*player.directionX,player.speedY*player.directionY,player.status,n1,m1)

		player.directionY = 1
		player.status = "fall"
		--player.speedX = player.speedX / 2
		player.speedY = player.standardY
		local ix,iy = player.image.x,player.image.y
		player.image:removeSelf()
		local d
		if abs1(player.directionX)>=0 then d="right" else d="left" end
		player.image = display.newSprite(player.imageSheet, player.sequenceData["jump" .. d])
		player.image.x,player.image.y = ix,iy
		player.image:play()
	end
	
	--	CAUSION:
	--	noting that each collision may change the player's position, i.e. the n1 and m1 may not accurate now.
	--	therefore, if we keep using the old n1 and m1, we might collide with the wrong tiles.
	
	--	CAUSION:
	--	generalCollide does not check speed. 
	--	That is to say, if player is overlapping at the left side and is running left, the generalCollide will stil change the player's speed
	--	That being said, we need to check carefully to aviod a same tile to be collided twice.
	
	--	relying on the generalCollide will do isColliding/isOverlapping check
	--	the engine just need to call the collide function without checking
	--	noting that we need to build a mock object inorder to call generalCollide
	
	for i=-1,2 do
		for j=-1,2 do
			if iv.map.tile[n1+i] ~= nil and iv.map.tile[n1+i][m1+j] ~= nil and iv.map.tile[n1+i][m1+j] > 0 then
--print(n1+i,m1+j)
				local o = makeObj(n1+i,m1+j,screen,generalCollide)
				o:collide(player,screen)
			end
		end
	end
	
	
	for i,v in ipairs(livings) do
		if (v.isVisible or true) then
--	print("livings",i,v)
			v:collide(player,screen, isReplay)
		end
	end
end


local tabFunc = function(player, event, ghostplay)
	if player.status == "run" then
		jumpChannel = audio.play( jumpSound )	

		player.image:removeSelf()
		print("jumping from run",time)

		if isReplay ~="replay" and (not ghostplay) then
			local action = {}
			action.phase = event.phase
			action.name = event.name
			action.time = event.time
			file.actionList[time] = action
		print("---------------save action", event.phase, event.name, event.time, time)
		end
		
		if player.directionX > 0 then
			player.image = display.newSprite(player.imageSheet, player.sequenceData["jumpright"])
			player.image.x = player.x - (screen.offsetX+1) * tileWidth - screen.offsetPx
			player.image.y = player.y - (screen.offsetY+1) * tileHeight - screen.offsetPy
			player.currentSprite = "jumpright"
			player.image:play()
		elseif player.directionX < 0 then
			player.image = display.newSprite(player.imageSheet, player.sequenceData["jumpleft"])
			player.image.x = player.x - (screen.offsetX+1) * tileWidth - screen.offsetPx
			player.image.y = player.y - (screen.offsetY+1) * tileHeight - screen.offsetPy
			player.currentSprite = "jumpleft"
			player.image:play()
		end
		player.status = "jump"
		player.directionY = math.abs(player.directionY)
		player.speedY = player.standardY
		player.count = 120
		player.countRate = 1
		
		--	for new jump functionality
		player.speedY = 2 * player.standardY
		player.jumpSpeed = player.gravity
		player.directionY = -1
		player.lastTouchBegan = nil
	elseif player.status == "stick" then
		jumpChannel = audio.play( jumpSound )
		print("jumping from stick",time)
		player.image:removeSelf()

		if isReplay ~= "replay" then
			local action = {}
			action.phase = event.phase
			action.name = event.name
			action.time = event.time
			file.actionList[time] = action
print("---------------save action", event.phase, event.name, event.time, time)
		end
		
		player.directionX = player.directionX * -1
		player.speedX = player.standardX + 0.6 * player.tempSx
	--	player.speedX = player.standardX
		player.status = "jump"
		player.count = 120
		player.countRate = 1
		player.directionY = math.abs(player.directionY)
		
		
		--	for new jump functionality
		player.speedY = 2 * player.standardY
		player.jumpSpeed = player.gravity
		player.directionY = -1
		
		
	--	player.speedY = player.standardY
		if player.directionX > 0 then
			player.image = display.newSprite(player.imageSheet, player.sequenceData["jumpright"])
			player.image.x = player.x - (screen.offsetX+1) * tileWidth - screen.offsetPx
			player.image.y = player.y - (screen.offsetY+1) * tileHeight - screen.offsetPy
			player.currentSprite = "jumpright"
			player.image:play()
		elseif player.directionX < 0 then
			player.image = display.newSprite(player.imageSheet, player.sequenceData["jumpleft"])
			player.image.x = player.x - (screen.offsetX+1) * tileWidth - screen.offsetPx
			player.image.y = player.y - (screen.offsetY+1) * tileHeight - screen.offsetPy
			player.currentSprite = "jumpleft"
			player.image:play()
		end
		
		player.lastTouchBegan = nil
	else
print("----------------store player.lastTouchBegan",player.status)
		player.lastTouchBegan = event	
--		print("failure tab", player.status,event.phase,event.time,time)
	end	
end


local ghostTab = function(ghost, event)
	if event.phase == "began" then
--print("ghostTab began",event.time)
		ghostTouchStart = event.time
		tabFunc(ghost, event,true)
	elseif event.phase == "ended" or event.phase == "cancelled" then
		if ghostTouchStart and event.time - ghostTouchStart < 150 then
--print("ghostTab short",event.time, ghostTouchStart)
			ghost.jumptype = "shortjump"
			ghost.speedY = ghost.speedY * 0.5
			ghost.jumpSpeed = ghost.jumpSpeed * 1.75
			ghost.countRate = 2
		elseif ghostTouchStart and event.time - ghostTouchStart > 150 and event.time - ghostTouchStart < 250 then
--print("ghostTab medium",event.time, ghostTouchStart)
			ghost.jumptype = "mediumjump"
			ghost.speedY = ghost.speedY * 0.75
			ghost.jumpSpeed = ghost.jumpSpeed * 1.5
		else
--print("ghostTab max",event.time, ghostTouchStart)
			ghost.jumptype = "maxjump"
		end
	end
end

local tab = function (event)
print("---------action detected", event.phase,event.name,event.time,time)
    if event.phase == "began" then
		touchstart = event.time
--		print("touch started at: ",touchstart,time,player.x,player.y,player.speedX*player.directionX, player.speedY*player.directionY)
		tabFunc(player, event)
	elseif event.phase == "ended" or event.phase == "cancelled" then
		local touchend = event.time
--		print("touch ended at: ",touchend,time,player.x,player.y,player.speedX*player.directionX, player.speedY*player.directionY)
		
		if player.lastTouchBegan == nil then
			local action = {}
			action.phase = event.phase
			action.name = event.name
			action.time = event.time
			if event.caching then
				file.actionList[time+1] = action
			else
				file.actionList[time] = action
			end
print("-------------save action", event.phase, event.name, event.time, time)
		else
print("-------------didn't save the action, store it into player",event.phase, event.name, event.time, time)
			player.lastTouchEnded = event
		end
		
		if touchstart == nil then return
		elseif(touchend-touchstart < 150)  then 
			player.jumptype = "shortjump"
			player.speedY = player.speedY * 0.5
			player.jumpSpeed = player.jumpSpeed * 1.75
			elseif (  (touchend-touchstart) > 150 and (touchend-touchstart) < 250
			)  then 
			player.jumptype = "mediumjump"
			player.speedY = player.speedY * 0.75
			player.jumpSpeed = player.jumpSpeed * 1.5
			print("medium jump")
		else
			player.jumptype = "maxjump"
			print("max jump")
		end
	else
	--	print(event.phase,touchstart,time,player.x,player.y,player.speedX*player.directionX, player.speedY*player.directionY)
	end -- matches if phase.edn
    
end


function mainLoop(event)


	--[[ The toFront used to bring the text on the screen on top of other objects ]]
	
	local stripTop

		screen.score:toFront()
		screen.scoreLabel:toFront()
		screen.timerLabel:toFront()
		screen.time:toFront()
		
		


	
		

	screen.memoryUsage:toFront()


	if isReplay== "replay" and ghost ~= nil then
		
		if player~=nil and player.image~=nil and player.image.removeSelf~=nil then player.image:removeSelf() end
		if replayFile ~= nil then
			if replayFile.actionList["" .. time] ~= nil then
				local e = {name = replayFile.actionList["" .. time].name, phase = replayFile.actionList["" .. time].phase, time = replayFile.actionList["" .. time].time }
				ghostTab(ghost, e)
				ghost.image.alpha = 0.5
			end
		else return
		end	
		
		if ghost.status == "dead" or ghost.status == "victory" then
			print("ghost",ghost.status)
			isBegin = false
			Runtime:removeEventListener("enterFrame",mainLoop)
			ghost.image:pause()
			ghost.speedX = 0
			ghost.speedY = 0
			local options =
			{
				effect = "fade",
				time = 400,
				isModal = true,
				params = { overlayType="youwin", level = currLevel }
			}

			storyboard.showOverlay("overlay_scene",options)
		--	return
		end
		time = time + 1
		ghostCollide(ghost,screen,iv,false)
		ghost.image.alpha = 0.5
		move_focus(ghost,screen)
	elseif player.status ~= "dead" and player.status ~= "victory" then
		--	v3.2 : rewind
		if (not inRewind) then
	
		--	v2.4.3
		--	will extract the actions for the ghost replay if applicable
		--	WARNING: the action is not guaranteed to be replayed in the same way it record. Because of the multi-thread problem.
			if replayFile ~= nil then
				if replayFile.actionList["" .. time] ~= nil then
					local e = {name = replayFile.actionList["" .. time].name, phase = replayFile.actionList["" .. time].phase, time = replayFile.actionList["" .. time].time }
					ghostTab(ghost, e)
					ghost.image.alpha = 0.5
				end
			end	
			
			time = time + 1
			if time < screen.totalPoints then
				screen.score.text = (screen.totalPoints - time)
			end
			


			screen.time.text = round((system.getTimer()-startTime)/1000,2)
			local memory = (system.getInfo( "textureMemoryUsed" ) / 1000000)
			screen.memoryUsage.text = "Memory: "..(string.sub( memory, 1, string.len( memory ) - 4 )).."MB"

			collide_beta(player)
			
		--	v2.4.3
		--	CAUSION: this will not work eventually!
		--	using the same collide function will cause the ghost to get the coins or powerups
		--	will need to define a ghost collide for later use!
			if ghost ~= nil then
				ghostCollide(ghost,screen,iv,true)
				ghost.image.alpha = 0.5
				if ghost.status == "dead" or ghost.status == "victory" then
					print("ghost",ghost.status)
					ghost.image:pause()
					ghost.speedX = 0
					ghost.speedY = 0
					ghost.move = generalMove
				end
			end 
			
		--  calling movement engine
			move_focus(player,screen)
			
			
			-- 3.0.1.11, rename move to move_focus, and put ghost:move outside the move engine into the mainLoop
			if ghost ~= nil then
				ghost:move(ghost,screen)
			end
			writeRewind(player,screen,time)
		else
			--	v3.2 : rewind
			--	rewindCount will perform a rewind slowdown functionality
			if (time <= 0) or rewindStart-time >= rewindTime or availRewindTime <=0 then powerUpEnds() return end
				
			if rewindCount == nil then
				rewindCount = 0
			elseif rewindCount ~= 0 then
				rewindCount = rewindCount - 1
			elseif rewindCount <= 0 then
				readRewind(player,screen,time)
				if time < screen.totalPoints then
					screen.score.text = (screen.totalPoints - time)
				end
				rewindCount = 0
			end
		end
	--[[elseif (player.status=="dead" and availRewindTime>0) then
		player.status="deadRewind"
		Runtime:addEventListener("touch", deadRewind)
		powerUpBegins(nil)]]
	else if (player.status == "victory" or (player.status == "dead" and doneDying < -1 )) then
			if needToSave then
				needToSave = false
				Runtime:removeEventListener("enterFrame", mainLoop)
				player.image:pause()
				local M = require("loadsave")
				M.saveTable(file, "temp")
				file.player.score=screen.score.text
				scoreUpdate(file.levelID,screen.score.text,file)
				print("saving score",file.levelID,screen.score.text)
				
				local storyOptions =
				{
					effect = "crossFade",
					time = 500,
					params = { level = "level0"}
				}
				isEnd =  true
				pauseGame()
			end
		else 
			if doneDying == 0 then
				local x,y = player.image.x , player.image.y  
				player.image:removeSelf()
				player.image = display.newImage(player.imageSheet,1,64,64)
				player.image.pause = function(self) end
				player.image.x , player.image.y  = x,y
				player.image:scale(2,2)
				doneDying = 1
			elseif ((doneDying ~=0 and player.image.y > screen.screenHeight * tileHeight) or player.image.contentHeight < 5 )then
				doneDying = -2
			elseif doneDying ~= 0 and player.image.y < 10 then
				doneDying = -1
			elseif doneDying == -1 and player.image.y < screen.screenHeight * tileHeight and player.image.y > 10 then
				player.image:scale(0.98,0.98)
			end
			player.image.y = player.image.y - 5 * doneDying
		end
	end
end

function deadRewind(event)
	Runtime:removeEventListener("touch",deadRewind)
	powerUpEnds(event)
end


function scene:createScene( event )  

local group = self.view


end 

function start(event)

print("in start")
	if not isBegin then
		isBegin = true
		startTime = system.getTimer()
		if isReplay ~= "replay" then
			Runtime:addEventListener("touch",tab)
		end
		Runtime:addEventListener("enterFrame",mainLoop)
		Runtime:removeEventListener("tap",start)
		return
	end
print("end start")
end

local buttonHandler = function( event )	

	if event.target.id == "resumeButton" then				
	      display.remove(resumeButton)
	      resumeButton = nil
	      isBegin = false 
	      start()  
      end 

    end

--[[

		We will use this function to call all powerups based on the configuration passed.
]]
local power 

function powerUpBegins(event)
	if availRewindTime <= 0 then return end
	if power then
	power:removeSelf()
	power=nil
	end
	power = display.newText( "",130, 45, "Comic Sans MS", 40)
	
	inRewind = true
	rewindStart = time
	rewindShadowCount = 1
end

function  powerUpEnds(event)
	if power then
		print("ending powerup!!")
		power:removeSelf()
		power=nil
		inRewind = false
		
		local v = rewindTable[math.mod(time, rewindTime) + 1]
	--	if (v == nil) then print("----------------------wat?", time, math.mod(time, rewindTime) + 1) end
		player.x = v.x
		player.y = v.y
		if player.currentSprite ~= v.currentSprite then
			local x,y = player.image.x, player.image.y
			player.image:removeSelf()
			player.image = display.newSprite(player.imageSheet, player.sequenceData[v.currentSprite .. "rewind"])
			player.image.x,player.image.y = x , y
			player.image:play()
			player.currentSprite = v.currentSprite
		end
		player.speedX = v.speedX
		player.speedY = v.speedY
		player.status = v.status
		player.directionY = v.directionY
		player.directionX = v.directionX
		if rewindShadow1 and rewindShadow1.image then rewindShadow1.image:removeSelf() end
		if rewindShadow2 and rewindShadow2.image then rewindShadow2.image:removeSelf() end
	end
end

--[[
		pauseGame function calls the overlay screen based on win lose or pause event
]]
function pauseGame(event)
print("in remove isEnd",isEnd)

		isBegin = false
		if event then   									-- Checks if this event is on clicking the pause button
			if event.target.id == "pausebutton" then
				isEnd = false
			end
		end

		Runtime:removeEventListener("touch",tab)
		Runtime:removeEventListener("enterFrame",mainLoop)

		local options =
		{
		    effect = "fade",
		    time = 400,
		    isModal = true,
		    params = { overlayType="", level = currLevel }
		}
		
    
		if isEnd then
			if player.status=="dead" then
				options.params.overlayType = "youlose"	
			else
				options.params.overlayType = "youwin"
			end
		elseif not isEnd then
			options.params.overlayType = "paused"
		end
  		storyboard.showOverlay("overlay_scene",options)
end



function scene:willEnterScene( event )  

	local group = self.view

    local params = event.params  -- 	levelParameter passed from the menu
    currLevel = params.level
	isReplay = params.selection
	local propertiesFilePath = "properties.json"
	local readPropsTable = readJson(propertiesFilePath)



	if readPropsTable.sfx == "yes" then
		print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^6")
		jumpSound = audio.loadSound("audio/ninja-jump.wav") --Loads sound for jump sequence
	else
		jumpSound = nil
	end
	
	doneDying = 0	
	temp = readJson(filepath)
	print("after reading--------------------in game.lua---------",temp.avatar)
	avatar = temp.avatar


    isBegin = false
	needToSave = true
	file = {}
	file.actionList = {}
	replayFile = nil
	player = {}
	livings = {}
	screen = {}
	ghost = nil
	time = 0
	rewindTable = {}

	iv=require(params.level)
	sheet = graphics.newImageSheet(iv.sheet, iv.options)
	file.levelID=params.levelID	
	
	
	--[[if params.replay ~= nil then
		local M = require("loadsave")
		replayFile = M.loadTable(params.replay)
		if replayFile~= nil then
			ghost = replayFile.player
		end
	end 
	]]--

	print("replay content",params.replayContent,"level Selected ",params.levelID)
	if params.replay ~= nil then
		--local M = require("loadsave")
		replayFile = params.replayContent
		if replayFile~= nil then
			local propertiesFilePath = "properties.json"
			local readPropsTable = readJson(propertiesFilePath)
			print("in here before the if case----------------")
			if readPropsTable.selfGhostPlay == "no" then
				ghost = nil
				replayFile = nil
				print("in here, if case----------------ghost: ", ghost)
			else
				ghost = replayFile.player
				print("in here, else case----------------ghost: ", ghost)
			end
		end
	end 

	
	
	if params.levelID == 5 then
		background = display.newImageRect( "images/background4.jpg", display.contentWidth, display.contentHeight )
    else
    	background = display.newImageRect( "images/background.jpg", display.contentWidth, display.contentHeight )
    end

    background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
  
	pauseButton = widget.newButton{
		default = "images/pausebtn.png",
		over = "images/pausebtn-over.png",
		onRelease = pauseGame,
		id = "pausebutton",
		font = default,
		fontSize = 28,
		emboss = true
	}

	pauseButton.x = 900; pauseButton.y = 560	
	
	powerUpButton = widget.newButton{
		default = "images/powerup.png",
		over = "images/powerup.png",
		onPress = powerUpBegins,
		onRelease = powerUpEnds,
		id = "pausebutton",
		font = default,
		fontSize = 28,
		powerUpType = "powerUp Begins"
	}

	powerUpButton.x = 800; powerUpButton.y = 560
	
    screen.isMovingX = false
    screen.isMovingY = false
	screen.totalPoints = iv.totalPoints or 1000
    screen.offsetX=0
    screen.offsetY=0
    screen.offsetPx=0
    screen.offsetPy=0
    screen.focusX=448
    screen.focusY=320
    screen.screenWidth = 16
    screen.screenHeight = 11
	
	screen.scoreLabel = display.newText("Score", 15, 15, "Ninja Naruto", 30 )
	screen.score = display.newText( "" .. screen.totalPoints, 25, 70, "Ninja Naruto", 30)
	
	screen.timerLabel = display.newText("Time", 800, 15, "Ninja Naruto", 30 )
	formattedtime = 0 
	screen.time = display.newText( formattedtime, 800, 55, "Ninjutsu BB", 40)



	local memory = (system.getInfo( "textureMemoryUsed" ) / 1000000)
	screen.memoryUsage = display.newText( "Memory: "..(string.sub( memory, 1, string.len( memory ) - 4 )).. "MB", 10, 550, "Comic Sans MS", 20)
    screen[1]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    screen[2]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    screen[3]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    screen[4]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    screen[5]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    screen[6]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    screen[7]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    screen[8]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    screen[9]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    screen[10]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    screen[11]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  
  
  
 


	--set player's init parameters
	player.imageSheet = graphics.newImageSheet("images/"..avatar, {width = 64, height = 64, numFrames = 20})
	player.standardX = 6
	player.standardY = 5
	player.gravity = 0.3
	player.jumpSpeed = player.gravity
	player.tempSx = player.standardX
	player.speedX=player.standardX
	player.speedY=player.standardY
	player.directionX=1
	player.directionY=0
	player.count = 100
	player.status = "run"
	player.score = 0
	player.sequenceData = {}
	player.sequenceData["runright"] = {name = "runright", start = 2, count = 3, loopDirection = "bounce", time = 400, loopCount = 0}
	player.sequenceData["runleft"] = {name = "runleft", start = 10, count = 3, loopDirection = "bounce", time = 400, loopCount = 0}
	player.sequenceData["jumpright"] = {name = "jumpright", start = 6, count = 3, loopDirection = "bounce", time = 400, loopCount = 0}
	player.sequenceData["jumpleft"] = {name = "jumpleft", start = 14, count = 3, loopDirection = "bounce", time = 400, loopCount = 0}
	player.sequenceData["stickright"] = {name = "stickright", start = 17, count = 1, loopDirection = "bounce", time = 1000, loopCount = 0}
	player.sequenceData["stickleft"] = {name = "stickleft", start = 18, count = 1, loopDirection = "bounce", time = 1000, loopCount = 0}
	player.getEnemyBox = function(self)
		return {x = self.x + tileWidth/4, y = self.y + tileHeight/4, tileWidth = tileWidth / 2, tileHeight = tileHeight / 2}
	end
	
	--	for jump caching
	player.touchFunc = tab
	
	--	v3.2 : rewind
	player.currentSprite = "runright"
	player.sequenceData["runrightrewind"] = {name = "runright", start = 2, count = 3, loopDirection = "bounce", time = 1200, loopCount = 0}
	player.sequenceData["runleftrewind"] = {name = "runleft", start = 10, count = 3, loopDirection = "bounce", time = 1200, loopCount = 0}
	player.sequenceData["jumprightrewind"] = {name = "jumpright", start = 6, count = 3, loopDirection = "bounce", time = 1200, loopCount = 0}
	player.sequenceData["jumpleftrewind"] = {name = "jumpleft", start = 14, count = 3, loopDirection = "bounce", time = 1200, loopCount = 0}
	player.sequenceData["stickrightrewind"] = {name = "stickright", start = 17, count = 1, loopDirection = "bounce", time = 1000, loopCount = 0}
	player.sequenceData["stickleftrewind"] = {name = "stickleft", start = 18, count = 1, loopDirection = "bounce", time = 1000, loopCount = 0}

	player.move = playerMove	
	
	--	v2.4.3
	if ghost~= nil then
		ghost.move = playerMove
		ghost.imageSheet = graphics.newImageSheet(ghost.imageSheetInfo.name, ghost.imageSheetInfo.option)
		ghost.getEnemyBox = player.getEnemyBox
	end
	
	
--	initializing the screen center, screen.offsetX, screen.offsetY --and the livings table
	for i,v in ipairs(iv.map["tile"]) do
		for j,vv in ipairs(v) do
			if vv==-1 then
				player.x = j * tileWidth
				player.y = i * tileHeight
				player.image = display.newSprite(player.imageSheet, player.sequenceData["runright"])
				if (j - screen.focusX/tileWidth - 1)<0 then
					screen.offsetX=0
					player.image.x=(j-1)*tileWidth
				elseif (j-1-screen.focusX/tileWidth+screen.screenWidth)>mapWidth then
					screen.offsetX=mapWidth-screen.screenWidth
					player.image.x= (j-screen.offsetX-1)*tileWidth
				else
					screen.offsetX=j-screen.focusX/tileWidth-1
					player.image.x=screen.focusX
				end
				if (i-1-screen.focusY/tileHeight)<0 then
					screen.offsetY=0
					player.image.y = (i-1)*tileHeight
				elseif (i-1-screen.focusY/tileHeight+screen.screenHeight)>mapHeight then
					screen.offsetY=mapHeight-screen.screenHeight
					player.image.y = (i-1-screen.offsetY)*tileHeight
				else
					screen.offsetY=i-1-screen.focusY/tileHeight
					player.image.y=screen.focusY
				end
				--	v2.4.3
				if ghost~= nil then
					ghost.x = player.x
					ghost.y = player.y
					ghost.image = display.newSprite(ghost.imageSheet, ghost.sequenceData.runright)
					ghost.image.x = player.image.x
					ghost.image.y = player.image.y
					ghost.image.alpha = 0.5
					ghost.image:play()
				end
				
				print("first it",i,j,screen.offsetX,screen.offsetY)
				break

			end
		end
	end  
	player.image:play()  
	
	
	file.player = {}
	file.player.imageSheetInfo = {}
	file.player.imageSheetInfo.name = "images/"..avatar
	file.player.imageSheetInfo.option = {width = 64, height = 64, numFrames = 20}
	file.player.standardX = player.standardX
	file.player.standardY = player.standardY
	file.player.speedX = player.speedX
	file.player.speedY = player.speedY
	file.player.gravity = player.gravity
	file.player.jumpSpeed = player.jumpSpeed
	file.player.tempSx = player.tempSx
	file.player.directionX = player.directionX
	file.player.directionY = player.directionY
	file.player.count = player.count
	file.player.score = player.score
	file.player.status = player.status
	file.player.sequenceData = {}
	file.player.sequenceData.runright = player.sequenceData.runright
	file.player.sequenceData.runleft = player.sequenceData.runleft
	file.player.sequenceData.jumpright = player.sequenceData.jumpright
	file.player.sequenceData.jumpleft = player.sequenceData.jumpleft
	file.player.sequenceData.stickright = player.sequenceData.stickright
	file.player.sequenceData.stickleft = player.sequenceData.stickleft
	file.name = "temp"
	file.level = lvl
--	initializing the livings
	for i,v in ipairs(iv.map["object"]) do
		for j,vv in ipairs(v) do
			if vv ~= 0 then
				local obj = iv.map["object"]["behavior"][vv]
				local o = {}
				o.imgSeq = obj.imgSeq
				o.directionX = obj.directionX
				o.directionY = obj.directionY
				o.speedX = obj.speedX
				o.speedY = obj.speedY
				o.isVisible = obj.isVisible
				o.move = obj.move
				o.collide = obj.collide
				o.x = j * tileWidth
				o.y = i * tileHeight
				o.image = display.newSprite(sheet, o.imgSeq)
				o.image.x = (j-screen.offsetX-1)*tileWidth
				o.image.y = (i-screen.offsetY-1)*tileHeight
				o.image:play()
--				print(o.image, o.x, o.y, o.image.x, o.image.y,o.collide,o.move)
				livings[#livings + 1] = o
			end
		end
	end

--	initializing the screen table
for i,v in ipairs(screen) do
  for j , vv in ipairs(v) do
    if(vv ~= nil and vv ~= 0 ) then
      print(i,j,vv,vv.image)
    end
  end
end

  
	for i,v in ipairs(iv.map["tile"])do
		if (i>=screen.offsetY+1 and i<=screen.offsetY+screen.screenHeight) then
			for j, vv in ipairs(v) do
				if (j>=screen.offsetX+1 and j<=screen.offsetX+screen.screenWidth) then
					if vv>0 then
						local obj = {}
						obj.x = j * tileWidth
						obj.y = i * tileHeight
						obj.image = display.newSprite(sheet, iv.map["image"][vv])
						obj.image.x = (j-screen.offsetX-1)*tileWidth
						obj.image.y = (i-screen.offsetY-1)*tileHeight
						obj.collide = generalCollide
						obj.move = generalMove
						screen[i-screen.offsetY][j-screen.offsetX]=obj
					end
				end
			end
		end
	end
	
	print("current screen", screen.offsetX,screen.offsetY)
	for i,v in ipairs(screen) do
		for j,vv in ipairs(v) do
			if vv ~= nil and vv ~= 0 then
				print(i,j,vv,vv.image)
			end
		end
	end
	
	print("the livings",#livings)
	for i,v in ipairs(livings) do
		print(i,v.image,v.image.x,v.image.y,v.image.removeSelf)
	end
	
	if ghost ~= nil then
		print("the ghost",ghost.x, ghost.y,ghost.image,ghost.image.x, ghost.image.y,ghost.speedX,ghost.speedY,ghost.directionX,ghost.directionY)
	end
  
		--	v3.2 : rewind
	--	starting value
	rewindTable[1] = {}
	rewindTable[1].x = player.x
	rewindTable[1].y = player.y
	rewindTable[1].offsetX = screen.offsetX * iv.tileWidth + screen.offsetPx
	rewindTable[1].offsetY = screen.offsetY * iv.tileHeight + screen.offsetPy
	rewindTable[1].speedX = player.speedX
	rewindTable[1].speedY = player.speedY
	rewindTable[1].directionX = player.directionX
	rewindTable[1].directionY = player.directionY
	rewindTable[1].status = player.status
	rewindTable[1].currentSprite = player.currentSprite


  group:insert(background)
  group:insert(pauseButton)
  group:insert(powerUpButton)


end 	

function scene:enterScene(event)
  
 -- Runtime:addEventListener("touch", tab)
	Runtime:addEventListener("tap",start)
end

function scene:exitScene( event )
	local group = self.view
	
    --[[ Destroying objects that were not inserted into group ]]

	screen.memoryUsage:removeSelf()
	screen.score:removeSelf()
	screen.time:removeSelf()

	if (player ~= nil and player.image ~= nil and player.image.removeSelf ~= nil) then
		player.image:removeSelf()
	end
	if ghost ~= nil then
		ghost.image:removeSelf()
	end	

    for i,v in ipairs(screen) do
		for j,vv in ipairs(v) do
			if vv ~= nil and vv ~= 0 then
				print(vv, i, j, vv.image)
				vv.image:removeSelf()
				vv = 0 
			end
			vv = 0
        end
    end
	screen = {}
       
    for i,v in ipairs(livings) do
		print(i,v,v.image)
		if v~=nil and v.image~=nil and v.image.removeSelf ~= nil then
			v.image:removeSelf()
		--	table.remove(livings,i)
		end
    end
       

	--audio.stop() -- needed else corona throws error ALmixer_FreeData: alDeleteBuffers failed. Invalid Operation
	--audio.dispose(backgroundMusic)
	--backgroundMusic = nil


 screen = nil
    Runtime:removeEventListener("enterFrame",mainLoop)
    Runtime:removeEventListener("touch", tab)
  --storyboard.removeAll()
	storyboard.removeScene(scene)

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
end


function scene:overlayBegan( event )
    print( "The overlay scene is showing: " .. event.sceneName )
    print( "We get custom params too! " .. event.params.overlayType )
end
scene:addEventListener( "overlayBegan" )

--

function scene:overlayEnded( event )
    print( "The following overlay scene was removed: " .. event.sceneName )
    isBegin = false
    start()
end
scene:addEventListener( "overlayEnded" )

scene:addEventListener("createScene",scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene