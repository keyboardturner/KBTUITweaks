local AH = CreateFrame("Frame")
AH:RegisterEvent("UNIT_HEALTH")
AH:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
AH:RegisterEvent("PLAYER_TARGET_CHANGED")


local bingus = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar

local targetStuff = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar

AH.Absorb = UnitGetTotalAbsorbs("player")
AH.TarAbsorb = UnitGetTotalAbsorbs("target")
AH.MaxHP = UnitHealthMax("player")
AH.TarMaxHP = UnitHealthMax("target")

AH.StatusBar = CreateFrame("StatusBar", nil, UIParent)
AH.StatusBar:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
AH.StatusBar:SetWidth(200)
AH.StatusBar:SetHeight(20)
AH.StatusBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
AH.StatusBar:GetStatusBarTexture():SetHorizTile(false)
AH.StatusBar:GetStatusBarTexture():SetVertTile(false)
AH.StatusBar:SetStatusBarColor(0/255, 229/255, 255/255, .6) -- r g b values, 0 - 255
AH.StatusBar:SetMinMaxValues(0, AH.MaxHP)
AH.StatusBar:SetFillStyle("STANDARD")
AH.StatusBar:SetOrientation("HORIZONTAL")
AH.StatusBar:SetValue(AH.Absorb)
AH.StatusBar:SetAllPoints(bingus)


AH.StatusBar.bg = AH.StatusBar:CreateTexture(nil, "BACKGROUND")
AH.StatusBar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
AH.StatusBar.bg:SetAllPoints(true)
AH.StatusBar.bg:SetVertexColor(0, 0, 0, 0)
-- 0 232 255

AH.StatusBarTarget = CreateFrame("StatusBar", nil, UIParent)
AH.StatusBarTarget:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
AH.StatusBarTarget:SetWidth(200)
AH.StatusBarTarget:SetHeight(20)
AH.StatusBarTarget:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
AH.StatusBarTarget:GetStatusBarTexture():SetHorizTile(false)
AH.StatusBarTarget:GetStatusBarTexture():SetVertTile(false)
AH.StatusBarTarget:SetStatusBarColor(0/255, 229/255, 255/255, .6) -- r g b values, 0 - 255
AH.StatusBarTarget:SetMinMaxValues(0, AH.TarMaxHP)
AH.StatusBarTarget:SetFillStyle("STANDARD")
AH.StatusBarTarget:SetOrientation("HORIZONTAL")
AH.StatusBarTarget:SetValue(AH.TarAbsorb)
AH.StatusBarTarget:SetAllPoints(targetStuff)


AH.StatusBarTarget.bg = AH.StatusBarTarget:CreateTexture(nil, "BACKGROUND")
AH.StatusBarTarget.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
AH.StatusBarTarget.bg:SetAllPoints(true)
AH.StatusBarTarget.bg:SetVertexColor(0, 0, 0, 0)

--[[
AH.StatusBar.value = AH.StatusBar:CreateFontString(nil, "OVERLAY")
AH.StatusBar.value:SetPoint("LEFT", AH.StatusBar, "LEFT", 4, 0)
AH.StatusBar.value:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
AH.StatusBar.value:SetJustifyH("LEFT")
AH.StatusBar.value:SetShadowOffset(1, -1)
AH.StatusBar.value:SetTextColor(0, 1, 0)
AH.StatusBar.value:SetText("100%")
]]

function AH:OnEvent()
	AH.Absorb = UnitGetTotalAbsorbs("player")
	AH.TarAbsorb = UnitGetTotalAbsorbs("target")
	AH.MaxHP = UnitHealthMax("player")
	AH.TarMaxHP = UnitHealthMax("target")


	AH.StatusBar:SetMinMaxValues(0, AH.MaxHP)
	AH.StatusBar:SetValue(AH.Absorb)

	AH.StatusBarTarget:SetMinMaxValues(0, AH.TarMaxHP)
	AH.StatusBarTarget:SetValue(AH.TarAbsorb)
end

AH:SetScript("OnEvent", AH.OnEvent)

bingus.TotalAbsorbBar:SetVertexColor(0, 0, 0, 0)
bingus.TotalAbsorbBarOverlay:SetVertexColor(0, 0, 0, 0)
bingus.OverAbsorbGlow:SetVertexColor(0, 0, 0, 0)

targetStuff.TotalAbsorbBar:SetVertexColor(0, 0, 0, 0)
targetStuff.TotalAbsorbBarOverlay:SetVertexColor(0, 0, 0, 0)
targetStuff.OverAbsorbGlow:SetVertexColor(0, 0, 0, 0)