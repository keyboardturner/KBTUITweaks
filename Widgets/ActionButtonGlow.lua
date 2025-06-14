--[[

local f = CreateFrame("Button", "MyGlowingButton", UIParent, "SecureActionButtonTemplate, ActionButtonTemplate")
f:SetSize(64, 64)
f:SetPoint("CENTER")
f.icon:SetTexture(134400)
f.icon:SetAllPoints(true)


f.isGlowing = false

local function SetGlowColor(button, r, g, b)
	local alert = button.SpellActivationAlert
	if alert and alert.ProcLoopFlipbook and alert.ProcStartFlipbook then
		alert.ProcLoopFlipbook:SetDesaturated(true)
		alert.ProcLoopFlipbook:SetVertexColor(r, g, b)
		alert.ProcStartFlipbook:SetDesaturated(true)
		alert.ProcStartFlipbook:SetVertexColor(r, g, b)
	end
end

f:SetScript("OnClick", function(self)
	if self.isGlowing then
		ActionButton_HideOverlayGlow(self)
		self.isGlowing = false
	else
		ActionButton_ShowOverlayGlow(self)
		SetGlowColor(MyGlowingButton, 0, 1, 1)
		self.isGlowing = true
	end
end)


--]]

--[[
local spellData = {

	[26573] = { buffID = 188370 },	

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
	{ start = 73, stop = 84, prefix = "ActionButton" }, -- Main Action Bar (Stealth)
	{ start = 121, stop = 132, prefix = "ActionButton" }, -- Main Action Bar (Skyriding)
};

local function HasUnitBuff(buffID)
	return C_UnitAuras.GetPlayerAuraBySpellID(buffID) ~= nil
end

local function HasAnyUnitBuff(buffIDs)
	for _, id in ipairs(buffIDs) do
		if C_UnitAuras.GetPlayerAuraBySpellID(id) then
			return true
		end
	end
	return false
end

local function HasTotemMatch(names)
	for i = 1, 5 do
		local haveTotem, totemName = GetTotemInfo(i)
		if haveTotem and totemName then
			for _, name in ipairs(names) do
				if totemName:find(name) then
					return true
				end
			end
		end
	end
	return false
end

local function ShouldGlow(data)
	if data.buffID then
		return not HasUnitBuff(data.buffID)
	end
	return false
end

local function ApplyGlow(button, shouldGlow)
	if not button then return end
	if shouldGlow then
		if not button._glowing then
			ActionButton_ShowOverlayGlow(button)
			button._glowing = true
		end
	else
		if button._glowing then
			ActionButton_HideOverlayGlow(button)
			button._glowing = false
		end
	end
end

local function GetActionButtonFromSpell(spellID)
	for _, bar in ipairs(actionBarMappings) do
		for i = bar.start, bar.stop do
			local button = _G[bar.prefix .. i]
			if button and button:GetAttribute("type") == "spell" then
				local id = button:GetAttribute("spell")
				if id == spellID then
					return button
				end
			end
		end
	end
	return nil
end

local function UpdateBuffGlows()
	for spellID, data in pairs(spellData) do
		local button = GetActionButtonFromSpell(spellID)
		if button then
			local glow = ShouldGlow(data)
			ApplyGlow(button, glow)
		end
	end
end

-- OnUpdate check
local glowFrame = CreateFrame("Frame")
local lastCheck = 0
glowFrame:SetScript("OnUpdate", function(self, elapsed)
	lastCheck = lastCheck + elapsed
	if lastCheck >= 1.0 then
		UpdateBuffGlows()
		lastCheck = 0
	end
end)

local eventsList = {
	"UNIT_AURA",
	"SPELL_UPDATE_COOLDOWN",
	"UNIT_SPELLCAST_SUCCEEDED",
	"ACTIONBAR_SLOT_CHANGED",
	"ACTION_USABLE_CHANGED",
	"ACTIONBAR_UPDATE_STATE",
	"ACTIONBAR_UPDATE_USABLE",
	"UPDATE_BONUS_ACTIONBAR",
	"PLAYER_TOTEM_UPDATE",
	"PLAYER_TARGET_CHANGED",
	"ACTION_RANGE_CHECK_UPDATE",
};

-- Initialize the script for tracking and updating
local f = CreateFrame("Frame");
for _, e in pairs(eventsList) do
	f:RegisterEvent(e)
end
f:SetScript("OnEvent", OnEvent);

for _, barInfo in ipairs(actionBarMappings) do
	for i = barInfo.start, barInfo.stop do
		local buttonName = barInfo.prefix .. (i - barInfo.start + 1);
		local button = _G[buttonName];
		if button then
			button.cooldownTexture = CreateCooldownTexture(button);
		end
	end
end

--]]