local this = {  }

---[[ Requirements
local Utility = require( "wu-lu.Utility" )
--]]

---[[ Inheritance
--]]

---[[ Private Fields
local configurationPath = "wu-lu/"
--]]

---[[ Public Properties
--]]

---[[ Private Functions
--]]

---[[ Public Functions
function this:LoadConfiguration ( isProd )
    local prefix = isProd and "~/.config/" or "./"
    configurationPath = prefix .. configurationPath 
    local fileName = "Config.json"
    local data = Utility.JsonLoad( configurationPath, fileName ) 
    if( data ) then
        for k,v in pairs( data ) do 
            self[ k ] = v
        end
    end
    
    return self
end
--]]

---[[ Static Functions
--]]

---[[ Initialization
this:LoadConfiguration( false )
--]]

return this
