local _, addon = ...

local bars = {}
addon.nameplateBars = bars  -- exposed for the /cfcb test harness

local function SetupCastbar(plate, unit)
	local hp = plate.UnitFrame.healthBar
	local bar = bars[unit]
	if bar then
		bar:SetParent(plate.UnitFrame)
	else
		bar = addon.CreateCastbar(plate.UnitFrame, unit, hp:GetWidth(), hp:GetHeight() - 2)
		bars[unit] = bar
	end
	bar.hp = hp  -- recycled plates reuse the bar; keep it pointed at the live health bar
	bar:ClearAllPoints()
	bar:SetPoint("TOP", hp, "BOTTOM", 16, -10)
	addon.AttachBar(bar, unit)
end

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
