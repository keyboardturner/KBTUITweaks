local LibForecast = LibStub:GetLibrary("LibForecast-1.0");
local weather = {};

local WeatherTypesID = CopyTable(LibForecast.WeatherType)

local WeatherTypes = {
	[-1] = "Unknown",
	[0] = "Clear",
	[1] = "Rain",
	[2] = "Snow",
	[3] = "Sandstorm",
	[4] = "Miscellaneous",
};

local currentWeatherType
local currentWeatherIntensity
local currentWeatherName

local function WeatherCounter()
	C_Timer.After(1, WeatherCounter);
	local currentMonth = tonumber(date("%m"))
	local currentDay = tonumber(date("%d"))
	local UIMapID = C_Map.GetBestMapForUnit("player")
	local subZone = GetSubZoneText()
	local zoneName = GetZoneText()
	if GetSubZoneText() == "" then
		subZone = zoneName
	end
	if subZone == nil then
		return
	end
	if zoneName == nil then
		return
	end
	if UIMapID == nil then
		return
	end
	if currentWeatherName == nil then return end
	if currentWeatherIntensity == nil then return end
	if KBTUI_DB["Weather"] == nil then
		KBTUI_DB["Weather"] = {};
	end
	if KBTUI_DB["Weather"][currentMonth] == nil then
		KBTUI_DB["Weather"][currentMonth] = {};
	end
	if KBTUI_DB["Weather"][currentMonth][currentDay] == nil then
		KBTUI_DB["Weather"][currentMonth][currentDay] = {};
	end
	if KBTUI_DB["Weather"][currentMonth][currentDay][UIMapID] == nil then
		KBTUI_DB["Weather"][currentMonth][currentDay][UIMapID] = {
			["ZoneName"] = zoneName
		};
	end
	if KBTUI_DB["Weather"][currentMonth][currentDay][UIMapID][subZone] == nil then
		KBTUI_DB["Weather"][currentMonth][currentDay][UIMapID][subZone] = {};
	end
	if KBTUI_DB["Weather"][currentMonth][currentDay][UIMapID][subZone][currentWeatherName] == nil then
		KBTUI_DB["Weather"][currentMonth][currentDay][UIMapID][subZone][currentWeatherName] = {}
	end
	if KBTUI_DB["Weather"][currentMonth][currentDay][UIMapID][subZone][currentWeatherName][currentWeatherIntensity] == nil then
		KBTUI_DB["Weather"][currentMonth][currentDay][UIMapID][subZone][currentWeatherName][currentWeatherIntensity] = 0
		--print("Adding new entry to " .. subZone)
	else
		KBTUI_DB["Weather"][currentMonth][currentDay][UIMapID][subZone][currentWeatherName][currentWeatherIntensity] = KBTUI_DB["Weather"][currentMonth][currentDay][UIMapID][subZone][currentWeatherName][currentWeatherIntensity] + 1
	end
end

local function GetWeatherStatsForZone(UIMapID, subZone)
	if not KBTUI_DB or not KBTUI_DB["Weather"] or not UIMapID then return "No data available." end

	local totals = {}
	local totalCount = 0

	for month, days in pairs(KBTUI_DB["Weather"]) do
		for day, maps in pairs(days) do
			local mapData = maps[UIMapID]
			if mapData then
				local subZoneData = mapData[subZone]
				if subZoneData then
					for weatherName, intensities in pairs(subZoneData) do
						for intensity, count in pairs(intensities) do
							totals[weatherName] = (totals[weatherName] or 0) + count
							totalCount = totalCount + count
						end
					end
				end
			end
		end
	end

	if totalCount == 0 then return "No weather history for this area." end

	local lines = {}
	for weatherName, count in pairs(totals) do
		local percent = math.floor((count / totalCount) * 100 + 0.5)
		table.insert(lines, string.format("%s - %d%%", weatherName, percent))
	end

	table.sort(lines) -- optional: alphabetize
	return table.concat(lines, "\n")
end

local function GetWeatherStatsForMap(UIMapID)
	if not KBTUI_DB or not KBTUI_DB["Weather"] then return "No data available." end

	local totals = {}
	local totalCount = 0

	for month, days in pairs(KBTUI_DB["Weather"]) do
		for day, maps in pairs(days) do
			local mapData = maps[UIMapID]
			if mapData then
				for subZone, weatherData in pairs(mapData) do
					if subZone ~= "ZoneName" then -- Skip metadata
						for weatherName, intensities in pairs(weatherData) do
							for intensity, count in pairs(intensities) do
								totals[weatherName] = (totals[weatherName] or 0) + count
								totalCount = totalCount + count
							end
						end
					end
				end
			end
		end
	end

	if totalCount == 0 then return "No weather history for this zone." end

	local lines = {}
	for weatherName, count in pairs(totals) do
		local percent = math.floor((count / totalCount) * 100 + 0.5)
		table.insert(lines, string.format("%s - %d%%", weatherName, percent))
	end

	table.sort(lines)
	return table.concat(lines, "\n")
end

-- Weather icon texture paths (you can use your own paths or shared media)
local WeatherIcons = {
	[0] = { -- Clear
		textureDefault = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\sunny",
		intensityLow = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\sunny",
		intensityMedium = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\partly_cloudy",
		intensityHigh = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\cloudy",
	},
	[1] = { -- Rain
		textureDefault = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\rain",
		intensityLow = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\rain_light",
		intensityMedium = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\rain",
		intensityHigh = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\rain_heavy",
	},
	[2] = { -- Snow
		textureDefault = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\snow",
		intensityLow = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\snow_light",
		intensityMedium = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\snow",
		intensityHigh = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\snow_heavy",
	},
	[3] = { -- Sandstorm
		textureDefault = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\sand",
		intensityLow = "",
		intensityMedium = "",
		intensityHigh = "",
	},
	[4] = { -- Miscellaneous
		textureDefault = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Weather\\fog",
		intensityLow = "",
		intensityMedium = "",
		intensityHigh = "",
	},
	[-1] = { -- Unknown
		textureDefault = "Interface\\Icons\\INV_Misc_QuestionMark",
		intensityLow = "",
		intensityMedium = "",
		intensityHigh = "",
	},
}

-- Create the weather button
local weatherButton = CreateFrame("Button", "KBTUIWeatherButton", UIParent)
weatherButton:SetSize(36, 36)
weatherButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -200, 200)

weatherButton.texture = weatherButton:CreateTexture(nil, "BACKGROUND", nil, 1)
weatherButton.texture:SetAllPoints()
weatherButton.texture:SetTexture(WeatherIcons[-1]["textureDefault"])

-- Tooltip on hover
weatherButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine("Current Weather")
	GameTooltip:AddLine(currentWeatherName or "Unknown", 1, 1, 1)
	GameTooltip:AddLine("Intensity: " .. (currentWeatherIntensity or "N/A"))
	GameTooltip:AddLine(" ")

	-- Add historical weather stats:
	local mapID = C_Map.GetBestMapForUnit("player")
	local zoneName = GetZoneText()
	local subZone = GetSubZoneText()
	if subZone == "" or subZone == nil then
		subZone = zoneName
	end
	local zoneInfo = C_Map.GetMapInfo(mapID)
	local zoneRegion = ""
	if zoneInfo then
		zoneRegion = zoneInfo.name
	end

	if zoneRegion then
		GameTooltip:AddLine("Region Weather History: " .. zoneRegion, 0.8, 0.8, 0.8)
		GameTooltip:AddLine(GetWeatherStatsForMap(mapID), 1, 1, 1, true)
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("Local Weather History: " .. subZone, 0.7, 0.8, 1)
	GameTooltip:AddLine(GetWeatherStatsForZone(mapID, subZone), 1, 1, 1, true)

	GameTooltip:Show()
end)
weatherButton:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

-- Update the icon and tooltip when weather changes
local function UpdateWeatherButton()
	local weatherSet = WeatherIcons[currentWeatherType or -1]
	local icon = weatherSet.textureDefault

	if currentWeatherIntensity then
		if currentWeatherIntensity <= 0.001 and weatherSet.intensityLow ~= "" then
			icon = weatherSet.intensityLow
		elseif currentWeatherIntensity >= 0.5 and weatherSet.intensityHigh ~= "" then
			icon = weatherSet.intensityHigh
		elseif weatherSet.intensityMedium ~= "" then
			icon = weatherSet.intensityMedium
		end
	end
	weatherButton.texture:SetTexture(icon)
end


local function bingus(_, weatherType, weatherIntensity)

	for k, v in pairs(weatherIntensity) do
		if k == "intensity" then
			currentWeatherIntensity = v
		end
		if k == "type" then
			currentWeatherType = v
		end
	end
	for k, v in pairs(WeatherTypes) do
		if currentWeatherType == k then
			currentWeatherName = v
		end
	end
	if currentWeatherType then
		print("Weather changed to", currentWeatherName, ", intensity", currentWeatherIntensity);
	else
		print("Unknown weather type:",currentWeatherType)
	end
	UpdateWeatherButton()
end



LibForecast.RegisterCallback(weather, "OnWeatherChanged", bingus)

local initialize = CreateFrame("Frame");
initialize:RegisterEvent("ADDON_LOADED");

function initialize:Go(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "KBTUITweaks" then
		if KBTUI_DB ~= nil then
			if KBTUI_DB["Weather"] == nil then
				KBTUI_DB["Weather"] = {}
			end
		end
		WeatherCounter()
	end
end

initialize:SetScript("OnEvent", initialize.Go)