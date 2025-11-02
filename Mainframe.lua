local _, KBT = ...

local function Print(text)
	local textColor = CreateColor(KBTUI_DB.settings.colors.prefix.r, KBTUI_DB.settings.colors.prefix.g, KBTUI_DB.settings.colors.prefix.b):GenerateHexColor()
	text = "|c" .. textColor .. "KBT UI Tweaks" .. "|r" .. ": " .. text
	
	return DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 1)
end


KBT.mainFrame = CreateFrame("Frame", "KBTUITweaks_Mainframe", UIParent, "PortraitFrameTemplateMinimizable");
tinsert(UISpecialFrames, KBT.mainFrame:GetName())
KBT.mainFrame.width = 338*2;
KBT.mainFrame:SetPortraitTextureRaw("Interface\\Icons\\inv_glyph_primeshaman");
--KBT.mainFrame.PortraitContainer.portrait:SetTexture("Interface\\AddOns\\Languages\\Languages_Icon_Small");
KBT.mainFrame:SetTitle("KBT UI Tweaks");
KBT.mainFrame:SetSize(KBT.mainFrame.width,424);
KBT.mainFrame:SetPoint("CENTER", UIParent, "CENTER");
KBT.mainFrame:SetMovable(true);
KBT.mainFrame:SetClampedToScreen(true);
KBT.mainFrame:SetScript("OnMouseDown", function(self, button)
	self:StartMoving();
end);
KBT.mainFrame:SetScript("OnMouseUp", function(self, button)
	KBT.mainFrame:StopMovingOrSizing();
end);
KBT.mainFrame:SetFrameStrata("HIGH")
KBT.mainFrame:Hide()
KBT.mainFrame:SetScript("OnShow", function()
	PlaySound(74421);
end);
KBT.mainFrame:SetScript("OnHide", function()
	PlaySound(74423);
end);
KBT.mainFrame.minMax = true;

function KBT.mainFrame.minMaxFunc()
	if KBT.mainFrame.minMax == true then
		KBT.mainFrame:SetSize(KBT.mainFrame.width,100);
		KBT.mainFrame.minMax = false
	elseif KBT.mainFrame.minMax == false then
		KBT.mainFrame:SetSize(KBT.mainFrame.width,424);
		KBT.mainFrame.minMax = true;
	end
end


-- Helper table to convert month abbreviations to numbers
local monthLookup = {Jan=1, Feb=2, Mar=3, Apr=4, May=5, Jun=6, Jul=7, Aug=8, Sep=9, Oct=10, Nov=11, Dec=12}

-- Helper function to convert the old date string format to a timestamp number
function KBT.mainFrame.convertOldDateToTimestamp(dateString)
	if not dateString or type(dateString) ~= "string" then
		return nil
	end
	
	-- Match format "Fri Oct 31 07:25:53 2025" or "Sun Jan  5 08:51:31 2025" (note the double space for single-digit days)
	-- Use %s+ to match one or more spaces between month and day
	local _, monStr, day, hour, min, sec, year = string.match(dateString, "(%a+)%s+(%a+)%s+(%d+)%s+(%d+):(%d+):(%d+)%s+(%d+)")

	if not year then
		-- Match failed, can't convert
		return nil
	end

	local month = monthLookup[monStr]
	if not month then
		return nil -- Unknown month string
	end

	local timeTable = {
		year = tonumber(year),
		month = tonumber(month),
		day = tonumber(day),
		hour = tonumber(hour),
		min = tonumber(min),
		sec = tonumber(sec)
	}
	
	-- Use pcall (protected call) in case os.time fails (e.g., invalid date components)
	local ok, timestamp = pcall(time, timeTable)
	if ok then
		return timestamp
	else
		-- Log the error for debugging
		Print("Failed to convert date string: " .. dateString)
		return nil
	end
end

KBT.mainFrame.MinimizeButton = CreateFrame("Button", nil, KBT.mainFrame, "MaximizeMinimizeButtonFrameTemplate");
KBT.mainFrame.MinimizeButton:SetPoint("TOPRIGHT", KBT.mainFrame, "TOPRIGHT", -24,0);
KBT.mainFrame.MinimizeButton:SetSize(24,24);
KBT.mainFrame.MinimizeButton:Enable();
KBT.mainFrame.MinimizeButton.MinimizeButton:SetScript("OnClick", KBT.mainFrame.minMaxFunc);
KBT.mainFrame.MinimizeButton.MaximizeButton:SetScript("OnClick", KBT.mainFrame.minMaxFunc);

KBT.mainFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, KBT.mainFrame, "ScrollFrameTemplate");
KBT.mainFrame.ScrollFrame:SetPoint("TOPLEFT", KBT.mainFrame, "TOPLEFT", 4, -8);
KBT.mainFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", KBT.mainFrame, "BOTTOMRIGHT", -3, 4);
KBT.mainFrame.ScrollFrame.ScrollBar:ClearAllPoints();
KBT.mainFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", KBT.mainFrame.ScrollFrame, "TOPRIGHT", -12, -18);
KBT.mainFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", KBT.mainFrame.ScrollFrame, "BOTTOMRIGHT", -7, 0);


KBT.mainFrame.ScrollFrame.child = CreateFrame("Frame", nil, KBT.mainFrame.ScrollFrame);
KBT.mainFrame.ScrollFrame:SetScrollChild(KBT.mainFrame.ScrollFrame.child);
KBT.mainFrame.ScrollFrame.child:SetWidth(KBT.mainFrame:GetWidth()-18);
KBT.mainFrame.ScrollFrame.child:SetHeight(1);

function KBT.mainFrame.Tab_OnClick(self)

	PanelTemplates_SetTab(self:GetParent(), self:GetID());

	local scrollChild = KBT.mainFrame.ScrollFrame:GetScrollChild();
	if (scrollChild) then
		scrollChild:Hide();
	end

	KBT.mainFrame.ScrollFrame:SetScrollChild(self.content);
	self.content:Show();
	PlaySound(841);

end

function KBT.mainFrame.SetTabs(frame,numTabs, ...)
	frame.numTabs = numTabs;

	local contents = {};
	local frameName = frame:GetName();

	for i = 1, numTabs do

		KBT.mainFrame.TabButtonTest = CreateFrame("Button", frameName .. "Tab" .. i, frame, "PanelTabButtonTemplate");
		KBT.mainFrame.TabButtonTest:SetID(i);
		KBT.mainFrame.TabButtonTest:SetText(select(i, ...));
		KBT.mainFrame.TabButtonTest:SetScript("OnClick", KBT.mainFrame.Tab_OnClick);

		KBT.mainFrame.TabButtonTest.content = CreateFrame("Frame", nil, KBT.mainFrame.ScrollFrame);
		KBT.mainFrame.TabButtonTest.content:SetSize(334, 10);
		KBT.mainFrame.TabButtonTest.content:Hide();

		--KBT.mainFrame.TabButtonTest.content.bg = KBT.mainFrame.TabButtonTest.content:CreateTexture(nil, "BACKGROUND")
		--KBT.mainFrame.TabButtonTest.content.bg:SetAllPoints(true)
		--KBT.mainFrame.TabButtonTest.content.bg:SetColorTexture(math.random(), math.random(), math.random(), .6)

		table.insert(contents, KBT.mainFrame.TabButtonTest.content)

		if (i == 1) then
			KBT.mainFrame.TabButtonTest:SetPoint("TOPLEFT", KBT.mainFrame, "BOTTOMLEFT", 11,2);
		else
			KBT.mainFrame.TabButtonTest:SetPoint("TOPLEFT", _G[frameName .. "Tab" .. (i-1)] , "TOPRIGHT", 3, 0);
		end

		--[[
		KBT.mainFrame.TabButtonTest:SetPoint("TOPLEFT", KBT.mainFrame, "BOTTOMLEFT", 20,0)
		KBT.mainFrame.TabButtonTest:SetSize(100,30)
		KBT.mainFrame.TabButtonTest:Enable()
		KBT.mainFrame.TabButtonTest:SetScript("OnClick", function(self, button)
			print("bingus")

		end);

		]]

		
	end


	KBT.mainFrame.Tab_OnClick(_G[frameName .. "Tab1"]);

	return unpack(contents);

end

local currentLanguage = {};
local preserveLanguage = {};
local content1, content2, content3 = KBT.mainFrame.SetTabs(KBT.mainFrame, 3, "Contents", "Settings", "Profiles");

-- Sort state and UI cache for Saved Data
KBT.mainFrame.savedDataSortKey = "name" -- "name", "time", "lastSeen", "firstSeen"
KBT.mainFrame.savedDataSortAsc = true
KBT.mainFrame.savedDataLines = {} -- Cache for UI elements

KBT.mainFrame.backdropInfo = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileEdge = true,
	tileSize = 8,
	edgeSize = 8,
	insets = { left = 1, right = 1, top = 1, bottom = 1 },
};

function KBT.DoPopulationStuff()

	KBT.mainFrame.sessionFrame = CreateFrame("Frame", nil, content1, "BackdropTemplate");
	KBT.mainFrame.sessionFrame:SetPoint("TOPLEFT", content1, "TOPLEFT", 0, -65);
	KBT.mainFrame.sessionFrame:SetSize(KBT.mainFrame.width-38,65);
	KBT.mainFrame.sessionFrame:SetBackdrop(KBT.mainFrame.backdropInfo);
	KBT.mainFrame.sessionFrame:SetBackdropColor(0,0,0,.5);

	KBT.mainFrame.sessionTitle = content1:CreateFontString();
	KBT.mainFrame.sessionTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
	KBT.mainFrame.sessionTitle:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 0, 15);
	KBT.mainFrame.sessionTitle:SetText("Current Session");


	KBT.mainFrame.backFrame = CreateFrame("Frame", nil, KBT.mainFrame.sessionFrame, "BackdropTemplate");
	KBT.mainFrame.backFrame:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "BOTTOMLEFT", 0, -25);
	KBT.mainFrame.backFrame:SetSize(KBT.mainFrame.width-38,65);
	KBT.mainFrame.backFrame:SetBackdrop(KBT.mainFrame.backdropInfo);
	KBT.mainFrame.backFrame:SetBackdropColor(0,0,0,.5);

	KBT.mainFrame.savedTitle = content1:CreateFontString();
	KBT.mainFrame.savedTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
	KBT.mainFrame.savedTitle:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 0, 15);
	KBT.mainFrame.savedTitle:SetText("Saved Data");


	local nameP, realmP = UnitFullName("player");
	local PlayerNameRealm = nameP .. "-" .. realmP;


	KBT.mainFrame.popSessNameTitle = content1:CreateFontString();
	KBT.mainFrame.popSessNameTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
	KBT.mainFrame.popSessNameTitle:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 10, -15);
	KBT.mainFrame.popSessNameTitle:SetText("Name");

	KBT.mainFrame.popSessSecondsCountedTitle = content1:CreateFontString();
	KBT.mainFrame.popSessSecondsCountedTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
	KBT.mainFrame.popSessSecondsCountedTitle:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 115, -15);
	KBT.mainFrame.popSessSecondsCountedTitle:SetText("Time Observed");

	KBT.mainFrame.popSessLastSeenTitle = content1:CreateFontString();
	KBT.mainFrame.popSessLastSeenTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
	KBT.mainFrame.popSessLastSeenTitle:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 115+95, -15);
	KBT.mainFrame.popSessLastSeenTitle:SetText("Last Seen");

	KBT.mainFrame.popSessFirstSeenTitle = content1:CreateFontString();
	KBT.mainFrame.popSessFirstSeenTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
	KBT.mainFrame.popSessFirstSeenTitle:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 305+95, -15);
	KBT.mainFrame.popSessFirstSeenTitle:SetText("First Seen");


	--[[ -- Replaced FontStrings with Buttons for sorting
	KBT.mainFrame.popNameTitle = content1:CreateFontString();
	KBT.mainFrame.popNameTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
	KBT.mainFrame.popNameTitle:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 10, -15);
	KBT.mainFrame.popNameTitle:SetText("Name");
	]]
	KBT.mainFrame.sortBtnName = CreateFrame("Button", nil, KBT.mainFrame.backFrame)
	KBT.mainFrame.sortBtnName:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 30, -15) -- Shifted right for icon
	KBT.mainFrame.sortBtnName:SetSize(80, 12) -- Set Width and Height
	KBT.mainFrame.sortBtnName:SetText("Name")
	KBT.mainFrame.sortBtnName:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 11)
	KBT.mainFrame.sortBtnName:GetFontString():SetPoint("LEFT")
	KBT.mainFrame.sortBtnName:GetFontString():SetTextColor(1, 1, 1) -- Set Normal text color (white)
	KBT.mainFrame.sortBtnName:SetScript("OnClick", function()
		if KBT.mainFrame.savedDataSortKey == "name" then
			KBT.mainFrame.savedDataSortAsc = not KBT.mainFrame.savedDataSortAsc
		else
			KBT.mainFrame.savedDataSortKey = "name"
			KBT.mainFrame.savedDataSortAsc = true -- Default asc for name
		end
		KBT.mainFrame.Populate()
		PlaySound(841)
	end)


	--[[
	KBT.mainFrame.popSecondsCountedTitle = content1:CreateFontString();
	KBT.mainFrame.popSecondsCountedTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
	KBT.mainFrame.popSecondsCountedTitle:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 115, -15);
	KBT.mainFrame.popSecondsCountedTitle:SetText("Time Observed");
	]]
	KBT.mainFrame.sortBtnTime = CreateFrame("Button", nil, KBT.mainFrame.backFrame)
	KBT.mainFrame.sortBtnTime:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 135, -15)
	KBT.mainFrame.sortBtnTime:SetSize(95, 12) -- Set Width and Height
	KBT.mainFrame.sortBtnTime:SetText("Time Observed")
	KBT.mainFrame.sortBtnTime:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 11)
	KBT.mainFrame.sortBtnTime:GetFontString():SetPoint("LEFT")
	KBT.mainFrame.sortBtnTime:GetFontString():SetTextColor(1, 1, 1) -- Set Normal text color (white)
	KBT.mainFrame.sortBtnTime:SetScript("OnClick", function()
		if KBT.mainFrame.savedDataSortKey == "time" then
			KBT.mainFrame.savedDataSortAsc = not KBT.mainFrame.savedDataSortAsc
		else
			KBT.mainFrame.savedDataSortKey = "time"
			KBT.mainFrame.savedDataSortAsc = false -- Default desc for time
		end
		KBT.mainFrame.Populate()
		PlaySound(841)
	end)

	--[[
	KBT.mainFrame.popLastSeenTitle = content1:CreateFontString();
	KBT.mainFrame.popLastSeenTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
	KBT.mainFrame.popLastSeenTitle:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 115+95, -15);
	KBT.mainFrame.popLastSeenTitle:SetText("Last Seen");
	]]
	KBT.mainFrame.sortBtnLastSeen = CreateFrame("Button", nil, KBT.mainFrame.backFrame)
	KBT.mainFrame.sortBtnLastSeen:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 135+95, -15)
	KBT.mainFrame.sortBtnLastSeen:SetSize(80, 12) -- Set Width and Height
	KBT.mainFrame.sortBtnLastSeen:SetText("Last Seen")
	KBT.mainFrame.sortBtnLastSeen:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 11)
	KBT.mainFrame.sortBtnLastSeen:GetFontString():SetPoint("LEFT")
	KBT.mainFrame.sortBtnLastSeen:GetFontString():SetTextColor(1, 1, 1) -- Set Normal text color (white)
	KBT.mainFrame.sortBtnLastSeen:SetScript("OnClick", function()
		if KBT.mainFrame.savedDataSortKey == "lastSeen" then
			KBT.mainFrame.savedDataSortAsc = not KBT.mainFrame.savedDataSortAsc
		else
			KBT.mainFrame.savedDataSortKey = "lastSeen"
			KBT.mainFrame.savedDataSortAsc = false -- Default desc for last seen
		end
		KBT.mainFrame.Populate()
		PlaySound(841)
	end)

	--[[
	KBT.mainFrame.popFirstSeenTitle = content1:CreateFontString();
	KBT.mainFrame.popFirstSeenTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
	KBT.mainFrame.popFirstSeenTitle:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 305+95, -15);
	KBT.mainFrame.popFirstSeenTitle:SetText("First Seen");
	]]
	KBT.mainFrame.sortBtnFirstSeen = CreateFrame("Button", nil, KBT.mainFrame.backFrame)
	KBT.mainFrame.sortBtnFirstSeen:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 325+95, -15)
	KBT.mainFrame.sortBtnFirstSeen:SetSize(80, 12) -- Set Width and Height
	KBT.mainFrame.sortBtnFirstSeen:SetText("First Seen")
	KBT.mainFrame.sortBtnFirstSeen:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 11)
	KBT.mainFrame.sortBtnFirstSeen:GetFontString():SetPoint("LEFT")
	KBT.mainFrame.sortBtnFirstSeen:GetFontString():SetTextColor(1, 1, 1) -- Set Normal text color (white)
	KBT.mainFrame.sortBtnFirstSeen:SetScript("OnClick", function()
		if KBT.mainFrame.savedDataSortKey == "firstSeen" then
			KBT.mainFrame.savedDataSortAsc = not KBT.mainFrame.savedDataSortAsc
		else
			KBT.mainFrame.savedDataSortKey = "firstSeen"
			KBT.mainFrame.savedDataSortAsc = true -- Default asc for first seen
		end
		KBT.mainFrame.Populate()
		PlaySound(841)
	end)
end

-- Helper function to hide all cached lines before repopulating
function KBT.mainFrame.ClearSavedDataLines()
    for _, line in ipairs(KBT.mainFrame.savedDataLines) do
		if line.portrait then line.portrait:Hide() end
        if line.name then line.name:Hide() end
        if line.seconds then line.seconds:Hide() end
        if line.lastSeen then line.lastSeen:Hide() end
        if line.firstSeen then line.firstSeen:Hide() end
    end
end

function KBT.mainFrame.SessionPopulate()
	local placeValue = 1;


	local nameP, realmP = UnitFullName("player");
	local PlayerNameRealm = nameP .. "-" .. realmP;
	local iconFallback = "inv_inscription_scroll"


	for k, v in pairs(KBT.Session) do
		--TRP3_API.slash.openProfile(k)

		if C_AddOns.IsAddOnLoaded("TotalRP3") == true then
			local realmU
			-- KBT.Session data (v) is just the string, not the table
			-- We must get the realm from the main DB
			local dbEntry = KBTUI_DB.Interlopers[PlayerNameRealm] and KBTUI_DB.Interlopers[PlayerNameRealm][k]
			if dbEntry and dbEntry.realmU then
				realmU = dbEntry.realmU
			else
				realmU = realmP
			end

			local profile = AddOn_TotalRP3.Player.static.CreateFromNameAndRealm(k, realmU)
			if profile and profile:GetProfileID() then
				if not KBT.mainFrame[k.."portraitClick"] then
					KBT.mainFrame[k.."portraitClick"] = CreateFrame("Frame", nil, KBT.mainFrame.sessionFrame)
				end
				KBT.mainFrame[k.."portraitClick"]:SetSize(15,15)
				--KBT.mainFrame[k.."portraitClick"]:SetText("TRP3")
				KBT.mainFrame[k.."portraitClick"]:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 5, -15*placeValue-12)
				KBT.mainFrame[k.."portraitClick"]:SetScript("OnMouseDown", function()
					--TargetFrame.TargetFrameContainer.Portrait:SetTexCoord(-0.02, 1.02, -0.02, 1.02)
				end)
				KBT.mainFrame[k.."portraitClick"]:SetScript("OnMouseUp", function()
					TRP3_API.slash.openProfile(k)
					--TargetFrame.TargetFrameContainer.Portrait:SetTexCoord(0, 1, 0, 1)
				end)

				KBT.mainFrame[k.."portraitClick"].IconTex = KBT.mainFrame[k.."portraitClick"]:CreateTexture()
				KBT.mainFrame[k.."portraitClick"].IconTex:SetAllPoints()
				KBT.mainFrame[k.."portraitClick"].IconTex:SetVertexColor(.7,.7,.7)
				if profile:GetCustomIcon() then
					KBT.mainFrame[k.."portraitClick"].IconTex:SetTexture("Interface\\Icons\\"..profile:GetCustomIcon())
				else
					KBT.mainFrame[k.."portraitClick"].IconTex:SetTexture("Interface\\Icons\\"..iconFallback)
				end
				KBT.mainFrame[k.."portraitClick"]:SetScript("OnEnter", function()
					KBT.mainFrame[k.."portraitClick"].IconTex:SetVertexColor(1,1,1)
				end)
				KBT.mainFrame[k.."portraitClick"]:SetScript("OnLeave", function()
					KBT.mainFrame[k.."portraitClick"].IconTex:SetVertexColor(.7,.7,.7)
				end)
			end
		end

		if not KBT.mainFrame[k.."popSessName"] then
			KBT.mainFrame[k.."popSessName"] = KBT.mainFrame.sessionFrame:CreateFontString();
		end
		KBT.mainFrame[k.."popSessName"]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		KBT.mainFrame[k.."popSessName"]:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 30, -15*placeValue-15);
		KBT.mainFrame[k.."popSessName"]:SetText(k);
		
		if not KBT.mainFrame[k.."popSessSecondsCounted"] then
			KBT.mainFrame[k.."popSessSecondsCounted"] = KBT.mainFrame.sessionFrame:CreateFontString();
		end
		KBT.mainFrame[k.."popSessSecondsCounted"]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		KBT.mainFrame[k.."popSessSecondsCounted"]:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 135, -15*placeValue-15);
		KBT.mainFrame[k.."popSessSecondsCounted"]:SetText(SecondsToTime(KBTUI_DB.Interlopers[PlayerNameRealm][k].secondsCounted));
		
		if not KBT.mainFrame[k.."popSessLastSeen"] then
			KBT.mainFrame[k.."popSessLastSeen"] = KBT.mainFrame.sessionFrame:CreateFontString();
		end
		KBT.mainFrame[k.."popSessLastSeen"]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		KBT.mainFrame[k.."popSessLastSeen"]:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 135+95, -15*placeValue-15);
		-- Format the timestamp from the DB (Check for number type)
		if type(KBTUI_DB.Interlopers[PlayerNameRealm][k].lastSeen) == "number" then
			KBT.mainFrame[k.."popSessLastSeen"]:SetText(date("%m/%d/%y %H:%M", KBTUI_DB.Interlopers[PlayerNameRealm][k].lastSeen));
		else
			KBT.mainFrame[k.."popSessLastSeen"]:SetText(KBTUI_DB.Interlopers[PlayerNameRealm][k].lastSeen or "N/A"); -- Show old string
		end

		if not KBT.mainFrame[k.."popSessFirstSeen"] then
			KBT.mainFrame[k.."popSessFirstSeen"] = KBT.mainFrame.sessionFrame:CreateFontString();
		end
		KBT.mainFrame[k.."popSessFirstSeen"]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		KBT.mainFrame[k.."popSessFirstSeen"]:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 325+95, -15*placeValue-15);
		-- Format the timestamp from the DB (Check for number type)
		if type(KBTUI_DB.Interlopers[PlayerNameRealm][k].firstSeen) == "number" then
			KBT.mainFrame[k.."popSessFirstSeen"]:SetText(date("%m/%d/%y %H:%M", KBTUI_DB.Interlopers[PlayerNameRealm][k].firstSeen));
		else
			KBT.mainFrame[k.."popSessFirstSeen"]:SetText(KBTUI_DB.Interlopers[PlayerNameRealm][k].firstSeen or "N/A"); -- Show old string
		end

		KBT.mainFrame.sessionFrame:SetHeight(15*placeValue+40);

		placeValue = placeValue + 1;
	end
end

-- This function now handles sorting and reuses UI elements
function KBT.mainFrame.Populate()
	KBT.mainFrame.ClearSavedDataLines() -- Hide old lines

	local placeValue = 1;
	local nameP, realmP = UnitFullName("player");
	local PlayerNameRealm = nameP .. "-" .. realmP;
	local iconFallback = "inv_inscription_scroll"

	if KBTUI_DB.Interlopers[PlayerNameRealm] then
		
		-- 1. Create sortable table
		local sortedData = {}
		for k, v in pairs(KBTUI_DB.Interlopers[PlayerNameRealm]) do
			table.insert(sortedData, { name = k, data = v })
		end

		-- *** NEW: Data Conversion Step ***
		-- This will find any old string-based dates and convert them to timestamps
		-- It also updates the main DB so this conversion only happens once.
		for _, entry in ipairs(sortedData) do
			local data = entry.data
			local name = entry.name
			
			-- Check and convert lastSeen
			if type(data.lastSeen) == "string" then
				local timestamp = KBT.mainFrame.convertOldDateToTimestamp(data.lastSeen)
				if timestamp then
					data.lastSeen = timestamp -- Update local table for sorting
					KBTUI_DB.Interlopers[PlayerNameRealm][name].lastSeen = timestamp -- Update persistent DB
				end
			end
			
			-- Check and convert firstSeen
			if type(data.firstSeen) == "string" then
				local timestamp = KBT.mainFrame.convertOldDateToTimestamp(data.firstSeen)
				if timestamp then
					data.firstSeen = timestamp -- Update local table for sorting
					KBTUI_DB.Interlopers[PlayerNameRealm][name].firstSeen = timestamp -- Update persistent DB
				end
			end
		end

		-- 2. Define comparator
		local comparator
		local sortKey = KBT.mainFrame.savedDataSortKey
		local sortAsc = KBT.mainFrame.savedDataSortAsc

		if sortKey == "name" then
			comparator = function(a, b)
				if sortAsc then return a.name < b.name else return a.name > b.name end
			end
		elseif sortKey == "time" then
			comparator = function(a, b)
				if sortAsc then return a.data.secondsCounted < b.data.secondsCounted else return a.data.secondsCounted > b.data.secondsCounted end
			end
		elseif sortKey == "lastSeen" then
			comparator = function(a, b)
				-- Add type checking to handle mixed string/number data
				local aVal = a.data.lastSeen
				local bVal = b.data.lastSeen
				local aIsNum = (type(aVal) == "number")
				local bIsNum = (type(bVal) == "number")

				if aIsNum and bIsNum then
					if sortAsc then return aVal < bVal else return aVal > bVal end
				elseif aIsNum and not bIsNum then
					return sortAsc -- Numbers are "greater" (newer) than strings
				elseif not aIsNum and bIsNum then
					return not sortAsc -- Strings are "less" (older) than numbers
				else
					-- Both are strings, just do alphabetical
					if sortAsc then return tostring(aVal) < tostring(bVal) else return tostring(aVal) > tostring(bVal) end
				end
			end
		elseif sortKey == "firstSeen" then
			comparator = function(a, b)
				-- Add type checking to handle mixed string/number data
				local aVal = a.data.firstSeen
				local bVal = b.data.firstSeen
				local aIsNum = (type(aVal) == "number")
				local bIsNum = (type(bVal) == "number")

				if aIsNum and bIsNum then
					if sortAsc then return aVal < bVal else return aVal > bVal end
				elseif aIsNum and not bIsNum then
					return sortAsc -- Numbers are "greater" (newer) than strings
				elseif not aIsNum and bIsNum then
					return not sortAsc -- Strings are "less" (older) than numbers
				else
					-- Both are strings, just do alphabetical
					if sortAsc then return tostring(aVal) < tostring(bVal) else return tostring(aVal) > tostring(bVal) end
				end
			end
		end

		-- 3. Sort the table
		if comparator then
			table.sort(sortedData, comparator)
		end

		-- 4. Iterate sorted table and populate UI
		for placeValue, entry in ipairs(sortedData) do
			local k = entry.name
			local v = entry.data
			local line = KBT.mainFrame.savedDataLines[placeValue]

			-- Create UI elements if they don't exist in cache
			if not line then
				line = {}
				
				line.portrait = CreateFrame("Frame", nil, KBT.mainFrame.backFrame)
				line.portrait:SetSize(15,15)
				line.portrait.IconTex = line.portrait:CreateTexture()
				line.portrait.IconTex:SetAllPoints()

				line.name = KBT.mainFrame.backFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
				line.name:SetFont("Fonts\\FRIZQT__.TTF", 11)
				
				line.seconds = KBT.mainFrame.backFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
				line.seconds:SetFont("Fonts\\FRIZQT__.TTF", 11)

				line.lastSeen = KBT.mainFrame.backFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
				line.lastSeen:SetFont("Fonts\\FRIZQT__.TTF", 11)

				line.firstSeen = KBT.mainFrame.backFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
				line.firstSeen:SetFont("Fonts\\FRIZQT__.TTF", 11)
				
				KBT.mainFrame.savedDataLines[placeValue] = line
			end

			-- Configure Portrait (TRP3 logic)
			line.portrait:ClearAllPoints()
			line.portrait:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 5, -15*placeValue-12)
			if C_AddOns.IsAddOnLoaded("TotalRP3") == true then
				local realmU = v.realmU or realmP
				
				local profile = AddOn_TotalRP3.Player.static.CreateFromNameAndRealm(k, realmU)
				if profile and profile:GetProfileID() then
					line.portrait:SetScript("OnMouseDown", nil)
					line.portrait:SetScript("OnMouseUp", function()
						TRP3_API.slash.openProfile(k)
					end)

					line.portrait.IconTex:SetVertexColor(.7,.7,.7)
					if profile:GetCustomIcon() then
						line.portrait.IconTex:SetTexture("Interface\\Icons\\"..profile:GetCustomIcon())
					else
						line.portrait.IconTex:SetTexture("Interface\\Icons\\"..iconFallback)
					end
					line.portrait:SetScript("OnEnter", function()
						line.portrait.IconTex:SetVertexColor(1,1,1)
					end)
					line.portrait:SetScript("OnLeave", function()
						line.portrait.IconTex:SetVertexColor(.7,.7,.7)
					end)
					line.portrait:Show()
				else
					line.portrait:Hide()
				end
			else
				line.portrait:Hide()
			end

			-- Configure Name
			line.name:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 30, -15*placeValue-15)
			line.name:SetText(k)
			line.name:Show()

			-- Configure Seconds
			line.seconds:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 135, -15*placeValue-15)
			line.seconds:SetText(SecondsToTime(v.secondsCounted))
			line.seconds:Show()

			-- Configure Last Seen
			line.lastSeen:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 135+95, -15*placeValue-15)
			-- Check type before formatting
			if type(v.lastSeen) == "number" then
				line.lastSeen:SetText(date("%m/%d/%y %H:%M", v.lastSeen))
			else
				line.lastSeen:SetText(v.lastSeen or "N/A") -- Display the old string
			end
			line.lastSeen:Show()

			-- Configure First Seen
			line.firstSeen:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 325+95, -15*placeValue-15)
			-- Check type before formatting
			if type(v.firstSeen) == "number" then
				line.firstSeen:SetText(date("%m/%d/%y %H:%M", v.firstSeen))
			else
				line.firstSeen:SetText(v.firstSeen or "N/A") -- Display the old string
			end
			line.firstSeen:Show()

			KBT.mainFrame.backFrame:SetHeight(15*placeValue+40)
		end
	end
end

