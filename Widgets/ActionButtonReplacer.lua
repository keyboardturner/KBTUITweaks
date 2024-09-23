
local spellTextures = {

	-- Frost Death Knight "Spellblade"
	[49020] = 135852, -- Obliterate
	[49143] = 135854, -- Frost Strike
	[47541] = 5929586, -- Death Coil
	[43265] = 1041234, -- Death and Decay
};

local function OnEvent()
	local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo();
	if canGlide or UnitInVehicle("player") then return end;
	for i = 1,12 do
		local actionType, TypeID, subType = GetActionInfo(i)
		local slot = _G["ActionButton"..i.."Icon"]

		if (actionType == "spell" or actionType == "macro") and subType == "spell" then
			-- put class/spec checker here

			local texture = spellTextures[TypeID]
			if texture then
				slot:SetTexture(texture);
			end

		end
	end
end

local f = CreateFrame("Frame");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
f:RegisterEvent("ACTIONBAR_UPDATE_STATE");
f:RegisterEvent("PLAYER_CAN_GLIDE_CHANGED");


f:SetScript("OnEvent", OnEvent);


for i = 1,12 do
	local button = _G["ActionButton"..i]
	button:HookScript("OnEnter", function()
		OnEvent()
	end)
end