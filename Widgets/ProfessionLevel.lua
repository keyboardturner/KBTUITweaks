local _, KBT = ...

local function Print(text)
	local textColor = CreateColor(KBTUI_DB.settings.colors.prefix.r, KBTUI_DB.settings.colors.prefix.g, KBTUI_DB.settings.colors.prefix.b):GenerateHexColor()
	text = "|c" .. textColor .. "KBT UI Tweaks" .. "|r" .. ": " .. text
	
	return DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 1)
end


KBT.ProfessionText = UIParent:CreateFontString(nil, "OVERLAY", "GameTooltipText")
KBT.ProfessionText:SetPoint("TOP", 0, -260)
KBT.ProfessionText:SetText("Hello World")
--KBT.ProfessionText:SetSize(200,100)
KBT.ProfessionText:SetFont("Fonts\\FRIZQT__.TTF", 30)
KBT.ProfessionText:Hide()
KBT.ProfessionTextTitle = UIParent:CreateFontString(nil, "OVERLAY", "GameTooltipText")
KBT.ProfessionTextTitle:SetPoint("TOP", 0, -300)
KBT.ProfessionTextTitle:SetText("Title")
--KBT.ProfessionText:SetSize(200,100)
KBT.ProfessionTextTitle:SetFont("Fonts\\FRIZQT__.TTF", 30)
KBT.ProfessionTextTitle:Hide()

KBT.ProfessionNotifier = CreateFrame("Frame")

KBT.ProfessionNotifier.fadeGroupShow = KBT.ProfessionNotifier:CreateAnimationGroup()
KBT.ProfessionNotifier.fadeGroupHide = KBT.ProfessionNotifier:CreateAnimationGroup()

KBT.ProfessionNotifier.fadeIn = KBT.ProfessionNotifier.fadeGroupShow:CreateAnimation("Alpha")
KBT.ProfessionNotifier.fadeIn:SetDuration(.5)
KBT.ProfessionNotifier.fadeIn:SetFromAlpha(0)
KBT.ProfessionNotifier.fadeIn:SetToAlpha(1)

KBT.ProfessionNotifier.fadeOut = KBT.ProfessionNotifier.fadeGroupHide:CreateAnimation("Alpha")
KBT.ProfessionNotifier.fadeOut:SetDuration(4)
KBT.ProfessionNotifier.fadeOut:SetFromAlpha(1)
KBT.ProfessionNotifier.fadeOut:SetToAlpha(0)

KBT.ProfessionNotifier.fadeOut:SetScript("OnFinished", function()
	KBT.ProfessionText:Hide();
	KBT.ProfessionTextTitle:Hide();
	print("thing commence")
end)

function KBT.ProfessionNotifier.ShowFadingFrame()
	KBT.ProfessionText:Show();
	KBT.ProfessionTextTitle:Show();
	KBT.ProfessionNotifier.fadeGroupShow:Play();
end

function KBT.ProfessionNotifier.HideFadingFrame()
	KBT.ProfessionNotifier.fadeGroupHide:Play();
end

function KBT:ProfessionNotifierFunc(_, eventMessage)
	local ERR_SKILL_UP_SI_modified = ERR_SKILL_UP_SI:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")
	local skill, skillLevel = string.match(eventMessage, ERR_SKILL_UP_SI_modified)

	if skill and skillLevel then
		KBT.ProfessionText:SetText(skill);
		KBT.ProfessionTextTitle:SetText(skillLevel);
		KBT.ProfessionNotifier.ShowFadingFrame();
		PlaySound(44292);
		PlaySound(44295);
		C_Timer.After(5, function()
			KBT.ProfessionNotifier.HideFadingFrame();
		end)

		--Print("Skill:", skill);
		--Print("Skill Level:", tonumber(skillLevel));
	end
end
KBT.ProfessionNotifier:RegisterEvent("CHAT_MSG_SKILL")
KBT.ProfessionNotifier:SetScript("OnEvent", KBT.ProfessionNotifierFunc)