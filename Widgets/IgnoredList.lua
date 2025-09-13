local AccountIgnores = CreateFrame("Frame", nil, FriendsFrame.IgnoreListWindow )
AccountIgnores:SetPoint("LEFT",FriendsFrame.IgnoreListWindow,"RIGHT",25,0)
AccountIgnores:SetSize(100,100)

AccountIgnores.tex = AccountIgnores:CreateTexture()
AccountIgnores.tex:SetAllPoints(AccountIgnores)
AccountIgnores.tex:SetTexture("Interface/Tooltips/UI-Tooltip-Background")
AccountIgnores.tex:SetVertexColor(0,0,0,.5)

AccountIgnores.title = AccountIgnores:CreateFontString(nil, "OVERLAY", "GameFontNormal")
AccountIgnores.title:SetText("Account Ignore List")
AccountIgnores.title:SetPoint("TOP", AccountIgnores, "TOP", 0, -5)

AccountIgnores.ScrollFrame = CreateFrame("ScrollFrame", nil, AccountIgnores, "ScrollFrameTemplate")
AccountIgnores.ScrollFrame:SetPoint("TOPLEFT", AccountIgnores, "TOPLEFT", 4, -8)
AccountIgnores.ScrollFrame:SetPoint("BOTTOMRIGHT", AccountIgnores, "BOTTOMRIGHT", -3, 4)
AccountIgnores.ScrollFrame.ScrollBar:ClearAllPoints()
AccountIgnores.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", AccountIgnores.ScrollFrame, "TOPRIGHT", -12, -18)
AccountIgnores.ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", AccountIgnores.ScrollFrame, "BOTTOMRIGHT", -7, 0)


AccountIgnores.ScrollFrame.child = CreateFrame("Frame", nil, AccountIgnores.ScrollFrame)
AccountIgnores.ScrollFrame:SetScrollChild(AccountIgnores.ScrollFrame.child)
AccountIgnores.ScrollFrame.child:SetWidth(AccountIgnores:GetWidth()-18)
AccountIgnores.ScrollFrame.child:SetHeight(1)

local CharNameRealm

local function GetIgnoreList()
	local ignoreCount = C_FriendList.GetNumIgnores()
	if ignoreCount == nil then
		return
	end
	NameListTemp = {};
	for i = 1, ignoreCount do
		local ignoreName = C_FriendList.GetIgnoreName(i)
		if ignoreName then
			table.insert(NameListTemp,ignoreName)
			if KBTUI_DB["IgnoredList"][CharNameRealm] == nil then
				KBTUI_DB["IgnoredList"][CharNameRealm] = {}
			end
			if KBTUI_DB["IgnoredList"][CharNameRealm] then
				--print("Adding " .. ignoreName .. " to ignore list.")
				KBTUI_DB["IgnoredList"][CharNameRealm] = NameListTemp
			end
		end
	end

	if type(next(NameListTemp)) == "nil" then
		--print("Clearing ignore list from data.")
		KBTUI_DB["IgnoredList"][CharNameRealm] = nil
	end
end

local function GetSavedIgnoreInfo()
	local altCount = 1
	for k,v in pairs(KBTUI_DB["IgnoredList"]) do
		if k ~= CharNameRealm then
			altCount = altCount + 1
			local altName = AccountIgnores.ScrollFrame.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			altName:SetText(k)
			altName:SetPoint("TOPLEFT", AccountIgnores.ScrollFrame.child, "TOPLEFT", 10, -20 * (altCount - 1))
			table.insert(AccountIgnores.altName, altName)
			for a,b in pairs(v) do
				local altNameIgnored = AccountIgnores.ScrollFrame.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				altNameIgnored:SetText(b)
				altNameIgnored:SetPoint("TOPLEFT", AccountIgnores.ScrollFrame.child, "TOPLEFT", 25, (-20 * (altCount - 1))-20)
				table.insert(AccountIgnores.altNameIgnored, altNameIgnored)
				altCount = altCount + 1
			end
		end
	end

--[[
	local ignoreCount = C_FriendList.GetNumIgnores()
	for i = 1, ignoreCount do
		local ignoreName = C_FriendList.GetIgnoreName(i)
		if ignoreName then
			local fontString = AccountIgnores:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			fontString:SetText(ignoreName)
			fontString:SetPoint("TOPLEFT", altName, "TOPLEFT", 10, -20 * (i - 1))
			table.insert(AccountIgnores.fontStrings, fontString)
		end
	end
]]
end

local function GenerateIgnoreList()
	local sizeX = FriendsFrame:GetWidth()
	local sizeY = FriendsFrame:GetHeight()
	if not FriendsFrame.IgnoreListWindow then AccountIgnores:Hide() return end
	AccountIgnores:Show()
	AccountIgnores:SetSize(sizeX,sizeY)
	FriendsFrame.IgnoreListWindow:SetSize(sizeX,sizeY)
	
	-- Clear previous font strings if any
	if AccountIgnores.altNameIgnored then
		for _, fontString in ipairs(AccountIgnores.altNameIgnored) do
			fontString:Hide()
		end
	else
		AccountIgnores.altNameIgnored = {}
	end


	if AccountIgnores.altName then
		for _, fontString in ipairs(AccountIgnores.altName) do
			fontString:Hide()
		end
	else
		AccountIgnores.altName = {}
	end
	
	GetSavedIgnoreInfo()
	GetIgnoreList()

end
AccountIgnores:SetScript("OnShow", GenerateIgnoreList)
AccountIgnores:SetScript("OnEvent", GenerateIgnoreList)



local initialize = CreateFrame("Frame");
initialize:RegisterEvent("ADDON_LOADED");

function initialize:Go(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "KBTUITweaks" then
		if KBTUI_DB ~= nil then
			if KBTUI_DB["IgnoredList"] == nil then
				KBTUI_DB["IgnoredList"] = {}
			end
		end
		CharNameRealm = UnitName("player").."-"..GetRealmName()
		GetIgnoreList()
		AccountIgnores:RegisterEvent("IGNORELIST_UPDATE")
	end
end

initialize:SetScript("OnEvent", initialize.Go)