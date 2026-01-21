--[[ -- broken in midnight atm

local valueTruncate = CreateFrame("Frame");

-- Player Frame References
local playerFrameHealth = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer.HealthBar;
local playerFramePower = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar;

-- Target Frame References
local targetFrameHealth = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar;
local targetFramePower = TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar;

-- Hide default right text for health and power
playerFrameHealth.RightText:SetTextColor(1,1,1,0);
targetFrameHealth.RightText:SetTextColor(1,1,1,0);
playerFramePower.RightText:SetTextColor(1,1,1,0);
targetFramePower.RightText:SetTextColor(1,1,1,0);

-- Create Font Strings for Player Health and Power
valueTruncate.HealthPlayer = valueTruncate:CreateFontString(nil, "OVERLAY", "GameFontNormal");
valueTruncate.HealthPlayer:SetParent(playerFrameHealth);
valueTruncate.HealthPlayer:SetFont(valueTruncate.HealthPlayer:GetFont(), 10, "OUTLINE");
valueTruncate.HealthPlayer:SetTextColor(1,1,1,1);
valueTruncate.HealthPlayer:SetPoint("RIGHT", playerFrameHealth, "RIGHT", -2, 0);

valueTruncate.PowerPlayer = valueTruncate:CreateFontString(nil, "OVERLAY", "GameFontNormal");
valueTruncate.PowerPlayer:SetParent(playerFramePower);
valueTruncate.PowerPlayer:SetFont(valueTruncate.PowerPlayer:GetFont(), 10, "OUTLINE");
valueTruncate.PowerPlayer:SetTextColor(1,1,1,1);
valueTruncate.PowerPlayer:SetPoint("RIGHT", playerFramePower, "RIGHT", -2, 0);

-- Create Font Strings for Target Health and Power
valueTruncate.HealthTarget = valueTruncate:CreateFontString(nil, "OVERLAY", "GameFontNormal");
valueTruncate.HealthTarget:SetParent(targetFrameHealth);
valueTruncate.HealthTarget:SetFont(valueTruncate.HealthTarget:GetFont(), 10, "OUTLINE");
valueTruncate.HealthTarget:SetTextColor(1,1,1,1);
valueTruncate.HealthTarget:SetPoint("RIGHT", targetFrameHealth, "RIGHT", -7, 0);

valueTruncate.PowerTarget = valueTruncate:CreateFontString(nil, "OVERLAY", "GameFontNormal");
valueTruncate.PowerTarget:SetParent(targetFramePower);
valueTruncate.PowerTarget:SetFont(valueTruncate.PowerTarget:GetFont(), 10, "OUTLINE");
valueTruncate.PowerTarget:SetTextColor(1,1,1,1);
valueTruncate.PowerTarget:SetPoint("RIGHT", targetFramePower, "RIGHT", -15, 0);

-- Function to truncate numbers
local function TruncateNumbers(verboseNumber)
	local shortNum = "";
	local newValue;
	local abbr = "";
	if verboseNumber >= 10^15 then
		newValue = "???";
	elseif verboseNumber >= 10^12 then
		newValue = verboseNumber / 10^12;
		abbr = " T";
		if verboseNumber >= 10^14 then
			shortNum = ("%.00f%s"):format(newValue, abbr);
		elseif verboseNumber >= 10^13 then
			shortNum = ("%.01f%s"):format(newValue, abbr);
		elseif verboseNumber >= 10^12 then
			shortNum = ("%.02f%s"):format(newValue, abbr);
		end
	elseif verboseNumber >= 10^9 then
		newValue = verboseNumber / 10^9;
		abbr = " B";
		if verboseNumber >= 10^11 then
			shortNum = ("%.00f%s"):format(newValue, abbr);
		elseif verboseNumber >= 10^10 then
			shortNum = ("%.01f%s"):format(newValue, abbr);
		elseif verboseNumber >= 10^9 then
			shortNum = ("%.02f%s"):format(newValue, abbr);
		end
	elseif verboseNumber >= 10^6 then
		newValue = verboseNumber / 10^6;
		abbr = " M";
		if verboseNumber >= 10^8 then
			shortNum = ("%.00f%s"):format(newValue, abbr);
		elseif verboseNumber >= 10^7 then
			shortNum = ("%.01f%s"):format(newValue, abbr);
		elseif verboseNumber >= 10^6 then
			shortNum = ("%.02f%s"):format(newValue, abbr);
		end
	elseif verboseNumber >= 10^3 then
		newValue = verboseNumber / 10^3;
		abbr = " K";
		if verboseNumber >= 10^5 then
			shortNum = ("%.00f%s"):format(newValue, abbr);
		elseif verboseNumber >= 10^4 then
			shortNum = ("%.01f%s"):format(newValue, abbr);
		elseif verboseNumber >= 10^3 then
			shortNum = ("%.02f%s"):format(newValue, abbr);
		end
	else
		shortNum = verboseNumber;
	end

	return shortNum, abbr
end

-- Function to update health and power values
local function UpdateValues()
    -- Update Player Health and Power
    valueTruncate.HealthPlayer:SetText(TruncateNumbers(UnitHealth("player")));
    valueTruncate.PowerPlayer:SetText(TruncateNumbers(UnitPower("player")));

    -- Update Target Health and Power
    if UnitExists("target") then
        valueTruncate.HealthTarget:SetText(TruncateNumbers(UnitHealth("target")));
        valueTruncate.PowerTarget:SetText(TruncateNumbers(UnitPower("target")));
    else
        valueTruncate.HealthTarget:SetText("");
        valueTruncate.PowerTarget:SetText("");
    end
end

-- Set up an OnUpdate script to refresh values dynamically
valueTruncate:SetScript("OnUpdate", function()
    UpdateValues();
end);

]]