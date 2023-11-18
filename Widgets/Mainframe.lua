local _, KBT = ...

local function Print(text)
	local textColor = CreateColor(KBTUI_DB.settings.colors.prefix.r, KBTUI_DB.settings.colors.prefix.g, KBTUI_DB.settings.colors.prefix.b):GenerateHexColor()
	text = "|c" .. textColor .. "KBT UI Tweaks" .. "|r" .. ": " .. text
	
	return DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 1)
end

KBT.mainFrame = CreateFrame("Frame", "KBTUITweaks_Mainframe", UIParent, "PortraitFrameTemplateMinimizable");
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

KBT.mainFrame.backdropInfo = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileEdge = true,
	tileSize = 8,
	edgeSize = 8,
	insets = { left = 1, right = 1, top = 1, bottom = 1 },
};

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


KBT.mainFrame.popNameTitle = content1:CreateFontString();
KBT.mainFrame.popNameTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
KBT.mainFrame.popNameTitle:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 10, -15);
KBT.mainFrame.popNameTitle:SetText("Name");

KBT.mainFrame.popSecondsCountedTitle = content1:CreateFontString();
KBT.mainFrame.popSecondsCountedTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
KBT.mainFrame.popSecondsCountedTitle:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 115, -15);
KBT.mainFrame.popSecondsCountedTitle:SetText("Time Observed");

KBT.mainFrame.popLastSeenTitle = content1:CreateFontString();
KBT.mainFrame.popLastSeenTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
KBT.mainFrame.popLastSeenTitle:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 115+95, -15);
KBT.mainFrame.popLastSeenTitle:SetText("Last Seen");

KBT.mainFrame.popFirstSeenTitle = content1:CreateFontString();
KBT.mainFrame.popFirstSeenTitle:SetFont("Fonts\\FRIZQT__.TTF", 11);
KBT.mainFrame.popFirstSeenTitle:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 305+95, -15);
KBT.mainFrame.popFirstSeenTitle:SetText("First Seen");

function KBT.mainFrame.SessionPopulate()
	local placeValue = 1;


	for k, v in pairs(KBT.Session) do
		if not KBT.mainFrame[k.."popSessName"] then
			KBT.mainFrame[k.."popSessName"] = content1:CreateFontString();
		end
		KBT.mainFrame[k.."popSessName"]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		KBT.mainFrame[k.."popSessName"]:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 10, -15*placeValue-15);
		KBT.mainFrame[k.."popSessName"]:SetText(k);
		
		if not KBT.mainFrame[k.."popSessSecondsCounted"] then
			KBT.mainFrame[k.."popSessSecondsCounted"] = content1:CreateFontString();
		end
		KBT.mainFrame[k.."popSessSecondsCounted"]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		KBT.mainFrame[k.."popSessSecondsCounted"]:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 115, -15*placeValue-15);
		KBT.mainFrame[k.."popSessSecondsCounted"]:SetText(SecondsToTime(KBTUI_DB.Interlopers[PlayerNameRealm][k].secondsCounted));
		
		if not KBT.mainFrame[k.."popSessLastSeen"] then
			KBT.mainFrame[k.."popSessLastSeen"] = content1:CreateFontString();
		end
		KBT.mainFrame[k.."popSessLastSeen"]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		KBT.mainFrame[k.."popSessLastSeen"]:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 115+95, -15*placeValue-15);
		KBT.mainFrame[k.."popSessLastSeen"]:SetText(KBTUI_DB.Interlopers[PlayerNameRealm][k].lastSeen);

		if not KBT.mainFrame[k.."popSessFirstSeen"] then
			KBT.mainFrame[k.."popSessFirstSeen"] = content1:CreateFontString();
		end
		KBT.mainFrame[k.."popSessFirstSeen"]:SetFont("Fonts\\FRIZQT__.TTF", 11);
		KBT.mainFrame[k.."popSessFirstSeen"]:SetPoint("TOPLEFT", KBT.mainFrame.sessionFrame, "TOPLEFT", 305+95, -15*placeValue-15);
		KBT.mainFrame[k.."popSessFirstSeen"]:SetText(KBTUI_DB.Interlopers[PlayerNameRealm][k].firstSeen);

		KBT.mainFrame.sessionFrame:SetHeight(15*placeValue+40);

		placeValue = placeValue + 1;
	end
end

function KBT.mainFrame.Populate()
	local placeValue = 1;

	for k, v in pairs(KBTUI_DB.Interlopers[PlayerNameRealm]) do
		KBT.mainFrame.popName = content1:CreateFontString();
		KBT.mainFrame.popName:SetFont("Fonts\\FRIZQT__.TTF", 11);
		KBT.mainFrame.popName:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 10, -15*placeValue-15);
		KBT.mainFrame.popName:SetText(k);

		KBT.mainFrame.popSecondsCounted = content1:CreateFontString();
		KBT.mainFrame.popSecondsCounted:SetFont("Fonts\\FRIZQT__.TTF", 11);
		KBT.mainFrame.popSecondsCounted:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 115, -15*placeValue-15);
		KBT.mainFrame.popSecondsCounted:SetText(SecondsToTime(v.secondsCounted));

		KBT.mainFrame.popLastSeen = content1:CreateFontString();
		KBT.mainFrame.popLastSeen:SetFont("Fonts\\FRIZQT__.TTF", 11);
		KBT.mainFrame.popLastSeen:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 115+95, -15*placeValue-15);
		KBT.mainFrame.popLastSeen:SetText(v.lastSeen);

		KBT.mainFrame.popFirstSeen = content1:CreateFontString();
		KBT.mainFrame.popFirstSeen:SetFont("Fonts\\FRIZQT__.TTF", 11);
		KBT.mainFrame.popFirstSeen:SetPoint("TOPLEFT", KBT.mainFrame.backFrame, "TOPLEFT", 305+95, -15*placeValue-15);
		KBT.mainFrame.popFirstSeen:SetText(v.firstSeen);

		KBT.mainFrame.backFrame:SetHeight(15*placeValue+40);

		placeValue = placeValue + 1;
	end
end