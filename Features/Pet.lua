local _, addon = ...

-- Build the pet castbar once, hung below the pet frame, scaled to 0.6 (uniform SetScale keeps the
-- template art's fit). bar.hp points at the pet health bar so the fill mirrors its texture each Show.
local function EnsureBar()
	if not addon.petBar then
		local bar = addon.CreateCastbar(PetFrame)
		bar:SetScale(0.6)
		bar:SetPoint("TOP", PetFrame, "BOTTOM", 5, -10)
		bar.hp = PetFrameHealthBar
		addon.petBar = bar
	end
	return addon.petBar
end
addon.EnsurePetBar = EnsureBar

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UNIT_PET")
f:SetScript("OnEvent", function(_, event, unit)
	if event == "UNIT_PET" and unit ~= "player" then return end
	if not UnitExists("pet") then
		if addon.petBar then CastingBarFrame_SetUnit(addon.petBar, nil) end
		return
	end
	EnsureBar()
	CastingBarFrame_SetUnit(addon.petBar, "pet")
end)
