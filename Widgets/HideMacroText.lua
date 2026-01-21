local actionBarMappings = {
	"Action",
	"MultiBarBottomLeft",
	"MultiBarBottomRight",
	"MultiBarRight",
	"MultiBarLeft",
	"MultiBar5",
	"MultiBar6",
	"MultiBar7",
};

local function setButtonNamesAlpha(alpha)
	for i = 1, #actionBarMappings do
		for btn = 1,12 do
			_G[actionBarMappings[i].."Button"..btn.."Name"]:SetAlpha(alpha)
		end
	end
end

setButtonNamesAlpha(0)

SLASH_HideMacroName1 = "/hmn"
SlashCmdList["HideMacroName"] = function() 
	setButtonNamesAlpha(0)
end

SLASH_ShowMacroName1 = "/smn"
SlashCmdList["ShowMacroName"] = function() 
	setButtonNamesAlpha(1)
end