CurrencyTransferMenu:EnableMouse(true)
CurrencyTransferMenu:SetMovable(true)
CurrencyTransferMenu:RegisterForDrag("LeftButton")
CurrencyTransferMenu:SetClampedToScreen(true)

CurrencyTransferMenu:SetScript("OnDragStart", function(self)
	if self:IsMovable() then
		self:StartMoving()
	end
end)

CurrencyTransferMenu:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
end)
