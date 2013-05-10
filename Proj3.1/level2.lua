require("map")

-- count by index
mapWidth=25
mapHeight=15

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
iv.map["tile"][1] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][2] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][3] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][4] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][5] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][6] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][7] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][8] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][9] ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][10]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][11]={1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][12]={0,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
iv.map["tile"][13]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][14]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][15]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

iv.map["image"]={}
iv.map["image"][1] = {name = "grassland", start = 1, count = 1, time=5000, loopCount = 1}
iv.map["image"][2] = {name = "wall", start = 2, count = 1, time=5000, loopCount = 1}
--iv.map["image"][3] = {name = "badguy", start = 3, count = 1, time=5000, loopCount = 1}

iv.map["object"] = {}
iv.map["object"][1] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][2] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][3] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][4] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][5] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][6] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][7] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][8] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][9] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,9}
iv.map["object"][10]= {0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][11]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,9}
iv.map["object"][12]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][13]= {0,0,0,0,0,0,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][14]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][15]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

iv.map["object"]["behavior"] = {}
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
												self.image.x = -10
												self.image.y = -10
												player.score = player.score + 500
												--screen[self.y-screen.offsetY][self.x-screen.offsetX]=0
												--screen[][self.y]=0
												print(" coin collected", player.score)
											end
										end,}


iv.map["object"]["behavior"][8] = {	imgSeq = {start = 1, count = 1, time=5000, loopCount = 1},
										img="images/coin.png",
										directionX = 0,
										directionY = 0,
										speedX = 0,
										speedY = 0,
										isVisible=true,
										move = generalMove,
										collide = function(self, player, screen, isGhost)
											local result = isColliding({x=self.x,y=self.y,tileWidth=64,tileHeight=64},{x=player.x,y=player.y})
												-- print(" *****************coin collected**********************************",result.isColliding)
											if result.isColliding==true and not isGhost then
												self.isVisible=false

												self.x = -10
												self.y = -10
												self.image.x = -10
												self.image.y = -10
												player.score = player.score + 1000

												 --print(" *****************coin collected******************************")
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
											local result = isColliding({x=self.x,y=self.y},{x=player.x,y=player.y})
										--	print(result, result.isColliding, result.isOverlapping)
											if result.isColliding==true then
												player.status = "dead"
												print("colliding obj")
											end
										end,}


return iv



