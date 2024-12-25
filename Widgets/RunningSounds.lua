local SoundFilesChain = {
	-- Chain (mail)
	567585, 567587, 567590, 567592, 567593,
	567594, 567597, 567600, 567603, 567605,

};

local SoundFilesPlate = {
	-- Plate
	567578, 567579, 567581, 567582, 567583,
	567584, 567588, 567589, 567595, 567596,
};

local SoundFilesLeather = {
	-- Leather
	567580, 567586, 567591, 567598, 567599,
	567601, 567602, 567604, 567606, 567607,
};

local ArmorType = {
	PLATE = {1, 2, 6},
	MAIL = {3, 7, 13},
	LEATHER = {4, 10, 11, 12},
	CLOTH = {5, 8, 9},
};

local function SoundSelector()
	local PlayerArmorType
	for k, v in pairs(ArmorType) do
		for key, val in pairs(v) do
			if select(3, UnitClass("player")) == val then
				PlayerArmorType = k;
			end
		end
	end
	if PlayerArmorType == "PLATE" then
		--local number = math.random(1,#SoundFilesPlate);
		--PlaySoundFile(SoundFilesPlate[number], "SFX");

		local number = math.random(1,#SoundFilesChain);
		PlaySoundFile(SoundFilesChain[number], "SFX");

	elseif PlayerArmorType == "MAIL" then
		local number = math.random(1,#SoundFilesChain);
		PlaySoundFile(SoundFilesChain[number], "SFX");
	elseif PlayerArmorType == "LEATHER" then
		local number = math.random(1,#SoundFilesLeather);
		PlaySoundFile(SoundFilesLeather[number], "SFX");
	end
end

local function FallingChecker()
	local currentMoving = IsPlayerMoving();
	local isFalling = IsFalling();
	local isMounted = IsMounted();
	if not isFalling and not currentMoving and not isMounted then
		SoundSelector();
	end
end

local function CheckPlayerMovement()
	local currentMoving = IsPlayerMoving();
	local isFalling = IsFalling();
	local isMounted = IsMounted();
	if isFalling then
		C_Timer.After(.35, FallingChecker);
	end
	if currentMoving and not isFalling and not isMounted then
		SoundSelector();
	end
end

C_Timer.NewTicker(0.35, CheckPlayerMovement);