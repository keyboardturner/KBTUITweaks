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

local function Print(text)
	local textColor = CreateColor(KBTUI_DB.settings.colors.prefix.r, KBTUI_DB.settings.colors.prefix.g, KBTUI_DB.settings.colors.prefix.b):GenerateHexColor()
	text = "|c" .. textColor .. "KBT UI Tweaks" .. "|r" .. ": " .. text
	
	return DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 1)
end

AddonCompartmentFrame:SetPoint("TOPLEFT", GameTimeFrame, "BOTTOMLEFT", 0, 35);

local KBT = {};

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
		C_CVar.SetCVar("WeatherDensity", 3);
		Print("CVar Settings for KBT set");
		EventToastManagerFrame:Hide();
		EventToastManagerFrame:EnableMouse(false);
		if EventToastManagerFrame.currentDisplayingToast then
			EventToastManagerFrame.currentDisplayingToast.Title:EnableMouse(false);
			EventToastManagerFrame.currentDisplayingToast.SubTitle:EnableMouse(false);
		end
	end
end
KBT.CVar:SetScript("OnEvent",KBT.CVar.OnEvent);

local NAMEPLATE_TOKEN = "nameplate%d";

KBT.Rodeo = CreateFrame("Frame");

KBT.Rodeo.MaxSteps = 50;

KBT.Session = {};

function KBT.Rodeo:Lasso()
	C_Timer.After(2, KBT.Rodeo.Lasso);

	for i=1, KBT.Rodeo.MaxSteps, 1 do
		local unitToken = format(NAMEPLATE_TOKEN, i);
		if UnitExists(unitToken) and C_PlayerInfo.GUIDIsPlayer(UnitGUID(unitToken)) then

			local targetToken = unitToken .. "target";

			if UnitExists(targetToken) then
				if UnitName(targetToken) == UnitName("player") then

					local nameP, realmP = UnitFullName("player");
					local PlayerNameRealm = nameP .. "-" .. realmP;

					if KBTUI_DB.SnooperMsg == true then
						Print(UnitName(unitToken) .. " is targeting " .. UnitName("player"));
					end
					if KBTUI_DB.Interlopers[PlayerNameRealm] == nil then
						KBTUI_DB.Interlopers[PlayerNameRealm] = {};
					end
					if KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)] == nil then
						Print("added " .. UnitName(unitToken) .." into Snooper DB");
						KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)] = { firstSeen = date(), lastSeen = date(), secondsCounted = 2 };
					end
					if KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)].lastSeen ~= nil then
						KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)].lastSeen = date();
					end
					if KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)].secondsCounted ~= nil then
						KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)].secondsCounted = KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)].secondsCounted + 2
					end
					KBT.Session[UnitName(unitToken)] = "|cffde9a26" .. UnitName(unitToken) .. "|r" .. 
					": Last Seen: " .. "|cffe6cd5e" .. KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)].lastSeen .. "|r" ..
					" | First Seen: " .. "|cffe6cd5e" .. KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)].firstSeen .. "|r" ..
					" | Time Observed: " .. "|cffe6cd5e" .. SecondsToTime(KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)].secondsCounted) .. "|r";
				end
			end
		end
	end
end

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

	["help"] = function()
		Print("List of commands:\n"..
			"snoop - toggle chat messages whenever a nameplate targets you.\n"..
			"spin - keyboardturning speed set to very fast.\n"..
			"interlopers - a list of people caught snooping this session.")
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
end

KBT.Initialize:SetScript("OnEvent", KBT.Initialize.Go)