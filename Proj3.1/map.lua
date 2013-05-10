-- All level lua files can require this file to start with

-- count by index
mapWidth=25
mapHeight=15

-- count by pixels
tileWidth=64
tileHeight=64

generalMove = function (self, player, screen)
--basic movement logic
--[[
	if screen.isMovingX then
		self.image.x = self.x - (screen.offsetX+1) * tileWidth -screen.offsetPx	
	end
	if screen.isMovingY then
		self.image.y = self.y - (screen.offsetY+1) * tileHeight - screen.offsetPy	
	end]]
	self.image.x = self.x - (screen.offsetX+1) * tileWidth - screen.offsetPx
	self.image.y = self.y - (screen.offsetY+1) * tileHeight - screen.offsetPy
end


--	expecting the third parameter box as a table {x, y, (tileWidth, tileHeight)}
--	function will take x, y and a box, return boolean value of whether the point is inside of the box
inBox = function(x,y,box)
	local tw = box.tileWidth or tileWidth
	local th = box.tileHeight or tileHeight
	if x >= box.x and x <= box.x+tw and y >=box.y and y<=box.y+th then	-- case that the point is inside the box
		return true
	end
	return false
end

-- 	The structure of an input box should be {x = XX, y = XX, tileWidth = XX, tileHeight = XX}
--	The function will return the relative position of box2
--	The structure of the return value will be {isOverlapping,isColliding,overlappingbox}
isColliding = function (box1, box2)
	local x1 = box1["x"]
	local y1 = box1["y"]
	local x2 = box2["x"]
	local y2 = box2["y"]
	local tileWidth1 = box1["tileWidth"] or tileWidth
	local tileHeight1 = box1["tileHeight"] or tileHeight
	local tileWidth2 = box2["tileWidth"] or tileWidth
	local tileHeight2 = box2["tileHeight"] or tileHeight
		
	local result = {}
	
	--	if the two boxes are not colliding, return the result
	if 	x1 + tileWidth1 < x2 or
		x1 > x2 + tileWidth2 or
		y1 + tileHeight1 < y2 or
		y1 > y2 + tileHeight2 or
		(x1+tileWidth1 == x2 and y1+tileHeight1 == y2) or
		(x1+tileWidth1 == x2 and y1 == y2+tileHeight2) or
		(x1 == x2+tileWidth2 and y1+tileHeight1 == y2) or
		(x1 == x2+tileWidth2 and y1 == y2+tileHeight1) then
		result.isColliding = false
		result.isOverlapping = false
		return result
	end
	
	--	now check the overlapping by checking four apices of box2 to see if its in the box1 ---NOT NEEDED
	--	there would be one more case that none of four apices of box2 is in box1 yet they still collide, that is box2 is larger than box1 and covers box1 ---NOT NEEDED
	
	--	there must be a collision now! (Justify it?)
	--	the offsetx(ox) and offsety(oy) is calculated by the top left apex of the two boxes. The dx and dy is calculated by ox and oy ---OBSOLETE
	--	will return the box of the overlapped region
	
	result.isColliding = true
	result.isOverlapping = true

	--	check four apices in order to generate the overlapped rectangle
	if inBox(x2,y2,box1) then -- topleft
		if x2 == x1+tileWidth1 or y2 == y1+tileHeight1 then
			result.isOverlapping = false
		else
		--	building up the overlappingbox
			result.box = {}
			result.box.x = x2
			result.box.y = y2
			result.box.tileHeight = math.min(y1+tileHeight1-y2,tileHeight2)
			result.box.tileWidth = math.min(x1+tileWidth1-x2, tileWidth2)
		end
	elseif inBox(x2,y2+tileHeight2,box1) then --bottom left
		if x2 == x1+tileWidth1 or y2+tileHeight2 == y1 then
			result.isOverlapping = false
		else
		--	building up the overlappingbox
			result.box = {}
			result.box.x = x2
			result.box.y = math.max(y1,y2)
			result.box.tileHeight = y2+tileHeight2 - result.box.y
			result.box.tileWidth = math.min(tileWidth2, x1+tileWidth1-x2)
		end
	elseif inBox(x2+tileWidth2,y2,box1) then --topright
		if x2+tileWidth2 == x1 or y2 == y1+tileHeight1 then
			result.isOverlapping = false
		else
		--	building up the overlappingbox
			result.box = {}
			result.box.x = math.max(x1,x2)
			result.box.y = y2
			result.box.tileHeight = math.min(y1+tileHeight1-y2,tileHeight2)
			result.box.tileWidth = x2+tileWidth2 - result.box.x
		end
	elseif inBox(x2+tileWidth2,y2+tileHeight2,box1) then --bottom right
		if x2+tileWidth2 == x1 or y2+tileHeight2 == y1 then
			result.isOverlapping = false
		else
		--	building up the overlappingbox
			result.box = {}
			result.box.x = math.max(x1,x2)
			result.box.y = math.max(y1,y2)
			result.box.tileHeight = y2+tileHeight2 - result.box.y
			result.box.tileWidth = x2+tileWidth2 - result.box.x
		end
	else
	--	box1 is contained by the box2
		result.box={}
		result.box.x = x1
		result.box.y = y1
		result.box.tileWidth = tileWidth1
		result.box.tileHeight = tileHeight1
	end
	return result
end

generalCollide = function (self, player, screen)
	--	if the player is dead, no need to collide
	if player.status == "dead" then return end
	local c = isColliding({x=self.x,y=self.y},{x=player.x,y=player.y})
	--	if the the player's box is not colliding with the tile box, should not perform a collision
	--	later may use different collision boxes for different purpose
	if c.isColliding == false then return end
		
--	print(string.format("x=%f, y=%f, px=%f, py=%f, ix=%f, iy=%f, pix=%f, piy=%f",self.x,self.y,player.x,player.y,self.image.x,self.image.y,player.image.x,player.image.y),screen.offsetPx,screen.offsetPy,c.isColliding,c.isOverlapping,player.status)


	local ctype = "" --collision type	
	
	-- handling overlap:
	-- check if four apices of the player's box are in the tile box. If so, bounce the player outside
	if c.isOverlapping then
		-- bounce back policy: if overlap the upper half, bounce up, if overlap the lower half, bounce down
							-- if overlap the left half, bounce left, if overlap the right half, bounce left.
							
		-- For general use, the overlapping region could be inside the box
		-- But for this specific situation, we would assume that the overlapping part always have at least one edge
		local xEdge = false
		local yEdge = false
		if c.box.x==self.x or c.box.x+c.box.tileWidth == self.x+tileWidth then
			xEdge = true
		end
		if c.box.y == self.y or c.box.y+c.box.tileHeight == self.y + tileHeight then
			yEdge = true
		end
		
		--	decide the collision senario based on which edge(s) are overlapping
		if xEdge then
			if yEdge and c.box.tileWidth > c.box.tileHeight then
				-- bounce y edge
				if c.box.y == self.y then
					print("bounce player up",self.x,self.y,player.x,player.y,player.status,player.speedY*player.directionY)
					ctype = "player up"
					player.y = player.y - c.box.tileHeight
					player.image.y = player.image.y - c.box.tileHeight
				else
					print("bounce player down",self.x,self.y,player.x,player.y,player.status,player.speedY*player.directionY)
					ctype = "player down"
					player.y = player.y + c.box.tileHeight
					player.image.y = player.image.y + c.box.tileHeight
				end
			else
				-- bounce x edge
				if c.box.x == self.x then
					print("bounce player left",self.x,self.y,player.x,player.y,player.status,player.speedX*player.directionX)
					ctype = "player left"
					player.x = player.x - c.box.tileWidth
					player.image.x = player.image.x - c.box.tileWidth
				else
					print("bounce player right",self.x,self.y,player.x,player.y,player.status,player.speedX*player.directionX)
					ctype = "player right"
					player.x = player.x + c.box.tileWidth
					player.image.x = player.image.x + c.box.tileWidth
				end
			end
		-- do not need to handle conflict here
		elseif yEdge then
			-- bounce y edge
			if c.box.y == self.y then
				print("bounce player up",self.x,self.y,player.x,player.y,player.status)
				ctype = "player up"
				player.y = player.y - c.box.tileHeight
				player.image.y = player.image.y - c.box.tileHeight
			else
				print("bounce player down",self.x,self.y,player.x,player.y,player.status)
				ctype = "player down"
				player.y = player.y + c.box.tileHeight
				player.image.y = player.image.y + c.box.tileHeight
			end
		end
		
	else	-- case that is colliding but not overlapping
		if player.y+tileHeight == self.y then ctype="player up"
		elseif player.y == self.y+tileHeight then ctype="player down"
		elseif player.x+tileWidth==self.x then ctype="player left"
		elseif player.x == self.x+tileWidth then ctype="player right"
		end
	end
		
	-- handle collision type accordingly
	if ctype == "player up" and player.speedY*player.directionY>0 then
		print("player up",player.directionX,player.directionY,player.speedX,player.speedY,player.status,player.x,player.y,self.x,self.y,player.image.x,player.image.y,self.image.x,self.image.y)
		--	situation that the player is above the tile
		--	if the player is sticking or falling, the tile will support the player, can change its status back to run
		--	else, nothing would happen
		if player.status == "fall" or player.status == "stick" then
			player.status = "run"
			player.directionY = 0
		--	player.speedX = player.standardX
			player.speedX = math.max(player.standardX, player.speedX)
			
			--	reset player sprite
			local x = player.image.x
			local y = player.image.y
			player.image:removeSelf()
			if player.directionX * player.speedX >=0 then
				player.image=display.newSprite(player.imageSheet, player.sequenceData["runright"])
				player.currentSprite = "runright"
			else
				player.image = display.newSprite(player.imageSheet, player.sequenceData["runleft"])
				player.currentSprite = "runleft"
			end
			player.image.x = x
			player.image.y = y
			player.image:play()
			
			
			--	jump caching
			if player.lastTouchBegan and system.getTimer() - player.lastTouchBegan.time > 0 and system.getTimer() - player.lastTouchBegan.time < 250 then
				print("-----------------perform jump caching", player.lastTouchBegan.phase,player.lastTouchBegan.name,player.lastTouchBegan.time,system.getTimer())
				if player.lastTouchEnded and player.lastTouchEnded.time - player.lastTouchBegan.time > 0 then
					player.lastTouchEnded.time = player.lastTouchEnded.time + system.getTimer() - player.lastTouchBegan.time
					player.lastTouchEnded.caching = true
					print("--------perform jump caching, jump ended", player.lastTouchEnded.phase,player.lastTouchEnded.name,player.lastTouchEnded.time,player.lastTouchEnded.caching)
					player.lastTouchBegan.time = system.getTimer()
					player.touchFunc(player.lastTouchBegan)
					player.touchFunc(player.lastTouchEnded)
				else
					player.lastTouchBegan.time = system.getTimer()
					player.touchFunc(player.lastTouchBegan)
				end
			end
		end
		print("end up",player.directionX,player.directionY,player.speedX,player.speedY,player.status,player.x,player.y,player.image.x,player.image.y,self.x,self.y)
	elseif ctype == "player down" and player.speedY*player.directionY<0 then
		--	situation that the player is underneath the tile
		--	if the player is jumping towards the tile, it will be bounced back
		if player.status == "jump" then
			player.directionY = 0 - player.directionY
			player.status = "fall"
		end
	elseif ctype == "player left" and player.speedX*player.directionX>0 then
--		print("player left",player.image.x, self.image.x,player.image.y,self.image.y,player.directionX,player.directionY,player.speedX,player.speedY,player.status)
		--	situation that the player is at the left side of the tile
		--	if the player is running towards the tile, it should be bounced back
		--	if the player is jumping or falling towards the tile, it should stick the tile and slide
		--	otherwise, nothing would happen
		if player.status == "fall" or player.status == "jump" then
			--	when sticking, a temp speed is saved so when the player is jump from stick, it will receive a speed boosts
			player.count = 0
			player.status = "stick"
			player.tempSx = player.speedX
			player.speedX = 0
			player.speedY = player.standardY/2
			player.directionY = 1
			--	reset player sprite
			local y = player.image.y
			player.image:removeSelf()
			player.image = display.newSprite(player.imageSheet, player.sequenceData["stickright"])
			player.image.x = self.image.x - tileWidth
			player.x = self.x - tileWidth
			player.image.y = y
			player.image:play()
			player.currentSprite = "stickright"
			
			
			--	jump caching
			if player.lastTouchBegan and system.getTimer() - player.lastTouchBegan.time > 0 and system.getTimer() - player.lastTouchBegan.time < 250 then
				print("-----------------perform jump caching", player.lastTouchBegan.phase,player.lastTouchBegan.name,player.lastTouchBegan.time,system.getTimer())
				if player.lastTouchEnded and player.lastTouchEnded.time - player.lastTouchBegan.time > 0 then
					player.lastTouchEnded.time = player.lastTouchEnded.time + system.getTimer() - player.lastTouchBegan.time
					player.lastTouchEnded.caching = true
					print("--------perform jump caching, jump ended", player.lastTouchEnded.phase,player.lastTouchEnded.name,player.lastTouchEnded.time,player.lastTouchEnded.caching)
					player.lastTouchBegan.time = system.getTimer()
					player.touchFunc(player.lastTouchBegan)
					player.touchFunc(player.lastTouchEnded)
				else
					player.lastTouchBegan.time = system.getTimer()
					player.touchFunc(player.lastTouchBegan)
				end
			end
		elseif player.status == "stick" then
			player.speedX = 0
		elseif player.status == "run" then
			player.directionX = player.directionX * -1
			--	reset player sprite
			local x = player.image.x
			local y = player.image.y
			player.image:removeSelf()
			player.image = display.newSprite(player.imageSheet, player.sequenceData["runleft"])
			player.image.x = x
			player.image.y = y
			player.image:play()
			player.currentSprite = "runleft"
			--	v3.1.1 <revoked>
		--	player.speedX = (player.speedX+player.standardX)/2
		end
		print("end left",player.x,player.y,self.x,self.y,player.directionX,player.directionY,player.speedX,player.speedY,player.status)
	elseif ctype == "player right" and player.speedX*player.directionX<0 then
--		print("player right",player.x,self.x,player.y,self.y,player.image.x, self.image.x,player.image.y,self.image.y,player.directionX,player.directionY,player.speedX,player.speedY,player.status)
		--	situation that the player is at the right side of the tile
		--	same as above
		if player.status == "fall" or player.status == "jump" then
			--	when sticking, a temp speed is saved so when the player is jump from stick, it will receive a speed boosts
			player.count = 0
			player.status = "stick"
			player.tempSx = player.speedX
			player.speedX = 0
			player.speedY = player.standardY/2
			player.directionY = 1
			--	reset player sprite
			local y = player.image.y
			player.image:removeSelf()
			player.image = display.newSprite(player.imageSheet, player.sequenceData["stickleft"])
			player.image.x = self.image.x + tileWidth
			player.x = self.x + tileWidth
			player.image.y = y
			player.image:play()
			player.currentSprite = "stickleft"
			
			
			--	jump caching
			if player.lastTouchBegan and system.getTimer() - player.lastTouchBegan.time > 0 and system.getTimer() - player.lastTouchBegan.time < 250 then
				print("-----------------perform jump caching", player.lastTouchBegan.phase,player.lastTouchBegan.name,player.lastTouchBegan.time,system.getTimer())
				if player.lastTouchEnded and player.lastTouchEnded.time - player.lastTouchBegan.time > 0 then
					player.lastTouchEnded.time = player.lastTouchEnded.time + system.getTimer() - player.lastTouchBegan.time
					player.lastTouchEnded.caching = true
					print("--------perform jump caching, jump ended", player.lastTouchEnded.phase,player.lastTouchEnded.name,player.lastTouchEnded.time,player.lastTouchEnded.caching)
					player.lastTouchBegan.time = system.getTimer()
					player.touchFunc(player.lastTouchBegan)
					player.touchFunc(player.lastTouchEnded)
				else
					player.lastTouchBegan.time = system.getTimer()
					player.touchFunc(player.lastTouchBegan)
				end
			end
		elseif player.status == "stick" then
			player.speedX = 0
		elseif player.status == "run" then
			player.directionX = player.directionX * -1
			--	reset player sprite
			local x = player.image.x
			local y = player.image.y
			player.image:removeSelf()
			player.image = display.newSprite(player.imageSheet, player.sequenceData["runright"])
			player.image.x = x
			player.image.y = y
			player.image:play()
			player.currentSprite = "runright"
			--	v3.1.1 <revoked>
		--	player.speedX = (player.speedX+player.standardX)/2
		end
		print("end right",player.x,player.y,self.x,self.y,player.directionX,player.directionY,player.speedX,player.speedY,player.status)
	end
end


playerMove = function (self, player, screen)
		--print(player.status, player.count, player.x, player.y, player.image.x, player.image.y,player.speedX*player.directionX,player.speedY*player.directionY,screen.isMoving)
	--	print(player.status, player.x, player.image.x, player.y, player.image.y,screen.offsetX,screen.offsetY,player.speedX*player.directionX,player.speedY*player.directionY)
	if self.status == "run" then		
		--	Origin
		--self.speedX = self.speedX + 0.01 * (self.standardX or self.speedX)
		
		--	accumulative speed up
		self.speedX = self.speedX*(1+math.min(math.pow((self.speedX * self.speedX /self.standardX / self.standardY/200),2),0.25)+0.001)
		--	max speed
		if self.speedX > 50 then self.speedX = 50 end
	elseif self.status == "stick" then
		self.tempSx = math.max(0, self.tempSx * (1- 1/self.standardX))
	elseif self.status == "jump" then
		--	messy jump

		--	jumpspeed is the gravity value
		self.speedY = self.speedY + self.jumpSpeed * self.directionY
		
		--	resistance could be turned off
		if true then
			if self.speedX~=0 or self.speedY~=0 then
				local tx = self.speedX / (self.speedX+self.speedY)
				local ty = self.speedY / (self.speedY + self.speedX)
				local resistance = 0
				--	resistance value will change according to the current total speed
				if self.speedX*self.speedX+self.speedY*self.speedY < (self.standardX*self.standardX+self.standardY*self.standardY)*2 then
					resistance = 0
				elseif self.speedX*self.speedX+self.speedY*self.speedY < (self.standardX*self.standardX+self.standardY*self.standardY)*3 then
					resistance = 0.05
				else
					resistance = 0.1
				end
				self.speedX = self.speedX * (1 - resistance*tx)
				self.speedY = self.speedY * (1- resistance*ty)
			end
		--	print(t1,t2,tx,ty)
		--	print(resistance)
		end
			
	--	print (self.speedY,self.directionY)
		if self.speedY < 0 then
			self.directionY = 1
			self.speedY = math.abs(self.speedY)
			self.status = "fall"
		end 
		
	--	added case for new jump functionality
	--	fall should perform the symmentrical movement of jump
	elseif self.status == "fall" then
		--self.speedY = self.speedY + self.jumpSpeed
		self.speedY = self.speedY + math.min(self.speedY*500/self.standardY*self.jumpSpeed * self.directionY+0.2,self.jumpSpeed * self.directionY)
		
		if true then
			if self.speedX~=0 or self.speedY~=0 then
				local tx = self.speedX / (self.speedX+self.speedY)
				local ty = self.speedY / (self.speedY + self.speedX)
				local resistance = 0
				if self.speedX*self.speedX+self.speedY*self.speedY < (self.standardX*self.standardX+self.standardY*self.standardY)*2 then
					resistance = 0
				elseif self.speedX*self.speedX+self.speedY*self.speedY < (self.standardX*self.standardX+self.standardY*self.standardY)*3 then
					resistance = 0.05
				else
					resistance = 0.1
				end
				self.speedX = self.speedX * (1 - resistance*tx)
				self.speedY = self.speedY * (1- resistance*ty)
			end
		--	print(t1,t2,tx,ty)
		--	print(resistance)
		end
		
	--	print (self.speedY)
	elseif self.status == "dead" then
		self.speedX = 0
		self.speedY = 0
		self.image:pause()
		return
	end
	
--	print("before",self.x, self.y,self.directionX,self.speedX,self.standardX,self.directionY,self.speedY,self.standardY,self.x+self.directionX*self.speedX,self.y+self.directionY*self.speedY)
	self.x = self.x + self.directionX * self.speedX
	self.y = self.y + self.directionY * self.speedY

	
	self.image.x = self.x - (screen.offsetX+1) * tileWidth - screen.offsetPx
	self.image.y = self.y - (screen.offsetY+1) * tileHeight - screen.offsetPy
end
