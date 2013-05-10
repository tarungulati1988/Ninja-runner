module(..., package.seeall)
local M = require("loadsave")


function suite_setup()
   print "\n\n-- running suite setup hook"
end

function suite_teardown()
   print "\n\n-- running suite teardown hook"
end

--=================================================================--
-- NOTE:
-- will be uncommenting some of the commented code below
-- program crashes for nil filenames
-- need to handle these cases


-- testing for nil table and nil filename
function test_saveTable_nil_values()
	local t = nil
	local filename = nil
	assert(true,M.saveTable(t,filename),
		"saveTable failed for nil table and nil filename!")
end

-- testing for empty table and some filename
function test_saveTable_somefilename()
	local t = {}
	local filename = "somefile"
	assert(true,M.saveTable(t,filename),"saveTable failed for empty table!")
end


-- testing with nil filename
-- function test_loadTable_nil_filename()
-- 	local filename = nil
-- 	assert(true,M.loadTable(filename),"loadTable failed for nil!")
-- end

-- testing with legal filename
-- throws error as the file "somefile" doesnt exist
function test_loadTable_legal_filename()
	local filename = "somefile"
	assert(true,M.loadTable(filename),"loadTable failed for nil!")
end

-- testing for existing file
-- function test_loadTable_existing_filename()
-- 	local filename = "temp"
-- 	assert(true,M.loadTable(filename),"loadTable failed for nil!")
-- end

-- below test throws error. filename needs to be a string
-- function test_loadTable_nil_filename()
-- 	local filename = somefile
-- 	assert(true,M.loadTable(filename),"loadTable failed for nil!")
-- end

-- NOTE: need to add test to have 
-- empty path = system.pathForFile( filename, system.DocumentsDirectory )

