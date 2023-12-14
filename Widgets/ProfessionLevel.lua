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

function KBT:ProfessionNotifierFunc(_, eventMessage)
	local ERR_SKILL_UP_SI_modified = ERR_SKILL_UP_SI:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")
	local skill, skillLevel = string.match(eventMessage, ERR_SKILL_UP_SI_modified)

	if skill and skillLevel then
		KBT.ProfessionText:SetText(skill);
		KBT.ProfessionTextTitle:SetText(skillLevel);
		KBT.ShowWithFadeProf();
		PlaySound(44292);
		PlaySound(44295);
		C_Timer.After(5, function()
			KBT.HideWithFadeProf();
		end)

		--Print("Skill:", skill);
		--Print("Skill Level:", tonumber(skillLevel));
	end
end
KBT.ProfessionFrame:RegisterEvent("CHAT_MSG_SKILL")
KBT.ProfessionFrame:SetScript("OnEvent", KBT.ProfessionNotifierFunc)