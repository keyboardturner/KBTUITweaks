local f = CreateFrame("Frame")
f:RegisterEvent("ZONE_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_STARTED_MOVING")
f:RegisterEvent("NEW_WMO_CHUNK")
f:RegisterEvent("PLAYER_LEAVING_WORLD")
f:RegisterEvent("ZONE_CHANGED_INDOORS")
f:RegisterEvent("AREA_POIS_UPDATED")
f:RegisterEvent("FOG_OF_WAR_UPDATED")
f:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")

local silentMusicPath = "Interface\\AddOns\\KBTUITweaks\\Assets\\Sound\\silenttrack.mp3"
local silentMusicActive = false

-- Customize these times as needed (24-hour format)
local DAY_START_HOUR = 6   -- 6:00 AM
local NIGHT_START_HOUR = 18 -- 6:00 PM

local function NotIndoors()
	if IsIndoors() == false then
		return true;
	else
		return false;
	end
end

function IsDay()
	local hour = GetGameTime()
	return hour >= DAY_START_HOUR and hour < NIGHT_START_HOUR
end

function IsNight()
	return not IsDay()
end

local function StartSilentMusic()
	if not silentMusicActive then
		PlayMusic(silentMusicPath)
		silentMusicActive = true
	end
end

local function StopSilentMusic()
	if silentMusicActive then
		StopMusic()
		silentMusicActive = false
	end
end

-- Define multiple named zones
-- the ones on top will be called first down the list in priority
local zones = {
	{
		subzone = "Wizard's Sanctum",
		mapID = 84, -- Stormwind City
		conditions = { IsIndoors },
		playlist = {
			{ fileID = 1417251, duration = 134 },
			{ fileID = 1417252, duration = 127 },
			{ fileID = 1417253, duration = 131 },
			{ fileID = 1417254, duration = 138 },
			{ fileID = 1417255, duration = 110 },
			{ fileID = 1417256, duration = 111 },
			{ fileID = 1417257, duration = 111 },
			{ fileID = 1417258, duration = 102 },
			{ fileID = 1417262, duration = 68 },
			{ fileID = 1417264, duration = 67 },
			{ fileID = 1417266, duration = 73 },
			{ fileID = 1417267, duration = 77 },
			{ fileID = 1417268, duration = 67 },
			{ fileID = 1417269, duration = 74 },
		},
	},

	{
		name = "The Blue Recluse",
		mapID = 84,
		minX = 0.50, maxX = 0.53,
		minY = 0.88, maxY = 0.97,
		conditions = { IsIndoors },
		playlist = {
			{ fileID = 53737, duration = 47 },
			{ fileID = 53738, duration = 51 },
			{ fileID = 53739, duration = 79 },
			{ fileID = 53740, duration = 82 },
			{ fileID = 53741, duration = 86 },
			{ fileID = 53742, duration = 92 },
			{ fileID = 53743, duration = 103 },
			{ fileID = 53748, duration = 93 },
			{ fileID = 53749, duration = 79 },
			{ fileID = 53750, duration = 86 },
			{ fileID = 53751, duration = 81 },
			{ fileID = 53752, duration = 70 },
			{ fileID = 53753, duration = 73 },
		},
	},
	{
		name = "The Golden Keg",
		mapID = 84,
		minX = 0.63, maxX = 0.67,
		minY = 0.30, maxY = 0.37,
		conditions = { IsIndoors },
		playlist = {
			{ fileID = 53737, duration = 47 },
			{ fileID = 53738, duration = 51 },
			{ fileID = 53739, duration = 79 },
			{ fileID = 53740, duration = 82 },
			{ fileID = 53741, duration = 86 },
			{ fileID = 53742, duration = 92 },
			{ fileID = 53743, duration = 103 },
			{ fileID = 53748, duration = 93 },
			{ fileID = 53749, duration = 79 },
			{ fileID = 53750, duration = 86 },
			{ fileID = 53751, duration = 81 },
			{ fileID = 53752, duration = 70 },
			{ fileID = 53753, duration = 73 },
		},
	},
	{
		name = "The Gilded Rose",
		mapID = 84,
		minX = 0.59, maxX = 0.61,
		minY = 0.73, maxY = 0.77,
		conditions = { IsIndoors },
		playlist = {
			{ fileID = 53737, duration = 47 },
			{ fileID = 53738, duration = 51 },
			{ fileID = 53739, duration = 79 },
			{ fileID = 53740, duration = 82 },
			{ fileID = 53741, duration = 86 },
			{ fileID = 53742, duration = 92 },
			{ fileID = 53743, duration = 103 },
			{ fileID = 53748, duration = 93 },
			{ fileID = 53749, duration = 79 },
			{ fileID = 53750, duration = 86 },
			{ fileID = 53751, duration = 81 },
			{ fileID = 53752, duration = 70 },
			{ fileID = 53753, duration = 73 },
		},
	},
	{
		subzone = "The Slaughtered Lamb",
		mapID = 84,
		conditions = { IsIndoors },
		playlist = {
			{ fileID = 53737, duration = 47 },
			{ fileID = 53738, duration = 51 },
			{ fileID = 53739, duration = 79 },
			{ fileID = 53740, duration = 82 },
			{ fileID = 53741, duration = 86 },
			{ fileID = 53742, duration = 92 },
			{ fileID = 53743, duration = 103 },
			{ fileID = 53748, duration = 93 },
			{ fileID = 53749, duration = 79 },
			{ fileID = 53750, duration = 86 },
			{ fileID = 53751, duration = 81 },
			{ fileID = 53752, duration = 70 },
			{ fileID = 53753, duration = 73 },
		},
	},
	{
		subzone = "Pig and Whistle Tavern",
		mapID = 84,
		conditions = { IsIndoors },
		playlist = {
			{ fileID = 53737, duration = 47 },
			{ fileID = 53738, duration = 51 },
			{ fileID = 53739, duration = 79 },
			{ fileID = 53740, duration = 82 },
			{ fileID = 53741, duration = 86 },
			{ fileID = 53742, duration = 92 },
			{ fileID = 53743, duration = 103 },
			{ fileID = 53748, duration = 93 },
			{ fileID = 53749, duration = 79 },
			{ fileID = 53750, duration = 86 },
			{ fileID = 53751, duration = 81 },
			{ fileID = 53752, duration = 70 },
			{ fileID = 53753, duration = 73 },
		},
	},

	--[[ -- test
	{
		name = "Cathedral Garden",
		mapID = 84,
		minX = 0.001, maxX = 0.002,
		minY = 0.001, maxY = 0.002,
		playlist = {
			{ fileID = 53737, duration = 47 },
			{ fileID = 53738, duration = 51 },
			{ fileID = 53739, duration = 79 },
		},
	},
	]]

	{
		subzone = "Dwarven District",
		conditions = { IsDay },
		mapID = 84, -- Stormwind City
		playlist = {
			{ fileID = 53192, duration = 123 },
			{ fileID = 53193, duration = 50 },
			{ fileID = 53194, duration = 81 },
			{ fileID = 53195, duration = 71 },
		},
	},
	{
		subzone = "Dwarven District",
		conditions = { IsNight },
		mapID = 84, -- Stormwind City
		playlist = {
			{ fileID = 441565, duration = 155 },
			{ fileID = 441566, duration = 66 },
			{ fileID = 441567, duration = 55 },
			{ fileID = 441568, duration = 102 },
			{ fileID = 441569, duration = 46 },
			{ fileID = 441570, duration = 106 },
			{ fileID = 441571, duration = 94 },
		},
	},

	{
		name = "Trading Post",
		mapID = 84,
		minX = 0.488, maxX = 0.52,
		minY = 0.70, maxY = 0.75,
		conditions = { NotIndoors },
		playlist = {
			{ fileID = 4889877, duration = 41 },
			{ fileID = 4889879, duration = 80 },
			{ fileID = 4889881, duration = 75 },
			{ fileID = 4887953, duration = 130 },
			{ fileID = 4887955, duration = 126 },
			{ fileID = 4887957, duration = 121 },
			{ fileID = 5168460, duration = 134 },
			{ fileID = 5168462, duration = 124 },
		},
	},

	{ -- requires defining map coords due to borked frequent subzone changes
		name = "Mage Quarter Area Day",
		mapID = 84,
		minX = 0.39, maxX = 0.56,
		minY = 0.75, maxY = 0.91,
		conditions = { IsDay },
		playlist = {
			{ fileID = 229800, duration = 68 },
			{ fileID = 229801, duration = 43 },
			{ fileID = 229802, duration = 70 },
			{ fileID = 229803, duration = 89 },
			{ fileID = 1417233, duration = 95 },
			{ fileID = 1417234, duration = 92 },
			{ fileID = 1417235, duration = 93 },
		},
	},
	{ -- requires defining map coords due to borked frequent subzone changes
		name = "Mage Quarter Area Night",
		mapID = 84,
		minX = 0.39, maxX = 0.56,
		minY = 0.75, maxY = 0.91,
		conditions = { IsNight },
		playlist = {
			{ fileID = 229800, duration = 68 },
			{ fileID = 229801, duration = 43 },
			{ fileID = 229802, duration = 70 },
			{ fileID = 229803, duration = 89 },
			{ fileID = 1417236, duration = 95 },
			{ fileID = 1417237, duration = 92 },
			{ fileID = 1417238, duration = 97 },
			{ fileID = 1417239, duration = 98 },
		},
	},

	{
		subzone = "The Seer's Library",
		mapID = 111, -- Shattrath City
		conditions = { IsIndoors },
		playlist = {
			{ fileID = 53806, duration = 138 },
			{ fileID = 53807, duration = 100 },
			{ fileID = 53808, duration = 92 },
			{ fileID = 53809, duration = 82 },
			{ fileID = 53810, duration = 118 },
			{ fileID = 53811, duration = 138 },
		},
	},

	{
		name = "Infinite Bazaar - Dalaran",
		mapID = 619, -- Broken Isles (Outer Dalaran, Legion Remix)
		minX = 0.451, maxX = 0.461,
		minY = 0.673, maxY = 0.689,
		playlist = {
			{ fileID = 4872432, duration = 141 },
			{ fileID = 4872434, duration = 143 },
			{ fileID = 4872442, duration = 168 },
			{ fileID = 4880323, duration = 112 },
			{ fileID = 4880325, duration = 100 },
			{ fileID = 4887909, duration = 130 },
			{ fileID = 4887913, duration = 106 },
			{ fileID = 4887915, duration = 92 },
			{ fileID = 4887927, duration = 112 },
			{ fileID = 4887929, duration = 103 },
		},
	},

	{
		subzone = "A Hero's Welcome",
		mapID = 627, -- Dalaran
		playlist = {
			{ fileID = 53737, duration = 47 },
			{ fileID = 53738, duration = 51 },
			{ fileID = 53739, duration = 79 },
			{ fileID = 53740, duration = 82 },
			{ fileID = 53741, duration = 86 },
			{ fileID = 53742, duration = 92 },
			{ fileID = 53743, duration = 103 },
			{ fileID = 53748, duration = 93 },
			{ fileID = 53749, duration = 79 },
			{ fileID = 53750, duration = 86 },
			{ fileID = 53751, duration = 81 },
			{ fileID = 53752, duration = 70 },
			{ fileID = 53753, duration = 73 },
		},
	},

	--[[ test
	{
		name = "Nagrand Zone Flying",
		zone = "Nagrand",
		conditions = { IsFlying },
		mapID = 107, -- Nagrand
		playlist = {
			{ fileID = 441565, duration = 155 },
			{ fileID = 441566, duration = 66 },
			{ fileID = 441567, duration = 55 },
			{ fileID = 441568, duration = 102 },
			{ fileID = 441569, duration = 46 },
			{ fileID = 441570, duration = 106 },
			{ fileID = 441571, duration = 94 },
		},
	},
	]]

};

local currentTrackIndex = 1
local musicPlaying = false
local musicTimer = 0
local timerElapsed = 0
local checkInterval = 1
local lastCheck = 0
local soundHandle = nil
local fadeoutTime = 5000
local lastTrackIndex = nil

local function IsInZone(zone)
	local mapID = C_Map.GetBestMapForUnit("player")
	if mapID ~= zone.mapID then return false end

	-- Subzone match (strict): if a subzone is defined, it *must* match
	if zone.subzone then
		local currentSubzone = GetSubZoneText()
		if currentSubzone ~= zone.subzone then
			return false -- hard fail if subzone doesn't match
		else
			return true -- subzone matched
		end
	end

	-- Coordinate match
	if zone.minX and zone.maxX and zone.minY and zone.maxY then
		local pos = C_Map.GetPlayerMapPosition(mapID, "player")
		if not pos then return false end

		local x, y = pos:GetXY()
		if x and y then
			return x >= zone.minX and x <= zone.maxX and
				   y >= zone.minY and y <= zone.maxY
		end
	end

	-- If neither subzone nor coords are defined, don't match
	return false
end


local function FindActiveZone()
	local mapID = C_Map.GetBestMapForUnit("player")
	if not mapID then return nil end

	local subzone = GetSubZoneText()
	local pos = C_Map.GetPlayerMapPosition(mapID, "player")

	for _, zone in ipairs(zones) do
		if zone.mapID == mapID and IsInZone(zone) then
			-- Evaluate conditions (if any)
			if zone.conditions then
				local valid = true
				for _, cond in ipairs(zone.conditions) do
					if not cond() then
						valid = false
						break
					end
				end
				if not valid then
					-- skip this zone
				else
					return zone
				end
			else
				-- No conditions, zone is valid
				return zone
			end
		end
	end

	return nil
end

local function StopCurrentMusic()
	musicPlaying = false;
	musicTimer = 0;
	timerElapsed = 0;
	currentTrackIndex = 1;
	activeZone = nil;

	StopSilentMusic();

	if soundHandle then
		StopSound(soundHandle, fadeoutTime);
		soundHandle = nil;
	end
end

local function PlayNextTrack()
	if not activeZone then return end

	StartSilentMusic()

	local playlist = activeZone.playlist
	local numTracks = #playlist
	if numTracks == 0 then return end

	-- Pick a random track index that's not the same as the last one (if more than one)
	local nextIndex
	repeat
		nextIndex = math.random(1, numTracks)
	until numTracks == 1 or nextIndex ~= lastTrackIndex

	local track = playlist[nextIndex]
	if not track then return end

	local willPlay, handle = PlaySoundFile(track.fileID, "Music")
	if willPlay then
		soundHandle = handle
		musicTimer = track.duration
		timerElapsed = 0
		musicPlaying = true
		lastTrackIndex = nextIndex
	else
		soundHandle = nil
		return
	end
end

local function CheckConditions()
	if C_CVar.GetCVar("Sound_EnableMusic") ~= "1" then
		if musicPlaying then
			StopCurrentMusic()
		end
		return
	end

	local zone = FindActiveZone()
	if zone then
		if activeZone ~= zone then
			StopCurrentMusic()
			activeZone = zone
			print("Entered custom zone:", zone.name or zone.subzone)
		end
		if not musicPlaying then
			PlayNextTrack()
		end
	else
		if musicPlaying then
			StopCurrentMusic()
		end
	end
end

f:SetScript("OnUpdate", function(_, elapsed)
	lastCheck = lastCheck + elapsed
	if lastCheck >= checkInterval then
		lastCheck = 0
		CheckConditions()
	end

	if musicPlaying then
		timerElapsed = timerElapsed + elapsed
		if timerElapsed >= musicTimer then
			PlayNextTrack()
		end
	end
end)

-- Stop music on logout or leaving the zone
f:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LEAVING_WORLD" then
		StopCurrentMusic()
	else
		CheckConditions()
	end
end)
