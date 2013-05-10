-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Your code here

local file1 = "gamestat_properties.json";
local loadsave = require("loadsave");
local json = require("json")

		
local t1 = display.newText( "File Contents", 0, 0, "Constantia-Bold", 36 )
t1.x, t1.y = display.contentCenterX, 70

print(loadsave)

local ylast = 120
local myTable = loadsave.loadTable(file1)
for k,v in pairs(myTable)do
	print(k,v)
	
	
	for obj=1,#v  do
		
		for key,value in pairs(v[obj]) do
			print(key,value)
			local xlast = 15
			local ti = display.newText( key, xlast, ylast, nil, 24 ); 
			xlast = xlast + 250
			local t = display.newText( value, xlast, ylast, nil, 24 );
			t:setTextColor( 255, 255, 255 );	
			ylast = ylast + 30
		end
		ylast = ylast + 30
	end
end
