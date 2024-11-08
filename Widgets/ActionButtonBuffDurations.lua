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

	-- Rogue
	[13877] = { buffID = 13877 }, -- Blade Flurry
	[1966] = { buffID = 1966 }, -- Feint
	[13750] = { buffID = 13750 }, -- Adrenaline Rush
	[31224] = { buffID = 31224 }, -- Cloak of Shadows
	[315496] = { buffID = 315496 }, -- Slice and Dice
	[5277] = { buffID = 5277 }, -- Evasion
	[185311] = { buffID = 185311 }, -- Crimson Vial
	[114018] = { buffID = 114018 }, -- Shroud of Concealment
	[2983] = { buffID = 2983 }, -- Sprint
	[1856] = { buffID = 115192 }, -- Vanish (Subterfuge)
	[195457] = { buffID = 457343 }, -- Grappling Hook (Death's Arrival)
	[381623] = { buffID = 381623 }, -- Thistle Tea
	[212283] = { buffID = 212283 }, -- Symbols of Death
	[121471] = { buffID = 121471 }, -- Shadow Blades
	[185313] = { buffID = 185422 }, -- Shadow Dance


	-- Racials
	[58984] = { buffID = 58984 }, -- Shadowmeld

	-- Dragonriding
	[403092] = { buffID = 425663 }, -- Aerial Halt (Wind's Respite)
	[372608] = { buffID = 388367 }, -- Surge Forward (Ohn'ahra's Gusts)
	[418592] = { buffID = 418592 }, -- Lightning Rush
	[374994] = { buffID = 375585 }, -- Bronze Timelock (Bronze Rewind)

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
	{ start = 73, stop = 84, prefix = "ActionButton" }, -- Main Action Bar (Stealth)
	{ start = 121, stop = 132, prefix = "ActionButton" }, -- Main Action Bar (Skyriding)
};


local borderTex = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Button_Border_White"

local function SetCustomSwipeColor(cooldown)
	local className, classFile, classID = UnitClass("player");

	if classID == 8 then -- Mage
		cooldown:SetSwipeColor(.984, .714, .820, 1);
	elseif classID == 6 then -- Death Knight
		cooldown:SetSwipeColor(.41, .85, 1, 1); -- Frost DK (Spellblade?)
	elseif classID == 4 then -- Rogue
		cooldown:SetSwipeColor(1,.95,.41, 1);
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

-- Update the cooldown texture for a specific slot if it matches a known action
local function UpdateActionBarSlot(slot)
	for _, barInfo in ipairs(actionBarMappings) do
		if slot >= barInfo.start and slot <= barInfo.stop then
			local buttonName = barInfo.prefix .. (slot - barInfo.start + 1);
			local button = _G[buttonName];
			if button then
				local actionType, actionID = GetActionInfo(slot);

				if (actionType == "spell" or actionType == "macro") and spellData[actionID] then
					local spellInfo = spellData[actionID];
					if spellInfo.buffID then
						CheckBuffAndUpdate(button, button.cooldownTexture, spellInfo);
					else
						button.cooldownTexture:Hide();  -- Hide cooldown if no active buff
					end
				else
					button.cooldownTexture:Hide();  -- Hide cooldown if slot action doesn’t match
				end
			end
			break;
		end
	end
end

-- Add 'ACTIONBAR_SLOT_CHANGED' to event handler
local function OnEvent(self, event, ...)
	if event == "UNIT_AURA" or event == "SPELL_UPDATE_COOLDOWN" then
		UpdateAllActionBars();
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unitTarget, castGUID, spellID = ...;
		HandleSpellCast(event, unitTarget, spellID);
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		local slot = ...;
		UpdateActionBarSlot(slot);
	end
end

local eventsList = {
	"UNIT_AURA",
	"SPELL_UPDATE_COOLDOWN",
	"UNIT_SPELLCAST_SUCCEEDED",
	"ACTIONBAR_SLOT_CHANGED",
	"ACTION_USABLE_CHANGED",
	"ACTIONBAR_UPDATE_STATE",
	"ACTIONBAR_UPDATE_USABLE",
	"UPDATE_BONUS_ACTIONBAR",
};

-- Initialize the script for tracking and updating
local f = CreateFrame("Frame");
for _, e in pairs(eventsList) do
	f:RegisterEvent(e)
end
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
