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
this:GetObservationForTime( hour, minute, forceUpdate )
    local epoch = os.time{ year = 2000, month = 1, day = 1, hour = hour, min = minute }
    local previousDataEpoch = 0
    local nextDataEpoch = 0
    local retVal = nil
    local featureData = self:GetFeatureData( forceUpdate )
    local observations = featureData.history.observations or {  }
    
    for _, observation in ipairs( observations )
    do
        local rawObservationEpoch = os.time{ year = 2000, month = 1, day = 1, hour = observation.date.hour, min = observation.date.min }
        if ( rawObservationEpoch < epoch or rawObservationEpoch == epoch )
        then -- exact or previous data
            previousDataEpoch = rawObservationEpoch
            retVal = observation
        elseif ( rawObservationEpoch > epoch )
        then -- next data
            nextDataEpoch = epoch

            local previousDiffEpoch = os.difftime( epoch, previousDataEpoch )
            local nextDiffEpoch = os.difftime( nextDataEpoch, epoch )
            if ( nextDiffEpoch < previousDiffEpoch )
            then -- select closest data
                retVal = observation
            end
            break
        end
    end
    
    return retVal
end
--]]

---[[ Static Functions
--]]

---[[ Initialization
this:Register(  )

-- just set initial query to yesterday
local dayEpoch = 60 * 60 * 24
local currentDateEpoch = os.time( )
local yesterdayEpoch = currentDateEpoch - dayEpoch
this:SetFeatureQuery( "history_" .. os.date( "%Y%m%d", yesterdayEpoch ) )
--]]

return this