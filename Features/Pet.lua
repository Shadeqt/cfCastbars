local _, addon = ...

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UNIT_PET")
f:SetScript("OnEvent", function(_, event, unit)
	if event == "UNIT_PET" and unit ~= "player" then return end
	if not UnitExists("pet") then
		if addon.petBar then CastingBarFrame_SetUnit(addon.petBar, nil) end
		return
	end
	if not addon.petBar then
		addon.petBar = addon.BuildUnitBar(PetFrame, "pet")
	end
	CastingBarFrame_SetUnit(addon.petBar, "pet")
end)
