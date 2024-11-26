-- Table of spells, buff IDs, and hardcoded durations (if applicable)
--[spellID] = auraID
local spellData = {

	-- Death Knight
	[196770] = { buffID = 196770 },		 -- Remorseless Winter
	[49020] = { buffID = 51271 },		 -- Pillar of Frost on Obliterate
	[43265] = { duration = 10},			 -- Death and Decay with a hardcoded 10-second duration -- buffID = 188290
	[48707] = { buffID = 48707 },		 -- Anti-Magic Shell
	[48792] = { buffID = 48792 }, 		 -- Icebound Fortitude
	[48265] = { buffID = 48265 },		 -- Death's Advance
	[49039] = { buffID = 49039 },		 -- Lichborne

	-- Mage
	[11426] = { buffID = 11426 },		 -- Ice Barrier
	[66] = { buffID = 32612 },			 -- Invisibility
	[130] = { buffID = 130 },			 -- Slow Fall

	-- Rogue
	[13877] = { buffID = 13877 },		 -- Blade Flurry
	[1966] = { buffID = 1966 },			 -- Feint
	[13750] = { buffID = 13750 },		 -- Adrenaline Rush
	[31224] = { buffID = 31224 },		 -- Cloak of Shadows
	[315496] = { buffID = 315496 },		 -- Slice and Dice
	[5277] = { buffID = 5277 },			 -- Evasion
	[185311] = { buffID = 185311 },		 -- Crimson Vial
	[114018] = { buffID = 114018 },		 -- Shroud of Concealment
	[2983] = { buffID = 2983 },			 -- Sprint
	[1856] = { buffID = 115192 },		 -- Vanish (Subterfuge)
	[195457] = { buffID = 457343 },		 -- Grappling Hook (Death's Arrival)
	[381623] = { buffID = 381623 },		 -- Thistle Tea
	[212283] = { buffID = 212283 },		 -- Symbols of Death
	[121471] = { buffID = 121471 },		 -- Shadow Blades
	[185313] = { buffID = 185422 },		 -- Shadow Dance
	[57934] = { buffID = 59628 },		 -- Tricks of the Trade

	-- Priest
	[19236] = { buffID = 19236 },		 -- Desperate Prayer
	[586] = { buffID = 586 },			 -- Fade
	[121536] = { buffID = 121557 },		 -- Angelic Feather
	[15286] = { buffID = 15286 },		 -- Vampiric Embrace
	[47585] = { buffID = 47585 },		 -- Dispersion
	[10060] = { buffID = 10060 },		 -- Power Infusion
	[391109] = { buffID = 391109 },		 -- Dark Ascension
	[228260] = { buffID = 194249 },		 -- Void Eruption
	[205448] = { buffID = 194249 },		 -- Void Bolt (Void Eruption)
	[64843] = { buffID = 64843 },		 -- Divine Hymn
	[64901] = { buffID = 64901 },		 -- Symbol of Hope
	[47788] = { buffID = 47788 },		 -- Guardian Spirit
	[33206] = { buffID = 33206 },		 -- Pain Suppression
	[47536] = { buffID = 47536 },		 -- Rapture
	[246287] = { buffID = 246287 },		 -- Evangelism
	[62618] = { duration = 10 },		 -- Power Word: Barrier
	[271466] = { buffID = 271466 },		 -- Luminous Barrier
	[589] = {							 -- Shadow Word: Pain
		debuffID = 589,
		refresh = 6.3,
	},
	[34914] = {							 -- Vampiric Touch
		debuffID = 34914,
		refresh = 6.3,
	},
	[335467] = {						 -- Devouring Plague
		debuffID = 335467,
		refresh = 2.5
	},
	[204197] = {						 -- Purge the Wicked
		debuffID = 204213,
		refresh = 6,
	},
	[200174] = {						 -- Mindbender (Shadow)
		totem = {
			"Sha Beast", "Mindbender", "Shadowfiend", "Lightspawn", "Voidling", -- enUS
		}
	},
	[123040] = {						 -- Mindbender (Discipline)
		totem = {
			"Sha Beast", "Mindbender", "Shadowfiend", "Lightspawn", "Voidling", -- enUS
		}
	},
	[34433] = {							 -- Shadowfiend
		totem = {
			"Sha Beast", "Mindbender", "Shadowfiend", "Lightspawn", "Voidling", -- enUS
		}
	},
	

	-- Racials
	[58984] = { buffID = 58984 },		 -- Shadowmeld

	-- Dragonriding
	[403092] = { buffID = 425663 },		 -- Aerial Halt (Wind's Respite)
	[372608] = { buffID = 388367 },		 -- Surge Forward (Ohn'ahra's Gusts)
	[418592] = { buffID = 418592 },		 -- Lightning Rush
	[374994] = { buffID = 375585 },		 -- Bronze Timelock (Bronze Rewind)

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
	local specID = GetSpecializationInfo(GetSpecialization());

	if classID == 8 then -- Mage
		cooldown:SetSwipeColor(.984, .714, .820, 1); -- Blue
	elseif classID == 6 and specID == 251 then -- Death Knight
		cooldown:SetSwipeColor(.41, .85, 1, 1); -- Frost DK (Spellblade?)
	elseif classID == 4 then -- Rogue
		cooldown:SetSwipeColor(1,.95,.41, 1); -- Yellow
	elseif classID == 5 and specID == 258 then -- Shadow Priest
		cooldown:SetSwipeColor(.66, 0, 1, 1); -- Purple
	else
		cooldown:SetSwipeColor(1, 1, 1, 1); -- None Found, White Default
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
	return cooldown;
end

-- Update the cooldown texture based on the buff's remaining duration
local function UpdateCooldownTexture(button, cooldown, duration, expirationTime)
	local startTime = expirationTime - duration;
	cooldown:SetCooldown(startTime, duration); -- Set the cooldown with start time and total duration
	SetCustomSwipeColor(cooldown);
end

-- Handle spell cast event for hardcoded durations
local function HandleSpellCast(event, unitTarget, spellID)
	if unitTarget == "player" and spellData[spellID] and spellData[spellID].duration then
		for _, barInfo in ipairs(actionBarMappings) do
			for i = barInfo.start, barInfo.stop do
				local buttonName = barInfo.prefix .. (i - barInfo.start + 1);
				local button = _G[buttonName];
				local buttonID = button.action
				if button and button.cooldownTexture then
					local actionType, actionID, subType = GetActionInfo(buttonID);
					if (actionType == "spell" or actionType == "macro") and spellData[actionID] then
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

-- Check target debuffs and update the action bar button
local function CheckDebuffAndUpdate(button, cooldown, spellInfo)
	if not button or not cooldown or not spellInfo.debuffID then return end
	local unit = "target"; -- Assuming debuffs are on the target
	local index = 1
	while true do -- Loop through the target's debuffs
		local aura = C_UnitAuras.GetAuraDataByIndex(unit, index, "HARMFUL");
		if not aura then break end
		if aura and aura.spellId == spellInfo.debuffID and aura.sourceUnit == "player" then
			local duration = aura.duration;
			local expirationTime = aura.expirationTime;
			local remainingTime = expirationTime - GetTime();

			-- Update the cooldown texture
			UpdateCooldownTexture(button, button.cooldownTexture, duration, expirationTime);

			-- Change color if the remaining time is below the refresh threshold
			if spellInfo.refresh and remainingTime <= spellInfo.refresh then
				cooldown:SetSwipeColor(1, 0, 0, 1); -- Bright red for refresh state
			else
				SetCustomSwipeColor(cooldown); -- Reset to default color
			end
			return; -- Exit once the matching debuff is processed
		end
		index = index + 1
	end
	button.cooldownTexture:Hide(); -- Hide if the debuff is not active
end

-- Check if the player has the buff and update the action bar button
local function CheckBuffAndUpdate(button, cooldown, spellInfo)
	if not button or not cooldown then return end
	if spellInfo.buffID then -- need to clean something here, this will often pass as "true" multiple times, and ends up hiding unrelated things
		local spellIDBuff = C_UnitAuras.GetPlayerAuraBySpellID(spellInfo.buffID);
		if spellIDBuff and spellIDBuff.sourceUnit == "player" then
			local duration = spellIDBuff.duration;
			local expirationTime = spellIDBuff.expirationTime;
			UpdateCooldownTexture(button, button.cooldownTexture, duration, expirationTime);
		else
			button.cooldownTexture:Hide(); -- hides cooldowns when they're abruptly dispelled or cancelled
		end
	-- Check for debuffs
	elseif spellInfo.debuffID then
		CheckDebuffAndUpdate(button, cooldown, spellInfo);
	elseif spellInfo.totem then
		-- Handle totems with a localized name comparison
		local totemFound = false;
		for index = 1, MAX_TOTEMS do
			local haveTotem, totemName, startTime, duration, icon = GetTotemInfo(index);
			if haveTotem and totemName then
				for _, v in ipairs(spellInfo.totem) do
					if string.lower(totemName) == string.lower(v) then
						local expirationTime = startTime + duration;
						UpdateCooldownTexture(button, button.cooldownTexture, duration, expirationTime);
						totemFound = true;
						break; -- Stop once the matching totem is found
					end
				end
			end
		end
		-- Hide cooldown if no matching totem is found
		if not totemFound then
			button.cooldownTexture:Hide();
		end
	end
end


-- Iterate over all action bars and update the textures or cooldowns
local function UpdateAllActionBars()
	for _, barInfo in ipairs(actionBarMappings) do
		for i = barInfo.start, barInfo.stop do
			local buttonName = barInfo.prefix .. (i - barInfo.start + 1);
			local button = _G[buttonName];
			local buttonID = button.action
			if button and button.cooldownTexture then
				local actionType, actionID, subType = GetActionInfo(buttonID);
				if (actionType == "spell" or actionType == "macro") and spellData[actionID] then
					-- Get the corresponding spell info (buff ID or hardcoded duration)
					--if HasBonusActionBar() and barInfo.prefix == "ActionButton" and i > 12 then -- something outside range of main action bar, when it's being replaced
					local spellInfo = spellData[actionID];

					--if spellData[C_ActionBar.GetSpell(buttonID)] then return end;
					if spellInfo then
						CheckBuffAndUpdate(button, button.cooldownTexture, spellInfo);
					end
				end
			end
		end
	end
end

-- Update event handler to include debuff updates
local function OnEvent(self, event, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unitTarget, _, spellID = ...;
        HandleSpellCast(event, unitTarget, spellID);
    end
	UpdateAllActionBars();
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
	"PLAYER_TOTEM_UPDATE",
	"PLAYER_TARGET_CHANGED",
	"ACTION_RANGE_CHECK_UPDATE",
};

-- Initialize the script for tracking and updating
local f = CreateFrame("Frame");
for _, e in pairs(eventsList) do
	f:RegisterEvent(e)
end
f:SetScript("OnEvent", OnEvent);

for _, barInfo in ipairs(actionBarMappings) do
	for i = barInfo.start, barInfo.stop do
		local buttonName = barInfo.prefix .. (i - barInfo.start + 1);
		local button = _G[buttonName];
		if button then
			button.cooldownTexture = CreateCooldownTexture(button);
		end
	end
end
