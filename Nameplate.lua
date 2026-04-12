cfCastbars.nameplateBars = {}
local bars = cfCastbars.nameplateBars
local K = cfCastbars.K

local function CreateNameplateCastbar(unitFrame, unit)
	local hp = unitFrame.healthBar
	local bar = cfCastbars.CreateCastbar(unitFrame, unit, hp:GetWidth(), hp:GetHeight())
	bar:SetPoint("TOP", hp, "BOTTOM", 0, -5)
	bars[unit] = bar
	return bar
end

function cfCastbars.ApplyNameplateSettings(bar)
	local db = cfCastbarsDB
	local hp = bar:GetParent().healthBar
	local baseW, baseH = hp:GetWidth(), hp:GetHeight()
	local w = baseW + db[K.NameplateWidth]
	local h = baseH + db[K.NameplateHeight]
	bar:SetScale(db[K.NameplateScale])
	bar:SetSize(w, h)
	local T = cfCastbars.BlizzCastbars.Target
	bar.Spark:SetSize(T.sparkSize * (h / T.barH), T.sparkSize * (h / T.barH))
	bar.Border:SetSize(T.borderW * (w / T.barW), T.borderH * (h / T.barH))
	local s = w / baseW
	bar.BorderShield:SetSize(T.borderW * (w / T.barW) + 4 * s, T.borderH * (h / T.barH))
	bar.BorderShield:SetPoint("CENTER", -3 * s, 0)

	-- Position
	bar:ClearAllPoints()
	bar:SetPoint("TOP", hp, "BOTTOM", db[K.NameplateX], -5 + db[K.NameplateY])

	-- Icon
	if db[K.NameplateIcon] then
		bar.Icon:Show()
		bar.Icon:SetSize(w * 0.15, h * 1.6)
		bar.Icon:SetScale(db[K.NameplateIconScale])
		bar.Icon:ClearAllPoints()
		bar.Icon:SetPoint("RIGHT", bar, "LEFT", -2 + db[K.NameplateIconX], 1 + db[K.NameplateIconY])
	else
		bar.Icon:Hide()
	end

	-- Timer
	if db[K.NameplateTimer] then
		bar.Timer:Show()
		bar.Timer:SetScale(db[K.NameplateTimerScale])
		bar.Timer:ClearAllPoints()
		bar.Timer:SetPoint("LEFT", bar, "RIGHT", 5 + db[K.NameplateTimerX], db[K.NameplateTimerY])
	else
		bar.Timer:Hide()
	end

	-- Text
	if db[K.NameplateText] then
		bar.Text:Show()
		bar.Text:SetScale(db[K.NameplateTextScale])
		bar.Text:ClearAllPoints()
		bar.Text:SetPoint("CENTER", bar, "CENTER", db[K.NameplateTextX], db[K.NameplateTextY])
	else
		bar.Text:Hide()
	end

	-- Spark / Flash / Border / Shield
	bar.Spark:SetShown(db[K.NameplateSpark])
	bar.Flash:SetShown(db[K.NameplateFlash])
	if db[K.NameplateBorderShield] then
		bar.BorderShield:Show()
		bar.Border:Hide()
	else
		bar.BorderShield:Hide()
		bar.Border:SetShown(db[K.NameplateBorder])
	end
end

function cfCastbars.UpdateNameplate()
	local db = cfCastbarsDB
	for _, bar in pairs(bars) do
		cfCastbars.ApplyNameplateSettings(bar)
		if not db[K.Nameplate] then
			CastingBarFrame_SetUnit(bar, nil)
			bar:Hide()
		elseif bar.cbtTestStart then
			bar:Show()
		end
	end
end

local function SetupCastbar(plate, unit)
	if not bars[unit] then CreateNameplateCastbar(plate.UnitFrame, unit) end
	cfCastbars.ApplyNameplateSettings(bars[unit])
	CastingBarFrame_SetUnit(bars[unit], unit)
	if UnitCastingInfo(unit) or UnitChannelInfo(unit) then
		CastingBarFrame_OnEvent(bars[unit], "PLAYER_ENTERING_WORLD")
	end
end

function cfCastbars.InitNameplate()
	local f = CreateFrame("Frame")
	f:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	f:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(_, event, unit)
		if event == "NAME_PLATE_UNIT_REMOVED" then
			if bars[unit] then CastingBarFrame_SetUnit(bars[unit], nil) end
			return
		end
		if not cfCastbarsDB[K.Nameplate] then return end
		if event == "PLAYER_ENTERING_WORLD" then
			for _, plate in ipairs(C_NamePlate.GetNamePlates()) do
				SetupCastbar(plate, plate.namePlateUnitToken)
			end
			return
		end
		local plate = C_NamePlate.GetNamePlateForUnit(unit)
		if plate then SetupCastbar(plate, unit) end
	end)
end
