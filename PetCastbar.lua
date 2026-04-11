local bar

function cfCastbars.CreatePetCastbar()
	local hp = PetFrameHealthBar
	local w, h = hp:GetWidth(), hp:GetHeight()
	bar = cfCastbars.CreateCastbar(UIParent, "pet", w, h)
	bar:SetPoint("TOP", PetFrame, "BOTTOM", 15, 0)
	cfCastbars.petBar = bar
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UNIT_PET")
f:SetScript("OnEvent", function(_, event, unit)
	if event == "UNIT_PET" and unit ~= "player" then return end
	if not PetFrame or not UnitExists("pet") then
		if bar then CastingBarFrame_SetUnit(bar, nil) end
		return
	end
	if not bar then cfCastbars.CreatePetCastbar() end
	CastingBarFrame_SetUnit(bar, "pet")
	if UnitCastingInfo("pet") or UnitChannelInfo("pet") then
		CastingBarFrame_OnEvent(bar, "PLAYER_ENTERING_WORLD")
	end
end)
