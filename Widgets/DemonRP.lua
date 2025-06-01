local DRP = CreateFrame("Frame");

function DRP.GetWarlockMinionType()
	local petUnit = "pet"
	local hasUI, isHunterPet = HasPetUI()
	local petName = UnitName("pet")
	if hasUI then
		if isHunterPet then
			return
		else
			if UnitExists(petUnit) then
				local petFamily = UnitCreatureFamily(petUnit)
				if petFamily then
					--print(petName.." is a " .. petFamily .. ".")
					return petFamily, petName
				else
					--print("Unable to determine the type of your warlock minion.")
					return nil
				end
			else
				--print("You do not have a minion summoned.")
				return nil
			end
		end
	end
end

DRP.FelguardQuotes = {
	Combat = {
		[1] = {
			["text"] = "Crush them all!",
			["channel"] = "MONSTER_SAY",
		},
		[2] = {
			["text"] = "Your end is near!",
			["channel"] = "MONSTER_SAY",
		},
		[3] = {
			["text"] = "Feel the wrath of my blade!",
			["channel"] = "MONSTER_SAY",
		},
		[4] = {
			["text"] = "I will tear you apart!",
			["channel"] = "MONSTER_SAY",
		},
		[5] = {
			["text"] = "You cannot escape your fate!",
			["channel"] = "MONSTER_SAY",
		},
		[6] = {
			["text"] = "Your soul will burn!",
			["channel"] = "MONSTER_SAY",
		},
		[7] = {
			["text"] = "Do you fear the darkness? Because I do.",
			["channel"] = "MONSTER_SAY",
		},
		[8] = {
			["text"] = "My blade thirsts for blood.",
			["channel"] = "MONSTER_SAY",
		},
		[9] = {
			["text"] = "...",
			["channel"] = "MONSTER_SAY",
		},
	},
	Idle = {
		[1] = {
			["text"] = "Why did the imp cross the road? I threw him.",
			["channel"] = "MONSTER_SAY",
		},
		[2] = {
			["text"] = "Why did the Felguard bring a ladder to battle? To reach new heights of destruction!",
			["channel"] = "MONSTER_SAY",
		},
		[3] = {
			["text"] = "Why do Felguards never get lost? Who knows.",
			["channel"] = "MONSTER_SAY",
		},
		[4] = {
			["text"] = "What’s a Felguard’s favorite music genre? Who knows.",
			["channel"] = "MONSTER_SAY",
		},
		[5] = {
			["text"] = "Why don’t Felguards ever get invited to parties? Who knows.",
			["channel"] = "MONSTER_SAY",
		},
		[6] = {
			["text"] = "How do Felguards stay in shape? By doing heavy lifting… with their enemies!",
			["channel"] = "MONSTER_SAY",
		},
		[7] = {
			["text"] = "What did the Felguard say when he joined the choir? Who knows.",
			["channel"] = "MONSTER_SAY",
		},
		[8] = {
			["text"] = "Why did the Felguard start a gardening club? Who knows.",
			["channel"] = "MONSTER_SAY",
		},
		[9] = {
			["text"] = "Why do Felguards make terrible detectives? Who knows.",
			["channel"] = "MONSTER_SAY",
		},
		[10] = {
			["text"] = "What if all my jokes were just really bad and underwhelming? That sure would be something, huh.",
			["channel"] = "MONSTER_SAY",
		},
		[11] = {
			["text"] = "You ever think about how we don't really ever expose our faces? Like every one of us of the felguard kind wear helmets. I mean we're also mo'arg, some of those guys don't wear helmets, and they're usually bald.",
			["channel"] = "MONSTER_SAY",
		},
		[12] = {
			["text"] = "It would be pretty neat if I got my own giant axe and I could stand idle with it holding it in one place, kind of like what you see the Fel Lords do.",
			["channel"] = "MONSTER_SAY",
		},
		[13] = {
			["text"] = "You know, 'Erak' is a common name among the mo'arg.",
			["channel"] = "MONSTER_SAY",
		},
	},
	Summon = {
		[1] = {
			["text"] = "You summon, I obey… for now.",
			["channel"] = "MONSTER_SAY",
		},
		[2] = {
			["text"] = "From the nether I rise, ready to destroy!",
			["channel"] = "MONSTER_SAY",
		},
		[3] = {
			["text"] = "Another pact, another slaughter.",
			["channel"] = "MONSTER_SAY",
		},
	},
};

DRP.ImpQuotes = {
	Combat = {
		[1] = {
			["text"] = "Is this REALLY necessary?!",
			["channel"] = "MONSTER_SAY",
		},
		[2] = {
			["text"] = "This was NOT in my contract!",
			["channel"] = "MONSTER_SAY",
		},
		[3] = {
			["text"] = "Can't we all just get along?",
			["channel"] = "MONSTER_SAY",
		},
		[4] = {
			["text"] = "Ohhhh sure, send the little guy!",
			["channel"] = "MONSTER_SAY",
		},
		[5] = {
			["text"] = "What's in it for me?",
			["channel"] = "MONSTER_SAY",
		},
		[6] = {
			["text"] = "Do I have to?!",
			["channel"] = "MONSTER_SAY",
		},
		[7] = {
			["text"] = "Ahh! Okay, okay, okay, okay, okay, okay!",
			["channel"] = "MONSTER_SAY",
		},
		[8] = {
			["text"] = "Yeah, I'll get right on it.",
			["channel"] = "MONSTER_SAY",
		},
		[9] = {
			["text"] = "What? You mean you can't kill this one by yourself?",
			["channel"] = "MONSTER_SAY",
		},
		[10] = {
			["text"] = "Make yourself useful and help me out on this one!",
			["channel"] = "MONSTER_SAY",
		},
		[11] = {
			["text"] = "Release me already, I've had enough!",
			["channel"] = "MONSTER_SAY",
		},
		[12] = {
			["text"] = "Alright, I'm on it! Stop yelling!",
			["channel"] = "MONSTER_SAY",
		},
		[13] = {
			["text"] = "No shi rakir no tiros kamil re lok ante refir shi rakir.",
			["channel"] = "MONSTER_SAY",
		},
		[14] = {
			["text"] = "Maz ruk X rikk xi laz enkil parn zila zilthuras karkun thorje kar x zennshi.",
			["channel"] = "MONSTER_SAY",
		},
		[15] = {
			["text"] = "Uh, 'scuse me, don't talk to me like I'm one of those PATHETIC CREATURES YOU HAD WHEN YOU STARTED OUT!",
			["channel"] = "MONSTER_SAY",
		},
		[16] = {
			["text"] = "What are you thinkin'?",
			["channel"] = "MONSTER_SAY",
		},
		[17] = {
			["text"] = "This is why we get along.",
			["channel"] = "MONSTER_SAY",
		},
		[18] = {
			["text"] = "Yeah! It's fighting time!",
			["channel"] = "MONSTER_SAY",
		},
		[19] = {
			["text"] = "It's burnin' time!",
			["channel"] = "MONSTER_SAY",
		},
		[20] = {
			["text"] = "Let's heat things up!",
			["channel"] = "MONSTER_SAY",
		},
		[21] = {
			["text"] = "Yeah... I'll be right behind you.",
			["channel"] = "MONSTER_SAY",
		},
		[22] = {
			["text"] = "Yeah yeah... I'll clean up your mess.",
			["channel"] = "MONSTER_SAY",
		},
	},
	Idle = {
		[1] = {
			["text"] = "Bingle.",
			["channel"] = "MONSTER_SAY",
		},
		[2] = {
			["text"] = "Bingle.",
			["channel"] = "MONSTER_SAY",
		},
		[3] = {
			["text"] = "Bingle.",
			["channel"] = "MONSTER_SAY",
		},
		[4] = {
			["text"] = "Bingle.",
			["channel"] = "MONSTER_SAY",
		},
		[5] = {
			["text"] = "Bingle.",
			["channel"] = "MONSTER_SAY",
		},
		[6] = {
			["text"] = "Bingle.",
			["channel"] = "MONSTER_SAY",
		},
		[7] = {
			["text"] = "Bingle.",
			["channel"] = "MONSTER_SAY",
		},
		[8] = {
			["text"] = "Bingle.",
			["channel"] = "MONSTER_SAY",
		},
		[9] = {
			["text"] = "Bingle.",
			["channel"] = "MONSTER_SAY",
		},
	},
	Dismiss = {
		[1] = {
			["text"] = "Bingle.",
			["channel"] = "MONSTER_SAY",
		},
	},
	Summon = {
		[1] = {
			["text"] = "Bingle.",
			["channel"] = "MONSTER_SAY",
		},
	},
};

local isOnCooldown = {
	combat = false,
	idle = false,
};
function DRP.cooldownTimerCombat()
	local cooldownThing = math.random(120,360); -- 15-30 mins would probably be ideal, will see.
	C_Timer.After(cooldownThing, function() isOnCooldown.combat = false; isOnCooldown.idle = false; end);
end;
function DRP.cooldownTimerIdle()
	local cooldownThing = math.random(300,900); -- 15-30 mins would probably be ideal, will see.
	C_Timer.After(cooldownThing, function() isOnCooldown.combat = false; isOnCooldown.idle = false; end);
end;

function DRP.petSpeak(petFamily, petName)
	if DRP[petFamily.."Quotes"] == nil then
		return
	end
	local timeStamps = date(C_CVar.GetCVar("showTimestamps"))
	local rng = 1
	if timeStamps == "none" or nil then
		timeStamps = ""
	end
	local msg = "..."
	local sender = petName
	local info = ChatTypeInfo["MONSTER_SAY"]
	if UnitAffectingCombat("player") == true then
		rng = math.random(1, #DRP[petFamily.."Quotes"].Combat)
		msg = DRP[petFamily.."Quotes"].Combat[rng]["text"]
		info = ChatTypeInfo[DRP[petFamily.."Quotes"].Combat[rng]["channel"]]
	elseif UnitAffectingCombat("player") == false then
		rng = math.random(1, #DRP[petFamily.."Quotes"].Idle)
		msg = DRP[petFamily.."Quotes"].Idle[rng]["text"]
		info = ChatTypeInfo[DRP[petFamily.."Quotes"].Idle[rng]["channel"]]
	end
	local body = CHAT_SAY_GET:format(sender) .. msg
	--local info = ChatTypeInfo["MONSTER_WHISPER"]
	--local body = CHAT_WHISPER_GET:format(sender) .. msg
	
	return DEFAULT_CHAT_FRAME:AddMessage(timeStamps .. body, info.r, info.g, info.b, info.id)
end;

local function CombatRPTalk()
	if isOnCooldown.combat == true then
		return
	end
	local petFamily, petName = DRP.GetWarlockMinionType()
	if petFamily == "Felguard" or petFamily == "Imp" then
		DRP.petSpeak(petFamily,petName)
	end
	isOnCooldown.combat = true
	DRP.cooldownTimerCombat()
end;

local function IdleRPTalk()
	if isOnCooldown.idle == true then
		return
	end
	local petFamily, petName = DRP.GetWarlockMinionType()
	if petFamily == "Felguard" or petFamily == "Imp" then
		DRP.petSpeak(petFamily,petName)
	end
	isOnCooldown.idle = true
	DRP.cooldownTimerIdle()
end

function DRP.repeatingTimer()
	C_Timer.After(10, DRP.repeatingTimer);
	if UnitAffectingCombat("player") == true then
		return
	end
	IdleRPTalk()
end;
DRP.repeatingTimer()

DRP:RegisterEvent("PLAYER_REGEN_DISABLED");
--"PET_DISMISS_START"
--"UNIT_PET" arg1 = "player"

DRP:SetScript("OnEvent", CombatRPTalk);