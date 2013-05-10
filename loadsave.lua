local M = {}

local json = require( "json" )
 
function M.saveTable( t, filename ) 
    local path = system.pathForFile( filename, system.DocumentsDirectory )
print(path)
    local file = io.open( path, "w" )
    if file then
        local contents = json.encode( t )
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
end
 
function M.loadTable( filename )
    local path = system.pathForFile( filename, system.DocumentsDirectory )
    print(path)
    local contents = ""
    local myTable = {}
    local file = io.open( path, "r" )
    if file then
        local contents = file:read( "*a" )
        myTable = json.decode( contents )
        io.close(file)
        return myTable
    end
    print ("file not found")
    return nil
end

return M