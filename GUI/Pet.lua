function cfCastbars.SetupPetGUI()
	local F = cfCastbars.F
	local K = cfCastbars.K
	local update = cfCastbars.UpdatePet

	local panel = CreateFrame("Frame", "cfCastbarsPetPanel")
	panel:Hide()

	local sc = F.ScrollPanel(panel)

	local title = sc:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("cfCastbars")

	-- Test mode
	local test = F.Checkbox(sc, nil, "Test Castbars", function(checked)
		if checked then
			cfCastbars.StartTest()
		else
			cfCastbars.StopTest()
		end
	end)
	test:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)

	local hsep = F.HSeparator(sc)
	hsep:SetPoint("TOP", test, "BOTTOM", 0, -10)

	local petHeader = F.Text(sc, "Pet", "GameFontNormalLarge")
	petHeader:SetPoint("TOPLEFT", hsep, "BOTTOMLEFT", 0, -10)

	-- Toggles
	local enabled = F.Checkbox(sc, K.Pet,       "Castbar", update)
	enabled:SetPoint("TOPLEFT", petHeader, "BOTTOMLEFT", 0, -5)
	local icon    = F.Checkbox(sc, K.PetIcon,   "Icon",   update)
	icon:SetPoint("TOPLEFT", enabled, "BOTTOMLEFT", 0, -5)
	local timer   = F.Checkbox(sc, K.PetTimer,  "Timer",  update)
	timer:SetPoint("LEFT", icon, "RIGHT", 60, 0)
	local text    = F.Checkbox(sc, K.PetText,   "Text",   update)
	text:SetPoint("TOPLEFT", icon, "BOTTOMLEFT", 0, -5)
	local border  = F.Checkbox(sc, K.PetBorder, "Border", update)
	border:SetPoint("LEFT", text, "RIGHT", 60, 0)

	-- Castbar
	local hCastbar = F.Text(sc, "Castbar", "GameFontNormal")
	hCastbar:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -15)
	local cbScale  = F.Slider(sc, K.PetScale,  "Castbar Scale",  0.1, 1.9, 0.05, update)
	cbScale:SetPoint("TOPLEFT", hCastbar, "BOTTOMLEFT", 0, -10)
	local cbX      = F.Slider(sc, K.PetX,      "Castbar X",      -1000, 1000, 1, update)
	cbX:SetPoint("TOPLEFT", cbScale, "BOTTOMLEFT", 0, -15)
	local cbY      = F.Slider(sc, K.PetY,      "Castbar Y",      -1000, 1000, 1, update)
	cbY:SetPoint("TOPLEFT", cbX, "BOTTOMLEFT", 0, -15)
	local cbW      = F.Slider(sc, K.PetWidth,  "Castbar Width",  -50, 500, 1, update)
	cbW:SetPoint("TOPLEFT", cbY, "BOTTOMLEFT", 0, -15)
	local cbH      = F.Slider(sc, K.PetHeight, "Castbar Height", -5, 50, 1, update)
	cbH:SetPoint("TOPLEFT", cbW, "BOTTOMLEFT", 0, -15)

	-- Icon
	local hIcon     = F.Text(sc, "Icon", "GameFontNormal")
	hIcon:SetPoint("TOPLEFT", cbH, "BOTTOMLEFT", 0, -15)
	local iconScale = F.Slider(sc, K.PetIconScale, "Icon Scale", 0.1, 1.9, 0.05, update)
	iconScale:SetPoint("TOPLEFT", hIcon, "BOTTOMLEFT", 0, -10)
	local iconX     = F.Slider(sc, K.PetIconX,     "Icon X",     -1000, 1000, 1, update)
	iconX:SetPoint("TOPLEFT", iconScale, "BOTTOMLEFT", 0, -15)
	local iconY     = F.Slider(sc, K.PetIconY,     "Icon Y",     -1000, 1000, 1, update)
	iconY:SetPoint("TOPLEFT", iconX, "BOTTOMLEFT", 0, -15)

	-- Timer
	local hTimer     = F.Text(sc, "Timer", "GameFontNormal")
	hTimer:SetPoint("TOPLEFT", iconY, "BOTTOMLEFT", 0, -15)
	local timerScale = F.Slider(sc, K.PetTimerScale, "Timer Scale", 0.1, 1.9, 0.05, update)
	timerScale:SetPoint("TOPLEFT", hTimer, "BOTTOMLEFT", 0, -10)
	local timerX     = F.Slider(sc, K.PetTimerX,     "Timer X",     -1000, 1000, 1, update)
	timerX:SetPoint("TOPLEFT", timerScale, "BOTTOMLEFT", 0, -15)
	local timerY     = F.Slider(sc, K.PetTimerY,     "Timer Y",     -1000, 1000, 1, update)
	timerY:SetPoint("TOPLEFT", timerX, "BOTTOMLEFT", 0, -15)

	-- Text
	local hText     = F.Text(sc, "Text", "GameFontNormal")
	hText:SetPoint("TOPLEFT", timerY, "BOTTOMLEFT", 0, -15)
	local textScale = F.Slider(sc, K.PetTextScale, "Text Scale", 0.1, 1.9, 0.05, update)
	textScale:SetPoint("TOPLEFT", hText, "BOTTOMLEFT", 0, -10)
	local textX     = F.Slider(sc, K.PetTextX,     "Text X",     -1000, 1000, 1, update)
	textX:SetPoint("TOPLEFT", textScale, "BOTTOMLEFT", 0, -15)
	local textY     = F.Slider(sc, K.PetTextY,     "Text Y",     -1000, 1000, 1, update)
	textY:SetPoint("TOPLEFT", textX, "BOTTOMLEFT", 0, -15)

	-- Reset
	local reset = F.Button(sc, "Reset", function()
		F.ResetPrefix("Pet", update)
	end)
	reset:SetPoint("TOPLEFT", textY, "BOTTOMLEFT", 0, -15)

	-- Bind visibility
	F.BindChildren(enabled, {
		icon, timer, text, border, 
		hCastbar, cbScale, cbX, cbY, cbW, cbH, 
		hIcon, iconScale, iconX, iconY, 
		hTimer, timerScale, timerX, timerY, 
		hText, textScale, textX, textY, 
		reset})
	F.BindChildren(icon, {hIcon, iconScale, iconX, iconY})
	F.BindChildren(timer, {hTimer, timerScale, timerX, timerY})
	F.BindChildren(text, {hText, textScale, textX, textY})

	-- Vertical separator
	local vsep = F.VSeparator(sc)
	vsep:SetPoint("TOPLEFT", hsep, "TOPLEFT", 200, 0)
	vsep:SetPoint("BOTTOMLEFT", reset, "BOTTOMLEFT", 200, 0)

	-- Register
	cfCastbars.category = Settings.RegisterCanvasLayoutCategory(panel, "cfCastbars")
	Settings.RegisterAddOnCategory(cfCastbars.category)

	-- Draggable
	SettingsPanel:SetMovable(true)
	SettingsPanel:EnableMouse(true)
	SettingsPanel:RegisterForDrag("LeftButton")
	SettingsPanel:SetScript("OnDragStart", SettingsPanel.StartMoving)
	SettingsPanel:SetScript("OnDragStop", SettingsPanel.StopMovingOrSizing)
end
