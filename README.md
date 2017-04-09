# wu-lu
Wunderground wrapper written in Lua.
Depends on 'lua-socket' and 'json' libraries.

# Usage
I try to make usage very simple. Just add 'require' for which wunderground feature you want to use.
The below lines show 'conditions' feature usage:
```lua
	local conditionsFeature = require( "wu-lu.Feature.Conditions" )
	local conditionsData = conditionsFeature:GetFeatureData()
	
	print( conditionsData.current_observation.observation_time )
	print( conditionsData.current_observation.local_time_rfc822 )
	print( conditionsData.current_observation.temp_c )
```
	
You can take a look at 'Test.lua' file also.
