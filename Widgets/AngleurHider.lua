local angleurHide = CreateFrame("Frame", nil, UIParent);

angleurHide.EventsList = {
	"PLAYER_ENTERING_WORLD",
};

for k, v in pairs(angleurHide.EventsList) do
	angleurHide:RegisterEvent(v);
end

function angleurHide.event(event, arg1)
	if C_AddOns.IsAddOnLoaded("Angleur") then
		if Angleur_Visual:IsShown() then
			Angleur_Visual:Hide();
		end
	end
end

angleurHide:SetScript("OnEvent", angleurHide.event);