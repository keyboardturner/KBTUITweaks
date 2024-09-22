--MoveTarTarF_DB
--StatusTrackingBarManager

return

--[[
local defaultsTable = {
	ToTFrame = {show = true, checked = true, scale = 1, x = 0, y = 0, point = "CENTER", relativePoint = "CENTER"},
	TarCastBar = {show = true, checked = true, scale = 1, x = 0, y = 0, point = "CENTER", relativePoint = "CENTER"},
	PetFrame = {show = true, checked = true, scale = 1, x = 0, y = 0, point = "CENTER", relativePoint = "CENTER"},
	
	locked = false,
}


local ToTFramePanel = CreateFrame("FRAME");
ToTFramePanel.name = "Movable Target of Target Frame";

ToTFramePanel.Headline = ToTFramePanel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
ToTFramePanel.Headline:SetFont(ToTFramePanel.Headline:GetFont(), 23);
ToTFramePanel.Headline:SetTextColor(0,1,0,1);
ToTFramePanel.Headline:ClearAllPoints();
ToTFramePanel.Headline:SetPoint("TOPLEFT", ToTFramePanel, "TOPLEFT",12,-12);
ToTFramePanel.Headline:SetText("Movable Target of Target Frame");

ToTFramePanel.Version = ToTFramePanel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
ToTFramePanel.Version:SetFont(ToTFramePanel.Version:GetFont(), 12);
ToTFramePanel.Version:SetTextColor(1,1,1,1);
ToTFramePanel.Version:ClearAllPoints();
ToTFramePanel.Version:SetPoint("TOPLEFT", ToTFramePanel, "TOPLEFT",400,-21);
ToTFramePanel.Version:SetText("Version: " .. GetAddOnMetadata("MovableTargetTargetFrame", "Version"));


------------------------------------------------------------------------------------------------------------------

--menu slider
ToTFramePanel.ToTSlider = CreateFrame("Slider", "ToTScaleSlider", ToTFramePanel, "OptionsSliderTemplate");
ToTFramePanel.ToTSlider:SetWidth(300);
ToTFramePanel.ToTSlider:SetHeight(15);
ToTFramePanel.ToTSlider:SetMinMaxValues(50,150);
ToTFramePanel.ToTSlider:SetValueStep(1);
ToTFramePanel.ToTSlider:ClearAllPoints();
ToTFramePanel.ToTSlider:SetPoint("TOPLEFT", ToTFramePanel, "TOPLEFT",12,-53);
getglobal(ToTFramePanel.ToTSlider:GetName() .. 'Low'):SetText('50');
getglobal(ToTFramePanel.ToTSlider:GetName() .. 'High'):SetText('150');
getglobal(ToTFramePanel.ToTSlider:GetName() .. 'Text'):SetText('Micromenu Frame Size');
ToTFramePanel.ToTSlider:SetScript("OnValueChanged", function()
	local scaleValue = getglobal(ToTFramePanel.ToTSlider:GetName()):GetValue() / 100;
	MoveTarTarF_DB.ToTFrame.scale = scaleValue;
	TargetFrameToT:SetScale(scaleValue);
end)


------------------------------------------------------------------------------------------------------------------

--menu slider
ToTFramePanel.CastSlider = CreateFrame("Slider", "CastTarScaleSlider", ToTFramePanel, "OptionsSliderTemplate");
ToTFramePanel.CastSlider:SetWidth(300);
ToTFramePanel.CastSlider:SetHeight(15);
ToTFramePanel.CastSlider:SetMinMaxValues(50,150);
ToTFramePanel.CastSlider:SetValueStep(1);
ToTFramePanel.CastSlider:ClearAllPoints();
ToTFramePanel.CastSlider:SetPoint("TOPLEFT", ToTFramePanel, "TOPLEFT",12,-53*2);
getglobal(ToTFramePanel.CastSlider:GetName() .. 'Low'):SetText('50');
getglobal(ToTFramePanel.CastSlider:GetName() .. 'High'):SetText('150');
getglobal(ToTFramePanel.CastSlider:GetName() .. 'Text'):SetText('Micromenu Frame Size');
ToTFramePanel.CastSlider:SetScript("OnValueChanged", function()
	local scaleValue = getglobal(ToTFramePanel.CastSlider:GetName()):GetValue() / 100;
	MoveTarTarF_DB.ToTFrame.scale = scaleValue;
	TargetFrameSpellBar:SetScale(scaleValue);
end)

------------------------------------------------------------------------------------------------------------------

--frames movable
ToTFramePanel.ToTLockedCheckbox = CreateFrame("CheckButton", "ToTLockedCheckbox", ToTFramePanel, "UICheckButtonTemplate");
ToTFramePanel.ToTLockedCheckbox:ClearAllPoints();
ToTFramePanel.ToTLockedCheckbox:SetPoint("TOPLEFT", 350, -53);
getglobal(ToTFramePanel.ToTLockedCheckbox:GetName().."Text"):SetText("Frame Locked");

ToTFramePanel.ToTLockedCheckbox:SetScript("OnClick", function(self)
	if ToTFramePanel.ToTLockedCheckbox:GetChecked() then
		MoveTarTarF_DB.locked = true;
		TargetFrameToT:Hide()
		TargetFrameSpellBar:Hide()
		PetFrame:Hide()
	else
		MoveTarTarF_DB.locked = false;
		TargetFrameToT:Show()
		TargetFrameSpellBar:Show()
		PetFrame:Show()
	end
end);



------------------------------------------------------------------------------------------------------------------

--final
InterfaceOptions_AddCategory(ToTFramePanel);


local ToTEventFrame = CreateFrame("Frame");
ToTEventFrame:RegisterEvent("ADDON_LOADED");
ToTEventFrame:RegisterEvent("PLAYER_LOGOUT");
ToTEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
ToTEventFrame:RegisterEvent("UNIT_SPELLCAST_START");
ToTEventFrame:RegisterEvent("UNIT_SPELLCAST_STOP");
ToTEventFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
ToTEventFrame:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
ToTEventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
ToTEventFrame:RegisterEvent("PLAYER_REGEN_DISABLED");


function ToTEventFrame.ReMoveStuff()
	TargetFrameSpellBar:ClearAllPoints()
	TargetFrameSpellBar:SetPoint("TOPLEFT", TargetFrame, "BOTTOMLEFT", 43, 5);
	TargetFrameSpellBar:SetScale(MoveTarTarF_DB.TarCastBar.scale);
end

function ToTEventFrame.CombatFunc()
	if UnitAffectingCombat("player") == true then
		MoveTarTarF_DB.locked = true;
	end
end

function ToTEventFrame.Login()
	if UnitAffectingCombat("player") == false then
		ToTFramePanel.ToTLockedCheckbox:SetChecked(MoveTarTarF_DB.locked);

		TargetFrameToT:ClearAllPoints()
		TargetFrameToT:SetPoint(MoveTarTarF_DB.ToTFrame.point, UIParent, MoveTarTarF_DB.ToTFrame.relativePoint, MoveTarTarF_DB.ToTFrame.x, MoveTarTarF_DB.ToTFrame.y);
		TargetFrameToT:SetScale(MoveTarTarF_DB.ToTFrame.scale);
		TargetFrameSpellBar:ClearAllPoints()
		TargetFrameSpellBar:SetPoint("TOPLEFT", TargetFrame, "BOTTOMLEFT", 43, 5);
		TargetFrameSpellBar:SetScale(MoveTarTarF_DB.TarCastBar.scale);
		PetFrame:ClearAllPoints()
		PetFrame:SetPoint(MoveTarTarF_DB.PetFrame.point, UIParent, MoveTarTarF_DB.PetFrame.relativePoint, MoveTarTarF_DB.PetFrame.x, MoveTarTarF_DB.PetFrame.y);
	end
end


function ToTEventFrame.Stuff(frame,button)
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetUserPlaced(true);
	frame:RegisterForDrag("LeftButton", "RightButton");
	frame:SetClampedToScreen(true)

	frame:SetScript("OnMouseDown", function(self, button)
		if MoveTarTarF_DB.locked == false then
			if button == "LeftButton" and not self.isMoving then
				Mixin(self, BackdropTemplateMixin);
				frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", insets = { left = -30, right = -1, top = -1, bottom = -1 }});
				frame:SetBackdropColor(1,.71,.75,.5);
				self:StartMoving();
				self.isMoving = true;
			end
		else
			return
		end
	end);
	frame:SetScript("OnMouseUp", function(self)
		Mixin(self, BackdropTemplateMixin);
		frame:SetBackdropColor(0,0,0,0);
		self:StopMovingOrSizing();
		self.isMoving = false;
		local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint();
		if frame == TargetFrameToT then
			MoveTarTarF_DB.ToTFrame.point = point
			MoveTarTarF_DB.ToTFrame.relativePoint = relativePoint
			MoveTarTarF_DB.ToTFrame.x = xOfs
			MoveTarTarF_DB.ToTFrame.y = yOfs
		end
		if frame == TargetFrameSpellBar then
			MoveTarTarF_DB.TarCastBar.point = point
			MoveTarTarF_DB.TarCastBar.relativePoint = relativePoint
			MoveTarTarF_DB.TarCastBar.x = xOfs
			MoveTarTarF_DB.TarCastBar.y = yOfs
		end
		if frame == PetFrame then
			MoveTarTarF_DB.PetFrame.point = point
			MoveTarTarF_DB.PetFrame.relativePoint = relativePoint
			MoveTarTarF_DB.PetFrame.x = xOfs
			MoveTarTarF_DB.PetFrame.y = yOfs
		end
	end);
end

function ToTEventFrame:OnEvent(event,arg1)
	if event == "ADDON_LOADED" and arg1 == "MovableTargetTargetFrame" then
		if not MoveTarTarF_DB then
			MoveTarTarF_DB = defaultsTable;
		end
		if not MoveTarTarF_DB.ToTFrame then
			MoveTarTarF_DB.ToTFrame = defaultsTable.ToTFrame;
		end
		if not MoveTarTarF_DB.TarCastBar then
			MoveTarTarF_DB.TarCastBar = defaultsTable.TarCastBar;
		end
		if not MoveTarTarF_DB.PetFrame then
			MoveTarTarF_DB.PetFrame = defaultsTable.PetFrame;
		end


		ToTFramePanel.ToTSlider:SetValue(MoveTarTarF_DB.ToTFrame.scale*100);
		ToTFramePanel.CastSlider:SetValue(MoveTarTarF_DB.TarCastBar.scale*100);

		ToTEventFrame.Login()
		ToTEventFrame.Stuff(TargetFrameToT);
		ToTEventFrame.Stuff(PetFrame);
		--ToTEventFrame.Stuff(TargetFrameSpellBar);
	end
	if event == "PLAYER_LOGOUT" then
		TargetFrameToT:SetUserPlaced(false);
		TargetFrameToT:ClearAllPoints();
		TargetFrameSpellBar:SetUserPlaced(false);
		TargetFrameSpellBar:ClearAllPoints();
		PetFrame:SetUserPlaced(false);
		PetFrame:ClearAllPoints();
	end
	if event == "PLAYER_REGEN_DISABLED" then
		ToTEventFrame.CombatFunc()
	end
	if event ~= "ADDON_LOADED" or "PLAYER_LOGOUT" then
		ToTEventFrame.ReMoveStuff();
	end
end
ToTEventFrame:SetScript("OnEvent",ToTEventFrame.OnEvent);


]]