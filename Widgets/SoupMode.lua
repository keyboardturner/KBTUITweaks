local soupMode = CreateFrame("Frame", nil, UIParent)
soupMode:SetPoint("CENTER")
soupMode:SetSize(512, 512)

soupMode.Tex = soupMode:CreateTexture()
soupMode.Tex:SetAllPoints(soupMode)
soupMode.Tex:SetTexture("Interface\\AddOns\\KBTUITweaks\\Assets\\soupmode")
soupMode:Hide()

local yesChef = CreateFrame("Frame", nil, UIParent)
yesChef:SetPoint("CENTER", 200, 200)
yesChef:SetSize(512/2, 256/2)

yesChef.Tex = yesChef:CreateTexture()
yesChef.Tex:SetAllPoints(yesChef)
yesChef.Tex:SetTexture("Interface\\AddOns\\KBTUITweaks\\Assets\\yeschef")
yesChef:Hide()

local tucker = CreateFrame("Frame", nil, UIParent)
tucker:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -10)
tucker:SetSize(498, 368)

tucker.Tex = tucker:CreateTexture()
tucker.Tex:SetAllPoints(tucker)
tucker.Tex:SetTexture("Interface\\AddOns\\KBTUITweaks\\Assets\\tucker.png")
tucker:Hide()

local cinema = CreateFrame("Frame", nil, UIParent)
cinema:SetPoint("CENTER")
cinema:SetSize(1920, 1080)

cinema.Tex = cinema:CreateTexture()
cinema.Tex:SetAllPoints(cinema)
cinema.Tex:SetTexture("Interface\\AddOns\\KBTUITweaks\\Assets\\cinema.jpg")
cinema:Hide()

function soupMode.func()
	soupMode:Show()
	UIFrameFadeOut(soupMode, 2, 1, 0)
	C_Timer.After(2.1, function() if soupMode:GetAlpha() == 0 then soupMode:Hide() end end)
end

function yesChef.func()
	yesChef:Show()
	UIFrameFadeOut(yesChef, 2, 1, 0)
	C_Timer.After(2.1, function() if yesChef:GetAlpha() == 0 then yesChef:Hide() end end)
end

function tucker.func()
	tucker:Show()
	UIFrameFadeOut(tucker, 2, 1, 0)
	C_Timer.After(2.1, function() if tucker:GetAlpha() == 0 then tucker:Hide() end end)
end

function cinema.func()
	cinema:Show()
	UIFrameFadeOut(cinema, 2, 1, 0)
	C_Timer.After(2.1, function() if cinema:GetAlpha() == 0 then cinema:Hide() end end)
end

SLASH_SOUPMODE1 = "/soupmode"
SlashCmdList["SOUPMODE"] = function(msg)
	soupMode.func();
end

SLASH_YESCHEF1 = "/yeschef"
SlashCmdList["YESCHEF"] = function(msg)
	yesChef.func();
end

SLASH_TUCKER1 = "/tucker"
SlashCmdList["TUCKER"] = function(msg)
	tucker.func()
end

SLASH_CINEMA1 = "/cinema"
SlashCmdList["CINEMA"] = function(msg)
	cinema.func()
end

soupMode.EventsList = {
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

soupMode.soupVariants = {
	"soup",
	"soop",
	"community feast",
	"iskaara feast",
};

yesChef.chefVariants = {
	"yes chef",
	"yes, chef",
	"yeschef",
};

tucker.tuckerVariants = {
	"tucker",
	"carlson"
};

cinema.cinemaVariants = {
	"cinema",
};

for k, v in pairs(soupMode.EventsList) do
	soupMode:RegisterEvent(v)
end

function soupMode:event(event, arg1)
	arg1 = string.lower(arg1)
	for k, v in pairs(soupMode.soupVariants) do
		if string.find(arg1, v) then
			soupMode.func();
		end
	end

	for k, v in pairs(yesChef.chefVariants) do
		if string.find(arg1, v) then
			yesChef.func();
		end
	end

	for k, v in pairs(tucker.tuckerVariants) do
		if string.find(arg1, v) then
			tucker.func();
		end
	end

	for k, v in pairs(cinema.cinemaVariants) do
		if string.find(arg1, v) then
			cinema.func();
		end
	end
end


soupMode:SetScript("OnEvent", soupMode.event)