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
	-- Chest
	-- Death Knight, Warlock, Demon Hunter
	[191010] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

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

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

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

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

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

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56394, 56089, 56505,
			},
		},
	},

	--Shoulder
	-- Death Knight, Warlock, Demon Hunter
	[191006] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

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

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

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

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

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

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56393, 56088, 56504,
			},
		},
	},
	
	-- Legs
	-- Death Knight, Warlock, Demon Hunter
	[191018] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

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

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

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

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

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

	-- Hands
	-- Death Knight, Warlock, Demon Hunter
	[191014] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

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

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

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

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

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

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56399, 56094, 56510,
			},
		},
	},

	-- Helm
	-- Death Knight, Warlock, Demon Hunter
	[191005] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56976, 56005, 56284,
			},
		},
	},
	-- Paladin, Priest, Shaman
	[191003] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

			},
			[Enum.ItemCreationContext.RaidMythic] = {
				57086, 55882, 56746,
			},
		},
	},
	-- Hunter, Mage, Druid
	[191002] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56338, 56624, 56179,
			},
		},
	},
	-- Warrior, Rogue, Monk
	[191004] = {
		Items = {
			[Enum.ItemCreationContext.RaidFinder] = {

			},
			[Enum.ItemCreationContext.RaidNormal] = {

			},
			[Enum.ItemCreationContext.RaidHeroic] = {

			},
			[Enum.ItemCreationContext.RaidMythic] = {
				56392, 56087, 56503,
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

			tooltip:AddDoubleLine(displayLink .. " " .. difficultyName, collectedText);
			tooltip:Show();
		end
	end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem);