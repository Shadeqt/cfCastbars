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
	cfCastbars.ApplyBarSettings(bar, "Target", "Nameplate")

	-- Position
	bar:ClearAllPoints()
	bar:SetPoint("TOP", hp, "BOTTOM", db[K.NameplateX], -5 + db[K.NameplateY])
end

function cfCastbars.UpdateNameplate()
	local db = cfCastbarsDB
	for _, bar in pairs(bars) do
		cfCastbars.ApplyNameplateSettings(bar)
		if not db[K.Nameplate] then
			CastingBarFrame_SetUnit(bar, nil)
			bar:Hide()
		elseif cfCastbars.testing.Nameplate then
			bar:Show()
		end
	end
end

local function SetupCastbar(plate, unit)
	if not bars[unit] then CreateNameplateCastbar(plate.UnitFrame, unit) end
	CastingBarFrame_SetUnit(bars[unit], unit)
	if UnitCastingInfo(unit) or UnitChannelInfo(unit) then
		CastingBarFrame_OnEvent(bars[unit], "PLAYER_ENTERING_WORLD")
	end
	cfCastbars.ApplyNameplateSettings(bars[unit])
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
