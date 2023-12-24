local yeehaw = CreateFrame("Frame")

yeehaw:RegisterEvent("QUEST_SESSION_CREATED")

local function Cowboy()
	QuestSessionManager.StartDialog:Confirm()
end

yeehaw:SetScript("OnEvent", Cowboy)