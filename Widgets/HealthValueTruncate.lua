local hp = CreateFrame("Frame")
local playerFrameStuff = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer.HealthBar
local targetFrameStuff = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar
playerFrameStuff.RightText:SetTextColor(1,1,1,0)
targetFrameStuff.RightText:SetTextColor(1,1,1,0)

hp.Update = hp:CreateFontString(nil, "OVERLAY", "GameFontNormal");
hp.Update:SetParent(playerFrameStuff);
hp.Update:SetFont(hp.Update:GetFont(), 10, "OUTLINE");
hp.Update:SetTextColor(1,1,1,1);
hp.Update:ClearAllPoints();
hp.Update:SetPoint("RIGHT", playerFrameStuff, "RIGHT",-2,0);
hp.Update:SetText(UnitHealth("player"));


function hp:OnEvent()
	local health = UnitHealth("player")
	local newhealth = UnitHealth("player")
	local maxhealth = UnitHealthMax("player")
	--local abbr, divider = hp:CalcTruncate(health)
	local abbr = ""
	hp.Update:SetText(("%.0f%s"):format(newhealth, abbr))
	if health >= 10^3 then --1,020 -> 1.02k
		newhealth = health / 10^3
		abbr = " K"
		hp.Update:SetText(("%.02f%s"):format(newhealth, abbr))
	end
	if health >= 10^4 then -- 10,200 -> 10.2k
		newhealth = health / 10^3
		abbr = " K"
		hp.Update:SetText(("%.01f%s"):format(newhealth, abbr))
	end
	if health >= 10^5 then -- 102,000 -> 102k
		newhealth = health / 10^3
		abbr = " K"
		hp.Update:SetText(("%.00f%s"):format(newhealth, abbr))
	end
	if health >= 10^6 then -- 1,020,000 -> 1.02m
		newhealth = health / 10^6
		abbr = " M"
		hp.Update:SetText(("%.02f%s"):format(newhealth, abbr))
	end
	if health >= 10^7 then -- 10,200,000 -> 10.2m
		newhealth = health / 10^6
		abbr = " M"
		hp.Update:SetText(("%.01f%s"):format(newhealth, abbr))
	end
	if health >= 10^8 then -- 102,000,000 -> 102m
		newhealth = health / 10^6
		abbr = " M"
		hp.Update:SetText(("%.00f%s"):format(newhealth, abbr))
	end
	if health >= 10^9 then -- 1,020,000,000 -> 1.02b
		newhealth = health / 10^9
		abbr = " B"
		hp.Update:SetText(("%.02f%s"):format(newhealth, abbr))
	end
	if health >= 10^10 then -- 10,200,000,000 -> 10.2b
		newhealth = health / 10^9
		abbr = " B"
		hp.Update:SetText(("%.01f%s"):format(newhealth, abbr))
	end
	if health >= 10^11 then -- 102,000,000,000 -> 102b
		newhealth = health / 10^9
		abbr = " B"
		hp.Update:SetText(("%.00f%s"):format(newhealth, abbr))
	end
	if health >= 10^12 then -- 1,020,000,000,000 -> 102t
		newhealth = health / 10^12
		abbr = " T"
		hp.Update:SetText(("%.02f%s"):format(newhealth, abbr))
	end
	if health >= 10^13 then -- 1,020,000,000,000 -> 102t
		newhealth = health / 10^12
		abbr = " T"
		hp.Update:SetText(("%.01f%s"):format(newhealth, abbr))
	end
	if health >= 10^14 then -- 1,020,000,000,000 -> 102t
		newhealth = health / 10^12
		abbr = " T"
		hp.Update:SetText(("%.00f%s"):format(newhealth, abbr))
	end
	if health >= 10^15 then -- 1,020,000,000,000 -> ???
		newhealth = "???"
		hp.Update:SetText(newhealth)
	end
	if health == 0 then
		newhealth = health.."/"..maxhealth
		hp.Update:SetText(newhealth)
	end
end


hp.Tar = hp:CreateFontString(nil, "OVERLAY", "GameFontNormal");
hp.Tar:SetParent(targetFrameStuff);
hp.Tar:SetFont(hp.Tar:GetFont(), 10, "OUTLINE");
hp.Tar:SetTextColor(1,1,1,1);
hp.Tar:ClearAllPoints();
hp.Tar:SetPoint("RIGHT", targetFrameStuff, "RIGHT",-5,0);
hp.Tar:SetText(UnitHealth("target"));

function hp.Tar:OnEvent()
	local health = UnitHealth("target")
	local newhealth = UnitHealth("target")
	local maxhealth = UnitHealthMax("target")
	local abbr = ""
	hp.Tar:SetText(("%.0f%s"):format(newhealth, abbr))
	if health >= 10^3 then --1,020 -> 1.02k
		newhealth = health / 10^3
		abbr = " K"
		hp.Tar:SetText(("%.02f%s"):format(newhealth, abbr))
	end
	if health >= 10^4 then -- 10,200 -> 10.2k
		newhealth = health / 10^3
		abbr = " K"
		hp.Tar:SetText(("%.01f%s"):format(newhealth, abbr))
	end
	if health >= 10^5 then -- 102,000 -> 102k
		newhealth = health / 10^3
		abbr = " K"
		hp.Tar:SetText(("%.00f%s"):format(newhealth, abbr))
	end
	if health >= 10^6 then -- 1,020,000 -> 1.02m
		newhealth = health / 10^6
		abbr = " M"
		hp.Tar:SetText(("%.02f%s"):format(newhealth, abbr))
	end
	if health >= 10^7 then -- 10,200,000 -> 10.2m
		newhealth = health / 10^6
		abbr = " M"
		hp.Tar:SetText(("%.01f%s"):format(newhealth, abbr))
	end
	if health >= 10^8 then -- 102,000,000 -> 102m
		newhealth = health / 10^6
		abbr = " M"
		hp.Tar:SetText(("%.00f%s"):format(newhealth, abbr))
	end
	if health >= 10^9 then -- 1,020,000,000 -> 1.02b
		newhealth = health / 10^9
		abbr = " B"
		hp.Tar:SetText(("%.02f%s"):format(newhealth, abbr))
	end
	if health >= 10^10 then -- 10,200,000,000 -> 10.2b
		newhealth = health / 10^9
		abbr = " B"
		hp.Tar:SetText(("%.01f%s"):format(newhealth, abbr))
	end
	if health >= 10^11 then -- 102,000,000,000 -> 102b
		newhealth = health / 10^9
		abbr = " B"
		hp.Tar:SetText(("%.00f%s"):format(newhealth, abbr))
	end
	if health >= 10^12 then -- 1,020,000,000,000 -> 102t
		newhealth = health / 10^12
		abbr = " T"
		hp.Tar:SetText(("%.02f%s"):format(newhealth, abbr))
	end
	if health >= 10^13 then -- 1,020,000,000,000 -> 102t
		newhealth = health / 10^12
		abbr = " T"
		hp.Tar:SetText(("%.01f%s"):format(newhealth, abbr))
	end
	if health >= 10^14 then -- 1,020,000,000,000 -> 102t
		newhealth = health / 10^12
		abbr = " T"
		hp.Tar:SetText(("%.00f%s"):format(newhealth, abbr))
	end
	if health >= 10^15 then -- 1,020,000,000,000 -> ???
		newhealth = "???"
		hp.Tar:SetText(newhealth)
	end
	if health == 0 then
		newhealth = health.."/"..maxhealth
		hp.Tar:SetText(newhealth)
	end
end

hp:RegisterEvent("UNIT_HEALTH")
hp:RegisterEvent("PLAYER_ENTERING_WORLD")
hp:RegisterEvent("PLAYER_TARGET_CHANGED")


hp:SetScript("OnEvent", hp.OnEvent)
PlayerFrame:HookScript("OnEnter", hp.OnEvent)
playerFrameStuff:HookScript("OnEnter", hp.OnEvent)
PlayerFrame:HookScript("OnLeave", hp.OnEvent)
playerFrameStuff:HookScript("OnLeave", hp.OnEvent)

hp:HookScript("OnEvent", hp.Tar.OnEvent)
TargetFrame:HookScript("OnEnter", hp.Tar.OnEvent)
targetFrameStuff:HookScript("OnEnter", hp.Tar.OnEvent)
TargetFrame:HookScript("OnLeave", hp.Tar.OnEvent)
targetFrameStuff:HookScript("OnLeave", hp.Tar.OnEvent)