-- Using Blizz's globally accessible frame fade function causes taint with the map
-- So just add their own code in locally

local FrameFaderDriver;
local fadingFrames;
local deferredFadingFrames;

local function OnUpdate(self, elapsed)
	local isMoving = IsPlayerMoving();
	for frame, setting in pairs(fadingFrames) do
		local fadeOut = isMoving and (not setting.fadePredicate or setting.fadePredicate());
		frame:SetAlpha(DeltaLerp(frame:GetAlpha(), fadeOut and setting.minAlpha or setting.maxAlpha, .1, elapsed));
	end
end

local function MergeDeferredEvents()
	if deferredFadingFrames then
		for frame, setting in pairs(deferredFadingFrames) do
			fadingFrames[frame] = setting;
		end
		deferredFadingFrames = nil;
	end
end

local function OnEvent(self, event, ...)
	if event == "PLAYER_STARTED_MOVING" 
	or event == "PLAYER_STOPPED_MOVING" 
	or event == "PLAYER_IS_GLIDING_CHANGED" 
	or event == "PLAYER_IMPULSE_APPLIED" then
		MergeDeferredEvents();
	end
end

local function InitializeDriver()
	if not FrameFaderDriver then
		fadingFrames = {};

		FrameFaderDriver = CreateFrame("FRAME");
		FrameFaderDriver:SetScript("OnUpdate", OnUpdate);
		FrameFaderDriver:SetScript("OnEvent", OnEvent);
		FrameFaderDriver:RegisterEvent("PLAYER_STARTED_MOVING");
		FrameFaderDriver:RegisterEvent("PLAYER_STOPPED_MOVING");
		FrameFaderDriver:RegisterEvent("PLAYER_IS_GLIDING_CHANGED");
		FrameFaderDriver:RegisterEvent("PLAYER_IMPULSE_APPLIED");
	end
end

local function PackFadeData(minAlpha, maxAlpha, durationSec, fadePredicate)
	return { minAlpha = minAlpha or .5, maxAlpha = maxAlpha or 1, durationSec = durationSec or 1, fadePredicate = fadePredicate };
end

local function RemoveFrameInternal(frame)
	if fadingFrames then
		fadingFrames[frame] = nil;
	end
	if deferredFadingFrames then
		deferredFadingFrames[frame] = nil;
	end
end

local PlayerMovementFrameFader = {};

function PlayerMovementFrameFader.AddFrame(frame, minAlpha, maxAlpha, durationSec, fadePredicate)
	RemoveFrameInternal(frame);

	InitializeDriver();
	fadingFrames[frame] = PackFadeData(minAlpha, maxAlpha, durationSec, fadePredicate);
end

-- The fading won't take effect until the player stops or starts moving again
function PlayerMovementFrameFader.AddDeferredFrame(frame, minAlpha, maxAlpha, durationSec, fadePredicate)
	InitializeDriver();
	RemoveFrameInternal(frame);

	if not deferredFadingFrames then
		deferredFadingFrames = {};
	end
	deferredFadingFrames[frame] = PackFadeData(minAlpha, maxAlpha, durationSec, fadePredicate);
end

function PlayerMovementFrameFader.RemoveFrame(frame)
	local maxAlpha = fadingFrames and fadingFrames[frame] and fadingFrames[frame].maxAlpha;
	if maxAlpha then
		frame:SetAlpha(maxAlpha);
	end

	RemoveFrameInternal(frame, restoreAlpha);
end

local function SetupFade(self)
	local minAlpha = 0.5;
	local maxAlpha = 1.0;
	local duration = 0.5;
	local predicate = function() return not self:IsMouseOver(); end;
	PlayerMovementFrameFader.AddDeferredFrame(self, minAlpha, maxAlpha, duration, predicate);
end

local function CleanupFade(self)
	PlayerMovementFrameFader.RemoveFrame(self);
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

local function initialize(self, event, arg1)
	if (event == "ADDON_LOADED" and arg1 == "KBTUITweaks") then
		if C_AddOns.IsAddOnLoaded("TotalRP3") then
			TRP3_MainFrame:HookScript("OnShow", SetupFade);
			TRP3_MainFrame:HookScript("OnHide", CleanupFade);
		end
	end
	if AchievementFrame then
		AchievementFrame:HookScript("OnShow", SetupFade);
		AchievementFrame:HookScript("OnHide", CleanupFade);
	end
	if ProfessionsFrame then
		ProfessionsFrame:HookScript("OnShow", SetupFade);
		ProfessionsFrame:HookScript("OnHide", CleanupFade);
	end
end

frame:SetScript("OnEvent", initialize)

