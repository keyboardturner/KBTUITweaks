local _, KBT = ...

local function Print(text)
	local textColor = CreateColor(KBTUI_DB.settings.colors.prefix.r, KBTUI_DB.settings.colors.prefix.g, KBTUI_DB.settings.colors.prefix.b):GenerateHexColor()
	text = "|c" .. textColor .. "KBT UI Tweaks" .. "|r" .. ": " .. text
	
	return DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 1)
end

function KBT.GetNormalizedPlayerName(includeRealm)
	local name, realm = GetUnitName("player", includeRealm);
	if includeRealm then
		return name .. "-" .. (realm or GetNormalizedRealmName());
	else
		return name
	end
end

KBT.AutoEmote = CreateFrame("FRAME");
KBT.AutoEmote:RegisterEvent("PLAYER_ENTERING_WORLD");
KBT.AutoEmote:RegisterEvent("CHAT_MSG_TEXT_EMOTE");

KBT.AutoEmote.SupportedEmotes = {
	HUG = "hug",
	BOOP = "boop",
	--LICK = "lick",
	--POKE = "poke",
	--BONK = "bonk",
	--ROAR = "roar",
};

KBT.AutoEmote.SupportedEmoteIDStrings = {
	HUG = "hugs you",
	BOOP = "boops your",
	--LICK = "licks you",
	--POKE = "pokes you",
	--BONK = "bonks you",
	--ROAR = "roars with bestial vigor at you",
};

function KBT.AutoEmote:OnEvent(event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		if KBTUI_DB.AutoEmote == nil then
			KBTUI_DB.AutoEmote = {
				DisabledCharacters = {};
				Markers = {
					COUNTER = "counter",
					LAST_EMOTE = "hugged",
				};
				TrackedEmote = KBT.AutoEmote.SupportedEmotes.HUG;
				EmoteCount = 0;
				LastEmoted = "";
				SpecialResponseEmotes = {
					--ROAR = "blush",
					POKE = "hug",
					--HUG = "hug",
				};
			};
		end
		self.Config = KBTUI_DB.AutoEmote;
		self:UnregisterEvent(event);
	elseif event == "CHAT_MSG_TEXT_EMOTE" then
		self:HandleEmote(...)
	end
end

KBT.AutoEmote:SetScript("OnEvent", KBT.AutoEmote.OnEvent);

function KBT.AutoEmote:IncrementCounter()
	self.Config.EmoteCount = self:GetEmoteCount() + 1;
	self:SaveConfig();
end

function KBT.AutoEmote:SetLastEmoted(victim)
	self.Config.LastEmoted = victim;
	self:SaveConfig();
end

function KBT.AutoEmote:IsSpecialResponseEmote(emote)
	return self.Config.SpecialResponseEmotes[emote] ~= nil;
end

function KBT.AutoEmote:GetResponseEmote(emote)
	emote = string.upper(emote)

	if self:IsSpecialResponseEmote(emote) then
		return string.upper(self.Config.SpecialResponseEmotes[emote]);
	else
		return string.upper(self.SupportedEmotes[emote]);
	end
end

function KBT.AutoEmote:GetTrackedEmote()
	return self.Config.TrackedEmote;
end

function KBT.AutoEmote:GetMarker(marker)
	return self.Config.Markers[marker] .. ": ";
end

function KBT.AutoEmote:GetEmoteCount()
	return self.Config.EmoteCount or 0;
end

function KBT.AutoEmote:GetLastEmoted()
	return self.Config.LastEmoted or "";
end

function KBT.AutoEmote:SetCounterMarker(marker)
	self.Config.Markers.COUNTER = marker;
	Print("Counter marker set to " .. marker);
	self:SaveConfig();
end

function KBT.AutoEmote:SetLastEmoteMarker(marker)
	self.Config.Markers.LAST_EMOTE = marker;
	Print("Last emote marker set to " .. marker);
	self:SaveConfig();
end

function KBT.AutoEmote:SaveConfig()
	assert(self.Config, "THE CONFIG'S GONE! PANIC!")
	KBT.AutoEmote = self.Config;
end

--TRP3 integration-------------------------------------
function KBT.AutoEmote:TRPUpdateCurrently(victim)
	if not C_AddOns.IsAddOnLoaded("TotalRP3") then
		return false;
	end

	if tContains(self.Config.DisabledCharacters, KBT.GetNormalizedPlayerName()) then
		return false;
	end

	local character = TRP3_API.profile.getData("player/character")

	local currentCurrently = character.CU

	if not currentCurrently then
		Print("No currently found, aborting update.")
		return false;
	end

	local counterMarker = self:GetMarker("COUNTER")
	local lastEmoteMarker = self:GetMarker("LAST_EMOTE")

	local counterPattern = counterMarker .. "%d-\n"
	local lastEmotePattern = lastEmoteMarker .. ".*%s-\n-"

	local newCounterString = counterMarker .. self:GetEmoteCount() + 1 .. "\n"
	local newLastEmoteString = lastEmoteMarker .. victim .. "\n"

	local newCurrently;

	newCurrently = string.gsub(currentCurrently, counterPattern, newCounterString)
	newCurrently = string.gsub(newCurrently, lastEmotePattern, newLastEmoteString)

	if not newCurrently or newCurrently == currentCurrently or newCurrently == "" then
		Print("Failed to update currently.")
		return false;
	end

	character.CU = newCurrently;

	character.v = TRP3_API.utils.math.incrementNumber(character.v or 1, 2);
	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.REGISTER_DATA_UPDATED, TRP3_API.globals.player_id,
		TRP3_API.profile.getPlayerCurrentProfileID(), "character");

	return true;
end

function KBT.AutoEmote:GetEmoteIDText(emote)
	return self.SupportedEmoteIDStrings[string.upper(emote)];
end

function KBT.AutoEmote:IdentifyEmote(emoteText)
	for _, emote in pairs(self.SupportedEmotes) do
		local emoteID = self:GetEmoteIDText(emote);

		if emoteID and string.find(emoteText, emoteID) ~= nil then
			return emote;
		end
	end
	return nil;
end


KBT.bingusCooldown = false
function KBT.AutoEmote:HandleEmote(...)
	local emoteText, playerName, _, _, _, _, _, _, _, _, _, GUID, _ = ...;
	local emote = self:IdentifyEmote(emoteText);

	if not emote or playerName == KBT.GetNormalizedPlayerName() or playerName == KBT.GetNormalizedPlayerName(true) then
		return;
	end

	local responseEmote = self:GetResponseEmote(emote);

	if emote == self:GetTrackedEmote() then
		local success = self:TRPUpdateCurrently(playerName);
		if success then
			self:IncrementCounter();
			self:SetLastEmoted(playerName);
		else
			Print("Failed to update TRP3 currently.");
		end
	end
	C_Timer.After(0, function()
		
		if KBT.bingusCooldown == false then
			DoEmote(responseEmote, playerName);
			KBT.bingusCooldown = true
			C_Timer.After(5, function()
				KBT.bingusCooldown = false
			end)
		end
	end)
end