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
iv.map["tile"][6] ={0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][7] ={0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][8] ={0,0,0,0,0,1,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][9] ={0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][10]={0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][11]={0,0,-1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][12]={0,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,0,0,1,1,1,1}
iv.map["tile"][13]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][14]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["tile"][15]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

iv.map["image"]={}
iv.map["image"][1] = {name = "grassland", start = 1, count = 1, time=5000, loopCount = 1}
iv.map["image"][2] = {name = "wall", start = 2, count = 1, time=5000, loopCount = 1}


iv.map["object"] = {}
iv.map["object"][1] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][2] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][3] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][4] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][5] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][6] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][7] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][8] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][9] = {9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][10]= {9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9}
iv.map["object"][11]= {9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,9}
iv.map["object"][12]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][13]= {0,0,0,0,0,0,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
iv.map["object"][14]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,0,0,9,9,9,0,0,0,0}
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
