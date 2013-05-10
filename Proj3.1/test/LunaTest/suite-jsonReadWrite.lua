module(..., package.seeall)
local M = require("jsonReadWrite")


function suite_setup()
   print "\n\n-- running suite setup hook"
end

function suite_teardown()
   print "\n\n-- running suite teardown hook"
end

--=================================================================--
-- NOTE: need to implement error handling for nil filenames

-- tests fail & throws errors
-- if the filename is not a string

-- testing for nil table and nil filename
-- crashes for nil values.. need to have some error handling
-- function test_writeJson_nil_values()
-- 	local table = nil
-- 	local filename = nil
-- 	assert(true,writeJson(t,filename),"saveTable failed for nil!")
-- end


-- testing for empty table and legal filename
function test_writeJson_empty_table()
	local table = {}
	local filename = "somefile"
	assert(true,writeJson(t,filename),"saveTable failed!")
end


-- testing for nil table and nil filename
function test_readJson()
	local filepath="somepath"
	local filename = filepath
	assert(true,readJson(filename),"loadTable failed for nil!")
end

