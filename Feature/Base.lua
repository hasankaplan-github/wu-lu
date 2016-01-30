local this = {  }

---[[ Requirements
local repository = require( "wu-lu.Repository" )
--]]

---[[ Inheritance
--]]

---[[ Private Fields
--]]

---[[ Public Properties
--]]

---[[ Private Functions
--]]

---[[ Public Functions
function 
this:Register ( )
    repository:Register( self.FeatureKey )
end

function 
this:UnRegister (  )
    repository:UnRegister( self.FeatureKey )
end

function 
this:UnRequire ( )    
    package.loaded[ self.FeatureKey ] = nil
    _G[ self.FeatureKey ] = nil
    self:UnRegister(  )
end

function 
this:SetFeatureQuery ( newFeatureQuery )
    repository:SetFeatureQuery( self.FeatureKey, newFeatureQuery )
end

function 
this:GetFeatureData ( forceUpdate )
    local featureData = repository:GetFeatureData( self.FeatureKey, forceUpdate )
    return featureData
end

--]]

---[[ Static Functions
--]]

---[[ Initialization
--]]

return this
