require("map")

-- count by index
mapWidth=50
mapHeight=18

-- count by pixels
tileWidth=64
tileHeight=64

local iv={}
iv.sheet = "images/game-tiles.png"
iv.options = {width = 64, height = 64, numFrames = 8}
iv.tileWidth = tileWidth
iv.tileHeight = tileHeight
iv.mapWidth = mapWidth
iv.mapHeight = mapHeight


iv.map={}

iv.map["tile"] = {}

iv.map["tile"][1] ={2,2,2,2,2,2,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][2] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][3] ={2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][4] ={2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][5] ={2,2,2,2,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0}
iv.map["tile"][6] ={0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][7] ={0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][8] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0}
iv.map["tile"][9] ={0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0}
iv.map["tile"][10]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][11] ={0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][12]={0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,0,0,0,0,0,0}
iv.map["tile"][13]={2,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][14]={2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][15]={2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][16] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][17]={2,0,0,0,2,2,2,2,2,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][18]={1,1,1,1,0,0,0,0,2,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1}
iv.map["tile"][19] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][20] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

iv.map["image"]={}
iv.map["image"][1] = {name = "grassland", start = 1, count = 1, time=5000, loopCount = 1}
iv.map["image"][2] = {name = "wall", start = 2, count = 1, time=5000, loopCount = 1}
iv.map["image"][3] = {name = "enemy", start = 3, count = 1, time=5000, loopCount = 1}


iv.map["object"] = {}
					   
iv.map["object"][1] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][2] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][3] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][4] = {0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][5] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,7,0,7,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][6] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,7,0,7,7,7,0,0,7,0,0,0,0,0,9}
iv.map["object"][7] = {0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][8] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][9] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][10]= {9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][11]= {9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][12]= {9,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][13]= {9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][14]= {9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][15]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,3,0,0,9}
iv.map["object"][16]= {9,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][17]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,9}
iv.map["object"][17]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][18]= {0,0,0,0,9,9,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,0,0,0,0,9,9,9,9,9,0,0,0,0,0,0,0,0}
iv.map["object"][19] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][20] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}


iv.map["object"]["behavior"] = {}


iv.map["object"]["behavior"][1] = {	imgSeq = {start = 5, count = 1, time=5000, loopCount = 1},
										directionX = -1,
										directionY = 0,
										speedX = 1,
										speedY = 0,
										move = function(self, player, screen)
											local xOff, yOff = 0, 0
											if self.x > player.x then
												xOff = -1
											elseif self.x < player.x then
												xOff = 1
											end
											
											if self.y > player.y then
												yOff = -1
											elseif self.y < player.y then
												yOff = 1
											end
											self.x = self.x + xOff * 2
											self.y = self.y + yOff * 2
											generalMove(self, player, screen)
										end, 
										collide = function(self, player, screen) 
											local result = isColliding({x=self.x,y=self.y},player:getEnemyBox() or {x=player.x,y=player.y})
											if result.isColliding==true then
												player.status = "dead" 
												print("colliding chasing killer")
											end
										end,}

iv.map["object"]["behavior"][2] = {	imgSeq = {start = 3, count = 1, time=5000, loopCount = 1},
										directionX = -1,
										directionY = 0,
										speedX = 1,
										speedY = 0,
										move = function(self, player, screen)
											if (self.count == nil) then
												self.count = 100
											end
											self.count = self.count - 2
											if (self.count > 75) then
												self.x = self.x + 2
											elseif (self.count > 25) and self.count <= 75 then
												self.x = self.x - 2
											elseif self.count <= 25 and self.count > 0 then
												self.x = self.x + 2
											elseif self.count <= 0 then
												self.count = 100
											end
											generalMove(self, player, screen)
										end, 
										collide = function(self, player, screen) 
											local result = isColliding({x=self.x,y=self.y},player:getEnemyBox() or {x=player.x,y=player.y})
											if result.isColliding==true then
												player.status = "dead" 
												print("colliding killer")
											end
										end
}



iv.map["object"]["behavior"][3] = {	imgSeq = {start = 5, count = 1, time=5000, loopCount = 1},
										directionX = -1,
										directionY = 0,
										speedX = 1,
										speedY = 0,
										move = generalMove,
										collide = function(self, player, screen)
											local result = isColliding({x=self.x,y=self.y},{x=player.x,y=player.y})
										--	print(result, result.isColliding, result.isOverlapping)
											if result.isColliding==true then
												player.status = "victory"
												print("colliding obj")
											end
										end,}

iv.map["object"]["behavior"][7] = {	imgSeq = {start = 7, count = 1, time=5000, loopCount = 1},
										--img="images/coin.png",
										directionX = -1,
										directionY = 0,
										speedX = 1,
										speedY = 0,
										isVisible=true,
										move = generalMove,

										collide = function(self, player, screen, isGhost)
											local result = isColliding({x=self.x,y=self.y},{x=player.x,y=player.y})
				--							print(result, result.isColliding, result.isOverlapping)
											if result.isColliding==true and not isGhost then
												screen.totalPoints=screen.totalPoints+1000
												self.isVisible=false
												self.x = -10
												self.y = -10
												if self.image and self.image.removeSelf then self.image:removeSelf() 
												else
													self.image.x = -10
													self.image.y = -10
												end
											
												print(" coin collected", player.score)
											end
										end,}



iv.map["object"]["behavior"][9] = {	imgSeq = {start =8, count = 1, time=5000, loopCount = 1},
										directionX = -1,
										directionY = 0,
										speedX = 1,
										speedY = 0,
										isVisible=false,
										move = generalMove,
										collide = function(self, player, screen)
											local result = isColliding({x=self.x,y=self.y},player:getEnemyBox() or {x=player.x,y=player.y})
										--	print(result, result.isColliding, result.isOverlapping)
											if result.isColliding==true then
												player.status = "dead"
												print("colliding obj")
											end
										end,}

return iv
