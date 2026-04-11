cfCastbars.nameplateBars = {}
local bars = cfCastbars.nameplateBars

local function CreateNameplateCastbar(unitFrame, unit)
	local hp = unitFrame.healthBar
	local bar = cfCastbars.CreateCastbar(unitFrame, unit, hp:GetWidth(), hp:GetHeight())
	bar:SetPoint("TOP", hp, "BOTTOM", 18, -5)
	bars[unit] = bar
	return bar
end

local function SetupCastbar(plate, unit)
	if not bars[unit] then CreateNameplateCastbar(plate.UnitFrame, unit) end
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
