 -- debug, do not add to final version
local function _OnTooltipSetItem(tooltip)
	local _, itemLink = GameTooltip:GetItem();
	if not itemLink then return end;
	
	local itemAppearanceID, itemModifiedAppearanceID = C_TransmogCollection.GetItemInfo(itemLink);
	tooltip:AddDoubleLine("AppearanceID", itemAppearanceID);
	tooltip:AddDoubleLine("ModifiedAppearanceID", itemModifiedAppearanceID);
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, _OnTooltipSetItem);
-- end of debug


local itemData = {
	-- Sepulcher

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