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
	[108839] = { buffID = 108839 },		 -- Ice Floes
	[342245] = { buffID = 342246 },		 -- Alter Time
	[342247] = { buffID = 342246 },		 -- Alter Time (on-use)
	[365350] = { buffID = 365362 },		 -- Arcane Surge
	[55342] = { buffID = 55342 },		 -- Mirror Image
	[414658] = { buffID = 414658 },		 -- Ice Cold
	[80353] = { buffID = 80353 },		 -- Time Warp
	[110959] = { buffID = 110960 },		 -- Greater Invisibility
	[235450] = { buffID = 235450 },		 -- Prismatic Barrier
	[12051] = { buffID = 384267 },		 -- Evocation
	[321507] = { debuffID = 210824 },	 -- Touch of the Magi


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

	-- Paladin
	[190784] = { 						 -- Divine Steed
		buffIDs = { 221883, 254474 }
	},
	[184662] = { buffID = 184662 },		 -- Shield of Vengeance
	[403876] = { buffID = 403876 },		 -- Divine Protection
	[1044] = { buffID = 1044 },			 -- Blessing of Freedom
	[1022] = { buffID = 1022 },			 -- Blessing of Protection
	[642] = { buffID = 642 },			 -- Divine Shield
	[198034] = { buffID = 198034 },		 -- Divine Hammer
	[231895] = { buffID = 231895 },		 -- Crusade (Avenging Wrath)
	[31884] = { buffID = 31884 },		 -- Avenging Wrath
	[454353] = {						 -- Radiant Glory (Crusade Proc)
		buffIDs = { 454373, 454351 },
	},
	[462048] = {						 -- Radiant Glory (Avenging Wrath Proc)
		buffIDs = { 454373, 454351 },
	},
	[255937] = {						 -- Wake of Ashes (Avenging Wrath Proc)
		buffIDs = { 454373, 454351 },
	},
	[24275] = { buffID = 383329 },		 -- Hammer of Wrath (Final Verdict Proc)
	[212641] = { buffID = 212641 },		 -- Guardian of Ancient Kings
	[26573] = {							 -- Consecration
		totem = {
			"Consecration", -- enUS
		}
	},
	[31850] = { buffID = 31850 },		 -- Ardent Defender
	[53600] = { buffID = 132403 },		 -- Shield of the Righteous
	[85673] = { buffID = 327510 },		 -- Word of Glory (Shining Light Proc)
	[375576] = { buffID = 386730 },		 -- Divine Toll

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
	[200183] = { buffID = 200183 },		 -- Apotheosis
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
		refresh = 2.5,
	},
	[204197] = {						 -- Purge the Wicked
		debuffID = 204213,
		refresh = 6,
	},
	[585] = {							 -- Smite (Sanctuary)
		debuffID = 208772,
		refresh = 4.2,
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

	-- Shaman
	[108271] = { buffID = 108271 },		 -- Astral Shift
	[58875] = { buffID = 58875 },		 -- Spirit Walk
	[73920] = { buffID = 73920 },		 -- Healing Rain
	[108281] = { buffID = 108281 },		 -- Ancestral Guidance
	[79206] = { buffID = 79206 },		 -- Spiritwalker's Grace
	[187874] = { buffID = 187874 },		 -- Crash Lightning
	[191634] = { buffID = 191634 },		 -- Stormkeeper
	[2484] = { totem = {
			"Earthbind Totem", -- enUS
		}
	},
	[5394] = { totem = {
			"Healing Stream Totem", -- enUS
		}
	},
	[98008] = { totem = {
			"Spirit Link Totem", -- enUS
		}

	},
	[108280] = { totem = {
			"Healing Tide Totem", -- enUS
		}
	},
	[192077] = { totem = {
			"Wind Rush Totem", -- enUS
		}
	},
	[198103] = { totem = {
			"Earth Elemental", "Greater Earth Elemental", -- enUS
		}
	},
	[192249] = { totem = {
			"Storm Elemental", "Greater Storm Elemental", -- enUS
		}

	},
	[192058] = { totem = {
			"Capacitor Totem", -- enUS
		}
	},
	[470411] = {						 -- Flame Shock
		debuffID = 188389,
		refresh = 6,
	},
	

	-- Hunter
	[781] = { buffID = 118922 },		 -- Disengage (Posthaste)
	[199483] = { buffID = 199483 },		 -- Camouflage
	--[19577] = { buffID = 19577 },		 -- Intimidation
	[109248] = { duration = 10 },		 -- Binding Shot
	[1543] = { duration = 20 },			 -- Flare
	[186257] = { buffID = 186257 },		 -- Aspect of the Cheetah
	[288613] = { buffID = 288613 },		 -- Trueshot
	[264735] = { buffID = 264735 },		 -- Survival of the Fittesh
	[186265] = { buffID = 186265 },		 -- Aspect of the Turtle
	[392956] = { buffID = 392956 },		 -- Fortitude of the Bear
	[5384] = { buffID = 5384 },			 -- Feign Death
	[260243] = { buffID = 260243 },		 -- Volley
	[257620] = { buffID = 257622 },		 -- Multi-Shot (Trick Shots)
	[34477] = { buffID = 35079 },		 -- Misdirection
	[186289] = { buffID = 186289 },		 -- Aspect of the Eagle
	[360952] = { buffID = 360952 },		 -- Coordinated Assault
	[272678] = { buffID = 272678 },		 -- Primal Rage
	[320976] = { buffID = 378770 },		 -- Kill Shot (Deathblow)
	[19574] = { buffID = 19574 },		 -- Bestial Wrath
	[120679] = { buffID = 281036 },		 -- Dire Beast
	[217200] = { buffID = 246152 },		 -- Barbed Shot
	[359844] = { buffID = 359844 },		 -- Call of the Wild
	[2643] = { buffID = 268877 },		 -- Multi-Shot (Beast Cleave)
	[56641] = { buffID = 193534 },		 -- Steady Shot (Steady Focus)

	-- Warrior
	[260708] = { buffID = 260708 },		 -- Sweeping Strikes
	[18499] = { buffID = 18499 },		 -- Berserker Rage
	[2565] = { buffID = 132404 },		 -- Shield Block
	[190456] = { buffID = 190456 },		 -- Ignore Pain

	--  Warlock
	[455465] = { totem = {				 -- Gloomhound
			"Gloomhound", "Charhound", "Vilefiend", -- enUS
		}
	},
	[455476] = { totem = {				 -- Charhound
			"Gloomhound", "Charhound", "Vilefiend", -- enUS
		}
	},
	[264119] = { totem = {				 -- Vilefiend
			"Gloomhound", "Charhound", "Vilefiend", -- enUS
		}
	},
	[265187] = { duration = 15 },		 -- Demonic Tyrant
	[264130] = {						 -- Power Siphon (Demonic Core)
		buffStacks = 264173,
		buffStacksLimit = 4,
	},
	[104316] = { totem = {				 -- Call Dreadstalkers
			"Dreadstalker", -- enUS
		}
	},
	[111898] = { totem = {				 -- Grimoire: Felguard
			"Erakzinul", 				 -- enUS, name changes with felguard name, change code for later
		}
	},
	[48018] = { buffID = 48018 },		 -- Demonic Circle
	[48020] = { buffID = 387633 },		 -- Demonic Circle: Teleport
	[385899] = { buffID = 387626 },		 -- Soulburn
	[104773] = { buffID = 104773 },		 -- Unending Resolve
	[108416] = { buffID = 108416 },		 -- Dark Pact
	[111771] = { buffID = 113942 },		 -- Demonic Gateway (Debuff)
	[702] = { debuffID = 702 },			 -- Curse of Weakness
	[334275] = { debuffID = 334275 },	 -- Curse of Exhaustion
	[1714] = { debuffID = 1714 },		 -- Curse of Tongues
	[6789] = { debuffID = 6789 },		 -- Mortal Coil
	[5792] = { debuffID = 118699 },		 -- Fear
	[30283] = { debuffID = 30283 },		 -- Shadowfury
	[264178] = { buffID = 264173 },		 -- Power Siphon (Demonic Core)
	[105174] = {						 -- Demonic Art (Hand of Gul'dan)
		buffIDs = { 428524, 431944, 432795, 432816, 432794, 432815, 433885 }
	},
	[135800] = { buffID = 433885 },		 -- Ruination (Hand of Gul'dan Proc)
	[841220] = { buffID = 841220 },		 -- Infernal Bolt (Shadow Bolt Proc)
	[316099] = {						 -- Unstable Affliction
		debuffID = 316099,
		refresh = 6,
	 },
	[445468] = { debuffID = 445474 },	 -- Wither (Corruption Hero Talent)
	[980] = {							 -- Agony
		debuffID = 980,
		refresh = 5,
	},
	[278350] = { debuffID = 386931 },	 -- Vile Taint
	[48181] = {							 -- Haunt
		debuffID = 48181,
		refresh = 5
	},
	[386997] = { debuffID = 386997 },	 -- Soul Rot
	[27243] = { debuffID = 27243 },		 -- Seed of Corruption
	[686] = { buffID = 264571 },		 -- Nightfall (Shadowbolt Proc)
	[205180] = { totem = {				 -- Darkglare
			"Darkglare", -- enUS
		}
	},
	[442726] = { buffID = 442726 },		 -- Malevolence (Hero Talent)
	[442804] = { debuffID = 442804 },	 -- Curse of the Satyr (Curse of Weakness Hero Talent)
	[348] = {							 -- Immolate
		debuffID = 157736,
		refresh = 6
	},
	[17962] = { debuffID = 265931 },	 -- Conflagrate
	[6353] = { debuffID = 457555 },		 -- Decimation (Soul Fire Proc)
	[17877] = { debuffID = 17877 },		 -- Shadowburn
	[80240] = { duration = 15 },		 -- Havoc


	--Monk
	[116841] = { buffID = 116841 },		 -- Tiger's Lust
	[123904] = { totem = {				 -- Invoke Xuen, the White Tiger
			"Xuen", -- enUS
		}
	},
	[115203] = { buffID = 115203 },		 -- Fortifying Brew

	-- Demon Hunter
	[188501] = { buffID = 188501 },		 -- Spectral Sight
	[196555] = { buffID = 196555 },		 -- Netherwalk
	[258920] = { buffID = 258920 },		 -- Immolation Aura
	--[427785] = { duration = 2 },		 -- Fel Rush (Dash of Chaos) -- needs redesign, query talent
	[198589] = { buffID = 212800 },		 -- Blur
	[191427] = { buffID = 162264 },		 -- Metamorphosis

	-- Racials
	[58984] = { buffID = 58984 },		 -- Shadowmeld
	[59547] = { buffID = 59547 },		 -- Gift of the Naaru
	[257040] = { buffID = 256948 },		 -- Spatial Rift (Active Use)

	-- Dragonriding
	[403092] = { buffID = 425663 },		 -- Aerial Halt (Wind's Respite)
	[372608] = { buffID = 388367 },		 -- Surge Forward (Ohn'ahra's Gusts)
	[418592] = { buffID = 418592 },		 -- Lightning Rush
	[374994] = { buffID = 375585 },		 -- Bronze Timelock (Bronze Rewind)

	-- Legion Remix
	[1237711] = { buffID = 1237711 },	 -- Twisted Crusade
	[1242973] = { buffID = 1237711 },	 -- Felspike (Twisted Crusade)

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
	elseif classID == 7 then -- Shaman
		cooldown:SetSwipeColor(0, .50, 1); -- Blue
	elseif classID == 3 then -- Hunter
		cooldown:SetSwipeColor(.67, .83, .45); -- Green
	elseif classID == 9 then -- Warlock
		cooldown:SetSwipeColor(.80, .63, 1); -- Purple
	elseif classID == 2 then -- Paladin
		cooldown:SetSwipeColor(.9569, .549, .7294); -- Pink
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

local function UpdateStackTexture(button, cooldown, stacks, maxStacks)
	if stacks and stacks > 0 then
		local pct = 1 - (stacks / maxStacks)  -- invert so full = max stacks

		if type(CooldownFrame_SetDisplayAsPercentage) == "function" then
			CooldownFrame_SetDisplayAsPercentage(cooldown, pct)
			cooldown._stackMode = true
			SetCustomSwipeColor(cooldown)
			return
		end

		-- Fallback: fake a cooldown that always renders at pct
		local D = 1000
		cooldown._stackMode = true
		cooldown:SetScript("OnUpdate", function(cd)
			local now = GetTime()
			cd:SetCooldown(now - pct * D, D)
		end)
		SetCustomSwipeColor(cooldown)
		cooldown:Show()
	else
		cooldown:Hide()
	end
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
					if (actionType == "spell" or actionType == "macro") and spellData[actionID] and actionID == spellID then
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

-- CONVERT TO  C_UnitAuras.GetAuraDataBySpellName("target", "SpellNameHere", "PLAYER, HARMFUL")
local function CheckDebuffAndUpdate(button, cooldown, spellInfo)
	if not button or not cooldown or not spellInfo.debuffID then return end

	local spellName = C_Spell.GetSpellInfo(spellInfo.debuffID).name
	if not spellName then return end

	local aura = C_UnitAuras.GetAuraDataBySpellName("target", spellName, "PLAYER|HARMFUL")
	if aura then
		local duration = aura.duration
		local expirationTime = aura.expirationTime
		local remainingTime = expirationTime - GetTime()

		-- Update the cooldown texture
		UpdateCooldownTexture(button, button.cooldownTexture, duration, expirationTime)

		-- Change color if the remaining time is below the refresh threshold
		if spellInfo.refresh and remainingTime <= spellInfo.refresh then
			cooldown:SetSwipeColor(1, 0, 0, 1) -- Bright red for refresh state
		else
			SetCustomSwipeColor(cooldown) -- Reset to default color
		end
	else
		button.cooldownTexture:Hide() -- Hide if the debuff is not active
	end
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
	elseif spellInfo.buffStacks and spellInfo.buffStacksLimit then
		local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellInfo.buffStacks)
		if aura and aura.applications then
			local stacks = aura.applications
			UpdateStackTexture(button, button.cooldownTexture, stacks, spellInfo.buffStacksLimit)
		else
			cooldown:Hide()
		end
	elseif spellInfo.buffIDs then -- multiple valid buffIDs
		local found = false
		
		for _, buffID in ipairs(spellInfo.buffIDs) do
			local spellIDBuff = C_UnitAuras.GetPlayerAuraBySpellID(buffID)
			if spellIDBuff and spellIDBuff.sourceUnit == "player" then
				local duration = spellIDBuff.duration
				local expirationTime = spellIDBuff.expirationTime
				UpdateCooldownTexture(button, button.cooldownTexture, duration, expirationTime)
				found = true
				break -- no need to check further
			end
		end

		if not found then
			button.cooldownTexture:Hide() -- hide only if none of the buffs were found
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
		if unitTarget == "player" then
			HandleSpellCast(event, unitTarget, spellID);
		end
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
