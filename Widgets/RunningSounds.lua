local SoundFilesChain = {	-- SoundKit ID 1005, but is MUTED
	-- Chain (mail)
	567585, 567587, 567590, 567592, 567593,
	567594, 567597, 567600, 567603, 567605,

};

local SoundFilesPlate = {	-- SoundKit ID 1004, but is MUTED
	-- Plate
	567578, 567579, 567581, 567582, 567583,
	567584, 567588, 567589, 567595, 567596,
};

local SoundFilesLeather = {	-- SoundKit ID 1003, but is MUTED
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
	local unitSpeed = select(1, GetUnitSpeed("player"));
	local speedMult = 1
	local speedFrequency = 7	 -- 7 is base run speed. this will make sounds occur more often the faster you are
	local scalingFactor = .3
	local offset = 0.7
	local multMin = .85 -- mount speed value
	local multMax = 1.54 -- walk speed value
	local basicMult = .37 -- (1.5 - 2 is "vanilla" frequency )

	if unitSpeed and unitSpeed ~= 0 then
		speedMult = (speedFrequency / unitSpeed) * scalingFactor + offset;
		if speedMult < multMin then
			speedMult = multMin
		end
		if speedMult > multMax then
			speedMult = multMax
		end
	end
	--print(basicMult*speedMult, speedMult)

	local currentMoving = IsPlayerMoving();
	local isFalling = IsFalling();
	local isMounted = IsMounted();
	if isFalling then
		C_Timer.After(.35, FallingChecker);
	end
	if currentMoving and not isFalling and not isMounted then
		SoundSelector();
	end
	C_Timer.After(basicMult*speedMult, CheckPlayerMovement);
end

CheckPlayerMovement();