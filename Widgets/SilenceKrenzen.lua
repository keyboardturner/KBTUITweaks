-- Create a frame to handle events
local frame = CreateFrame("Frame")

-- Set the coordinates for the restricted area
local restrictedArea = {
	minX = 852.40+7, -- Replace with your desired minimum X coordinate
	minY = -8958.90-7, -- Replace with your desired minimum Y coordinate
	maxX = 852.40-7, -- Replace with your desired maximum X coordinate
	maxY = -8958.90+7, -- Replace with your desired maximum Y coordinate
}

-- Register events to listen for
frame:RegisterEvent("CHAT_MSG_MONSTER_SAY")
frame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

local function chatfilter(self, event, message, sender, ...)
	-- Check if the player is outside the restricted area
	local playerY, playerX = UnitPosition("player")
	local mapID = C_Map.GetBestMapForUnit("player")

	if mapID == 84 then
		if (playerY > restrictedArea.minY and playerY < restrictedArea.maxY) and
			(playerX < restrictedArea.minX and playerX > restrictedArea.maxX) then
				return false
			else
			-- Process NPC messages only when outside the restricted area
			if sender and (sender == "Blue" or sender == "Krenzen") then
				--print("message filter success")
				return true
			end
		end
	end
end

-- Set up event handler function
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_SAY", chatfilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_EMOTE", chatfilter)