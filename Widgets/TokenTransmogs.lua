local strmatch = string.match;
local GetAllAppearanceSources = C_TransmogCollection.GetAllAppearanceSources;
local GetAppearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo;
local PlayerHasTransmogItemModifiedAppearance = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance;


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


local itemData = {};

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
				local classNameFromString = strmatch(var, pattern);
				if classNameFromString then
					return MatchClassIcon(classNameFromString)
				end
			end
		end
	end
end


local ClassVisual = {};

function ClassVisual:GetClassIconMarkup(classID)
	if not self.classIconMarkups then
		self.classIconMarkups = {};
	end

	if self.classIconMarkups[classID] == nil then
		local _, fileName = GetClassInfo(classID);

		local useAtlas = false;		--CharacterCreateIcons are 128x128 they doesn't look good when down-scaled
		local iconSize = 0;			--0: follow font size

		if useAtlas then
			local atlas = "classicon-"..fileName;
			if C_Texture.GetAtlasInfo(atlas) then
				self.classIconMarkups[classID] = string.format("|A:%s:%s:%s|a", atlas, iconSize, iconSize);
			else
				self.classIconMarkups[classID] = false;
			end
		else
			self.classIconMarkups[classID] = string.format("|Tinterface\\icons\\classicon_%s:%s:%s:0:0:64:64:4:60:4:60|t", fileName, iconSize, iconSize);
		end
	end

	return self.classIconMarkups[classID]
end


local ItemContextNameTranslator = EnumUtil.GenerateNameTranslation(Enum.ItemCreationContext);

local function GetItemContextFromLink(itemLink)
	local _, linkData = LinkUtil.ExtractLink(itemLink);
	local itemContext = select(12, strsplit(":", linkData));
	itemContext = tonumber(itemContext);
	return itemContext;
end

local function GetCollectionInfoForToken(itemLink)
	local tokenID = tonumber(strmatch(itemLink, "item:(%d+)"));
	local itemInfo = tokenID and itemData[tokenID];
	if itemInfo then
		local itemContext = GetItemContextFromLink(itemLink);
		local difficultyName = ItemContextNameTranslator(itemContext);
		local appearances = itemInfo.Items[itemContext];
		if not appearances then return end

		local classGroup = itemInfo.Classes;
		local linkReceived = true;

		local collectionInfo = {};

		for i, appearanceID in ipairs(appearances) do
			local sources = GetAllAppearanceSources(appearanceID);
			if not sources then return end

			local displayLink = select(6, GetAppearanceSourceInfo(sources[1]));
			if displayLink then
				if not strmatch(displayLink, "%[(.+)%]") then
					linkReceived = false;
				end
			end

			local classID = classGroup and classGroup[i] or nil;
			local iconMarkup;
			if classID then
				iconMarkup = ClassVisual:GetClassIconMarkup(classGroup[i]);
			end
			if not iconMarkup then
				local requiredClass = GetItemClassRequirement(displayLink);
				if not requiredClass then
					iconMarkup = "";
				else
					iconMarkup = "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:15:15:0:0:512:512:".. requiredClass[1]*512 ..":".. requiredClass[2]*512 ..":".. requiredClass[3]*512 ..":".. requiredClass[4]*512 .."|t"
				end
			end

			local collected = false;
			for _, sourceID in ipairs(sources) do
				if PlayerHasTransmogItemModifiedAppearance(sourceID) then
					collected = true;
					break
				end
			end

			local collectedColor = collected and GREEN_FONT_COLOR or RED_FONT_COLOR;
			local collectedText = collected and COLLECTED or FOLLOWERLIST_LABEL_UNCOLLECTED;
			collectedText = collectedColor:WrapTextInColorCode(collectedText);

			collectionInfo[i] = {
				classID = classID,
				link = displayLink,
				collected = collected,
				leftText = iconMarkup .. " " .. displayLink,
				rightText = collectedText
			};
		end

		return collectionInfo, linkReceived
	end
end

KBTUI_GetCollectionInfoForToken = GetCollectionInfoForToken;	--Globals

local function OnTooltipSetItem(tooltip)
	if not tooltip.GetItem then return end;		--Change GameTooltip to tooltip so it covers ItemRefTooltip
	local _, itemLink = tooltip:GetItem();
	if not itemLink then return end;

	local collectionInfo, linkReceived = GetCollectionInfoForToken(itemLink);
	if collectionInfo then
		for _, info in ipairs(collectionInfo) do
			tooltip:AddDoubleLine(info.leftText, info.rightText);
		end

		if not linkReceived then
			if tooltip.RefreshDataNextUpdate then
				tooltip:RefreshDataNextUpdate();
			end
		end

		tooltip:Show();
	end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem);




local RAID_FINDER = Enum.ItemCreationContext.RaidFinder;
local RAID_NORMAL = Enum.ItemCreationContext.RaidNormal;
local RAID_HEROIC = Enum.ItemCreationContext.RaidHeroic;
local RAID_MYTHIC = Enum.ItemCreationContext.RaidMythic;

local CLASS_GROUP_1 = {6, 9, 12};		--Death Knight, Warlock, Demon Hunter
local CLASS_GROUP_2 = {3, 8, 11};		--Hunter, Mage, Druid
local CLASS_GROUP_3 = {2, 5, 7};		--Paladin, Priest, Shaman
local CLASS_GROUP_4 = {1, 4, 10, 13};	--Warrior, Rogue, Monk, Evoker

itemData = {
	-- Sepulcher of the First Ones

	-- Helm
	-- Death Knight, Warlock, Demon Hunter
	[191005] = {
		Items = {
			[RAID_FINDER] = {
				56967, 55996, 56275,
			},
			[RAID_NORMAL] = {
				56994, 56023, 56309,
			},
			[RAID_HEROIC] = {
				56985, 56014, 56293,
			},
			[RAID_MYTHIC] = {
				56976, 56005, 56284,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[191002] = {
		Items = {
			[RAID_FINDER] = {
				56329, 56634, 56169,
			},
			[RAID_NORMAL] = {
				56356, 56664, 56199,
			},
			[RAID_HEROIC] = {
				56347, 56654, 56189,
			},
			[RAID_MYTHIC] = {
				56338, 56624, 56179,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[191003] = {
		Items = {
			[RAID_FINDER] = {
				57077, 55872, 56755,
			},
			[RAID_NORMAL] = {
				57104, 55902, 56728,
			},
			[RAID_HEROIC] = {
				57095, 55892, 56764,
			},
			[RAID_MYTHIC] = {
				57086, 55882, 56746,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk
	[191004] = {
		Items = {
			[RAID_FINDER] = {
				56383, 56047, 56494,
			},
			[RAID_NORMAL] = {
				56410, 57003, 56521,
			},
			[RAID_HEROIC] = {
				56401, 56063, 56512,
			},
			[RAID_MYTHIC] = {
				56392, 56087, 56503,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	--Shoulder
	-- Death Knight, Warlock, Demon Hunter
	[191006] = {
		Items = {
			[RAID_FINDER] = {
				56968, 55997, 56276,
			},
			[RAID_NORMAL] = {
				56995, 56024, 56310,
			},
			[RAID_HEROIC] = {
				56986, 56015, 56294,
			},
			[RAID_MYTHIC] = {
				56977, 56006, 56285,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[191007] = {
		Items = {
			[RAID_FINDER] = {
				56330, 56635, 56170, 
			},
			[RAID_NORMAL] = {
				56357, 56665, 56200, 
			},
			[RAID_HEROIC] = {
				56348, 56655, 56190,
			},
			[RAID_MYTHIC] = {
				56339, 56625, 56180,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[191008] = {
		Items = {
			[RAID_FINDER] = {
				57078, 55873, 56756, 
			},
			[RAID_NORMAL] = {
				57105, 55903, 56729, 
			},
			[RAID_HEROIC] = {
				57096, 55893, 56765, 
			},
			[RAID_MYTHIC] = {
				57087, 55883, 56747,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk
	[191009] = {
		Items = {
			[RAID_FINDER] = {
				56384, 56048, 56495, 
			},
			[RAID_NORMAL] = {
				56411, 57004, 56522, 
			},
			[RAID_HEROIC] = {
				56402, 56064, 56513, 
			},
			[RAID_MYTHIC] = {
				56393, 56088, 56504,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	-- Chest
	-- Death Knight, Warlock, Demon Hunter
	[191010] = {
		Items = {
			[RAID_FINDER] = {
				56969, 55998, 56277, 
			},
			[RAID_NORMAL] = {
				56996, 56025, 56302, 
			},
			[RAID_HEROIC] = {
				56987, 56016, 56295, 
			},
			[RAID_MYTHIC] = {
				56978, 56007, 56286,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[191011] = {
		Items = {
			[RAID_FINDER] = {
				56331, 56636, 56171, 
			},
			[RAID_NORMAL] = {
				56358, 56666, 56201, 
			},
			[RAID_HEROIC] = {
				56349, 56656, 56191, 
			},
			[RAID_MYTHIC] = {
				56340, 56626, 56181,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[191012] = {
		Items = {
			[RAID_FINDER] = {
				57079, 55874, 56757, 
			},
			[RAID_NORMAL] = {
				57106, 55904, 56730, 
			},
			[RAID_HEROIC] = {
				57097, 55901, 56766, 
			},
			[RAID_MYTHIC] = {
				57088, 55891, 56748,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk
	[191013] = {
		Items = {
			[RAID_FINDER] = {
				56385, 56049, 56496, 
			},
			[RAID_NORMAL] = {
				56412, 56041, 56523, 
			},
			[RAID_HEROIC] = {
				56403, 56065, 56514, 
			},
			[RAID_MYTHIC] = {
				56394, 56089, 56505,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	-- Hands
	-- Death Knight, Warlock, Demon Hunter
	[191014] = {
		Items = {
			[RAID_FINDER] = {
				56974, 56003, 56282, 
			},
			[RAID_NORMAL] = {
				57001, 56030, 56307, 
			},
			[RAID_HEROIC] = {
				56992, 56021, 56300, 
			},
			[RAID_MYTHIC] = {
				56983, 56012, 56291,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[191015] = {
		Items = {
			[RAID_FINDER] = {
				56336, 56641, 56176, 
			},
			[RAID_NORMAL] = {
				56363, 56671, 56206, 
			},
			[RAID_HEROIC] = {
				56354, 56661, 56196, 
			},
			[RAID_MYTHIC] = {
				56345, 56631, 56186,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[191016] = {
		Items = {
			[RAID_FINDER] = {
				57084, 55879, 56762, 
			},
			[RAID_NORMAL] = {
				57111, 55909, 56735, 
			},
			[RAID_HEROIC] = {
				57102, 55899, 56771, 
			},
			[RAID_MYTHIC] = {
				57093, 55889, 56753,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk
	[191017] = {
		Items = {
			[RAID_FINDER] = {
				56390, 56054, 56501, 
			},
			[RAID_NORMAL] = {
				56417, 56046, 56528, 
			},
			[RAID_HEROIC] = {
				56408, 56070, 56519, 
			},
			[RAID_MYTHIC] = {
				56399, 56094, 56510,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	-- Legs
	-- Death Knight, Warlock, Demon Hunter
	[191018] = {
		Items = {
			[RAID_FINDER] = {
				56971, 56000, 56279,
			},
			[RAID_NORMAL] = {
				56998, 56027, 56304,
			},
			[RAID_HEROIC] = {
				56989, 56018, 56297,
			},
			[RAID_MYTHIC] = {
				56980, 56009, 56288,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[191019] = {
		Items = {
			[RAID_FINDER] = {
				56333, 56638, 56173, 
			},
			[RAID_NORMAL] = {
				56360, 56668, 56203, 
			},
			[RAID_HEROIC] = {
				56351, 56658, 56193, 
			},
			[RAID_MYTHIC] = {
				56342, 56628, 56183,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[191020] = {
		Items = {
			[RAID_FINDER] = {
				57081, 55876, 56759, 
			},
			[RAID_NORMAL] = {
				57108, 55906, 56732, 
			},
			[RAID_HEROIC] = {
				57099, 55896, 56768, 
			},
			[RAID_MYTHIC] = {
				57090, 55886, 56750,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk
	[191021] = {
		Items = {
			[RAID_FINDER] = {
				56387, 56051, 56498,
			},
			[RAID_NORMAL] = {
				56414, 56043, 56525,
			},
			[RAID_HEROIC] = {
				56405, 56067, 56516,
			},
			[RAID_MYTHIC] = {
				56091, 56396, 56525,
			},
		},
		Classes = CLASS_GROUP_4,
	},


	-- Nerub-ar Palace

	-- Helm
	-- Death Knight, Warlock, Demon Hunter
	[225622] = {
		Items = {
			[RAID_FINDER] = {
				91659, 93102, 91882,
			},
			[RAID_NORMAL] = {
				91650, 93037, 91831,
			},
			[RAID_HEROIC] = {
				91686, 93089, 91860,
			},
			[RAID_MYTHIC] = {
				91649, 93073, 91828,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[225623] = {
		Items = {
			[RAID_FINDER] = {
				92495, 93013, 91592,
			},
			[RAID_NORMAL] = {
				92475, 92977, 91568,
			},
			[RAID_HEROIC] = {
				92525, 92989, 91580,
			},
			[RAID_MYTHIC] = {
				92513, 92974, 91565,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[225624] = {
		Items = {
			[RAID_FINDER] = {
				92082, 92314, 92850,
			},
			[RAID_NORMAL] = {
				92027, 92270, 92802,
			},
			[RAID_HEROIC] = {
				92060, 92259, 92838,
			},
			[RAID_MYTHIC] = {
				92047, 92301, 92824,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk, Evoker
	[225625] = {
		Items = {
			[RAID_FINDER] = {
				92427, 92772, 92191, 92129,
			},
			[RAID_NORMAL] = {
				92403, 92745, 92181, 92093,
			},
			[RAID_HEROIC] = {
				92463, 92754, 92211, 92117,
			},
			[RAID_MYTHIC] = {
				92448, 92781, 92179, 92162,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	-- Shoulder
	-- Death Knight, Warlock, Demon Hunter
	[225630] = {
		Items = {
			[RAID_FINDER] = {
				91513, 93103, 91883,
			},
			[RAID_NORMAL] = {
				91503, 93038, 91832,
			},
			[RAID_HEROIC] = {
				91543, 93090, 91861,
			},
			[RAID_MYTHIC] = {
				91501, 93074, 91829,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[225631] = {
		Items = {
			[RAID_FINDER] = {
				92496, 93014, 91593,
			},
			[RAID_NORMAL] = {
				92476, 92978, 91569,
			},
			[RAID_HEROIC] = {
				92526, 92990, 91581,
			},
			[RAID_MYTHIC] = {
				92514, 92975, 91566,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[225632] = {
		Items = {
			[RAID_FINDER] = {
				92083, 92554, 92851,
			},
			[RAID_NORMAL] = {
				92028, 92546, 92803,
			},
			[RAID_HEROIC] = {
				92061, 92544, 92839,
			},
			[RAID_MYTHIC] = {
				92048, 92551, 92825,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk, Evoker
	[225633] = {
		Items = {
			[RAID_FINDER] = {
				92428, 92773, 92192, 92130,
			},
			[RAID_NORMAL] = {
				92404, 92746, 92182, 92094,
			},
			[RAID_HEROIC] = {
				92464, 92755, 92212, 92118,
			},
			[RAID_MYTHIC] = {
				92449, 92789, 92180, 92163,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	-- Chest
	-- Death Knight, Warlock, Demon Hunter
	[225614] = {
		Items = {
			[RAID_FINDER] = {
				91514, 93104, 91884,
			},
			[RAID_NORMAL] = {
				91504, 93039, 91833,
			},
			[RAID_HEROIC] = {
				91544, 93091, 91862,
			},
			[RAID_MYTHIC] = {
				91494, 93065, 91822,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[225615] = {
		Items = {
			[RAID_FINDER] = {
				92497, 93015, 91594,
			},
			[RAID_NORMAL] = {
				92477, 92979, 91570,
			},
			[RAID_HEROIC] = {
				92527, 92991, 91582,
			},
			[RAID_MYTHIC] = {
				92507, 93126, 91558,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[225616] = {
		Items = {
			[RAID_FINDER] = {
				92084, 92315, 92859,
			},
			[RAID_NORMAL] = {
				92029, 92271, 92811,
			},
			[RAID_HEROIC] = {
				92062, 92260, 92847,
			},
			[RAID_MYTHIC] = {
				92040, 92400, 92823,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk, Evoker
	[225617] = {
		Items = {
			[RAID_FINDER] = {
				92429, 92774, 92193, 92131,
			},
			[RAID_NORMAL] = {
				92405, 92747, 92183, 92095,
			},
			[RAID_HEROIC] = {
				92465, 92756, 92213, 92119,
			},
			[RAID_MYTHIC] = {
				92441, 92783, 92173, 92155,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	-- Hands
	-- Death Knight, Warlock, Demon Hunter
	[225618] = {
		Items = {
			[RAID_FINDER] = {
				91519, 93109, 91889,
			},
			[RAID_NORMAL] = {
				91509, 93044, 91838,
			},
			[RAID_HEROIC] = {
				91549, 93096, 91867,
			},
			[RAID_MYTHIC] = {
				91499, 93070, 91972,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[225619] = {
		Items = {
			[RAID_FINDER] = {
				92502, 93020, 91599,
			},
			[RAID_NORMAL] = {
				92482, 92984, 91575,
			},
			[RAID_HEROIC] = {
				92532, 92996, 91587,
			},
			[RAID_MYTHIC] = {
				92512, 93120, 91563,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[225620] = {
		Items = {
			[RAID_FINDER] = {
				92089, 92320, 92857,
			},
			[RAID_NORMAL] = {
				92034, 92276, 92809,
			},
			[RAID_HEROIC] = {
				92067, 92265, 92845,
			},
			[RAID_MYTHIC] = {
				92045, 92327, 92821,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk, Evoker
	[225621] = {
		Items = {
			[RAID_FINDER] = {
				92434, 92779, 92198, 92136,
			},
			[RAID_NORMAL] = {
				92410, 92752, 92188, 92100,
			},
			[RAID_HEROIC] = {
				92470, 92761, 92218, 92124,
			},
			[RAID_MYTHIC] = {
				92446, 92788, 92178, 92160,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	-- Legs
	-- Death Knight, Warlock, Demon Hunter
	[225626] = {
		Items = {
			[RAID_FINDER] = {
				91516, 93106, 91886,
			},
			[RAID_NORMAL] = {
				91506, 93041, 91835,
			},
			[RAID_HEROIC] = {
				91546, 93093, 91864,
			},
			[RAID_MYTHIC] = {
				91496, 93067, 91824,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[225627] = {
		Items = {
			[RAID_FINDER] = {
				92499, 93017, 91596,
			},
			[RAID_NORMAL] = {
				92479, 92981, 91572,
			},
			[RAID_HEROIC] = {
				92529, 92993, 91584,
			},
			[RAID_MYTHIC] = {
				92509, 92969, 91560,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[225628] = {
		Items = {
			[RAID_FINDER] = {
				92086, 92317, 94158,
			},
			[RAID_NORMAL] = {
				92031, 92273, 94162,
			},
			[RAID_HEROIC] = {
				92064, 92262, 94159,
			},
			[RAID_MYTHIC] = {
				92042, 92295, 94161,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk, Evoker
	[225629] = {
		Items = {
			[RAID_FINDER] = {
				92431, 92776, 92195, 92133,
			},
			[RAID_NORMAL] = {
				92407, 92749, 92185, 92097,
			},
			[RAID_HEROIC] = {
				92467, 92758, 92215, 92121,
			},
			[RAID_MYTHIC] = {
				92443, 92785, 92175, 92157,
			},
		},
		Classes = CLASS_GROUP_4,
	},



	-- Ulduar
	-- Helm
	-- Warrior, Hunter, Shaman
	[45648] = {
		Items = {
			[RAID_NORMAL] = {
				11450, 11411, 11438,
			},
			[RAID_HEROIC] = {
				11450, 11411, 11438,
			},
		},
	},
};