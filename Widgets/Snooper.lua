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
					KBT.mainFrame.SessionPopulate()
				end
			end
		end
	end
end