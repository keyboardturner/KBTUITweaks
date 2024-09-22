--[[

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
f:RegisterEvent("UNIT_FLAGS")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

local function IsPlayerMountedAndStationary()
	return IsMounted() and not IsFalling() and GetUnitSpeed("player") == 0
end

local originalKeyBinding

local function OverrideSpacebar()
	if IsPlayerMountedAndStationary() then
		if not originalKeyBinding then
			originalKeyBinding = GetBindingAction("SPACE")
			SetBinding("SPACE", "MountSpecial")
		end
	else
		if originalKeyBinding then
			SetBinding("SPACE", originalKeyBinding)
			originalKeyBinding = nil
		end
	end
	SaveBindings(GetCurrentBindingSet())
end

f:SetScript("OnEvent", function(self, event, arg1, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_MOUNT_DISPLAY_CHANGED" or
	   (event == "UNIT_FLAGS" and arg1 == "player") or
	   (event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player") then
		OverrideSpacebar()
	end
end)

]]