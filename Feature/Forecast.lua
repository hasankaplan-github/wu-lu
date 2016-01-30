local this = {  }

---[[ Requirements
local Utility   = require( "wu-lu.Utility" )
local base      = require( "wu-lu.Feature.Base" )
--]]

---[[ Inheritance
Utility.SetBaseTable( this, base )
--]]

---[[ Private Fields
--]]

---[[ Public Properties
this.FeatureKey = ( ... )
--]]

---[[ Private Functions
--]]

---[[ Public Functions
function 
this:GetSimpleForecastDay( year, month, day, forceUpdate )
    local retVal = nil
    local featureData = self:GetFeatureData( forceUpdate )
    local simpleForecastDays = featureData and featureData.forecast and featureData.forecast.simpleforecast.forecastday or {  }
    
    for _, simpleForecastDay in ipairs( simpleForecastDays )
    do
        local sfdYear = simpleForecastDay.date.year
        local sfdMonth = simpleForecastDay.date.month
        local sfdDay = simpleForecastDay.date.day

        if ( sfdDay == day
            and sfdMonth == month
            and sfdYear == year )
        then
            retVal = simpleForecastDay
            break
        end
    end
   
    return retVal
end

function 
this:GetAllSimpleForecastDays( forceUpdate )
    local featureData = self:GetFeatureData( forceUpdate )
    local simpleForecastDays = featureData and featureData.forecast and featureData.forecast.simpleforecast.forecastday or { }
        
    if ( #simpleForecastDays < 1 )
    then
        simpleForecastDays = nil
    end
    
    return simpleForecastDays
end
--]]

---[[ Static Functions
--]]

---[[ Initialization
this:Register(  )
--]]

return this