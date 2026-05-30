local _, addon = ...

-- Build + place the pet castbar. Single source of truth for pet bar geometry,
-- shared by the production event handler and the /cfcb test harness.
function addon.BuildPetBar()
	local hp = PetFrameHealthBar
	local bar = addon.CreateCastbar(UIParent, "pet", hp:GetWidth() * 1.25, hp:GetHeight())
	bar:SetPoint("TOP", PetFrame, "BOTTOM", 10, 0)
	return bar
end

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
		addon.petBar = addon.BuildPetBar()
	end
	CastingBarFrame_SetUnit(addon.petBar, "pet")
end)
