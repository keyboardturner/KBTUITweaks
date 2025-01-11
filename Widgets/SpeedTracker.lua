-- Create a frame for our addon
local SpeedTrackerFrame = CreateFrame("Frame", "SpeedTrackerFrame", UIParent)

-- Create a font string to display the speed
local SpeedText = SpeedTrackerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
SpeedText:SetPoint("CENTER", UIParent, "CENTER", 0, 0) -- Center of the screen
SpeedText:SetText("Speed: 0.00")

-- Variables to track player's previous position and speed
local lastX, lastY, lastZ, lastTime = nil, nil, nil, nil

-- Update function, called every 0.1 seconds
local function UpdateSpeed(self, elapsed)
    -- Get the player's current position
    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then return end

    local position = C_Map.GetPlayerMapPosition(mapID, "player")
    if not position then return end

    local x, y = position:GetXY()
    local z = UnitPosition("player")
    local timeNow = GetTime()

    -- If we have previous coordinates, calculate the distance and speed
    if lastX and lastY and lastZ and lastTime then
        local dx = x - lastX
        local dy = y - lastY
        local dz = z - lastZ
        local dt = timeNow - lastTime

        local distance = math.sqrt(dx * dx + dy * dy + dz * dz) -- Calculate distance
        local speed = distance / dt -- Speed = distance / time

        -- Update the speed display
        SpeedText:SetText(string.format("Speed: %.2f", speed))
    end

    -- Update the last position and time
    lastX, lastY, lastZ, lastTime = x, y, z, timeNow
end

-- Set up the frame to run the update function every 0.1 seconds
SpeedTrackerFrame:SetScript("OnUpdate", UpdateSpeed)
