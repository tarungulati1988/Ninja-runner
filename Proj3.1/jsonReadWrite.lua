--[[
--	"jsonReadWrite.lua"
--	read and write functions for json files for properties file implementation
--
]]

local json = require("json")

function writeJson(table, filepath)
	--print("....",filepath)
	--print("........",table[2].title)
	local path = system.pathForFile( filepath, system.DocumentsDirectory)
	local file2 = io.open(path, "w")
	--print('filepath is ',path)
	local writeTable = json.encode(table)
	file2:write(writeTable)
	io.close(file2)
end

function readJson(filepath)
	local path = system.pathForFile( filepath, system.DocumentsDirectory)
	local file = io.open( path, "r" )
	--print("spock hi5.... ", path)
	--print("yabbbaa dabba dooooooo  ", file)
	if file then
	    local contents = file:read("*all")
	    local readTable = json.decode(contents)
		io.close( file )
	    --print("may the force be with you!!!  ", readTable.gamestatistics.coins.Coinsavailable)
	    return readTable
	else
		print("file not found!!!")
		return readTable
	end
end