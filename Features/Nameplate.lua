local _, addon = ...

local bars = {}
addon.nameplateBars = bars  -- pooled per unit token; reused by the /cfcb harness

local function SetupCastbar(plate, unit)
	local hp = plate.UnitFrame.healthBar
	local bar = bars[unit]
	if bar then
		bar:SetParent(plate.UnitFrame)
	else
		bar = addon.CreateCastbar(plate.UnitFrame)
		bar:SetScale(0.8)  -- uniform shrink; keeps the template art's fit. Survives re-parenting.
		bars[unit] = bar
	end
	bar.hp = hp  -- recycled plates reuse the bar; keep it pointed at the live health bar
	bar:ClearAllPoints()
	bar:SetPoint("TOP", hp, "BOTTOM", 10, -10)
	addon.AttachBar(bar, unit)
end

local f = CreateFrame("Frame")
f:RegisterEvent("NAME_PLATE_UNIT_ADDED")
f:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(_, event, unit)
	if event == "NAME_PLATE_UNIT_REMOVED" then
		-- Detach AND hide: SetUnit(nil) stops updates but won't hide a bar caught mid-cast, and the
		-- plate is about to be recycled for another unit -- a frozen bar would flash onto its frame.
		if bars[unit] then
			CastingBarFrame_SetUnit(bars[unit], nil)
			bars[unit]:Hide()
		end
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
