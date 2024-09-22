local function Print(text)
	local textColor = CreateColor(KBTUI_DB.settings.colors.prefix.r, KBTUI_DB.settings.colors.prefix.g, KBTUI_DB.settings.colors.prefix.b):GenerateHexColor()
	text = "|c" .. textColor .. "KBT UI Tweaks" .. "|r" .. ": " .. text
	
	return DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 1)
end


local initialize = CreateFrame("Frame");
initialize:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW");
initialize:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE");

local buttonFrame = CreateFrame("Button", nil, initialize, "UIPanelButtonTemplate")
buttonFrame:SetWidth(164)
buttonFrame:SetHeight(22)
buttonFrame:SetText("Unblock Mouse Frame")
buttonFrame:SetNormalFontObject("GameFontNormal")
buttonFrame:SetScript("OnClick", function(self, button)
	VoidStorageBorderFrameMouseBlockFrame:Hide()
	VoidStorageBorderFrame.Bg:Hide()
end)
buttonFrame:Hide()


local function PlaceButton()
	if UnitAffectingCombat("player") ~= true then
		buttonFrame:ClearAllPoints()
		buttonFrame:SetParent(VoidStorageBorderFrame)
		buttonFrame:Show()
		buttonFrame:SetPoint("BOTTOMRIGHT", VoidStorageBorderFrame, "BOTTOMRIGHT", 0, 0)
	else
		return
	end
end

local function CheckFrame()
	PlaceButton()
	VoidStorageBorderFrameMouseBlockFrame:Hide()
	VoidStorageBorderFrame.Bg:Hide()
end


function initialize:Go(event, arg1)
	if event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" and (arg1 == "26" or arg1 == 26) then
		Print("Unblocking the Void Storage frame.")
		RunNextFrame(CheckFrame)
	end
	if event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" and (arg1 == "26" or arg1 == 26) then
		buttonFrame:ClearAllPoints()
		buttonFrame:Hide()
	end
end

initialize:SetScript("OnEvent", initialize.Go)