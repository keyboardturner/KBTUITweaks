SlashCmdList.ECHO = function(msg)
	SendChatMessage(msg, "WHISPER", nil, UnitNameUnmodified("player"))
end
SLASH_ECHO1 = "/echo"

SlashCmdList.PRINT = function(msg)
	local result, errorMessage = loadstring("return " .. msg)

	if result then
		local success, value = pcall(result)
		if success and value then
			print(value)
		elseif value == nil then
			print(msg)
		end
	else
		print("Error parsing expression:", errorMessage)
	end
end
SLASH_PRINT1 = "/print"

