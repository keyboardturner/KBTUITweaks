local spellTextures = {
	-- Frost Death Knight "Spellblade"
	[49020] = { -- Obliterate
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\Obliterate",
	},
	[49143] = { -- Frost Strike
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\FrostStrike",
	},
	[47541] = { -- Death Coil
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\DeathCoil",
	},
	[49184] = { -- Howling Blast
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\HowlingBlast",
	},
	[43265] = { -- Death and Decay
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\DeathandDecay",
	},
	[196770] = { -- Remorseless Winter
		 default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\RemorselessWinter",
	 },
	[48707] = { -- Anti-Magic Shell
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\Anti-Magic Shell2",
	},
	[50977] = { -- Death Gate
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\DeathGate",
	},
	[48265] = { -- Death's Advance
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\DeathsAdvance",
	},
	[47528] = { -- Mind Freeze
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\MindFreeze",
	},
	[49576] = { -- Death Grip
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\DeathGrip",
	},
	[56222] = { -- Dark Command
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\DarkCommand",
	},
	[48792] = { 
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\IceboundFortitude",
	}, -- Icebound Fortitude
	[49039] = { -- Lichborne
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\Lichborne",
	},
	[61999] = { -- Raise Ally
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\RaiseAlly",
	},
	[46585] = { -- Raise Dead
		default = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\Icons\\RaiseDead",
	},

	-- Frost Mage Corrections
	[11426] = { -- Ice Barrier
		default = "Interface\\ICONS\\Spell_Frost_FrostArmor02",
		buffed = "Interface\\ICONS\\Spell_Frost_ChillingArmor",
		buffID = 11426,
		model = {
			modelID = 166366,
			translate = { 2, 0, -1 },
			camera = { 2.62, 0, 0},
			animation = 158,
		},
	},
	[130] = { -- Slow Fall
		model = {
			modelID = 5735510,
			translate = { 2, 0, -1 },
			camera = { 2.62, 0, 0},
			animation = 0,
		},
		buffID = 130,
	},

	-- Racials
	[58984] = { -- Shadowmeld
		buffed = "Interface\\ICONS\\spell_nature_wispsplode",
		buffID = 58984,
	},
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

-- Frame Pool
local modelScenePool = {};
local activeModelScenes = {};
local modelScenes = {};

-- Function to acquire a ModelScene frame from the pool
local function AcquireModelScene()
	for i, modelScene in ipairs(modelScenePool) do
		if not modelScene:IsShown() then
			table.remove(modelScenePool, i);
			table.insert(activeModelScenes, modelScene);
			return modelScene;
		end
	end

	-- If no available frames in the pool, create a new one
	local newModelScene = CreateFrame("ModelScene", nil, UIParent);
	newModelScene:SetSize(200, 200);
	newModelScene:SetFrameStrata("HIGH");
	newModelScene:Hide();

	-- Create a new model actor
	local model = newModelScene:CreateActor();
	newModelScene.model = model;

	table.insert(activeModelScenes, newModelScene);
	return newModelScene;
end

-- Function to release a ModelScene frame back to the pool
local function ReleaseModelScene(modelScene)
	modelScene:Hide();
	table.insert(modelScenePool, modelScene);

	-- Remove it from the active list
	for i, scene in ipairs(activeModelScenes) do
		if scene == modelScene then
			table.remove(activeModelScenes, i);
			break;
		end
	end
end

local modelScene = CreateFrame("ModelScene", "BuffModelScene", UIParent);
modelScene:SetSize(200, 200);
modelScene:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
modelScene:SetFrameStrata("HIGH");
modelScene:Hide();

local model = modelScene:CreateActor()
model:SetModelByFileID(5735510);
model:SetPosition(5,0,-1.5);
model:SetYaw(0);

-- Function to update the ModelScene
local function UpdateModelScene(frame, slot)
	if not frame then return; end

	local buttonName = frame:GetName(); -- Get the button's name to identify its model scene
	local modelScene = modelScenes[buttonName]; -- Retrieve the existing model scene for this button

	-- If the model scene doesn't exist, create it
	if not modelScene then
		modelScene = CreateFrame("ModelScene", buttonName .. "ModelScene", UIParent);
		modelScene:SetSize(200, 200);
		modelScene:SetFrameStrata("HIGH");
		modelScene:Hide();
		modelScenes[buttonName] = modelScene; -- Store the model scene in the table

		local model = modelScene:CreateActor();
		model:SetPosition(5, 0, -1.5);
		model:SetYaw(0);
		modelScene.model = model; -- Store the model reference in the scene
	end

	local actionType, TypeID, subType = GetActionInfo(slot); -- Use the actionID of the button to get its spell
	local shouldShow = false; -- Flag to track if we need to show the model scene

	-- Check if the action is a spell and has a corresponding spellTexture entry
	if (actionType == "spell" or actionType == "macro") and subType == "spell" then
		local spellData = spellTextures[TypeID];
		if spellData and spellData.buffID and spellData.model then
			local buffActive = C_UnitAuras.GetPlayerAuraBySpellID(spellData.buffID); -- Check if the buff is active

			if buffActive then
				-- If the spell is active, show the ModelScene with the appropriate model
				if not modelScene:IsShown() then
					modelScene:ClearAllPoints();
					modelScene:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, frame:GetHeight() * .5);
					modelScene:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0);
					modelScene.model:SetModelByFileID(spellData.model.modelID);
					modelScene.model:SetPosition(unpack(spellData.model.translate));
					modelScene.model:SetAnimation(spellData.model.animation);
					modelScene:Show();
				end
				shouldShow = true; -- We need to show the model scene
			end
		end
	end

	-- Hide the ModelScene if no buff is active
	if not shouldShow and modelScene:IsShown() then
		modelScene:Hide();
	end
end

-- Function to update the action bar buttons' textures and models
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
					local spellData = spellTextures[TypeID];
					if spellData then
						local texture = spellData.default or (C_Spell.GetSpellInfo(TypeID) and C_Spell.GetSpellInfo(TypeID).iconID);
						if spellData.buffID and spellData.buffed then
							local buffActive = C_UnitAuras.GetPlayerAuraBySpellID(spellData.buffID, "player");
							if buffActive then
								texture = spellData.buffed;
							end
						end
						slot:SetTexture(texture);

						-- Update ModelScene if the spell has one
						if spellData.model then
							UpdateModelScene(button, i);
						end
					end
				end
			end
		end
	end
end

-- Event handler to update the action bar textures and models
local function OnEvent(self, event, ...)
	UpdateActionBarTextures();
end

-- Create the frame and register events
local f = CreateFrame("Frame");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
f:RegisterEvent("ACTIONBAR_UPDATE_STATE");
f:RegisterEvent("PLAYER_CAN_GLIDE_CHANGED");
f:RegisterEvent("UNIT_AURA");
f:RegisterEvent("SPELL_UPDATE_COOLDOWN");
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
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
