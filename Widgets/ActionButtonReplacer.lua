
local spellTextures = {

	-- Frost Death Knight "Spellblade"
	[49020] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\Obliterate", -- Obliterate
	[49143] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\FrostStrike", -- Frost Strike
	[47541] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\DeathCoil", -- Death Coil
	[49184] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\HowlingBlast", -- Death and Decay
	[43265] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\DeathandDecay", -- Death and Decay
	[196770] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\RemorselessWinter", -- Remorseless Winter
	[48707] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\Anti-Magic Shell2", -- Anti-Magic Shell
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