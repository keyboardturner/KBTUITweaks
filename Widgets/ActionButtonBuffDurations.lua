-- Table of spells, buff IDs, and hardcoded durations (if applicable)
--[spellID] = auraID
local spellData = {

	-- Death Knight
	[196770] = { buffID = 196770 },	-- Remorseless Winter
	[49020] = { buffID = 51271 },	-- Pillar of Frost on Obliterate
	[43265] = { duration = 10},		-- Death and Decay with a hardcoded 10-second duration -- buffID = 188290
	[48707] = { buffID = 48707 },	-- Anti-Magic Shell
	[48792] = { buffID = 48792 }, 	-- Icebound Fortitude
	[48265] = { buffID = 48265 },	-- Death's Advance
	[49039] = { buffID = 49039 },	-- Lichborne

	-- Mage
	[11426] = { buffID = 11426 }, -- Ice Barrier
	[66] = { buffID = 32612 }, -- Invisibility
	[130] = { buffID = 130 }, -- Slow Fall

	-- Racials
	[58984] = { buffID = 58984 }, -- Shadowmeld
};

-- Define the mapping of action bar ranges to their respective button names
local actionBarMappings = {
	{ start = 1, stop = 12, prefix = "ActionButton" }, -- Main Action Bar
	{ start = 61, stop = 72, prefix = "MultiBarBottomLeftButton" }, -- Action Bar 2
	{ start = 49, stop = 60, prefix = "MultiBarBottomRightButton" }, -- Action Bar 3
	{ start = 25, stop = 36, prefix = "MultiBarRightButton" }, -- Action Bar 4
	{ start = 37, stop = 48, prefix = "MultiBarLeftButton" }, -- Action Bar 5
	{ start = 145, stop = 156, prefix = "MultiBar5Button" }, -- Action Bar 6
	{ start = 157, stop = 168, prefix = "MultiBar6Button" }, -- Action Bar 7
	{ start = 169, stop = 180, prefix = "MultiBar7Button" }, -- Action Bar 8
};


local borderTex = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Button_Border_White"

local function SetCustomSwipeColor(cooldown)
	local className, classFile, classID = UnitClass("player");

	if classID == 8 then -- Mage
		cooldown:SetSwipeColor(.984, .714, .820, 1);
	elseif classID == 6 then -- Death Knight
		cooldown:SetSwipeColor(.41, .85, 1, 1); -- Frost DK (Spellblade?)
	else
		cooldown:SetSwipeColor(.41, .85, 1, 1);
	end
end

-- Create a radial cooldown texture
local function CreateCooldownTexture(button)
	local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate");
	cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0);
	cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0);
	cooldown:SetDrawEdge(false); -- Optional: Hide the edge of the cooldown
	cooldown:SetDrawSwipe(true); -- Show the circular swipe effect
	cooldown:SetReverse(false);  -- Clockwise fill; set to true for counterclockwise
	cooldown:SetHideCountdownNumbers(true); -- Hide default countdown numbers if present
	cooldown:SetSwipeTexture(borderTex);
	SetCustomSwipeColor(cooldown);
	return cooldown;
end

-- Update the cooldown texture based on the buff's remaining duration
local function UpdateCooldownTexture(button, cooldown, duration, expirationTime)
	local startTime = expirationTime - duration;
	cooldown:SetCooldown(startTime, duration); -- Set the cooldown with start time and total duration
end

-- Check if the player has the buff and update the action bar button
local function CheckBuffAndUpdate(button, cooldown, spellInfo)
	if spellInfo.buffID then
		local spellIDBuff = C_UnitAuras.GetPlayerAuraBySpellID(spellInfo.buffID);
		if spellIDBuff and spellIDBuff.sourceUnit == "player" then
			local duration = spellIDBuff.duration;
			local expirationTime = spellIDBuff.expirationTime;
			UpdateCooldownTexture(button, cooldown, duration, expirationTime);
		else
			cooldown:Hide(); -- Hide if the buff is not active
		end
	elseif spellInfo.duration then
		-- Handle hardcoded duration case
		local currentTime = GetTime();
		local expirationTime = currentTime + spellInfo.duration;
		UpdateCooldownTexture(button, cooldown, spellInfo.duration, expirationTime);
	end
end

-- Iterate over all action bars and update the textures or cooldowns
local function UpdateAllActionBars()
	for _, barInfo in ipairs(actionBarMappings) do
		for i = barInfo.start, barInfo.stop do
			local buttonName = barInfo.prefix .. (i - barInfo.start + 1);
			local button = _G[buttonName];
			if button then
				local actionType, actionID, subType = GetActionInfo(i);

				if (actionType == "spell" or actionType == "macro") and spellData[actionID] then
					-- Get the corresponding spell info (buff ID or hardcoded duration)
					local spellInfo = spellData[actionID];
					if spellInfo and spellInfo.buffID then
						CheckBuffAndUpdate(button, button.cooldownTexture, spellInfo);
					end
				end
			end
		end
	end
end

-- Handle spell cast event for hardcoded durations
local function HandleSpellCast(event, unitTarget, spellID)
	if unitTarget == "player" and spellData[spellID] and spellData[spellID].duration then
		for _, barInfo in ipairs(actionBarMappings) do
			for i = barInfo.start, barInfo.stop do
				local buttonName = barInfo.prefix .. (i - barInfo.start + 1);
				local button = _G[buttonName];
				if button then
					local actionType, actionID, subType = GetActionInfo(i);

					if (actionType == "spell" or actionType == "macro") and actionID == spellID then
						local spellInfo = spellData[spellID];
						local currentTime = GetTime();
						local expirationTime = currentTime + spellInfo.duration;
						UpdateCooldownTexture(button, button.cooldownTexture, spellInfo.duration, expirationTime);
					end
				end
			end
		end
	end
end

-- Event handler for UNIT_SPELLCAST_SUCCEEDED
local function OnEvent(self, event, ...)
	if event == "UNIT_AURA" or event == "SPELL_UPDATE_COOLDOWN" then
		UpdateAllActionBars();
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unitTarget, castGUID, spellID = ...;
		HandleSpellCast(event, unitTarget, spellID);
	end
end

-- Initialize the script for tracking and updating
local f = CreateFrame("Frame");
f:RegisterEvent("UNIT_AURA");
f:RegisterEvent("SPELL_UPDATE_COOLDOWN");
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
f:SetScript("OnEvent", OnEvent);

-- Create the cooldown textures for each action button
for _, barInfo in ipairs(actionBarMappings) do
    for i = barInfo.start, barInfo.stop do
        local buttonName = barInfo.prefix .. (i - barInfo.start + 1);
        local button = _G[buttonName];
        if button then
            button.cooldownTexture = CreateCooldownTexture(button);
        end
    end
end
