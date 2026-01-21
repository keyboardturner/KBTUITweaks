local actionBarMappings = {
	{ start = 1, stop = 12, prefix = "ActionButton" }, -- Main Action Bar
	{ start = 61, stop = 72, prefix = "MultiBarBottomLeftButton" }, -- Action Bar 2
	{ start = 49, stop = 60, prefix = "MultiBarBottomRightButton" }, -- Action Bar 3
	{ start = 25, stop = 36, prefix = "MultiBarRightButton" }, -- Action Bar 4
	{ start = 37, stop = 48, prefix = "MultiBarLeftButton" }, -- Action Bar 5
	{ start = 145, stop = 156, prefix = "MultiBar5Button" }, -- Action Bar 6
	{ start = 157, stop = 168, prefix = "MultiBar6Button" }, -- Action Bar 7
	{ start = 169, stop = 180, prefix = "MultiBar7Button" }, -- Action Bar 8
};

local function UpdateOutfitHighlighter()
	local activeOutfitID = C_TransmogOutfitInfo.GetActiveOutfitID()

	for _, barInfo in ipairs(actionBarMappings) do
		for i = barInfo.start, barInfo.stop do
			local buttonName = barInfo.prefix .. (i - barInfo.start + 1)
			local button = _G[buttonName]

			if button then
				local actionType, actionID = GetActionInfo(i)

				if not button.OutfitHighlight then
					button.OutfitHighlight = button:CreateTexture(nil, "OVERLAY", nil, 5)
					button.OutfitHighlight:SetAllPoints(button)
					button.OutfitHighlight:SetAtlas("transmog-gearSlot-transmogrified-HL")
					button.OutfitHighlight:SetTexCoord(.825,.175,.825,.175)
					button.OutfitHighlight:SetAlpha(.75)
					button.OutfitHighlight:Hide()
				end

				if not button.OutfitBorder then
					button.OutfitBorder = button:CreateTexture(nil, "OVERLAY", nil, 5)
					button.OutfitBorder:SetAllPoints(button)
					button.OutfitBorder:SetAtlas("transmog-outfit-card-lineGlw-purple")
					--button.OutfitBorder:SetTexCoord(.825,.175,.825,.175)
					button.OutfitBorder:SetAlpha(.65)
					button.OutfitBorder:Hide()

				end

				if actionType == "outfit" then
					button.OutfitBorder:Show()
					if actionID == activeOutfitID then
						button.OutfitHighlight:Show()
						button.CheckedTexture:SetAlpha(0)
					else
						button.OutfitHighlight:Hide()
						button.CheckedTexture:SetAlpha(1)
					end
				else
					button.OutfitHighlight:Hide()
					button.CheckedTexture:SetAlpha(1)
					button.OutfitBorder:Hide()
				end
			end
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
frame:RegisterEvent("TRANSMOG_DISPLAYED_OUTFIT_CHANGED")

frame:SetScript("OnEvent", function(self, event, ...)
	UpdateOutfitHighlighter()
end)