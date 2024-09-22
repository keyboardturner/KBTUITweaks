-- Create a frame to hold the UI
local frame = CreateFrame("Frame", "SoundFinderFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(300, 200)
frame:SetPoint("CENTER")
frame:Hide()



-- Min Edit Box
local minEditBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
minEditBox:SetSize(100, 30)
minEditBox:SetPoint("TOPLEFT", 20, -40)
minEditBox:SetAutoFocus(false)
minEditBox:SetNumeric(true)
minEditBox:SetMaxLetters(7)
minEditBox:SetText("1") -- Default min value

local minLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
minLabel:SetPoint("BOTTOMLEFT", minEditBox, "TOPLEFT", 0, 5)
minLabel:SetText("Min ID")

-- Max Edit Box
local maxEditBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
maxEditBox:SetSize(100, 30)
maxEditBox:SetPoint("TOPRIGHT", -20, -40)
maxEditBox:SetAutoFocus(false)
maxEditBox:SetNumeric(true)
maxEditBox:SetMaxLetters(7)
maxEditBox:SetText("6163218") -- Default max value

local maxLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
maxLabel:SetPoint("BOTTOMRIGHT", maxEditBox, "TOPRIGHT", 0, 5)
maxLabel:SetText("Max ID")

-- Function to mute a range of sound file IDs
local function MuteRange(minID, maxID)
    for i = minID, maxID do
        MuteSoundFile(i)
    end
end

-- Function to unmute all sound file IDs
local function UnmuteAll()
    for i = 1, 6163218 do
        UnmuteSoundFile(i)
    end
end

-- Mute Range Button
local muteButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
muteButton:SetSize(140, 40)
muteButton:SetPoint("BOTTOMLEFT", 20, 20)
muteButton:SetText("Mute Range")
muteButton:SetScript("OnClick", function()
    local minID = tonumber(minEditBox:GetText())
    local maxID = tonumber(maxEditBox:GetText())
    if minID and maxID and minID <= maxID then
        MuteRange(minID, maxID)
    else
        print("Invalid range. Ensure that the min value is less than or equal to the max value.")
    end
end)

-- Unmute All Button
local unmuteButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
unmuteButton:SetSize(140, 40)
unmuteButton:SetPoint("BOTTOMRIGHT", -20, 20)
unmuteButton:SetText("Unmute All")
unmuteButton:SetScript("OnClick", function()
    UnmuteAll()
end)

-- Title Text
local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
titleText:SetPoint("TOP", 0, -10)
titleText:SetText("Sound ID Finder")
