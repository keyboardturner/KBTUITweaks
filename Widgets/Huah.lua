local huah = CreateFrame("Frame", nil, UIParent)
huah:SetPoint("CENTER")
huah:SetSize(512, 512)

function huah.func()
	PlaySoundFile(540727, "SFX")
end

SLASH_HUAH1 = "/huah"
SlashCmdList["HUAH"] = function(msg)
	huah.func();
end

huah.EventsList = {
	"CHAT_MSG_SAY",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_YELL",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY_LEADER",
};

huah.huahVariants = {
	"huah",
	"hua",
	"hooah",
	"hooa",
};

for k, v in pairs(huah.EventsList) do
	huah:RegisterEvent(v)
end

function huah:event(event, arg1)
	arg1 = string.lower(arg1)
	for k, v in pairs(huah.huahVariants) do
		if string.find(arg1, v) then
			huah.func();
		end
	end
end


huah:SetScript("OnEvent", huah.event)