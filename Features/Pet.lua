local _, addon = ...

local bar

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UNIT_PET")
f:SetScript("OnEvent", function(_, event, unit)
	if event == "UNIT_PET" and unit ~= "player" then return end
	if not UnitExists("pet") then
		if bar then CastingBarFrame_SetUnit(bar, nil) end
		return
	end
	if not bar then
		local hp = PetFrameHealthBar
		bar = addon.CreateCastbar(UIParent, "pet", hp:GetWidth() * 1.25, hp:GetHeight())
		bar:SetPoint("TOP", PetFrame, "BOTTOM", 10, 0)
	end
	CastingBarFrame_SetUnit(bar, "pet")
end)
