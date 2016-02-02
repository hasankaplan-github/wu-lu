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
this:GetHourlyForecast( year, month, day, hour, forceUpdate )
    local epoch = os.time{ year = year, month = month, day = day, hour = hour }
    local retVal = nil
    local featureData = self:GetFeatureData( forceUpdate )
    
    for _, hourlyForecast in ipairs( featureData.hourly_forecast )
    do    
        if ( tonumber( hourlyForecast.FCTTIME.epoch ) == epoch )
        then
            retVal = hourlyForecast
            break
        end
    end
    
    return retVal
end

function 
this:GetAllHourlyForecastsForDay( year, month, day, forceUpdate )
    local allHourlyForecastsForDay = {  }
    local featureData = self:GetFeatureData( forceUpdate )

    for _, hourlyForecast in ipairs( featureData.hourly_forecast )
    do    
        if( tonumber( hourlyForecast.FCTTIME.mday ) == day
            and tonumber( hourlyForecast.FCTTIME.mon ) == month 
            and tonumber( hourlyForecast.FCTTIME.year ) == year )
        then
            allHourlyForecastsForDay[ #allHourlyForecastsForDay + 1 ] = hourlyForecast
            break
        end
    end
    
    if ( Utility.IsEmpty( allHourlyForecastsForDay ) )
    then
        allHourlyForecastsForDay = nil
    end
    
    return allHourlyForecastsForDay
end
--]]

---[[ Static Functions
--]]

---[[ Initialization
this:Register(  )
--]]

return this