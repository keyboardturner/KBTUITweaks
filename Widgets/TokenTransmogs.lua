 -- debug, do not add to final version
local function _OnTooltipSetItem(tooltip)
	local _, itemLink = GameTooltip:GetItem();
	if not itemLink then return end;
	
	local itemAppearanceID, itemModifiedAppearanceID = C_TransmogCollection.GetItemInfo(itemLink);

	if not itemAppearanceID or not itemModifiedAppearanceID then return end;
	tooltip:AddDoubleLine("AppearanceID", itemAppearanceID);
	tooltip:AddDoubleLine("ModifiedAppearanceID", itemModifiedAppearanceID);
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, _OnTooltipSetItem);
-- end of debug


local itemData = {
	-- Sepulcher of the First Ones

	-- Helm
	-- Death Knight, Warlock, Demon Hunter
	[191005] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56967, 55996, 56275,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56994, 56023, 56309,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56985, 56014, 56293,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56976, 56005, 56284,
			},
		},
	},
	-- Hunter, Mage, Druid
	[191002] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56329, 56634, 56169,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56356, 56664, 56199,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56347, 56654, 56189,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56338, 56624, 56179,
			},
		},
	},
	-- Paladin, Priest, Shaman
	[191003] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				57077, 55872, 56755,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				57104, 55902, 56728,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				57095, 55892, 56764,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				57086, 55882, 56746,
			},
		},
	},
	-- Warrior, Rogue, Monk
	[191004] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56383, 56047, 56494,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56410, 57003, 56521,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56401, 56063, 56512,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56392, 56087, 56503,
			},
		},
	},

	--Shoulder
	-- Death Knight, Warlock, Demon Hunter
	[191006] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56968, 55997, 56276,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56995, 56024, 56310,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56986, 56015, 56294,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56977, 56006, 56285,
			},
		},
	},
	-- Hunter, Mage, Druid
	[191007] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56330, 56635, 56170, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56357, 56665, 56200, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56348, 56655, 56190,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56339, 56625, 56180,
			},
		},
	},
	-- Paladin, Priest, Shaman
	[191008] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				57078, 55873, 56756, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				57105, 55903, 56729, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				57096, 55893, 56765, 
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				57087, 55883, 56747,
			},
		},
	},
	-- Warrior, Rogue, Monk
	[191009] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56384, 56048, 56495, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56411, 57004, 56522, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56402, 56064, 56513, 
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56393, 56088, 56504,
			},
		},
	},
	
	-- Chest
	-- Death Knight, Warlock, Demon Hunter
	[191010] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56969, 55998, 56277, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56996, 56025, 56302, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56987, 56016, 56295, 
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56978, 56007, 56286,
			},
		},
	},
	-- Hunter, Mage, Druid
	[191011] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56331, 56636, 56171, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56358, 56666, 56201, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56349, 56656, 56191, 
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56340, 56626, 56181,
			},
		},
	},
	-- Paladin, Priest, Shaman
	[191012] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				57079, 55874, 56757, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				57106, 55904, 56730, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				57097, 55901, 56766, 
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				57088, 55891, 56748,
			},
		},
	},
	-- Warrior, Rogue, Monk
	[191013] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56385, 56049, 56496, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56412, 56041, 56523, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56403, 56065, 56514, 
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56394, 56089, 56505,
			},
		},
	},

	-- Hands
	-- Death Knight, Warlock, Demon Hunter
	[191014] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56974, 56003, 56282, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				57001, 56030, 56307, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56992, 56021, 56300, 
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56983, 56012, 56291,
			},
		},
	},
	-- Hunter, Mage, Druid
	[191015] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56336, 56641, 56176, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56363, 56671, 56206, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56354, 56661, 56196, 
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56345, 56631, 56186,
			},
		},
	},
	-- Paladin, Priest, Shaman
	[191016] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				57084, 55879, 56762, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				57111, 55909, 56735, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				57102, 55899, 56771, 
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				57093, 55889, 56753,
			},
		},
	},
	-- Warrior, Rogue, Monk
	[191017] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56390, 56054, 56501, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56417, 56046, 56528, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56408, 56070, 56519, 
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56399, 56094, 56510,
			},
		},
	},

	-- Legs
	-- Death Knight, Warlock, Demon Hunter
	[191018] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56971, 56000, 56279,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56998, 56027, 56304,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56989, 56018, 56297,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56980, 56009, 56288,
			},
		},
	},
	-- Hunter, Mage, Druid
	[191019] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56333, 56638, 56173, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56360, 56668, 56203, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56351, 56658, 56193, 
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56342, 56628, 56183,
			},
		},
	},
	-- Paladin, Priest, Shaman
	[191020] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				57081, 55876, 56759, 
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				57108, 55906, 56732, 
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				57099, 55896, 56768, 
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				57090, 55886, 56750,
			},
		},
	},
	-- Warrior, Rogue, Monk
	[191021] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				56387, 56051, 56498,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				56414, 56043, 56525,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				56405, 56067, 56516,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56091, 56396, 56525,
			},
		},
	},


	-- Nerub-ar Palace

	-- Helm
	-- Death Knight, Warlock, Demon Hunter
	[225622] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				91659, 93102, 91882,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				91650, 93037, 91831,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				91686, 93089, 91860,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				91649, 93073, 91828,
			},
		},
	},
	-- Hunter, Mage, Druid
	[225623] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92495, 93013, 91592,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92475, 92977, 91568,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92525, 92989, 91580,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92513, 92974, 91565,
			},
		},
	},
	-- Paladin, Priest, Shaman
	[225624] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92082, 92314, 92850,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92027, 92270, 92802,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92060, 92259, 92838,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92047, 92301, 92824,
			},
		},
	},
	-- Warrior, Rogue, Monk, Evoker
	[225625] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92427, 92772, 92191, 92129,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92403, 92745, 92181, 92093,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92463, 92754, 92211, 92117,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92448, 92781, 92179, 92162,
			},
		},
	},

	-- Shoulder
	-- Death Knight, Warlock, Demon Hunter
	[225630] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				91513, 93103, 91883,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				91503, 93038, 91832,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				91543, 93090, 91861,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				91501, 93074, 91829,
			},
		},
	},
	-- Hunter, Mage, Druid
	[225631] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92496, 93014, 91593,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92476, 92978, 91569,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92526, 92990, 91581,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92514, 92975, 91566,
			},
		},
	},
	-- Paladin, Priest, Shaman
	[225632] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92083, 92554, 92851,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92028, 92546, 92803,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92061, 92544, 92839,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92048, 92551, 92825,
			},
		},
	},
	-- Warrior, Rogue, Monk, Evoker
	[225633] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92428, 92773, 92192, 92130,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92404, 92746, 92182, 92094,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92464, 92755, 92212, 92118,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92449, 92789, 92180, 92163,
			},
		},
	},

	-- Chest
	-- Death Knight, Warlock, Demon Hunter
	[225614] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				91514, 93104, 91884,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				91504, 93039, 91833,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				91544, 93091, 91862,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				91494, 93065, 91822,
			},
		},
	},
	-- Hunter, Mage, Druid
	[225615] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92497, 93015, 91594,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92477, 92979, 91570,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92527, 92991, 91582,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92507, 93126, 91558,
			},
		},
	},
	-- Paladin, Priest, Shaman
	[225616] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92084, 92315, 92859,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92029, 92271, 92811,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92062, 92260, 92847,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92040, 92400, 92823,
			},
		},
	},
	-- Warrior, Rogue, Monk, Evoker
	[225617] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92429, 92774, 92193, 92131,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92405, 92747, 92183, 92095,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92465, 92756, 92213, 92119,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92441, 92783, 92173, 92155,
			},
		},
	},

	-- Hands
	-- Death Knight, Warlock, Demon Hunter
	[225618] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				91519, 93109, 91889,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				91509, 93044, 91838,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				91549, 93096, 91867,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				91499, 93070, 91972,
			},
		},
	},
	-- Hunter, Mage, Druid
	[225619] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92502, 93020, 91599,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92482, 92984, 91575,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92532, 92996, 91587,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92512, 93120, 91563,
			},
		},
	},
	-- Paladin, Priest, Shaman
	[225620] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92089, 92320, 92857,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92034, 92276, 92809,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92067, 92265, 92845,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92045, 92327, 92821,
			},
		},
	},
	-- Warrior, Rogue, Monk, Evoker
	[225621] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92434, 92779, 92198, 92136,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92410, 92752, 92188, 92100,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92470, 92761, 92218, 92124,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92446, 92788, 92178, 92160,
			},
		},
	},

	-- Legs
	-- Death Knight, Warlock, Demon Hunter
	[225626] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				91516, 93106, 91886,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				91506, 93041, 91835,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				91546, 93093, 91864,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				91496, 93067, 91824,
			},
		},
	},
	-- Hunter, Mage, Druid
	[225627] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92499, 93017, 91596,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92479, 92981, 91572,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92529, 92993, 91584,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92509, 92969, 91560,
			},
		},
	},
	-- Paladin, Priest, Shaman
	[225628] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92086, 92317, 94158,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92031, 92273, 94162,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92064, 92262, 94159,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92042, 92295, 94161,
			},
		},
	},
	-- Warrior, Rogue, Monk, Evoker
	[225629] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {
				92431, 92776, 92195, 92133,
			},
			[Enum.ItemCreationContext.RaidNormal] = {
				92407, 92749, 92185, 92097,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				92467, 92758, 92215, 92121,
			},
			[Enum.ItemCreationContext.RaidMythic] = {
				92443, 92785, 92175, 92157,
			},
		},
	},



	-- Ulduar
	-- Helm
	-- Warrior, Hunter, Shaman
	[45648] = {
		Items = {
			[Enum.ItemCreationContext.RaidNormal] = {
				11450, 11411, 11438,
			},
			[Enum.ItemCreationContext.RaidHeroic] = {
				11450, 11411, 11438,
			},
		},
	},
};

local ClassListTbl = LocalizedClassList();

local function MatchClassIcon(className)
	for k, v in pairs(ClassListTbl) do
		if v == className then
			local coords = CLASS_ICON_TCOORDS[k];
			return coords
		end
	end
end

local function GetItemClassRequirement(itemLink)
	local data = C_TooltipInfo.GetHyperlink(itemLink)
	local pattern = ITEM_CLASSES_ALLOWED:gsub("%%s", "(.+)")

	for k, v in pairs(data.lines) do
		for key, var in pairs(v) do
			if key == "leftText" and type(var) == "string" then
				local classNameFromString = string.match(var, pattern);
				if classNameFromString then
					return MatchClassIcon(classNameFromString)
				end
			end
		end
	end
end


local ItemContextNameTranslator = EnumUtil.GenerateNameTranslation(Enum.ItemCreationContext);

local function GetItemContextFromLink(itemLink)
	local _, linkData = LinkUtil.ExtractLink(itemLink);
	local itemContext = select(12, strsplit(":", linkData));
	itemContext = tonumber(itemContext);
	return itemContext;
end

local function OnTooltipSetItem(tooltip)
	local _, itemLink = GameTooltip:GetItem();
	if not itemLink then return end;

	local tokenID = tonumber(string.match(itemLink, "item:(%d+)"));
	local itemInfo = itemData[tokenID];
	if tokenID and itemInfo then
		local itemContext = GetItemContextFromLink(itemLink);
		local difficultyName = ItemContextNameTranslator(itemContext);
		local appearances = itemInfo.Items[itemContext];
		if not appearances then return end
		for _, appearanceID in ipairs(appearances) do
			local sources = C_TransmogCollection.GetAllAppearanceSources(appearanceID);
			if not sources then return end
			local displayLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sources[1]));
			local requiredClass = GetItemClassRequirement(displayLink);
			if not requiredClass then
				requiredClass = "";
			else
				requiredClass = "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:15:15:0:0:512:512:".. requiredClass[1]*512 ..":".. requiredClass[2]*512 ..":".. requiredClass[3]*512 ..":".. requiredClass[4]*512 .."|t"
			end
			local collected = false;
			for _, sourceID in ipairs(sources) do
				if C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID) then
					collected = true;
					break
				end
			end

			local collectedColor = collected and GREEN_FONT_COLOR or RED_FONT_COLOR;
			local collectedText = collected and COLLECTED or FOLLOWERLIST_LABEL_UNCOLLECTED;
			collectedText = collectedColor:WrapTextInColorCode(collectedText);

			tooltip:AddDoubleLine(requiredClass .. " " .. displayLink, collectedText);
			tooltip:Show();
		end
	end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem);