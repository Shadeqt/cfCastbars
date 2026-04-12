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
	local T = cfCastbars.BlizzCastbars.Target
	bar.Spark:SetSize(T.sparkSize * (h / T.barH), T.sparkSize * (h / T.barH))
	bar.Border:SetSize(T.borderW * (w / T.barW), T.borderH * (h / T.barH))
	local s = w / baseW
	bar.BorderShield:SetSize(T.borderW * (w / T.barW) + 2 * s, T.borderH * (h / T.barH))
	bar.BorderShield:SetPoint("CENTER", -2 * s, 0)

	-- Icon
	if db[K.PetIcon] then
		bar.Icon:Show()
		bar.Icon:SetSize(w * 0.15, h * 1.6)
		bar.Icon:SetScale(db[K.PetIconScale])
		bar.Icon:ClearAllPoints()
		bar.Icon:SetPoint("RIGHT", bar, "LEFT", -1 + db[K.PetIconX], 1 + db[K.PetIconY])
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

	-- Spark / Flash / Border / Shield
	bar.Spark:SetShown(db[K.PetSpark])
	bar.Flash:SetShown(db[K.PetFlash])
	if db[K.PetBorderShield] then
		bar.BorderShield:Show()
		bar.Border:Hide()
	else
		bar.BorderShield:Hide()
		bar.Border:SetShown(db[K.PetBorder])
	end
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
