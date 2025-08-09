local _, KBT = ...

local function Print(text)
	local textColor = CreateColor(KBTUI_DB.settings.colors.prefix.r, KBTUI_DB.settings.colors.prefix.g, KBTUI_DB.settings.colors.prefix.b):GenerateHexColor()
	text = "|c" .. textColor .. "KBT UI Tweaks" .. "|r" .. ": " .. text
	
	return DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 1)
end


KBT.ProfessionFrame = CreateFrame("Frame", nil, UIParent)
KBT.ProfessionFrame:SetPoint("TOP", 0, -260)
KBT.ProfessionFrame:SetSize(300,100)
KBT.ProfessionFrame.Tex = KBT.ProfessionFrame:CreateTexture()
KBT.ProfessionFrame.Tex:SetAllPoints()
KBT.ProfessionFrame.Tex:SetTexture(130660)
KBT.ProfessionFrame.Border = CreateFrame("Frame", nil, KBT.ProfessionFrame)
KBT.ProfessionFrame.Border:SetAllPoints(KBT.ProfessionFrame)
for i = 1, 4 do
	KBT.ProfessionFrame.Border[i] = KBT.ProfessionFrame:CreateTexture()
	KBT.ProfessionFrame.Border[i]:SetSize(20,20)
	KBT.ProfessionFrame.Border[i]:SetTexture(130660)
	KBT.ProfessionFrame.Border["Corner" .. i] = KBT.ProfessionFrame:CreateTexture()
	KBT.ProfessionFrame.Border["Corner" .. i]:SetSize(20,20)
	KBT.ProfessionFrame.Border["Corner" .. i]:SetTexture(130660)
end
KBT.ProfessionFrame.Border[1]:SetPoint("LEFT", KBT.ProfessionFrame.Border, "RIGHT")
KBT.ProfessionFrame.Border[2]:SetPoint("RIGHT", KBT.ProfessionFrame.Border, "LEFT")
KBT.ProfessionFrame.Border[3]:SetPoint("TOP", KBT.ProfessionFrame.Border, "BOTTOM")
KBT.ProfessionFrame.Border[4]:SetPoint("BOTTOM", KBT.ProfessionFrame.Border, "TOP")
KBT.ProfessionFrame.Border["Corner" .. 1]:SetPoint("TOPLEFT", KBT.ProfessionFrame.Border, "BOTTOMRIGHT")
KBT.ProfessionFrame.Border["Corner" .. 2]:SetPoint("TOPRIGHT", KBT.ProfessionFrame.Border, "BOTTOMLEFT")
KBT.ProfessionFrame.Border["Corner" .. 3]:SetPoint("BOTTOMLEFT", KBT.ProfessionFrame.Border, "TOPRIGHT")
KBT.ProfessionFrame.Border["Corner" .. 4]:SetPoint("BOTTOMRIGHT", KBT.ProfessionFrame.Border, "TOPLEFT")
KBT.ProfBorderH = KBT.ProfessionFrame.Border:GetHeight()
KBT.ProfBorderW = KBT.ProfessionFrame.Border:GetWidth()
for i = 1, 2 do -- left right
	KBT.ProfessionFrame.Border[i]:SetHeight(KBT.ProfBorderH)
end
for i = 3, 4 do -- top bottom
	KBT.ProfessionFrame.Border[i]:SetWidth(KBT.ProfBorderW)
end




KBT.ProfessionFrame:Hide()


KBT.ProfessionTextTitle = KBT.ProfessionFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
KBT.ProfessionTextTitle:SetPoint("TOP", 0, 0)
KBT.ProfessionTextTitle:SetText("Title")
KBT.ProfessionText = KBT.ProfessionFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
KBT.ProfessionText:SetPoint("TOP", 0, -40)
KBT.ProfessionText:SetText("Hello World")
--KBT.ProfessionText:SetSize(200,100)
KBT.ProfessionText:SetFont("Fonts\\FRIZQT__.TTF", 30)
--KBT.ProfessionText:SetSize(200,100)
KBT.ProfessionTextTitle:SetFont("Fonts\\FRIZQT__.TTF", 30)



KBT.fadeInProfGroup = KBT.ProfessionFrame:CreateAnimationGroup()
KBT.fadeOutProfGroup = KBT.ProfessionFrame:CreateAnimationGroup()

-- Create a fade in animation
KBT.fadeInProf = KBT.fadeInProfGroup:CreateAnimation("Alpha")
KBT.fadeInProf:SetFromAlpha(0)
KBT.fadeInProf:SetToAlpha(1)
KBT.fadeInProf:SetDuration(1) -- Duration of the fade in animation

-- Create a fade out animation
KBT.fadeOutProf = KBT.fadeOutProfGroup:CreateAnimation("Alpha")
KBT.fadeOutProf:SetFromAlpha(1)
KBT.fadeOutProf:SetToAlpha(0)
KBT.fadeOutProf:SetDuration(3) -- Duration of the fade out animation

-- Set scripts for when animations start and finish
KBT.fadeOutProfGroup:SetScript("OnFinished", function()
	KBT.ProfessionFrame:Hide() -- Hide the frame when the fade out animation is finished
end)
KBT.fadeInProfGroup:SetScript("OnPlay", function()
	KBT.ProfessionFrame:Show() -- Show the frame when the fade in animation starts
end)

-- Function to show the frame with a fade in animation
function KBT.ShowWithFadeProf()
	KBT.fadeInProfGroup:Stop() -- Stop any ongoing animations
	KBT.fadeInProfGroup:Play() -- Play the fade in animation
end

-- Function to hide the frame with a fade out animation
function KBT.HideWithFadeProf()
	KBT.fadeOutProfGroup:Stop() -- Stop any ongoing animations
	KBT.fadeOutProfGroup:Play() -- Play the fade out animation
end

KBT.ProfessionNames = {
	[129] = "First Aid",
	[164] = "Blacksmithing",
	[165] = "Leatherworking",
	[171] = "Alchemy",
	[182] = "Herbalism",
	[185] = "Cooking",
	[186] = "Mining",
	[197] = "Tailoring",
	[202] = "Engineering",
	[333] = "Enchanting",
	[356] = "Fishing",
	[393] = "Skinning",
	[755] = "Jewelcrafting",
	[773] = "Inscription",
	[794] = "Archeology",
};

KBT.ProfessionVariants = {
	[129] = { -- First Aid

	},
	[164] = { -- Blacksmithing
		[2477] = "Classic Blacksmithing",
		[2476] = "Outland Blacksmithing",
		[2475] = "Northrend Blacksmithing",
		[2474] = "Cataclysm Blacksmithing",
		[2473] = "Pandaria Blacksmithing",
		[2472] = "Draenor Blacksmithing",
		[2454] = "Legion Blacksmithing",
		[2437] = "Kul Tiran Blacksmithing",
		[2751] = "Shadowlands Blacksmithing",
		[2822] = "Dragon Isles Blacksmithing",
		[2872] = "Khaz Algar Blacksmithing",
	},
	[165] = { -- Leatherworking
		[2532] = "Classic Leatherworking",
		[2531] = "Outland Leatherworking",
		[2530] = "Northrend Leatherworking",
		[2529] = "Cataclysm Leatherworking",
		[2528] = "Pandaria Leatherworking",
		[2527] = "Draenor Leatherworking",
		[2526] = "Legion Leatherworking",
		[2525] = "Kul Tiran Leatherworking",
		[2758] = "Shadowlands Leatherworking",
		[2830] = "Dragon Isles Leatherworking",
		[2880] = "Khaz Algar Leatherworking",
	},
	[171] = { -- Alchemy
		[2485] = "Classic Alchemy",
		[2484] = "Outland Alchemy",
		[2483] = "Northrend Alchemy",
		[2482] = "Cataclysm Alchemy",
		[2481] = "Pandaria Alchemy",
		[2480] = "Draenor Alchemy",
		[2479] = "Legion Alchemy",
		[2478] = "Kul Tiran Alchemy",
		[2750] = "Shadowlands Alchemy",
		[2823] = "Dragon Isles Alchemy",
		[2871] = "Khaz Algar Alchemy",
	},
	[182] = { -- Herbalism
		[2556] = "Classic Herbalism",
		[2555] = "Outland Herbalism",
		[2554] = "Northrend Herbalism",
		[2553] = "Cataclysm Herbalism",
		[2552] = "Pandaria Herbalism",
		[2551] = "Draenor Herbalism",
		[2550] = "Legion Herbalism",
		[2549] = "Kul Tiran Herbalism",
		[2760] = "Shadowlands Herbalism",
		[2832] = "Dragon Isles Herbalism",
		[2877] = "Khaz Algar Herbalism",
	},
	[185] = { -- Cooking
		[2548] = "Classic Cooking",
		[2547] = "Outland Cooking",
		[2546] = "Northrend Cooking",
		[2545] = "Cataclysm Cooking",
		[2544] = "Pandaria Cooking",
		[2543] = "Draenor Cooking",
		[2542] = "Legion Cooking",
		[2541] = "Kul Tiran Cooking",
		[2752] = "Shadowlands Cooking",
		[2824] = "Dragon Isles Cooking",
		[2873] = "Khaz Algar Cooking"
	},
	[186] = { -- Mining
		[2572] = "Classic Mining",
		[2571] = "Outland Mining",
		[2570] = "Northrend Mining",
		[2569] = "Cataclysm Mining",
		[2568] = "Pandaria Mining",
		[2567] = "Draenor Mining",
		[2566] = "Legion Mining",
		[2565] = "Kul Tiran Mining",
		[2761] = "Shadowlands Mining",
		[2833] = "Dragon Isles Mining",
		[2881] = "Khaz Algar Mining",
	},
	[197] = { -- Tailoring
		[2540] = "Classic Tailoring",
		[2539] = "Outland Tailoring",
		[2538] = "Northrend Tailoring",
		[2537] = "Cataclysm Tailoring",
		[2536] = "Pandaria Tailoring",
		[2535] = "Draenor Tailoring",
		[2534] = "Legion Tailoring",
		[2533] = "Kul Tiran Tailoring",
		[2759] = "Shadowlands Tailoring",
		[2831] = "Dragon Isles Tailoring",
		[2883] = "Khaz Algar Tailoring",
	},
	[202] = { -- Engineering
		[2506] = "Classic Engineering",
		[2505] = "Outland Engineering",
		[2504] = "Northrend Engineering",
		[2503] = "Cataclysm Engineering",
		[2502] = "Pandaria Engineering",
		[2501] = "Draenor Engineering",
		[2500] = "Legion Engineering",
		[2499] = "Kul Tiran Engineering",
		[2755] = "Shadowlands Engineering",
		[2827] = "Dragon Isles Engineering",
		[2875] = "Khaz Algar Engineering",
	},
	[333] = { -- Enchanting
		[2494] = "Classic Enchanting",
		[2493] = "Outland Enchanting",
		[2492] = "Northrend Enchanting",
		[2491] = "Cataclysm Enchanting",
		[2489] = "Pandaria Enchanting",
		[2488] = "Draenor Enchanting",
		[2487] = "Legion Enchanting",
		[2486] = "Kul Tiran Enchanting",
		[2753] = "Shadowlands Enchanting",
		[2825] = "Dragon Isles Enchanting",
		[2874] = "Khaz Algar Enchanting",
	},
	[356] = { -- Fishing
		[2592] = "Classic Fishing",
		[2591] = "Outland Fishing",
		[2590] = "Northrend Fishing",
		[2589] = "Cataclysm Fishing",
		[2588] = "Pandaria Fishing",
		[2587] = "Draenor Fishing",
		[2586] = "Legion Fishing",
		[2585] = "Kul Tiran Fishing",
		[2754] = "Shadowlands Fishing",
		[2826] = "Dragon Isles Fishing",
		[2876] = "Khaz Algar Fishing",
	},
	[393] = { -- Skinning
		[2564] = "Classic Skinning",
		[2563] = "Outland Skinning",
		[2562] = "Northrend Skinning",
		[2561] = "Cataclysm Skinning",
		[2560] = "Pandaria Skinning",
		[2559] = "Draenor Skinning",
		[2558] = "Legion Skinning",
		[2557] = "Kul Tiran Skinning",
		[2762] = "Shadowlands Skinning",
		[2834] = "Dragon Isles Skinning",
		[2882] = "Khaz Algar Skinning",
	},
	[755] = { -- Jewelcrafting
		[2524] = "Classic Jewelcrafting",
		[2523] = "Outland Jewelcrafting",
		[2522] = "Northrend Jewelcrafting",
		[2521] = "Cataclysm Jewelcrafting",
		[2520] = "Pandaria Jewelcrafting",
		[2519] = "Draenor Jewelcrafting",
		[2518] = "Legion Jewelcrafting",
		[2517] = "Kul Tiran Jewelcrafting",
		[2757] = "Shadowlands Jewelcrafting",
		[2829] = "Dragon Isles Jewelcrafting",
		[2879] = "Khaz Algar Jewelcrafting",
	},
	[773] = { -- Inscription
		[2514] = "Classic Inscription",
		[2513] = "Outland Inscription",
		[2512] = "Northrend Inscription",
		[2511] = "Cataclysm Inscription",
		[2510] = "Pandaria Inscription",
		[2509] = "Draenor Inscription",
		[2508] = "Legion Inscription",
		[2507] = "Kul Tiran Inscription",
		[2756] = "Shadowlands Inscription",
		[2828] = "Dragon Isles Inscription",
		[2878] = "Khaz Algar Inscription",
	},
	[794] = { -- Archaeology

	},
};

KBT.FakeSoundKits = {
	[356] = {2066763, 2066764, 2066765, 2066766, 2066767}, -- fishing
	[197] = {4612169, 4612171, 4612173, 4612175, 4612177, 4612179, 4612181, 4612183, 4612185, 4612187}, -- tialoring
};

function KBT:SetProfessionTextures(profID)
	if profID == 182 then -- herb
		KBT.ProfessionFrame.Tex:SetAtlas("Professions-Specializations-Preview-Art-Herbalism")
		PlaySound(171203);
		--PlaySound(172362);
		PlaySound(187682);
	elseif profID == 356 then -- fish
		KBT.ProfessionFrame.Tex:SetAtlas("Professions-Specializations-Preview-Art-Herbalism") -- placeholder test
		--PlaySound(117843); -- infinite loop
		PlaySoundFile(KBT.FakeSoundKits[356][math.random(1,5)]);
		PlaySound(203692);
	elseif profID == 333 then -- enchanting
		PlaySound(23747)
		PlaySound(20561)
	elseif profID == 197 then -- tailoring
		PlaySoundFile(KBT.FakeSoundKits[197][math.random(1,5)]);
		PlaySound(215234);
	else -- everything else
		KBT.ProfessionFrame.Tex:SetTexture(130660);
		PlaySound(44292);
		PlaySound(44295);
	end

end

function KBT:FindProfession(skill)
	for k, v in pairs(KBT.ProfessionNames) do
		--Print(v)
		--Print(C_TradeSkillUI.GetTradeSkillDisplayName(k))
		for i, t in pairs(KBT.ProfessionVariants[k]) do
			--Print(C_TradeSkillUI.GetTradeSkillDisplayName(i))
			if string.find(string.lower(skill), string.lower(C_TradeSkillUI.GetTradeSkillDisplayName(i))) then
				Print(C_TradeSkillUI.GetTradeSkillDisplayName(i) .. " - Expansion-Specific Name")
				Print(C_TradeSkillUI.GetTradeSkillDisplayName(k) .. " - General Name")
				KBT:SetProfessionTextures(k)
			end
		end
	end
end

function KBT:ProfessionNotifierFunc(_, eventMessage)
	local ERR_SKILL_UP_SI_modified = ERR_SKILL_UP_SI:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")
	local skill, skillLevel = string.match(eventMessage, ERR_SKILL_UP_SI_modified)

	if skill and skillLevel then
		KBT.ProfessionText:SetText(skill);
		KBT.ProfessionTextTitle:SetText(skillLevel);
		KBT.ShowWithFadeProf();
		--Print("Skill: " .. skill)
		--Print("Skill Level: " .. skillLevel)
		KBT:FindProfession(skill);
		C_Timer.After(5, function()
			KBT.HideWithFadeProf();
		end)

		--Print("Skill:", skill);
		--Print("Skill Level:", tonumber(skillLevel));
	end
end
KBT.ProfessionFrame:RegisterEvent("CHAT_MSG_SKILL")
KBT.ProfessionFrame:SetScript("OnEvent", KBT.ProfessionNotifierFunc)