local bar
local K = cfCastbars.K

function cfCastbars.UpdatePet()
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
	bar.Spark:SetSize(h * 3.2, h * 3.2)
	bar.Border:SetSize(196 * (w / 150), 49 * (h / 10))

	-- Icon
	if db[K.PetIcon] then
		bar.Icon:Show()
		bar.Icon:SetScale(db[K.PetIconScale])
		bar.Icon:ClearAllPoints()
		bar.Icon:SetPoint("RIGHT", bar, "LEFT", -5 + db[K.PetIconX], db[K.PetIconY])
	else
		bar.Icon:Hide()
	end

	-- Timer
	if db[K.PetTimer] then
		bar.Timer:Show()
		bar.Timer:SetScale(db[K.PetTimerScale])
		bar.Timer:ClearAllPoints()
		bar.Timer:SetPoint("LEFT", bar, "RIGHT", 5 + db[K.PetTimerX], db[K.PetTimerY])
	else
		bar.Timer:Hide()
	end

	-- Text
	if db[K.PetText] then
		bar.Text:Show()
		bar.Text:SetScale(db[K.PetTextScale])
		bar.Text:ClearAllPoints()
		bar.Text:SetPoint("CENTER", bar, "CENTER", db[K.PetTextX], db[K.PetTextY])
	else
		bar.Text:Hide()
	end

	-- Border
	bar.Border:SetShown(db[K.PetBorder])

	-- Enabled
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
