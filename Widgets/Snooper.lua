local KBTUITweaks, KBT = ...

local function Print(text)
	local textColor = CreateColor(KBTUI_DB.settings.colors.prefix.r, KBTUI_DB.settings.colors.prefix.g, KBTUI_DB.settings.colors.prefix.b):GenerateHexColor()
	text = "|c" .. textColor .. "KBT UI Tweaks" .. "|r" .. ": " .. text
	
	return DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 1)
end

local NAMEPLATE_TOKEN = "nameplate%d";
local NAMEPLATE_NUMBER = "NamePlate%d";

KBT.Rodeo = CreateFrame("Frame");

KBT.Rodeo.MaxSteps = 50;

KBT.Session = {};

KBT.NamePlateTextures = {};

--[[


	for _, namePlate in pairs(C_NamePlate.GetNamePlates()) do
		local unitToken = namePlate.namePlateUnitToken
		local frameName = namePlate:GetName()
		
		if unitToken then

			if KBT.NamePlateTextures[formattedToken] and KBT.NamePlateTextures[formattedToken]:IsShown() then
			KBT.NamePlateTextures[formattedToken]:Hide();
			end

			local formattedTokenSub = formatNameplate(unitToken)

			if formattedTokenSub and not KBT.NamePlateTextures[formattedTokenSub] then
				KBT.NamePlateTextures[formattedTokenSub] = CreateFrame("Frame", nil, UIParent);
				KBT.NamePlateTextures[formattedTokenSub]:SetPoint("CENTER", _G[formattedTokenSub], "CENTER", 5, 5);
				KBT.NamePlateTextures[formattedTokenSub]:SetSize(64, 64);

				KBT.NamePlateTextures[formattedTokenSub].tex = KBT.NamePlateTextures[formattedTokenSub]:CreateTexture();
				KBT.NamePlateTextures[formattedTokenSub].tex:SetAllPoints();
				KBT.NamePlateTextures[formattedTokenSub].tex:SetTexture("interface\\addons\\KBTUITweaks\\Assets\\Textures\\eye");
			elseif formattedTokenSub then
				KBT.NamePlateTextures[formattedTokenSub]:ClearAllPoints()
				KBT.NamePlateTextures[formattedTokenSub]:SetPoint("CENTER", _G[formattedTokenSub], "CENTER", 5, 5)
				KBT.NamePlateTextures[formattedTokenSub]:Show()
			end
		end
	end

]]

for i = 1, KBT.Rodeo.MaxSteps, 1 do
	local nameplate = "NamePlate"..i
	KBT.NamePlateTextures[nameplate] = CreateFrame("Frame", nil, UIParent);
	KBT.NamePlateTextures[nameplate]:SetSize(32, 32);

	KBT.NamePlateTextures[nameplate].tex = KBT.NamePlateTextures[nameplate]:CreateTexture();
	KBT.NamePlateTextures[nameplate].tex:SetAllPoints();
	KBT.NamePlateTextures[nameplate].tex:SetAtlas("talents-heroclass-ring-minimize-show");
	--KBT.NamePlateTextures[nameplate].tex:SetVertexColor(.7,.75,1,.85);
	KBT.NamePlateTextures[nameplate]:Hide();
end

local function AddOrRemoveNamePlates(self, event, unitToken)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unitToken)
	if not namePlate then return end
	local unitFrame = namePlate:GetName()

	if event == "NAME_PLATE_UNIT_REMOVED" then
		KBT.NamePlateTextures[unitFrame]:ClearAllPoints();
		KBT.NamePlateTextures[unitFrame]:Hide();
	end
	if event == "NAME_PLATE_UNIT_ADDED" then
		local targetToken = unitToken .. "target";
		if UnitExists(targetToken) and UnitName(targetToken) == UnitName("player") then
			KBT.NamePlateTextures[unitFrame]:ClearAllPoints();
			KBT.NamePlateTextures[unitFrame]:SetPoint("RIGHT", _G[unitFrame], "LEFT", 0, 0);
			KBT.NamePlateTextures[unitFrame]:Show();
		end
	end
end

local function processUnit(unitToken)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unitToken)
	if not namePlate then return end
	local unitFrame = namePlate:GetName()

	if UnitExists(unitToken) and C_PlayerInfo.GUIDIsPlayer(UnitGUID(unitToken)) then
		local targetToken = unitToken .. "target";
		if UnitExists(targetToken) and UnitName(targetToken) == UnitName("player") then
			local nameP, realmP = UnitFullName("player");
			local realmU = select(2, UnitFullName(unitToken, true));
			if realmU == nil then
				realmU = realmP
			end

			if KBT.NamePlateTextures[unitFrame] then
				KBT.NamePlateTextures[unitFrame]:ClearAllPoints();
				KBT.NamePlateTextures[unitFrame]:SetPoint("RIGHT", _G[unitFrame], "LEFT", 0, 0);
				KBT.NamePlateTextures[unitFrame]:Show();
			end

			local PlayerNameRealm = nameP .. "-" .. realmP;

			if KBTUI_DB.SnooperMsg == true then
				Print(UnitName(unitToken) .. " is targeting " .. UnitName("player"));
			end

			if KBTUI_DB.Interlopers[PlayerNameRealm] == nil then
				KBTUI_DB.Interlopers[PlayerNameRealm] = {};
			end

			if KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)] == nil then
				Print("added " .. UnitName(unitToken) .. " into Snooper DB");
				KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)] = { realmU = realmU, firstSeen = date(), lastSeen = date(), secondsCounted = 1 };
			end
			if KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)]["realmU"] == nil then
				Print("added realm name " .. realmU .. " to " .. UnitName(unitToken))
				KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)]["realmU"] = realmU
			end

			local interloperData = KBTUI_DB.Interlopers[PlayerNameRealm][UnitName(unitToken)];
			interloperData.lastSeen = date();
			interloperData.secondsCounted = interloperData.secondsCounted + 1;

			KBT.Session[UnitName(unitToken)] = "|cffde9a26" .. UnitName(unitToken) .. "|r" ..
					": Last Seen: " .. "|cffe6cd5e" .. interloperData.lastSeen .. "|r" ..
					" | First Seen: " .. "|cffe6cd5e" .. interloperData.firstSeen .. "|r" ..
					" | Time Observed: " .. "|cffe6cd5e" .. SecondsToTime(interloperData.secondsCounted) .. "|r";

			KBT.mainFrame.SessionPopulate();
		else
			KBT.NamePlateTextures[unitFrame]:Hide();
		end
	end
end

KBT.Rodeo:RegisterEvent("NAME_PLATE_UNIT_ADDED")
KBT.Rodeo:RegisterEvent("NAME_PLATE_UNIT_REMOVED")


KBT.Rodeo:SetScript("OnEvent",AddOrRemoveNamePlates)

local soundPlayingSmall = false
local soundPlayingMedium = false
local soundPlayingLarge = false
local willPlaySoundSmall, PlaySoundSmall
local willPlaySoundMedium, PlaySoundMedium
local willPlaySoundLarge, PlaySoundLarge

local function timerChecker()
	if KBTUI_DB.SoundPlayer == nil then
		KBTUI_DB.SoundPlayer = true;
	end
	C_Timer.After(185, function()
		if soundPlayingLarge == true then
			local num = math.random(1,6)
			if PlaySoundLarge then
				StopSound(PlaySoundLarge, 5000)
			end
			if PlaySoundMedium then
				StopSound(PlaySoundMedium, 5000)
			end
			if PlaySoundSmall then
				StopSound(PlaySoundSmall, 5000)
			end
			if KBTUI_DB.SoundPlayer ~= true then
				return
			end
			willPlaySoundLarge, PlaySoundLarge = PlaySoundFile("Interface\\AddOns\\KBTUITweaks\\Assets\\Sound\\Ambience\\Busy_"..num..".mp3", "Ambience")
			print("queue up sound - Large")
			soundPlayingLarge = true
			timerChecker()
			soundPlayingLarge = false
		end
		if soundPlayingMedium == true then
			local num = math.random(1,6)
			if PlaySoundLarge then
				StopSound(PlaySoundLarge, 5000)
			end
			if PlaySoundMedium then
				StopSound(PlaySoundMedium, 5000)
			end
			if PlaySoundSmall then
				StopSound(PlaySoundSmall, 5000)
			end
			if KBTUI_DB.SoundPlayer ~= true then
				return
			end
			willPlaySoundMedium, PlaySoundMedium = PlaySoundFile("Interface\\AddOns\\KBTUITweaks\\Assets\\Sound\\Ambience\\Busy_"..num..".mp3", "Ambience")
			print("queue up sound - Medium")
			timerChecker()
			soundPlayingMedium = false
		end
		if soundPlayingSmall == true then
			local num = math.random(1,6)
			if PlaySoundLarge then
				StopSound(PlaySoundLarge, 5000)
			end
			if PlaySoundMedium then
				StopSound(PlaySoundMedium, 5000)
			end
			if PlaySoundSmall then
				StopSound(PlaySoundSmall, 5000)
			end
			if KBTUI_DB.SoundPlayer ~= true then
				return
			end
			willPlaySoundSmall, PlaySoundSmall = PlaySoundFile("Interface\\AddOns\\KBTUITweaks\\Assets\\Sound\\Ambience\\Busy_"..num..".mp3", "Ambience")
			print("queue up sound - Small")
			timerChecker()
			soundPlayingSmall = false
		end
	end)
end

function KBT.Rodeo:Lasso()
	local nameplateCount = 0
	C_Timer.After(1, KBT.Rodeo.Lasso);


	for i = 1, KBT.Rodeo.MaxSteps, 1 do
		processUnit(format(NAMEPLATE_TOKEN, i));
		if UnitExists(format(NAMEPLATE_TOKEN, i)) then
			nameplateCount = nameplateCount + 1
		end
	end

	local num = math.random(1,6)
	if nameplateCount >= 15 then
		soundPlayingSmall = false
		soundPlayingMedium = false
		if PlaySoundMedium then
			StopSound(PlaySoundMedium, 1300)
		end
		if PlaySoundSmall then
			StopSound(PlaySoundSmall, 1300)
		end

		if soundPlayingLarge == true then
			return
		end
		if KBTUI_DB.SoundPlayer ~= true then
			return
		end
		willPlaySoundLarge, PlaySoundLarge = PlaySoundFile("Interface\\AddOns\\KBTUITweaks\\Assets\\Sound\\Ambience\\Busy_"..num..".mp3", "Ambience")
		soundPlayingLarge = true
	elseif nameplateCount >= 10 and nameplateCount < 15 then
		soundPlayingSmall = false
		soundPlayingLarge = false
		if PlaySoundLarge then
			StopSound(PlaySoundLarge, 1300)
		end
		if PlaySoundSmall then
			StopSound(PlaySoundSmall, 1300)
		end

		if soundPlayingMedium == true then
			return
		end
		if KBTUI_DB.SoundPlayer ~= true then
			return
		end
		willPlaySoundMedium, PlaySoundMedium = PlaySoundFile("Interface\\AddOns\\KBTUITweaks\\Assets\\Sound\\Ambience\\Medium_"..num..".mp3", "Ambience")
		soundPlayingMedium = true
	elseif nameplateCount >= 5 and nameplateCount < 10 then
		soundPlayingMedium = false
		soundPlayingLarge = false
		if PlaySoundLarge then
			StopSound(PlaySoundLarge, 1300)
		end
		if PlaySoundMedium then
			StopSound(PlaySoundMedium, 1300)
		end

		if soundPlayingSmall == true then
			return
		end
		if KBTUI_DB.SoundPlayer ~= true then
			return
		end
		willPlaySoundSmall, PlaySoundSmall = PlaySoundFile("Interface\\AddOns\\KBTUITweaks\\Assets\\Sound\\Ambience\\Soft_"..num..".mp3", "Ambience")
		soundPlayingSmall = true
	else
		soundPlayingSmall = false
		soundPlayingMedium = false
		soundPlayingLarge = false
		if PlaySoundLarge then
			StopSound(PlaySoundLarge, 1300)
		end
		if PlaySoundMedium then
			StopSound(PlaySoundMedium, 1300)
		end
		if PlaySoundSmall then
			StopSound(PlaySoundSmall, 1300)
		end
	end

	local MOToken = "mouseover";



	processUnit(MOToken);
end
