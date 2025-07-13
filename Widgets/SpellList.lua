--[[

local ScrollBox = CreateFrame("Frame", nil, UIParent, "WowScrollBoxList")
ScrollBox:SetPoint("CENTER")
ScrollBox:SetSize(300, 300)

local ScrollBar = CreateFrame("EventFrame", nil, UIParent, "MinimalScrollBar")
ScrollBar:SetPoint("TOPLEFT", ScrollBox, "TOPRIGHT")
ScrollBar:SetPoint("BOTTOMLEFT", ScrollBox, "BOTTOMRIGHT")

local DataProvider = CreateDataProvider()
local ScrollView = CreateScrollBoxListLinearView()
ScrollView:SetDataProvider(DataProvider)

ScrollUtil.InitScrollBoxListWithScrollBar(ScrollBox, ScrollBar, ScrollView)

-- Element Initializer
local function Initializer(button, data)
	button:SetText(data.name, data.id)
	local isUsable, noMana = C_Spell.IsSpellUsable(data.id)
	if isUsable and not noMana then
		button:Enable()
	else
		button:Disable()
	end
	button:SetScript("OnClick", function()
		print("Spell: " .. data.name .. " (ID: " .. data.id .. ")")
	end)
end


ScrollView:SetElementInitializer("UIPanelButtonTemplate", Initializer)

-- Optional: Element Resetter
local function Resetter(frame, data)
	frame:SetText("")
	frame:SetScript("OnClick", nil)
end

ScrollView:SetElementResetter(Resetter)

-- Function to load all player spells using SpellMixin
local function LoadPlayerSpells()
	DataProvider:Flush()

	for spellID = 1, 1249473 do
		if IsPlayerSpell(spellID) then
			local spell = spellID
			local name = C_Spell.GetSpellInfo(spellID).name
			DataProvider:Insert({
				id = spellID,
				name = name,
			})
		end
	end
end

-- Load the spells after login to ensure the spellbook is initialized
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	LoadPlayerSpells()
end)

--]]