
--[[
-- This function properly works. Use this as a template moving forward.
local function CreateTRP3_PartyTime()
    local frame = CreateFrame("Frame", "TRP3_PartyTime", UIParent)
    frame:SetSize(75, 75)
    frame:SetPoint("CENTER")

    local FatcatParty = frame:CreateTexture("FatcatParty", "BACKGROUND")
    FatcatParty:SetAlpha(1)
    FatcatParty:SetBlendMode("BLEND")
    FatcatParty:SetTexture("Interface\\AddOns\\totalRP3\\resources\\fatcatparty")
    FatcatParty:SetSize(75, 75)
    FatcatParty:SetPoint("CENTER")
    frame.FatcatParty = FatcatParty

    local FatcatPat = frame:CreateTexture("FatcatPat", "BACKGROUND")
    FatcatPat:SetAlpha(0)
    FatcatPat:SetBlendMode("BLEND")
    FatcatPat:SetTexture("Interface\\AddOns\\totalRP3\\resources\\fatcatpat")
    FatcatPat:SetSize(75, 75)
    FatcatPat:SetPoint("CENTER")
    frame.FatcatPat = FatcatPat

    frame:SetScript("OnShow", function(self)
        self.FatcatParty:SetAlpha(1)
        self.FatcatPat:SetAlpha(0)
        self.FatcatPartyAnim:Play()
    end)

    frame:SetScript("OnEnter", function(self)
        self:StopAnimating()
        self.FatcatParty:SetAlpha(0)
        self.FatcatPat:SetAlpha(1)
        self.FatcatPatAnim:Play()
    end)

    frame:SetScript("OnLeave", function(self)
        self:StopAnimating()
        self.FatcatParty:SetAlpha(1)
        self.FatcatPat:SetAlpha(0)
        self.FatcatPartyAnim:Play()
    end)

    frame:SetScript("OnHide", function(self)
        self:StopAnimating()
    end)

    local FatcatPartyAnim = frame:CreateAnimationGroup()
    frame.FatcatPartyAnim = FatcatPartyAnim
    FatcatPartyAnim:SetLooping("REPEAT")
    FatcatPartyAnim:SetToFinalAlpha(true)

    local FatcatPartyFlipBook = FatcatPartyAnim:CreateAnimation("FlipBook")
    FatcatPartyFlipBook:SetChildKey("FatcatParty")
    FatcatPartyFlipBook:SetDuration(0.5)
    FatcatPartyFlipBook:SetOrder(1)
    FatcatPartyFlipBook:SetFlipBookRows(4)
    FatcatPartyFlipBook:SetFlipBookColumns(4)
    FatcatPartyFlipBook:SetFlipBookFrames(10)
    FatcatPartyFlipBook:SetFlipBookFrameWidth(0)
    FatcatPartyFlipBook:SetFlipBookFrameHeight(0)

    local FatcatPatAnim = frame:CreateAnimationGroup()
    frame.FatcatPatAnim = FatcatPatAnim
    FatcatPatAnim:SetLooping("REPEAT")
    FatcatPatAnim:SetToFinalAlpha(true)

    local FatcatPatFlipBook = FatcatPatAnim:CreateAnimation("FlipBook")
    FatcatPatFlipBook:SetChildKey("FatcatPat")
    FatcatPatFlipBook:SetDuration(0.2)
    FatcatPatFlipBook:SetOrder(1)
    FatcatPatFlipBook:SetFlipBookRows(2)
    FatcatPatFlipBook:SetFlipBookColumns(2)
    FatcatPatFlipBook:SetFlipBookFrames(4)
    FatcatPatFlipBook:SetFlipBookFrameWidth(0)
    FatcatPatFlipBook:SetFlipBookFrameHeight(0)

    return frame
end

local frame = CreateTRP3_PartyTime()
frame:Show()
]]