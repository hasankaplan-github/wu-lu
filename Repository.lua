local this = {  }

---[[ Requirements
local Utility       = require( "wu-lu.Utility" )
local configuration = require( "wu-lu.Configuration" )
local UpdateType    = require( "wu-lu.UpdateType" )
--]]

---[[ Inheritance
--]]

---[[ Private Fields
local registeredFeatures = {  }
local urlChanged = false
local weatherDataCache = nil
--]]

---[[ Public Properties
this.LastUpdateEpoch = 0
this.LastUpdateType = ""
this.LastSuccessfulUpdateEpoch = 0
this.LastSuccessfulUpdateType = ""

--]]

---[[ Private Functions
local function 
LoadWeatherData ( self )
    local loadFunction = nil
    local weatherDataFormat = configuration.WeatherDataFormat 
    if ( weatherDataFormat == "rss" or weatherDataFormat == "xml" )
    then
        loadFunction = Utility.XmlLoad
    elseif ( weatherDataFormat == "json" ) 
    then
        loadFunction = Utility.JsonLoad
    end
    
    local isSuccessful, content = pcall( loadFunction, configuration.WeatherDataFilePath, configuration.WeatherDataFileName .. "." .. weatherDataFormat )
    
    if ( isSuccessful )
    then
        isSuccessful = ( content ~= nil )
        if ( isSuccessful )
        then
            weatherDataCache = content
        end
    end    
    
    return isSuccessful
end

local function 
GetRegisteredFeatureQueries ( self )
    local registeredFeatureQueries = {  }

    for registeredFeatureKey, _ in pairs( registeredFeatures )
    do
        local featureQuery = configuration.FeatureProperties[ registeredFeatureKey ].Query
        registeredFeatureQueries[ featureQuery ] = true
    end
    
    return registeredFeatureQueries
end

local function 
GetDownloadUrl ( self )
    local url = configuration.Url
    local apiKey = configuration.ApiKey
    local registeredFeatureQueries = GetRegisteredFeatureQueries( self )
    local weatherLocation = configuration.WeatherLocation
    local weatherDataFormat = configuration.WeatherDataFormat

    local downloadUrl = url .. "/" .. apiKey
    for featureQuery, _ in pairs ( registeredFeatureQueries )
    do
        downloadUrl = downloadUrl .. "/" .. featureQuery
    end
    --downloadUrl = downloadUrl .. "/" .. table.concat( requiredFeatureQueries, "/" )
    downloadUrl = downloadUrl .. "/q/" .. weatherLocation .. "." .. weatherDataFormat

    return downloadUrl
end 

local function 
DownloadWeatherData ( self )
    local url = GetDownloadUrl( self )
    local isSuccessful = Utility.DownloadFile( url, configuration.WeatherDataFilePath, configuration.WeatherDataFileName .. "." .. configuration.WeatherDataFormat )
    return isSuccessful
end

local function 
UpdateWeatherDataFromWeb ( self )
    local isSuccessful = DownloadWeatherData( self )
    if ( isSuccessful ) 
    then
        isSuccessful = LoadWeatherData( self )
    end
        
    return isSuccessful
end

local function 
UpdateWeatherDataFromFile ( self )
    local isSuccessful = LoadWeatherData( self )
    return isSuccessful
end

local function 
GetWeatherData ( self, forceUpdate )
    if ( self:NeedsUpdate( forceUpdate ) )
    then
        self:UpdateWeatherData( forceUpdate )
    end
    
    return weatherDataCache
end

--]]

---[[ Public Functions
function 
this:Register ( featureKey )
    registeredFeatures[ featureKey ] = true
end

function 
this:UnRegister( featureKey )
    registeredFeatures[ featureKey ] = nil
end

function 
this:SetFeatureQuery ( featureKey, newFeatureQuery )
    local currentFeatureQuery = configuration.FeatureProperties[ featureKey ].Query 
    if ( currentFeatureQuery ~= newFeatureQuery )
    then
        configuration.FeatureProperties[ featureKey ].Query = newFeatureQuery
        urlChanged = true
    end
end

function 
this:GetFeatureData ( featureKey, forceUpdate )
    local featureData = {  }
    local dataKeys = configuration.FeatureProperties[ featureKey ].DataKeys
    local weatherData = GetWeatherData( self, forceUpdate )
    for dataKey in string.gmatch( dataKeys, "%S+" ) -- split by space
    do
        local partialData = Utility.GetValue( weatherData, dataKey ) 
        featureData[ dataKey ] = partialData
    end

    if ( #featureData < 1 )
    then
        featureData = nil
    end
    
    return featureData
end

function 
this:NeedsUpdate ( forceUpdate )
    local needsUpdate = false    
    local secondsPassedFromLastUpdate = os.difftime( os.time(), self.LastUpdateEpoch )

    if ( forceUpdate 
        or ( configuration.UpdateInterval > 0 -- other than zero means update enabled
            and ( secondsPassedFromLastUpdate > configuration.UpdateInterval 
                or not weatherDataCache 
                or urlChanged ) ) )
    then
        needsUpdate = true
    end

    return needsUpdate
end

function 
this:UpdateWeatherData ( forceUpdate )
    local currentUpdateOrder = {  }
    local isSuccessful = false
    local isCompleted = false

    if ( forceUpdate ) 
    then
        if ( type( forceUpdate ) == "string" )
        then
            currentUpdateOrder = { forceUpdate }
        elseif ( type( forceUpdate ) == "table" )
        then
            currentUpdateOrder = forceUpdate
        end
    else
        currentUpdateOrder = configuration.UpdateOrder
    end

    if ( currentUpdateOrder )
    then
        for _, currentUpdateType in ipairs( currentUpdateOrder )
        do
            if ( currentUpdateType == UpdateType.FromWeb )
            then
                isCompleted, isSuccessful = pcall( UpdateWeatherDataFromWeb, self )
            elseif ( currentUpdateType == UpdateType.FromFile )
            then
                isCompleted, isSuccessful = pcall( UpdateWeatherDataFromFile, self )
            end

            self.LastUpdateType = currentUpdateType
            self.LastUpdateEpoch = os.time(  )

            if ( isCompleted and isSuccessful )
            then
                -- store last successful update info
                self.LastSuccessfulUpdateType = self.LastUpdateType
                self.LastSuccessfulUpdateEpoch = self.LastUpdateEpoch 
                break
            end
        end
    end

    -- Update completed, reset variables that trigger an update
    urlChanged = false
end
--]]

---[[ Static Functions
--]]

---[[ Initialization
--]]

return this
