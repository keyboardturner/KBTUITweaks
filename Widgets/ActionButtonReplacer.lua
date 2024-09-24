local spellTextures = {
	-- Frost Death Knight "Spellblade"
	[49020] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\Obliterate", -- Obliterate
	[49143] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\FrostStrike", -- Frost Strike
	[47541] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\DeathCoil", -- Death Coil
	[49184] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\HowlingBlast", -- Howling Blast
	[43265] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\DeathandDecay", -- Death and Decay
	[196770] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\RemorselessWinter", -- Remorseless Winter
	[48707] = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\Anti-Magic Shell2", -- Anti-Magic Shell
};

-- Define the mapping of action bar ranges to their respective button names
local actionBarMappings = {
	{ start = 1, stop = 12, prefix = "ActionButton" }, -- Main Action Bar
	{ start = 61, stop = 72, prefix = "MultiBarBottomLeftButton" }, -- Action Bar 2
	{ start = 49, stop = 60, prefix = "MultiBarBottomRightButton" }, -- Action Bar 3
	{ start = 25, stop = 36, prefix = "MultiBarRightButton" }, -- Action Bar 4
	{ start = 37, stop = 48, prefix = "MultiBarLeftButton" }, -- Action Bar 5
	{ start = 145, stop = 156, prefix = "MultiBar5Button" }, -- Action Bar 6
	{ start = 157, stop = 168, prefix = "MultiBar6Button" }, -- Action Bar 7
	{ start = 169, stop = 180, prefix = "MultiBar7Button" }, -- Action Bar 8
};

-- Function to update the action bar buttons' textures
local function UpdateActionBarTextures()
	local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
	if canGlide or UnitInVehicle("player") then return; end;

	for _, barInfo in ipairs(actionBarMappings) do
		for i = barInfo.start, barInfo.stop do
			local buttonName = barInfo.prefix .. (i - barInfo.start + 1);
			local button = _G[buttonName];
			if button then
				local actionType, TypeID, subType = GetActionInfo(i);
				local slot = _G[buttonName .. "Icon"];

				if (actionType == "spell" or actionType == "macro") and subType == "spell" then
					-- You can add class/spec checker here if necessary

					local texture = spellTextures[TypeID];
					if texture then
						slot:SetTexture(texture);
					end
				end
			end
		end
	end
end

-- Event handler for PLAYER_ENTERING_WORLD and other actionbar-related events
local function OnEvent(self, event, ...)
	UpdateActionBarTextures();
end

-- Create the frame and register the events
local f = CreateFrame("Frame");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
f:RegisterEvent("ACTIONBAR_UPDATE_STATE");
f:RegisterEvent("PLAYER_CAN_GLIDE_CHANGED");
f:SetScript("OnEvent", OnEvent);

-- Hook the OnEnter event for all action buttons
for _, barInfo in ipairs(actionBarMappings) do
	for i = barInfo.start, barInfo.stop do
		local buttonName = barInfo.prefix .. (i - barInfo.start + 1);
		local button = _G[buttonName];
		if button then
			button:HookScript("OnEnter", function()
				UpdateActionBarTextures();
			end);
		end
	end
end
