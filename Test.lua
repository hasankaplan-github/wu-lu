
local conditions = require( "wu-lu.Feature.Conditions" )
local forecast10Day = require( "wu-lu.Feature.Forecast10Day" )

local conditionsData = conditions:GetFeatureData( nil )
local simpleForecastDayData = forecast10Day:GetSimpleForecastDay( 2016, 2, 1, nil )

if( conditionsData ~= nil )
then
    print( conditionsData.current_observation.observation_time )
    print( conditionsData.current_observation.local_time_rfc822 )
end

if( simpleForecastDayData ~= nil )
then
    print( simpleForecastDayData.high.celsius )
end
