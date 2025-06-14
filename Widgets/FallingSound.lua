local f = CreateFrame("Frame")
local isFalling = false
local SOUND_PATH = "Interface\\AddOns\\KBTUITweaks\\Assets\\Sound\\AltitudeLoop.ogg"
local SOUND_CHANNEL = "SFX"
local soundHandle = nil


local function StartFallingSound()
	if not soundHandle then
		-- Create a new sound handle
		local willPlay, handle = PlaySoundFile(SOUND_PATH, SOUND_CHANNEL)
		if willPlay then
			soundHandle = handle
		end
	end
end

local function StopFallingSound()
	if soundHandle then
		StopSound(soundHandle, 100)
		soundHandle = nil
	end
end

f:SetScript("OnUpdate", function(self, elapsed)
	local falling = IsFalling()

	if falling and not isFalling then
		isFalling = true
		StartFallingSound()
	elseif not falling and isFalling then
		isFalling = false
		StopFallingSound()
	end
end)
