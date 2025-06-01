local _, KBT = ...

local function Print(text)
	local textColor = CreateColor(KBTUI_DB.settings.colors.prefix.r, KBTUI_DB.settings.colors.prefix.g, KBTUI_DB.settings.colors.prefix.b):GenerateHexColor()
	text = "|c" .. textColor .. "KBT UI Tweaks" .. "|r" .. ": " .. text
	
	return DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 1)
end

--personal addon for me

--soft target - friend
--C_CVar.SetCVar("SoftTargetFriend", 0)
--C_CVar.SetCVar("SoftTargetIconFriend", 1)
--C_CVar.SetCVar("SoftTargetEnemyRange", 9)
--C_CVar.SetCVar("SoftTargetFriendRange", 9)

--C_CVar.GetCVar("")

defaultsTable = {
	SnooperMsg = true; -- Show chat message updates when somebody is targeting you

	settings = {
		colors = {
			prefix = {r = 28/255, g = 230/255, b = 81/255},
		},
	},

	Interlopers = {},
};

AddonCompartmentFrame:SetPoint("TOPLEFT", GameTimeFrame, "BOTTOMLEFT", 0, 35);


KBT.CVar = CreateFrame("Frame");
--KBTCvar:RegisterEvent("ADDON_LOADED");
--KBTCvar:RegisterEvent("PLAYER_LOGOUT");
KBT.CVar:RegisterEvent("PLAYER_ENTERING_WORLD");
KBT.CVar:RegisterEvent("CURRENCY_DISPLAY_UPDATE");

--[[
local function hookFunc(...)
	local cvarName, value = ...;
	if cvarName == "WeatherDensity" then
		print(debugstack(2));
	end
end
]]

--hooksecurefunc("SetCVar", hookFunc);


function KBT.CVar:OnEvent(event,arg1)
	if event == "PLAYER_ENTERING_WORLD" then
		--C_CVar.SetCVar("SoftTargetFriend", 0)
		--C_CVar.SetCVar("SoftTargetInteract", 1)
		C_CVar.SetCVar("WeatherDensity", 3); -- something likes to make this 0, so revert it.
		C_CVar.SetCVar("AutoPushSpellToActionBar", 0); -- stops auto-adding spells when swapping spec, etc.
		Print("CVar Settings for KBT set");
		EventToastManagerFrame:Hide();
		EventToastManagerFrame:EnableMouse(false);
		if EventToastManagerFrame.currentDisplayingToast then
			if EventToastManagerFrame.currentDisplayingToast.Title then
				EventToastManagerFrame.currentDisplayingToast.Title:EnableMouse(false);
			end
			if EventToastManagerFrame.currentDisplayingToast.SubTitle then
				EventToastManagerFrame.currentDisplayingToast.SubTitle:EnableMouse(false);
			end
		end
	end
end
KBT.CVar:SetScript("OnEvent",KBT.CVar.OnEvent);


EventRegistry:RegisterCallback("Settings.CategoryChanged", function()
	-- These sound settings keep getting reset upon opening the menu
	RunNextFrame(function()
		--C_CVar.SetCVar("Sound_AmbienceVolume", 1.0);
		C_CVar.SetCVar("Sound_DialogVolume", 1.0); 
		--C_CVar.SetCVar("Sound_MasterVolume", 1.0);
		--C_CVar.SetCVar("Sound_MusicVolume", .9);
		C_CVar.SetCVar("Sound_SFXVolume", .5);
	end)
end);

KBT.commands = {
	["snoop"] = function()
		if KBTUI_DB.SnooperMsg == true then
			KBTUI_DB.SnooperMsg = false;
			Print("Snooper messages turned off.");
		else
			KBTUI_DB.SnooperMsg = true;
			Print("Snooper messages turned on.");
		end
	end,

	["spin"] = function()
		if C_CVar.GetCVar("Turnspeed") == "540" then
			Print("Setting Turnspeed to 100.");
			C_CVar.SetCVar("Turnspeed", 100);
		else
			Print("Setting Turnspeed to 540.");
			C_CVar.SetCVar("Turnspeed", 540);
		end
	end,

	["interlopers"] = function()
		Print("Latest Interlopers: ")
		for k, v in pairs(KBT.Session) do
			--print(k)
			print(v)
		end
	end,

	["open"] = function()
		if KBT.mainFrame:IsShown() then
			KBT.mainFrame:Hide();
		else
			KBT.mainFrame:Show();
		end
	end,

	["show"] = function()
		KBT.ShowWithFadeProf()
	end,

	["hide"] = function()
		KBT.HideWithFadeProf()
	end,

	["milk"] = function()
		local MILKMODE = CreateFrame("Frame")
		local function MILKBUY()
			KBT.MILKMODE = true
			local a={"Ice Cold Milk",20}
			for i=1,GetMerchantNumItems() do
				if GetMerchantItemInfo(i)==a[1] and KBT.MILKMODE == true then
					BuyMerchantItem(i,a[2])
				end
			end
		end
		if KBT.MILKMODE == nil then
			KBT.MILKMODE = false
		end
		if KBT.MILKMODE == true then
			KBT.MILKMODE = false
			MILKMODE:SetScript("OnUpdate", nil)
			return
		else
			Print("MILK MODE ACTIVATED. PLEASE BE ADVISED, YOU WILL NOW BUY AS MUCH ICE COLD MILK AS POSSIBLE FOREVER (until you reload or log out)")
			MILKMODE:SetScript("OnUpdate", MILKBUY)
		end
	end,

	["help"] = function()
		Print("List of commands:\n"..
			"snoop - toggle chat messages whenever a nameplate targets you.\n"..
			"spin - keyboardturning speed set to very fast.\n"..
			"interlopers - a list of people caught snooping this session.\n"..
			"open - a window with a bunch of stuff.")
	end,
};


function KBT.HandleSlashCommands(str)
	if (#str == 0) then
		KBT.commands.help();
		return;
		end

		local args = {};
		for _dummy, arg in ipairs({ string.split(' ', str) }) do
		if (#arg > 0) then
			table.insert(args, arg);
			end
			end

			local path = KBT.commands; -- required for updating found table.

			for id, arg in ipairs(args) do

			if (#arg > 0) then --if string length is greater than 0
			arg = arg:lower();          
			if (path[arg]) then
				if (type(path[arg]) == "function") then
					-- all remaining args passed to our function!
					path[arg](select(id + 1, unpack(args))); 
					return;                 
				elseif (type(path[arg]) == "table") then
					path = path[arg]; -- another sub-table found!
				end
				else
					KBT.commands.help();
				return;
			end
		end
	end
end



KBT.Initialize = CreateFrame("Frame");
KBT.Initialize:RegisterEvent("ADDON_LOADED");
KBT.Initialize:RegisterEvent("PLAYER_LOGIN");

function KBT.Initialize:Go(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "KBTUITweaks" then
		if KBTUI_DB == nil then
			KBTUI_DB = CopyTable(defaultsTable)
		end
		Print("Settings for KBT UI Tweaks Loaded")
		KBT.Rodeo:Lasso();


		SLASH_KBT1 = "/kbt"
		SlashCmdList.KBT = KBT.HandleSlashCommands;
	end

	if event == "PLAYER_LOGIN" then
		KBT.DoPopulationStuff();
		KBT.mainFrame.Populate();
	end
end

KBT.Initialize:SetScript("OnEvent", KBT.Initialize.Go)