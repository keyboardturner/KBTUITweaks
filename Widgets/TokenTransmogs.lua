local strmatch = string.match;
local GetAllAppearanceSources = C_TransmogCollection.GetAllAppearanceSources;
local GetAppearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo;
local PlayerHasTransmogItemModifiedAppearance = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance;

--[[
-- debug, do not add to final version
local idEditBox = CreateFrame("EditBox", "AppearanceIDEditBox", UIParent, "InputBoxTemplate");
idEditBox:SetSize(500, 45);
idEditBox:SetAutoFocus(false);
idEditBox:Hide();
idEditBox:SetPoint("CENTER", UIParent, "CENTER");
idEditBox:SetTextInsets(10, 10, 10, 10);
idEditBox:SetFontObject("GameFontHighlight");
idEditBox:SetScript("OnEscapePressed", function(self) self:Hide() end);

local collectedAppearanceIDs = {};

idEditBox:SetScript("OnHide", function(self)
    collectedAppearanceIDs = {};
end)
local function _OnTooltipSetItem(tooltip)
	local _, itemLink = GameTooltip:GetItem();
	if not itemLink then return end;

	local itemAppearanceID, itemModifiedAppearanceID = C_TransmogCollection.GetItemInfo(itemLink);

	if not itemAppearanceID or not itemModifiedAppearanceID then return end;
	tooltip:AddDoubleLine("AppearanceID", itemAppearanceID);
	tooltip:AddDoubleLine("ModifiedAppearanceID", itemModifiedAppearanceID);

	local msg = string.format("AppearanceID: %d, ModifiedAppearanceID: %d", itemAppearanceID, itemModifiedAppearanceID);
	DEFAULT_CHAT_FRAME:AddMessage(msg);

    if not collectedAppearanceIDs[itemAppearanceID] then
        table.insert(collectedAppearanceIDs, itemAppearanceID);
        collectedAppearanceIDs[itemAppearanceID] = true;
    end

    local displayText = table.concat(collectedAppearanceIDs, " ");
    idEditBox:SetText(displayText);
    idEditBox:HighlightText();
    idEditBox:Show();
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, _OnTooltipSetItem);
-- end of debug
]]


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

--SLs/Dragonflight+
local CLASS_GROUP_1 = {6, 9, 12};		--Death Knight, Warlock, Demon Hunter
local CLASS_GROUP_2 = {3, 8, 11};		--Hunter, Mage, Druid
local CLASS_GROUP_3 = {2, 5, 7};		--Paladin, Priest, Shaman
local CLASS_GROUP_4 = {1, 4, 10, 13};	--Warrior, Rogue, Monk, Evoker

--TBC(Mount Hyjal)-MoP
local CLASS_GROUP_5 = {2, 5, 9};		--Paladin, Priest, Warlock
local CLASS_GROUP_6 = {1, 3, 7, 10};	--Warrior, Hunter, Shaman, Monk
local CLASS_GROUP_7 = {4, 6, 8, 11};	--Rogue, Death Knight, Mage, Druid

--TBC(Gruul's Lair)-TBC(The Eye)
local CLASS_GROUP_8 = {2, 4, 7};		--Paladin, Rogue, Shaman
local CLASS_GROUP_9 = {1, 5, 11};		--Warrior, Priest, Druid
local CLASS_GROUP_10 = {3, 8, 9};		--Hunter, Mage, Warlock

--Vanilla(AQ40)
local CLASS_GROUP_11 = {1, 3, 4, 5};		--Warrior, Hunter, Rogue, Priest 			(Qiraji Bindings of Command)
local CLASS_GROUP_12 = {2, 7, 8, 9, 11};	--Paladin, Shaman, Mage, Warlock, Druid		(Qiraji Bindings of Dominance)
local CLASS_GROUP_13 = {1, 3, 4, 7, 11};	--Paladin, Hunter, Rogue, Shaman, Druid		(Vek'lore's Diadem)
local CLASS_GROUP_14 = {1, 5, 8, 9};		--Warrior, Priest, Mage, Warlock			(Vek'nilash's Circlet)
local CLASS_GROUP_15 = {1, 4, 5, 8};		--Warrior, Rogue, Priest, Mage				(Ouro's Intact Hide)
local CLASS_GROUP_16 = {2, 3, 7, 11};		--Paladin, Hunter, Shaman, Warlock, Druid	(Skin of the Great Sandworm)
local CLASS_GROUP_17 = {1, 2, 3, 4, 7};		--Warrior, Paladin, Hunter, Rogue, Shaman	(Carapace of the Old God)
local CLASS_GROUP_18 = {5, 8, 9, 11};		--Priest, Mage, Warlock, Druid				(Husk of the Old God)

--Vanilla(AQ10)
local CLASS_GROUP_19 = {3, 4, 5, 9};		--Hunter, Rogue, Priest, Warlock			(Qiraji Ceremonial Ring)
local CLASS_GROUP_20 = {1, 2, 7, 8, 11};	--Warrior, Paladin, Shaman, Mage, Druid		(Qiraji Magisterial Ring)
local CLASS_GROUP_21 = {1, 4, 5, 8};		--Warrior, Rogue, Priest, Mage				(Qiraji Martial Drape)
local CLASS_GROUP_22 = {2, 3, 7, 9, 11};	--Paladin, Hunter, Shaman, Warlock, Druid	(Qiraji Regal Drape)
local CLASS_GROUP_23 = {5, 8, 9, 11};		--Priest, Mage, Warlock, Druid				(Qiraji Ornate Hilt)
local CLASS_GROUP_24 = {1, 2, 3, 4, 7};		--Warrior, Paladin, Hunter, Rogue, Shaman	(Qiraji Spiked Hilt)



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

	-- Amirdrassil
	-- Helm
	-- Death Knight, Warlock, Demon Hunter
	[207470] = {
		Items = {
			[RAID_FINDER] = {
				82944, 81631, 81139,
			},
			[RAID_NORMAL] = {
				82955, 81619, 81148,
			},
			[RAID_HEROIC] = {
				82922, 81583, 81166,
			},
			[RAID_MYTHIC] = {
				82942, 81605, 81175,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[207471] = {
		Items = {
			[RAID_FINDER] = {
				82261, 81227, 82602, -- Hunter, Mage, Druid Head Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				82291, 81260, 82613,
			},
			[RAID_HEROIC] = {
				82271, 81249, 82624,
			},
			[RAID_MYTHIC] = {
				82281, 81224, 82645,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[207472] = {
		Items = {
			[RAID_FINDER] = {
				81088, 82046, 81034, -- Paladin, Priest, Shaman Head Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				81077, 82094, 81045,
			},
			[RAID_HEROIC] = {
				81098, 82070, 81023,
			},
			[RAID_MYTHIC] = {
				81116, 82092, 81018,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk, Evoker
	[207473] = {
		Items = {
			[RAID_FINDER] = {
				82739, 82667, 81352, 82834, -- Warrior, Rogue, Monk, Evoker Head Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				82757, 82703, 81392, 82823,
			},
			[RAID_HEROIC] = {
				82766, 82679, 81362, 82856,
			},
			[RAID_MYTHIC] = {
				82782, 82736, 81382, 82877,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	-- Shoulder
	-- Death Knight, Warlock, Demon Hunter
	[207478] = {
		Items = {
			[RAID_FINDER] = {
				82998, 82668, 81353, 82835, -- Warrior, Rogue, Monk, Evoker Shoulder Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				83002, 82704, 81393, 82824,
			},
			[RAID_HEROIC] = {
				83004, 82680, 81363, 82857,
			},
			[RAID_MYTHIC] = {
				83007, 82737, 81391, 82868,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[207479] = {
		Items = {
			[RAID_FINDER] = {
				82262, 81228, 82603, -- Hunter, Mage, Druid Shoulder Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				82292, 81261, 82614,
			},
			[RAID_HEROIC] = {
				82272, 81250, 82625,
			},
			[RAID_MYTHIC] = {
				82290, 81225, 82655,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[207480] = {
		Items = {
			[RAID_FINDER] = {
				81089, 82047, 81036, -- Paladin, Priest, Shaman Shoulder Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				81069, 82095, 81043,
			},
			[RAID_HEROIC] = {
				81099, 82071, 81021,
			},
			[RAID_MYTHIC] = {
				81124, 82093, 81017,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk, Evoker
	[207481] = {
		Items = {
			[RAID_FINDER] = {
				82998, 82668, 81353, 82835, -- Warrior, Rogue, Monk, Evoker Shoulder Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				83002, 82704, 81393, 82824,
			},
			[RAID_HEROIC] = {
				83004, 82680, 81363, 82857,
			},
			[RAID_MYTHIC] = {
				83007, 82737, 81391, 82868,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	-- Chest
	-- Death Knight, Warlock, Demon Hunter
	[207462] = {
		Items = {
			[RAID_FINDER] = {
				82946, 81575, 81141,
			},
			[RAID_NORMAL] = {
				82957, 81621, 81150,
			},
			[RAID_HEROIC] = {
				82924, 81585, 81168,
			},
			[RAID_MYTHIC] = {
				82935, 81597, 81177,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[207463] = {
		Items = {
			[RAID_FINDER] = {
				82263, 81229, 82604, -- Hunter, Mage, Druid Chest Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				82293, 81262, 82615,
			},
			[RAID_HEROIC] = {
				82273, 81251, 82626,
			},
			[RAID_MYTHIC] = {
				82283, 81218, 82647,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[207464] = {	
		Items = {
			[RAID_FINDER] = {
				81090, 82055, 81032, -- Paladin, Priest, Shaman Chest Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				81063, 82103, 81047,
			},
			[RAID_HEROIC] = {
				81100, 82079, 81026,
			},
			[RAID_MYTHIC] = {
				81118, 82091, 81016,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk, Evoker
	[207465] = {
		Items = {
			[RAID_FINDER] = {
				82740, 82669, 81354, 82843, -- Warrior, Rogue, Monk, Evoker Chest Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				82758, 82705, 81394, 82832,
			},
			[RAID_HEROIC] = {
				82767, 82681, 81364, 82865,
			},
			[RAID_MYTHIC] = {
				82797, 82729, 81384, 82876,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	-- Hands
	-- Death Knight, Warlock, Demon Hunter
	[207466] = {
		Items = {
			[RAID_FINDER] = {
				82951, 81580, 81146,
			},
			[RAID_NORMAL] = {
				82962, 81626, 81155,
			},
			[RAID_HEROIC] = {
				82929, 81590, 81173,
			},
			[RAID_MYTHIC] = {
				82940, 81602, 81182,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[207467] = {
		Items = {
			[RAID_FINDER] = {
				82268, 81234, 82609, -- Hunter, Mage, Druid Hand Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				82298, 81267, 82620,
			},
			[RAID_HEROIC] = {
				82278, 81256, 82631,
			},
			[RAID_MYTHIC] = {
				82288, 81223, 82652,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[207468] = {
		Items = {
			[RAID_FINDER] = {
				81095, 82053, 81031, -- Paladin, Priest, Shaman Hand Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				81064, 82101, 81048,
			},
			[RAID_HEROIC] = {
				81105, 82077, 81027,
			},
			[RAID_MYTHIC] = {
				81123, 82089, 81010,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk, Evoker
	[207469] = {
		Items = {
			[RAID_FINDER] = {
				82745, 82674, 81359, 82841, -- Warrior, Rogue, Monk, Evoker Hand Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				82763, 82710, 81399, 82830,
			},
			[RAID_HEROIC] = {
				82772, 82686, 81369, 82863,
			},
			[RAID_MYTHIC] = {
				82781, 82734, 81389, 82874,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	-- Legs
	-- Death Knight, Warlock, Demon Hunter
	[207474] = {
		Items = {
			[RAID_FINDER] = {
				82948, 81577, 81143,
			},
			[RAID_NORMAL] = {
				82959, 81623, 81152,
			},
			[RAID_HEROIC] = {
				82926, 81587, 81170,
			},
			[RAID_MYTHIC] = {
				82937, 81599, 81179,
			},
		},
		Classes = CLASS_GROUP_1,
	},
	-- Hunter, Mage, Druid
	[207475] = {
		Items = {
			[RAID_FINDER] = {
				82265, 81231, 82606, -- Hunter, Mage, Druid Leg Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				82295, 81264, 82617,
			},
			[RAID_HEROIC] = {
				82275, 81253, 82628,
			},
			[RAID_MYTHIC] = {
				82285, 81220, 82649,
			},
		},
		Classes = CLASS_GROUP_2,
	},
	-- Paladin, Priest, Shaman
	[207476] = {
		Items = {
			[RAID_FINDER] = {
				81092, 82050, 81035, -- Paladin, Priest, Shaman Leg Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				81067, 82098, 81044,
			},
			[RAID_HEROIC] = {
				81102, 82074, 81022,
			},
			[RAID_MYTHIC] = {
				81120, 82086, 81008,
			},
		},
		Classes = CLASS_GROUP_3,
	},
	-- Warrior, Rogue, Monk, Evoker
	[207477] = {
		Items = {
			[RAID_FINDER] = {
				82742, 82671, 81356, 82838, -- Warrior, Rogue, Monk, Evoker Leg Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				82760, 82707, 81396, 82827,
			},
			[RAID_HEROIC] = {
				82769, 82683, 81366, 82860,
			},
			[RAID_MYTHIC] = {
				82778, 82731, 81386, 82871,
			},
		},
		Classes = CLASS_GROUP_4,
	},

	--Aberrus
	-- Death Knight, Warlock, Demon Hunter
	[202627] = {
		Items = {
			[RAID_FINDER] = {
				80411, 79580, 80547, -- Death Knight, Warlock, Demon Hunter Head Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				80400, 79593, 80536,
			},
			[RAID_HEROIC] = {
				80444, 79567, 80580,
			},
			[RAID_MYTHIC] = {
				80442, 79564, 80578,
			},
		},
	},
	[202621] = {
		Items = {
			[RAID_FINDER] = {
				80412, 79581, 80548, -- Death Knight, Warlock, Demon Hunter Shoulder Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				80401, 79594, 80537,
			},
			[RAID_HEROIC] = {
				80445, 79568, 80581,
			},
			[RAID_MYTHIC] = {
				80443, 79565, 80579,
			},
		},
	},
	[202631] = {
		Items = {
			[RAID_FINDER] = {
				80413, 79582, 80549, -- Death Knight, Warlock, Demon Hunter Chest Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				80402, 79595, 80538,
			},
			[RAID_HEROIC] = {
				80446, 79569, 80582,
			},
			[RAID_MYTHIC] = {
				80435, 79556, 80571,
			},
		},
	},
	[202624] = {
		Items = {
			[RAID_FINDER] = {
				80418, 79587, 80554, -- Death Knight, Warlock, Demon Hunter Hand Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				80407, 79600, 80543,
			},
			[RAID_HEROIC] = {
				80451, 79574, 80587,
			},
			[RAID_MYTHIC] = {
				80440, 79561, 80576,
			},
		},
	},
	[202634] = {
		Items = {
			[RAID_FINDER] = {
				80415, 79584, 80551, -- Death Knight, Warlock, Demon Hunter Leg Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				80404, 79597, 80540,
			},
			[RAID_HEROIC] = {
				80448, 79571, 80584,
			},
			[RAID_MYTHIC] = {
				80437, 79558, 80573,
			},
		},
	},

	-- Hunter, Mage, Druid
	[202628] = {
		Items = {
			[RAID_FINDER] = {
				79925, 80496, 78936, -- Hunter, Mage, Druid Head Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				79903, 80515, 78876,
			},
			[RAID_HEROIC] = {
				79958, 80466, 78924,
			},
			[RAID_MYTHIC] = {
				79956, 80811, 78921,
			},
		},
	},
	[202622] = {
		Items = {
			[RAID_FINDER] = {
				79926, 80497, 78937, -- Hunter, Mage, Druid Shoulder Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				79904, 80516, 78877,
			},
			[RAID_HEROIC] = {
				79959, 80467, 78925,
			},
			[RAID_MYTHIC] = {
				79957, 80513, 78922,
			},
		},
	},
	[202632] = {
		Items = {
			[RAID_FINDER] = {
				79927, 80498, 78938, -- Hunter, Mage, Druid Chest Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				79905, 80517, 78878,
			},
			[RAID_HEROIC] = {
				79960, 80468, 78926,
			},
			[RAID_MYTHIC] = {
				79949, 80507, 78914,
			},
		},
	},
	[202625] = {
		Items = {
			[RAID_FINDER] = {
				79932, 80503, 78943, -- Hunter, Mage, Druid Hand Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				79910, 80522, 78883,
			},
			[RAID_HEROIC] = {
				79965, 80473, 78931,
			},
			[RAID_MYTHIC] = {
				79954, 80512, 78919,
			},
		},
	},
	[202635] = {
		Items = {
			[RAID_FINDER] = {
				79929, 80500, 78940, -- Hunter, Mage, Druid Leg Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				79907, 80519, 78880,
			},
			[RAID_HEROIC] = {
				79962, 80470, 78928,
			},
			[RAID_MYTHIC] = {
				79951, 80509, 78916,
			},
		},
	},

	-- Paladin, Priest, Shaman
	[202729] = {
		Items = {
			[RAID_FINDER] = {
				79067, 79196, 78972, -- Paladin, Priest, Shaman Head Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				79089, 79246, 79008,
			},
			[RAID_HEROIC] = {
				79078, 79216, 78996,
			},
			[RAID_MYTHIC] = {
				79065, 79215, 78993,
			},
		},
	},
	[202623] = {
		Items = {
			[RAID_FINDER] = {
				79068, 79197, 78973, -- Paladin, Priest, Shaman Shoulder Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				79090, 79247, 79009,
			},
			[RAID_HEROIC] = {
				79079, 79217, 78997,
			},
			[RAID_MYTHIC] = {
				79066, 79207, 78994,
			},
		},
	},
	[202633] = {
		Items = {
			[RAID_FINDER] = {
				79075, 79198, 78974, -- Paladin, Priest, Shaman Chest Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				79097, 79248, 79010,
			},
			[RAID_HEROIC] = {
				79086, 79218, 78998,
			},
			[RAID_MYTHIC] = {
				79064, 79208, 78986,
			},
		},
	},
	[202626] = {
		Items = {
			[RAID_FINDER] = {
				79074, 79203, 78979, -- Paladin, Priest, Shaman Hand Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				79096, 79253, 79015,
			},
			[RAID_HEROIC] = {
				79085, 79223, 79003,
			},
			[RAID_MYTHIC] = {
				79063, 79213, 78991,
			},
		},
	},
	[202636] = {
		Items = {
			[RAID_FINDER] = {
				79071, 79200, 78976, -- Paladin, Priest, Shaman Leg Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				79093, 79250, 79012,
			},
			[RAID_HEROIC] = {
				79082, 79220, 79000,
			},
			[RAID_MYTHIC] = {
				79060, 79210, 78988,
			},
		},
	},

	-- Warrior, Rogue, Monk, Evoker
	[202630] = {
		Items = {
			[RAID_FINDER] = {
				80709, 78388, 79656, 80615, -- Warrior, Rogue, Monk, Evoker Head Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				80661, 78398, 79606, 80591,
			},
			[RAID_HEROIC] = {
				80673, 78378, 79646, 80649,
			},
			[RAID_MYTHIC] = {
				80730, 78368, 79644, 80647,
			},
		},
	},
	[202637] = {
		Items = {
			[RAID_FINDER] = {
				80710, 78389, 79657, 80616, -- Warrior, Rogue, Monk, Evoker Shoulder Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				80662, 78399, 79607, 80592,
			},
			[RAID_HEROIC] = {
				80674, 78379, 79647, 80650,
			},
			[RAID_MYTHIC] = {
				80731, 78377, 79645, 80813,
			},
		},
	},
	[202639] = {
		Items = {
			[RAID_FINDER] = {
				80711, 78390, 79658, 80617, -- Warrior, Rogue, Monk, Evoker Chest Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				80663, 78400, 79608, 80593,
			},
			[RAID_HEROIC] = {
				80675, 78380, 79648, 80651,
			},
			[RAID_MYTHIC] = {
				80723, 78370, 79638, 80640,
			},
		},
	},
	[2026238] = {
		Items = {
			[RAID_FINDER] = {
				80716, 78395, 79663, 80622, -- Warrior, Rogue, Monk, Evoker Hand Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				80668, 78405, 79613, 80598,
			},
			[RAID_HEROIC] = {
				80680, 78385, 79653, 80656,
			},
			[RAID_MYTHIC] = {
				80728, 78375, 79643, 80645,
			},
		},
	},
	[202640] = {
		Items = {
			[RAID_FINDER] = {
				80713, 78392, 79660, 80619, -- Warrior, Rogue, Monk, Evoker Leg Slot IDs grouped together
			},
			[RAID_NORMAL] = {
				80665, 78402, 79610, 80595,
			},
			[RAID_HEROIC] = {
				80677, 78382, 79650, 80653,
			},
			[RAID_MYTHIC] = {
				80725, 78372, 79640, 80642,
			},
		},
	},

	-- Vault of the Incarnates





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