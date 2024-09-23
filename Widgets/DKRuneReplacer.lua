local RF = RuneFrame.Runes
local rune = "Interface\\AddOns\\KBTUITweaks\\Assets\\Textures\\rune_"

local function KeepOrder()
	RuneFrame.runeIndices = {1,2,3,4,5,6};
end


local function OnEvent()
	for k, v in pairs(RF) do
		RF[k].Rune_Active:SetTexture(rune..k);
		RF[k].Rune_Inactive:SetTexture(rune..k);
		RF[k].Rune_Eyes:SetTexture(rune..k); -- part of the finisher?
		RF[k].Rune_Mid:SetTexture(rune..k); -- part of the finisher?
		RF[k].Rune_Lines:SetTexture(nil); -- part of depletion?
		RF[k].Rune_Grad:SetTexture(nil); -- part of depletion?

		RF[k].Rune_Active:SetVertexColor(.53,.74,.92,1);
		RF[k].Rune_Inactive:SetVertexColor(.25,.25,.25,1);
		RF[k].Smoke:SetTexture(rune..k); -- The effect when it flies up when activating

		RF[k].DepleteVisuals.Rune_Inactive:SetTexture(nil); -- fading texture effect
		RF[k].DepleteVisuals.FB_RuneDeplete:SetTexture(nil); -- the flipbook animation that plays upon depletion (6x4, topleft to right)
		RF[k].DepleteVisuals.Rune_Lines:SetTexture(nil); -- A flashing visual when rune initially depletes

		if RF[k].visualState ~= 4 then
			RF[k].Rune_Active:SetVertexColor(.25,.25,.25,1);
		else
			RF[k].Rune_Active:SetVertexColor(.53,.74,.92,1);
		end

		KeepOrder();
	end
end
	 
local f = CreateFrame("Frame");
f:RegisterEvent("RUNE_POWER_UPDATE");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
f:SetScript("OnEvent", OnEvent);

hooksecurefunc(RuneButtonMixin, "CompareRuneButtons", function()
	KeepOrder();
end);