local KBTUITweaks, KBT = ...

local function Print(text)
	local textColor = CreateColor(KBTUI_DB.settings.colors.prefix.r, KBTUI_DB.settings.colors.prefix.g, KBTUI_DB.settings.colors.prefix.b):GenerateHexColor()
	text = "|c" .. textColor .. "KBT UI Tweaks" .. "|r" .. ": " .. text
	
	return DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 1)
end

local NAMEPLATE_TOKEN = "nameplate%d";

KBT.Rodeo = CreateFrame("Frame");

KBT.Rodeo.MaxSteps = 50;

KBT.Session = {};

local function processUnit(unitToken)
	if UnitExists(unitToken) and C_PlayerInfo.GUIDIsPlayer(UnitGUID(unitToken)) then
		local targetToken = unitToken .. "target";
		if UnitExists(targetToken) and UnitName(targetToken) == UnitName("player") then
			local nameP, realmP = UnitFullName("player");
			local PlayerNameRealm = nameP .. "-" .. realmP;

			if KBTUI_DB.SnooperMsg == true then
				Print(UnitName(unitToken) .. " is targeting " .. UnitName("player"));
			end

			if KBTUI_DB.Interlopers[PlayerNameRealm] == nil then
				KBTUI_DB.Interlopers[PlayerNameRealm] = {};
			end

			if KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)] == nil then
				Print("added " .. UnitName(unitToken) .. " into Snooper DB");
				KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)] = { firstSeen = date(), lastSeen = date(), secondsCounted = 1 };
			end

			local interloperData = KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)];
			interloperData.lastSeen = date();
			interloperData.secondsCounted = interloperData.secondsCounted + 1;

			KBT.Session[UnitName(unitToken)] = "|cffde9a26" .. UnitName(unitToken) .. "|r" ..
					": Last Seen: " .. "|cffe6cd5e" .. interloperData.lastSeen .. "|r" ..
					" | First Seen: " .. "|cffe6cd5e" .. interloperData.firstSeen .. "|r" ..
					" | Time Observed: " .. "|cffe6cd5e" .. SecondsToTime(interloperData.secondsCounted) .. "|r";

			KBT.mainFrame.SessionPopulate();
		end
	end
end

function KBT.Rodeo:Lasso()
	C_Timer.After(1, KBT.Rodeo.Lasso);

	for i = 1, KBT.Rodeo.MaxSteps, 1 do
		processUnit(format(NAMEPLATE_TOKEN, i));
	end

	local MOToken = "mouseover";

	processUnit(MOToken);
end
