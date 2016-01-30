-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------
local M = {  }

---[[ Requirements
local json =        require( "json" )
local socket =      require( "socket" )
local socketHttp =  require( "socket.http" )
--]]

---[[ Public Functions 
-----------------------------------------------------------------------------
--  Converts (decodes) json data to a lua table. 
--  Depends on 'json' library. 
--  Static function.
--
--  @param jsonData         [string] json data to convert (decode.)
--  @return                 [lua table] converted (decoded) lua table from json data.
-----------------------------------------------------------------------------
function M.ConvertJsonToLuaTable ( jsonData )
    local luaTableData = json.decode( jsonData )
    return luaTableData
end

-----------------------------------------------------------------------------
--  Converts (encodes) lua table to json data. 
--  Depends on 'json' library. 
--  Static function.
--
--  @param luaTableData     [lua table] lua table variable to convert (encode.)
--  @return                 [string] converted (encoded) json data from lua table.
-----------------------------------------------------------------------------
function M.ConvertLuaTableToJson ( luaTableData )
    local jsonData = json.encode( luaTableData )
    return jsonData
end

function M.JsonLoad ( filePath, fileName )
    local firstChar = string.sub( filePath, 1, 1 )
    if ( firstChar == "~" )
    then
        filePath = os.getenv("HOME") .. string.sub( filePath, 2 )
    end
    local fullFileName = ( filePath or "" ) .. ( fileName or "" )
    
    local luaTable = nil
    local jsonFile = M.ReadDataFile( filePath, fileName ) 
    if ( jsonFile )
    then
        luaTable = M.ConvertJsonToLuaTable( jsonFile )
    end
    
    return luaTable
end

function M.ReadDataFile ( filePath, fileName )
    local firstChar = string.sub( filePath, 1, 1 )
    if ( firstChar == "~" )
    then
        filePath = os.getenv("HOME") .. string.sub( filePath, 2 )
    end

    local fullFileName = ( filePath or "" ) .. ( fileName or "" )
    local dataFile = io.open( fullFileName, "rb" )
    local dataContent = nil
    if ( dataFile ) 
    then
        dataContent = dataFile:read( "*all" )
        dataFile:close(  )
    end  

    return dataContent 
end

function M.WriteDataFile ( filePath, fileName, contentToWrite )
    local fullFileName = ( filePath or "" ) .. ( fileName or "" )
    if ( contentToWrite )
    then
        local dataFile = io.open( fullFileName, "w" )
        dataFile:write( contentToWrite )
        dataFile:close(  )
    end
end

function M.DownloadFile( url, filePath, fileName )  
    local isSuccessful, content = pcall( socketHttp.request, url )
    if ( isSuccessful )
    then
        isSuccessful = pcall( M.WriteDataFile, filePath, fileName, content )
    end
    
    return isSuccessful
end

function M.GetValue ( allData, field )
    local value = allData
    if ( allData  and field )
    then
        for w in string.gmatch(field, "[%w_]+") 
        do
            value = value[w]
            if ( not value )
            then -- there is no such filed, break loop and return nil
                break
            end
        end
    end

    return value
end

function M.Sleep ( seconds )
    --socket.select( nil, nil, seconds )
    socket.sleep( seconds )
end

function M.SetBaseTable ( childTable, baseTable )
    local inheritanceMt = {  }
    inheritanceMt.__index = baseTable
    inheritanceMt.__newindex = function (t, k, v)
        if ( baseTable[ k ] ~= nil and type( v ) ~= "function" ) then
            baseTable[ k ] = v
        else
            rawset( t, k, v )
        end
    end
    setmetatable( childTable, inheritanceMt )
end

--]]

---[[ Finalization
return M
--]]