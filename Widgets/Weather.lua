local LibForecast = LibStub:GetLibrary("LibForecast-1.0");
local weather = {};

local WeatherTypesID = CopyTable(LibForecast.WeatherType)

local WeatherTypes = {
	[-1] = "Unknown",
	[1] = "Clear",
	[2] = "Rain",
	[3] = "Snow",
	[4] = "Sandstorm",
	[5] = "Miscellaneous",
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
	print("Weather changed to " .. currentWeatherName .. ", intensity " .. currentWeatherIntensity);
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