module(..., package.seeall)
require("game")
--require("forunittest")


function suite_setup()
   print "\n\n-- running suite setup hook"
end

function suite_teardown()
   print "\n\n-- running suite teardown hook"
end

function test_ok()
   assert_true(true)
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
-- rewriting collide_beta function here coz 
-- test values are overwritten by globals in game.lua

-- NOTE: iv.tileWidth modified to tileWidth
function isPlayerFallingLocal(player,screen,n1,m1)
	if (screen[n1+1] ~= nil and 										-- 	if it's the last row, there's no way to fall
		((player.status == "run" and 									--	if the player is running,
		(screen[n1+1][m1] == nil or screen[n1+1][m1] == 0)and			--	and there's nothing beneath, or
		(math.round((player.image.x+screen.offsetPx)*100)/100 == (m1 -1) * tileWidth or
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

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--




--------------------------------------------------------------------------
--  tests for abs1(v)
--------------------------------------------------------------------------
-- for negative v value
function test_absv1_negative()
	local v = -5
	assert_equal(-1,abs1(v),"abs1(v) failed for negative value")
end

-- for positive v value
function test_absv1_positive()
	local v = 30
	assert_equal(1,abs1(v),"abs1(v) failed for positive value")
end

-- for zero v value
function test_absv1_zero()
	local v = 0
	assert_equal(0,abs1(v),"abs1(v) failed for positive value")
end

-- test for +ve decimals
function test_absv1_pos_decimals()
	local v = 5.5
	assert_equal(1,abs1(v),"abs1(v) failed for pos decimal value")
end

-- test for -ve decimals
function test_absv1_neg_decimals()
	local v = -5.5
	assert_equal(-1,abs1(v),"abs1(v) failed for neg decimal value")
end

-- test for large number
function test_absv1_largenbr()
	local v = 5877627689267898
	assert_equal(1,abs1(v),"abs1(v) failed for large nbr")
end


-- test for nil
-- throws error

-- function test_absv1_largenbr()
-- 	local v = nil
-- 	assert_equal(nil,abs1(v),"abs1(v) failed for large nbr")
-- end



--------------------------------------------------------------------------
--  tests for makeObj()

--  testing whether obj is successfully created by 
--  checking the obj.x and obj.y value
-- 	these tests crashses/ throws error for nil values of i and j, nil screen
--------------------------------------------------------------------------

-- for j=2, expecting obj.x = 128
-- since obj.x = j*tileWidth
-- and tileWidth = 64
function test_makeObj_j2()
	local i=4
	local j=2
	local screen = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}
	screen.offsetX = 10
	screen.offsetY = 15
	screen.offsetPx = 3
	screen.offsetPy = 3
	local collideFunc = function ()
							end
	local obj = makeObj(i,j,screen,collideFunc)
	assert_equal(128,obj.x,"makeObj failed for j=2")
end


-- for i=2, expecting obj.y = 128
-- since obj.y = j*tileHeight
-- and tileHeight = 64
function test_makeObj_i4()
	local i=2
	local j=2
	local screen = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}
	screen.offsetX = 10
	screen.offsetY = 15
	screen.offsetPx = 3
	screen.offsetPy = 3
	local collideFunc = function ()
							end
	local obj = makeObj(i,j,screen,collideFunc)
	assert_equal(128,obj.y,"makeObj failed for i=2")
end

-- fails for nil value of i and j
-- commented because nil value throws errors
--  NOTE: uncomment to verify the test

-- function test_makeObj_i4()
-- 	local i
-- 	local j
-- 	local screen = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}
-- 	screen.offsetX = 10
-- 	screen.offsetY = 15
-- 	screen.offsetPx = 3
-- 	screen.offsetPy = 3
-- 	local collideFunc = function ()
-- 							end
-- 	local obj = makeObj(i,j,screen,collideFunc)
-- 	assert_equal(128,obj.y,"makeObj failed for i=2")
-- end





--------------------------------------------------------------------------
--  testing move_focus as whole
--------------------------------------------------------------------------
-- if player.image.x = -ve, we should just return
-- 
--
-- FAILS for nil value of x and y
function test_move_focus_negative_imageX()
	local player = {}
	local screen = {}
	player.image = {}
	player.image.x = -5
	player.image.y = 0
	assert_equal(nil,move_focus(player,screen),"move_focus failed for negative image.x!")
end

function test_move_focus_negative_imageY()
	local player = {}
	local screen = {}
	player.image = {}
	player.image.x = 0
	player.image.y = -5
	screen.screenWidth = 16
	screen.screenHeight = 16

	assert_equal(nil,move_focus(player,screen),"move_focus failed for negative image.y!")
end

-- ignores check for local values of directionX and speedX
-- picks global values.
-- strangely, it checks for player.directionX 
-- at (screen.focusX-player.image.x)*player.directionX 

-- function test_move_focus_zero_imageXY()
-- 	local player = {}
-- 	local screen = {}
-- 	screen[1]={0,0,0,0,0}
-- 	screen[2]={0,0,0,0,0}
-- 	screen[3]={0,0,0,0,0}

-- 	player.image = {}
-- 	player.image.x = 0
-- 	player.image.y = 0
-- 	player.directionX = 0
-- 	player.directionY = 0
-- 	-- player.speedX = nil
-- 	player.move = function (self,player,screen)
-- 					return true
-- 				  end

-- 	screen.focusX=0
-- 	screen.focusY=0
-- 	screen.screenWidth = 16
-- 	screen.screenHeight = 16
	

	

-- 	assert_true(move_focus(player,player,screen),"move focus failed!")
-- end



--------------------------------------------------------------------------
-- testing move_focus helper functions 
-- would crash for nil values

-- NOTE: tests need to modified and more tests need to be added
-- in progress!!
--------------------------------------------------------------------------


-- values getting overwritten by the global values in game.lua
-- failing incorrectly
function test_player_outofbounds()
	local player = {}
	local screen = {}
	player.image = {}
	player.image.x = 10
	player.image.y = 120
	screen.screenWidth = 25
	screen.screenHeight = 16
	assert_false(player_outofbounds(player,screen),"player_outofbounds failed")
end


function test_isPlayer_moving_horizontally()
	local player = {}
	local screen = {}
	player.image = {}
	player.image.x = 10
	player.image.y = 120
	player.directionX = 1
	player.speedX = 4

	screen.screenWidth = 25
	screen.screenHeight = 16
	screen.focusX = 240
	screen.offsetX = 5
	
	assert_true(isPlayer_moving_horizontally(player,screen),"isPlayer_moving_horizontally failed")
end


function test_isPlayer_moving_vertically()
	local player = {}
	local screen = {}
	player.image = {}
	player.image.x = 10
	player.image.y = 120
	player.directionY = 1
	player.directionX = 1
	player.speedY = 4

	screen.screenWidth = 25
	screen.screenHeight = 16
	screen.focusX = 240
	screen.focusY = 320
	screen.offsetY = 5
	
	assert_true(isPlayer_moving_horizontally(player,screen),"isPlayer_moving_horizontally failed")
end








--------------------------------------------------------------------------
-- beta_collide() helper function tests
--------------------------------------------------------------------------


-- player value nil
function test_isPLayerFalling_player_nil()
	local player = {}
	player.status = nil
	local screen = {{1,0,1,0,1},{0,0,0,0,0},{1,1,0,0,0},{1,1,1,1,1},{0,1,0,0,1,1}}
	local n1 = 1
	local m1 = 1
	assert_false(isPlayerFallingLocal(player,screen,n1,m1),
		"test_isPLayerFalling failed!") 
end

-- empty screen
function test_isPLayerFalling_screen_empty()
	local player = {}
	player.status = "run"
	player.image = {}
	player.image.x = 320
	player.speedX  = 4
	player.speedY = 4
	player.directionX = 1
	local screen = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0,0}}
	screen.offsetPx = 3

	local n1 = 1
	local m1 = 1
	assert_true(isPlayerFallingLocal(player,screen,n1,m1),
		"test_isPLayerFalling failed!") 
end

-- filled_screen
function test_isPLayerFalling_screen_filled()
	local player = {}
	player.status = "run"
	player.image = {}
	player.image.x = 320
	player.speedX  = 4
	player.speedY = 4
	player.directionX = 1
	local screen = {{1,1,1,1,1},{1,1,1,1,1},{1,1,1,1,1},{1,1,1,1,1},{1,1,1,1,1,1}}
	screen.offsetPx = 3

	local n1 = 1
	local m1 = 1
	assert_false(isPlayerFallingLocal(player,screen,n1,m1),
		"test_isPLayerFalling failed!") 
end


-- no tile beneath the player
-- -- note screen[3][3]

function test_isPLayerFalling_notilebeneath()
	local player = {}
	player.status = "run"
	player.image = {}
	player.image.x = 128
	player.speedX  = 4
	player.directionX = 1
	local screen = {{1,0,0,0,1},{1,0,0,0,1},{1,0,0,1,1},{1,1,1,1,1},{1,1,1,1,1,1}}
	screen.offsetPx = 3

	local n1 = 2
	local m1 = 2
	assert_true(isPlayerFallingLocal(player,screen,n1,m1),
		"test_isPLayerFalling_notilebeneath failed!") 
end

-- there is tile to support the player
-- note screen[3][3]
function test_isPLayerFalling_tilebeneath()
	local player = {}
	player.status = "run"
	player.image = {}
	player.image.x = 128
	player.speedX  = 4
	player.directionX = 1
	local screen = {{1,0,0,0,1},{1,0,0,0,1},{1,0,1,1,1},{1,1,1,1,1},{1,1,1,1,1,1}}
	screen.offsetPx = 3

	local n1 = 2
	local m1 = 2
	assert_false(isPlayerFallingLocal(player,screen,n1,m1),
		"test_isPLayerFalling_tile_beneath failed!") 
end



-- there is tile to support the player
-- note screen[3][5]
function test_isPLayerFalling_tilebeneath_screencorner()
	local player = {}
	player.status = "run"
	player.image = {}
	player.image.x = 128
	player.speedX  = 4
	player.directionX = 1
	local screen = {{1,0,0,0,1},{1,0,0,0,1},{1,0,0,0,0},{1,0,0,0,0},{1,0,0,0,0}}
	screen.offsetPx = 3

	local n1 = 4
	local m1 = 4
	assert_true(isPlayerFallingLocal(player,screen,n1,m1),
		"test_isPLayerFalling_tilebeneath_screencorner failed!") 
end
















