local frame

local function CreateMainFrame()
	frame = CreateFrame("Frame", "OutfitPickerFrame", UIParent, "PortraitFrameTemplate")
	tinsert(UISpecialFrames, frame:GetName())
	
	local portrait = frame.PortraitContainer.portrait
	portrait:SetTexCoord(0.03, 1, 0.03, 1)
	portrait:SetAtlas("transmog-icon-UI")
	
	frame:SetTitle("Transmog Outfits")
	frame:SetSize(380, 450)
	frame:SetPoint("CENTER")
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		self:StopMovingOrSizing()
	end)
	frame:SetFrameStrata("HIGH")
	frame:Hide()
	frame:SetScript("OnHide", function()
		PlaySound(74423)
	end)
	frame:SetScript("OnShow", function()
		PlaySound(74421)
	end)
	
	local scrollBorder = CreateFrame("Frame", nil, frame, "InsetFrameTemplate3")
	scrollBorder:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -65)
	scrollBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 4)
	frame.ScrollBorder = scrollBorder
	
	local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "ScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", scrollBorder, "TOPLEFT", 4, -4)
	scrollFrame:SetPoint("BOTTOMRIGHT", scrollBorder, "BOTTOMRIGHT", -3, 3)
	scrollFrame.ScrollBar:ClearAllPoints()
	scrollFrame.ScrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", -12, -18)
	scrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", -7, 16)
	
	local content = CreateFrame("Frame", nil, scrollFrame)
	content:SetSize(340, 1)
	scrollFrame:SetScrollChild(content)
	
	frame.scrollFrame = scrollFrame
	frame.content = content
	frame.buttons = {}
	
	return frame
end

local function CreateOutfitButton(parent, outfit, index)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(45, 45)
	
	local col = (index - 1) % 6
	local row = math.floor((index - 1) / 6)
	button:SetPoint("TOPLEFT", 10 + (col * 55), -10 - (row * 55))
	
	button.icon = button:CreateTexture(nil, "BACKGROUND")
	button.icon:SetAllPoints()
	button.icon:SetTexture(outfit.icon)
	
	button.border = button:CreateTexture(nil, "OVERLAY")
	button.border:SetAtlas("transmog-outfit-card-lineGlw-purple")
	button.border:SetBlendMode("ADD")
	button.border:SetAllPoints()
	
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	
	button.outfitID = outfit.outfitID
	button.outfitName = outfit.name
	
	button:RegisterForClicks("LeftButtonUp", "LeftButtonDown")
	button:SetScript("OnClick", function(self, btn)
		if btn == "LeftButton" then
			--do stuff here (if possible, equip outfit)
		end
	end)
	
	button:RegisterForDrag("LeftButton")
	button:SetScript("OnDragStart", function(self)
		C_TransmogOutfitInfo.PickupOutfit(self.outfitID)
	end)
	
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.outfitName, 1, 1, 1)
		--GameTooltip:AddLine("Left-click to equip", 0.5, 0.5, 0.5)
		GameTooltip:AddLine("Drag to action bar", 0.5, 0.5, 0.5)
		GameTooltip:Show()
	end)
	
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	return button
end

local function RefreshOutfits()
	if not frame then return end
	
	for _, button in ipairs(frame.buttons) do
		button:Hide()
		button:SetParent(nil)
	end
	frame.buttons = {}
	
	local outfits = C_TransmogOutfitInfo.GetOutfitsInfo()
	
	if not outfits or #outfits == 0 then
		return
	end
	
	for i, outfit in ipairs(outfits) do
		local button = CreateOutfitButton(frame.content, outfit, i)
		table.insert(frame.buttons, button)
	end
	
	local rows = math.ceil(#outfits / 6)
	frame.content:SetHeight(math.max(rows * 55, frame.scrollFrame:GetHeight()))
end

SLASH_OUTFITPICKER1 = "/outfits"
SLASH_OUTFITPICKER2 = "/op"
SlashCmdList["OUTFITPICKER"] = function(msg)
	if not frame then
		frame = CreateMainFrame()
	end
	
	if frame:IsShown() then
		frame:Hide()
	else
		RefreshOutfits()
		frame:Show()
	end
end