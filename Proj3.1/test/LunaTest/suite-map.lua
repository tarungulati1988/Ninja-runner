module(..., package.seeall)
require("map")


function suite_setup()
   print "\n\n-- running suite setup hook"
end

function suite_teardown()
   print "\n\n-- running suite teardown hook"
end


-------------------------------------------------
--
--
-------------------------------------------------

-- testing for x=0,y=0
-- point x=0,y=0 supposed to be in the box
function test_inBox_zero_xy()
	local x= 0
	local y = 0
	local box = {}
	box.tileWidth=64
	box.tileHeight=64
	box.x=0
	box.y=0
	assert_true(inBox(x,y,box),"inBox failed for x=0,y=0")
end


-- testing for negative_xy
function test_inBox_negative_xy()
	local x= -1
	local y = -1
	local box = {}
	box.tileWidth=64
	box.tileHeight=64
	box.x=0
	box.y=0
	assert_false(inBox(x,y,box),"inBox failed for negative xy")
end


-- testing for outofbox_xy
function test_inBox_outofbox_xy()
	local x= 65
	local y = 65
	local box = {}
	box.tileWidth=64
	box.tileHeight=64
	box.x=0
	box.y=0
	assert_false(inBox(x,y,box),"inBox failed for out of box values of xy")
end

--  [just in - boundary]
function test_inBox_inbox_justinside()
	local x= 65
	local y = 65
	local box = {}
	box.tileWidth=64
	box.tileHeight=64
	box.x=1
	box.y=1
	assert_true(inBox(x,y,box),"inBox failed for inbox case: just inside")
end

--  [ on the box]
function test_inBox_inbox_onthebox()
	local x= 64
	local y = 64
	local box = {}
	box.tileWidth=64
	box.tileHeight=64
	box.x=0
	box.y=0
	assert_true(inBox(x,y,box),"inBox failed for inbox case: on the box")
end


-- inside the box
function test_inBox_inbox_inside()
	local x= 20
	local y = 30
	local box = {}
	box.tileWidth=64
	box.tileHeight=64
	box.x=0
	box.y=0
	assert_true(inBox(x,y,box),"inBox failed for inbox case: in box")
end


-- x in box, y out of box
function test_inBox_inbox_xin_yout()
	local x= 20
	local y = 66
	local box = {}
	box.tileWidth=64
	box.tileHeight=64
	box.x=0
	box.y=0
	assert_false(inBox(x,y,box),"inBox failed for inbox case: x in box, y out of box")
end


-- y in box, x out of box
function test_inBox_inbox_xout_yin()
	local x= 66
	local y = 20
	local box = {}
	box.tileWidth=64
	box.tileHeight=64
	box.x=0
	box.y=0
	assert_false(inBox(x,y,box),"inBox failed for inbox case: x out of box, y in")
end

-------------------------------------------------
--
--
-------------------------------------------------
function test_isColliding()
	local box1 = {}
	local box2 = {}
	box1.tileWidth=64
	box1.tileHeight=64
	box1.x=1
	box1.y=1
	box2.tileWidth=64
	box2.tileHeight=64
	box2.x=1
	box2.y=1
	
	local result = isColliding(box1,box2)
	assert_true(result.isOverlapping,"isColliding failed")

end

--overlapping halfway
function test_isColliding_overlap_halfway()
	local box1 = {}
	local box2 = {}
	box1.tileWidth=64
	box1.tileHeight=64
	box1.x=1
	box1.y=1
	box2.tileWidth=64
	box2.tileHeight=64
	box2.x=32
	box2.y=32
	
	local result = isColliding(box1,box2)
	assert_true(result.isOverlapping,"isColliding failed for halfway overlapping")

end


-- just overlapping boxes
function test_isColliding_notoverlapping()
	local box1 = {}
	local box2 = {}
	box1.tileWidth=64
	box1.tileHeight=64
	box1.x=1
	box1.y=1
	box2.tileWidth=64
	box2.tileHeight=64
	box2.x=65
	box2.y=65
	
	local result = isColliding(box1,box2)
	assert_false(result.isOverlapping,"isColliding failed for not overlapping case")

end

-- boxes away by a tile
function test_isColliding_notoverlapping1()
	local box1 = {}
	local box2 = {}
	box1.tileWidth=64
	box1.tileHeight=64
	box1.x=0
	box1.y=0
	box2.tileWidth=64
	box2.tileHeight=64
	box2.x=64
	box2.y=64
	
	local result = isColliding(box1,box2)
	assert_false(result.isOverlapping,"isColliding failed for not overlapping case")

end


-- perfect overlap
function test_isColliding_overlapping_perfectly()
	local box1 = {}
	local box2 = {}
	box1.tileWidth=64
	box1.tileHeight=64
	box1.x=0
	box1.y=0
	box2.tileWidth=64
	box2.tileHeight=64
	box2.x=0
	box2.y=0
	
	local result = isColliding(box1,box2)
	assert_true(result.isOverlapping,"isColliding failed for perfect overlap")
end



-- box1 and box2 adjacent
function test_isColliding_adjacentboxes()
	local box1 = {}
	local box2 = {}
	box1.tileWidth=64
	box1.tileHeight=64
	box1.x=64
	box1.y=64
	box2.tileWidth=64
	box2.tileHeight=64
	box2.x=64
	box2.y=64
	
	local result = isColliding(box1,box2)
	assert_true(result.isOverlapping,"isColliding failed for two adjacent boxes")

end

--near adjacent
function test_isColliding_near_adjacentboxes()
	local box1 = {}
	local box2 = {}
	box1.tileWidth=64
	box1.tileHeight=64
	box1.x=63
	box1.y=63
	box2.tileWidth=64
	box2.tileHeight=64
	box2.x=127
	box2.y=127
	
	local result = isColliding(box1,box2)
	assert_false(result.isOverlapping,"isColliding failed for two near adjacent boxes")

end



-------------------------------------------------
--
--
-------------------------------------------------

