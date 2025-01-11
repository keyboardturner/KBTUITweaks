local SpeedTrackerFrame = CreateFrame("Frame", nil, UIParent)

local SpeedText = SpeedTrackerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
SpeedText:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
SpeedText:SetText("Speed: 0.00")

local lastX, lastY, lastZ, lastTime = nil, nil, nil, nil

local function UpdateSpeed(self, elapsed)
	local mapID = C_Map.GetBestMapForUnit("player")
	if not mapID then return end

	local position = C_Map.GetPlayerMapPosition(mapID, "player")
	if not position then return end

	local x, y, z = UnitPosition("player")
	local timeNow = GetTime()

	if lastX and lastY and lastZ and lastTime then
		local dx = x - lastX
		local dy = y - lastY
		local dz = z - lastZ
		local dt = timeNow - lastTime

		local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
		local speed = distance / dt

		SpeedText:SetText(string.format("Speed: %.2f", speed))
	end

	lastX, lastY, lastZ, lastTime = x, y, z, timeNow
end

C_Timer.NewTicker(.1, UpdateSpeed)