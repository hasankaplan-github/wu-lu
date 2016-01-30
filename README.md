# wu-lu
Wunderground wrapper written in lua script.
Depends on 'lua-socket' and 'json' libraries.

# Usage
I try to make usage very simple. Just add 'require' for which wunderground feature you want to use.
The below line shows 'conditions' feature usage:

	local conditionsFeature = require( "wu-lu.Feature.Conditions" )
	local conditionsData = conditionsFeature:GetFeatureData()
	
	print( conditionsData.current_observation.observation_time )
	print( conditionsData.current_observation.local_time_rfc822 )
	print( conditionsData.current_observation.temp_c )
	
You can take a look to 'Test.lua' file also.
