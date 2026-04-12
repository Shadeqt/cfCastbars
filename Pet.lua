local bar
local K = cfCastbars.K

function cfCastbars.ApplyPetSettings()
	local db = cfCastbarsDB
	local hp = PetFrameHealthBar
	local baseW, baseH = hp:GetWidth(), hp:GetHeight()

	if not bar then
		bar = cfCastbars.CreateCastbar(UIParent, "pet", baseW, baseH)
		cfCastbars.petBar = bar
	end

	-- Bar
	local w = baseW + db[K.PetWidth]
	local h = baseH + db[K.PetHeight]
	bar:SetScale(db[K.PetScale])
	bar:SetSize(w, h)
	bar:ClearAllPoints()
	bar:SetPoint("TOP", PetFrame, "BOTTOM", 15 + db[K.PetX], db[K.PetY])
	cfCastbars.ApplyBarSettings(bar, "Target", "Pet")
end

function cfCastbars.UpdatePet()
	cfCastbars.ApplyPetSettings()

	-- Enabled
	local db = cfCastbarsDB
	if not db[K.Pet] then
		CastingBarFrame_SetUnit(bar, nil)
		bar:Hide()
	elseif UnitExists("pet") then
		CastingBarFrame_SetUnit(bar, "pet")
	elseif bar.cbtTestStart then
		bar:Show()
	end
end

function cfCastbars.InitPet()
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("UNIT_PET")
	f:SetScript("OnEvent", function(_, event, unit)
		if event == "UNIT_PET" and unit ~= "player" then return end
		if not PetFrame or not UnitExists("pet") then
			if bar then CastingBarFrame_SetUnit(bar, nil) end
			return
		end
		cfCastbars.UpdatePet()
	end)
end
