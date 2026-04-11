function cfCastbars.SetupPetGUI()
	local F = cfCastbars.F
	local K = cfCastbars.K

	local panel = CreateFrame("Frame", "cfCastbarsPanel")
	panel:Hide()

	local sc = F.ScrollPanel(panel)

	local title = sc:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("cfCastbars")

	local hsep = F.HSeparator(sc)
	hsep:SetPoint("TOP", title, "BOTTOM", 0, -10)

	-- 3 equal columns across usable width
	local W = 639
	local COL_W = W / 3
	local PAD = 15
	local COL1 = PAD
	local COL2 = COL_W + PAD
	local COL3 = COL_W * 2 + PAD
	local ROW_TOP = hsep

	-----------------------------------------------------------------------
	-- Column 1: Player
	-----------------------------------------------------------------------
	local pl = cfCastbars.UpdatePlayer
	local plHeader = F.Text(sc, "Player", "GameFontNormalLarge")
	plHeader:SetPoint("TOPLEFT", ROW_TOP, "BOTTOMLEFT", COL1, -10)
	local plTest = F.Checkbox(sc, nil, "Test", function(c) cfCastbars.TestPlayer(c) end)
	plTest:SetPoint("TOPLEFT", plHeader, "BOTTOMLEFT", 0, -5)
	local plEnabled = F.Checkbox(sc, K.Player, "Castbar", pl)
	plEnabled:SetPoint("TOPLEFT", plTest, "BOTTOMLEFT", 0, -5)
	local plIcon = F.Checkbox(sc, K.PlayerIcon, "Icon", pl)
	plIcon:SetPoint("TOPLEFT", plEnabled, "BOTTOMLEFT", 0, -5)
	local plTimer = F.Checkbox(sc, K.PlayerTimer, "Timer", pl)
	plTimer:SetPoint("LEFT", plIcon, "RIGHT", 60, 0)
	local plText = F.Checkbox(sc, K.PlayerText, "Text", pl)
	plText:SetPoint("TOPLEFT", plIcon, "BOTTOMLEFT", 0, -5)
	local plBorder = F.Checkbox(sc, K.PlayerBorder, "Border", pl)
	plBorder:SetPoint("LEFT", plText, "RIGHT", 60, 0)

	local plhCb = F.Text(sc, "Castbar", "GameFontNormal")
	plhCb:SetPoint("TOPLEFT", plText, "BOTTOMLEFT", 0, -15)
	local plScale = F.Slider(sc, K.PlayerScale, "Castbar Scale", 0.1, 1.9, 0.05, pl)
	plScale:SetPoint("TOPLEFT", plhCb, "BOTTOMLEFT", 0, -10)
	local plX = F.Slider(sc, K.PlayerX, "Castbar X", -1000, 1000, 1, pl)
	plX:SetPoint("TOPLEFT", plScale, "BOTTOMLEFT", 0, -15)
	local plY = F.Slider(sc, K.PlayerY, "Castbar Y", -1000, 1000, 1, pl)
	plY:SetPoint("TOPLEFT", plX, "BOTTOMLEFT", 0, -15)
	local plW = F.Slider(sc, K.PlayerWidth, "Castbar Width", -150, 500, 1, pl)
	plW:SetPoint("TOPLEFT", plY, "BOTTOMLEFT", 0, -15)
	local plH = F.Slider(sc, K.PlayerHeight, "Castbar Height", -10, 50, 1, pl)
	plH:SetPoint("TOPLEFT", plW, "BOTTOMLEFT", 0, -15)

	local plhIcon = F.Text(sc, "Icon", "GameFontNormal")
	plhIcon:SetPoint("TOPLEFT", plH, "BOTTOMLEFT", 0, -15)
	local plIconScale = F.Slider(sc, K.PlayerIconScale, "Icon Scale", 0.1, 1.9, 0.05, pl)
	plIconScale:SetPoint("TOPLEFT", plhIcon, "BOTTOMLEFT", 0, -10)
	local plIconX = F.Slider(sc, K.PlayerIconX, "Icon X", -1000, 1000, 1, pl)
	plIconX:SetPoint("TOPLEFT", plIconScale, "BOTTOMLEFT", 0, -15)
	local plIconY = F.Slider(sc, K.PlayerIconY, "Icon Y", -1000, 1000, 1, pl)
	plIconY:SetPoint("TOPLEFT", plIconX, "BOTTOMLEFT", 0, -15)

	local plhTimer = F.Text(sc, "Timer", "GameFontNormal")
	plhTimer:SetPoint("TOPLEFT", plIconY, "BOTTOMLEFT", 0, -15)
	local plTimerScale = F.Slider(sc, K.PlayerTimerScale, "Timer Scale", 0.1, 1.9, 0.05, pl)
	plTimerScale:SetPoint("TOPLEFT", plhTimer, "BOTTOMLEFT", 0, -10)
	local plTimerX = F.Slider(sc, K.PlayerTimerX, "Timer X", -1000, 1000, 1, pl)
	plTimerX:SetPoint("TOPLEFT", plTimerScale, "BOTTOMLEFT", 0, -15)
	local plTimerY = F.Slider(sc, K.PlayerTimerY, "Timer Y", -1000, 1000, 1, pl)
	plTimerY:SetPoint("TOPLEFT", plTimerX, "BOTTOMLEFT", 0, -15)

	local plhText = F.Text(sc, "Text", "GameFontNormal")
	plhText:SetPoint("TOPLEFT", plTimerY, "BOTTOMLEFT", 0, -15)
	local plTextScale = F.Slider(sc, K.PlayerTextScale, "Text Scale", 0.1, 1.9, 0.05, pl)
	plTextScale:SetPoint("TOPLEFT", plhText, "BOTTOMLEFT", 0, -10)
	local plTextX = F.Slider(sc, K.PlayerTextX, "Text X", -1000, 1000, 1, pl)
	plTextX:SetPoint("TOPLEFT", plTextScale, "BOTTOMLEFT", 0, -15)
	local plTextY = F.Slider(sc, K.PlayerTextY, "Text Y", -1000, 1000, 1, pl)
	plTextY:SetPoint("TOPLEFT", plTextX, "BOTTOMLEFT", 0, -15)

	local plReset = F.Button(sc, "Reset", function() F.ResetPrefix("Player", pl) end)
	plReset:SetPoint("TOPLEFT", plTextY, "BOTTOMLEFT", 0, -15)

	F.BindChildren(plIcon, {plhIcon, plIconScale, plIconX, plIconY})
	F.BindChildren(plTimer, {plhTimer, plTimerScale, plTimerX, plTimerY})
	F.BindChildren(plText, {plhText, plTextScale, plTextX, plTextY})
	F.BindChildren(plEnabled, {plIcon, plTimer, plText, plBorder, plhCb, plScale, plX, plY, plW, plH, plhIcon, plIconScale, plIconX, plIconY, plhTimer, plTimerScale, plTimerX, plTimerY, plhText, plTextScale, plTextX, plTextY})

	-----------------------------------------------------------------------
	-- Column 2: Target
	-----------------------------------------------------------------------
	local tg = cfCastbars.UpdateTarget
	local tgHeader = F.Text(sc, "Target", "GameFontNormalLarge")
	tgHeader:SetPoint("TOPLEFT", ROW_TOP, "BOTTOMLEFT", COL2, -10)
	local tgTest = F.Checkbox(sc, nil, "Test", function(c) cfCastbars.TestTarget(c) end)
	tgTest:SetPoint("TOPLEFT", tgHeader, "BOTTOMLEFT", 0, -5)
	local tgEnabled = F.Checkbox(sc, K.Target, "Castbar", tg)
	tgEnabled:SetPoint("TOPLEFT", tgTest, "BOTTOMLEFT", 0, -5)
	local tgIcon = F.Checkbox(sc, K.TargetIcon, "Icon", tg)
	tgIcon:SetPoint("TOPLEFT", tgEnabled, "BOTTOMLEFT", 0, -5)
	local tgTimer = F.Checkbox(sc, K.TargetTimer, "Timer", tg)
	tgTimer:SetPoint("LEFT", tgIcon, "RIGHT", 60, 0)
	local tgText = F.Checkbox(sc, K.TargetText, "Text", tg)
	tgText:SetPoint("TOPLEFT", tgIcon, "BOTTOMLEFT", 0, -5)
	local tgBorder = F.Checkbox(sc, K.TargetBorder, "Border", tg)
	tgBorder:SetPoint("LEFT", tgText, "RIGHT", 60, 0)

	local tghCb = F.Text(sc, "Castbar", "GameFontNormal")
	tghCb:SetPoint("TOPLEFT", tgText, "BOTTOMLEFT", 0, -15)
	local tgScale = F.Slider(sc, K.TargetScale, "Castbar Scale", 0.1, 1.9, 0.05, tg)
	tgScale:SetPoint("TOPLEFT", tghCb, "BOTTOMLEFT", 0, -10)
	local tgX = F.Slider(sc, K.TargetX, "Castbar X", -1000, 1000, 1, tg)
	tgX:SetPoint("TOPLEFT", tgScale, "BOTTOMLEFT", 0, -15)
	local tgY = F.Slider(sc, K.TargetY, "Castbar Y", -1000, 1000, 1, tg)
	tgY:SetPoint("TOPLEFT", tgX, "BOTTOMLEFT", 0, -15)
	local tgW = F.Slider(sc, K.TargetWidth, "Castbar Width", -100, 500, 1, tg)
	tgW:SetPoint("TOPLEFT", tgY, "BOTTOMLEFT", 0, -15)
	local tgH = F.Slider(sc, K.TargetHeight, "Castbar Height", -8, 50, 1, tg)
	tgH:SetPoint("TOPLEFT", tgW, "BOTTOMLEFT", 0, -15)

	local tghIcon = F.Text(sc, "Icon", "GameFontNormal")
	tghIcon:SetPoint("TOPLEFT", tgH, "BOTTOMLEFT", 0, -15)
	local tgIconScale = F.Slider(sc, K.TargetIconScale, "Icon Scale", 0.1, 1.9, 0.05, tg)
	tgIconScale:SetPoint("TOPLEFT", tghIcon, "BOTTOMLEFT", 0, -10)
	local tgIconX = F.Slider(sc, K.TargetIconX, "Icon X", -1000, 1000, 1, tg)
	tgIconX:SetPoint("TOPLEFT", tgIconScale, "BOTTOMLEFT", 0, -15)
	local tgIconY = F.Slider(sc, K.TargetIconY, "Icon Y", -1000, 1000, 1, tg)
	tgIconY:SetPoint("TOPLEFT", tgIconX, "BOTTOMLEFT", 0, -15)

	local tghTimer = F.Text(sc, "Timer", "GameFontNormal")
	tghTimer:SetPoint("TOPLEFT", tgIconY, "BOTTOMLEFT", 0, -15)
	local tgTimerScale = F.Slider(sc, K.TargetTimerScale, "Timer Scale", 0.1, 1.9, 0.05, tg)
	tgTimerScale:SetPoint("TOPLEFT", tghTimer, "BOTTOMLEFT", 0, -10)
	local tgTimerX = F.Slider(sc, K.TargetTimerX, "Timer X", -1000, 1000, 1, tg)
	tgTimerX:SetPoint("TOPLEFT", tgTimerScale, "BOTTOMLEFT", 0, -15)
	local tgTimerY = F.Slider(sc, K.TargetTimerY, "Timer Y", -1000, 1000, 1, tg)
	tgTimerY:SetPoint("TOPLEFT", tgTimerX, "BOTTOMLEFT", 0, -15)

	local tghText = F.Text(sc, "Text", "GameFontNormal")
	tghText:SetPoint("TOPLEFT", tgTimerY, "BOTTOMLEFT", 0, -15)
	local tgTextScale = F.Slider(sc, K.TargetTextScale, "Text Scale", 0.1, 1.9, 0.05, tg)
	tgTextScale:SetPoint("TOPLEFT", tghText, "BOTTOMLEFT", 0, -10)
	local tgTextX = F.Slider(sc, K.TargetTextX, "Text X", -1000, 1000, 1, tg)
	tgTextX:SetPoint("TOPLEFT", tgTextScale, "BOTTOMLEFT", 0, -15)
	local tgTextY = F.Slider(sc, K.TargetTextY, "Text Y", -1000, 1000, 1, tg)
	tgTextY:SetPoint("TOPLEFT", tgTextX, "BOTTOMLEFT", 0, -15)

	local tgReset = F.Button(sc, "Reset", function() F.ResetPrefix("Target", tg) end)
	tgReset:SetPoint("TOPLEFT", tgTextY, "BOTTOMLEFT", 0, -15)

	F.BindChildren(tgIcon, {tghIcon, tgIconScale, tgIconX, tgIconY})
	F.BindChildren(tgTimer, {tghTimer, tgTimerScale, tgTimerX, tgTimerY})
	F.BindChildren(tgText, {tghText, tgTextScale, tgTextX, tgTextY})
	F.BindChildren(tgEnabled, {tgIcon, tgTimer, tgText, tgBorder, tghCb, tgScale, tgX, tgY, tgW, tgH, tghIcon, tgIconScale, tgIconX, tgIconY, tghTimer, tgTimerScale, tgTimerX, tgTimerY, tghText, tgTextScale, tgTextX, tgTextY})

	-----------------------------------------------------------------------
	-- Column 3: Pet
	-----------------------------------------------------------------------
	local pt = cfCastbars.UpdatePet
	local ptHeader = F.Text(sc, "Pet", "GameFontNormalLarge")
	ptHeader:SetPoint("TOPLEFT", ROW_TOP, "BOTTOMLEFT", COL3, -10)
	local ptTest = F.Checkbox(sc, nil, "Test", function(c) cfCastbars.TestPet(c) end)
	ptTest:SetPoint("TOPLEFT", ptHeader, "BOTTOMLEFT", 0, -5)
	local ptEnabled = F.Checkbox(sc, K.Pet, "Castbar", pt)
	ptEnabled:SetPoint("TOPLEFT", ptTest, "BOTTOMLEFT", 0, -5)
	local ptIcon = F.Checkbox(sc, K.PetIcon, "Icon", pt)
	ptIcon:SetPoint("TOPLEFT", ptEnabled, "BOTTOMLEFT", 0, -5)
	local ptTimer = F.Checkbox(sc, K.PetTimer, "Timer", pt)
	ptTimer:SetPoint("LEFT", ptIcon, "RIGHT", 60, 0)
	local ptText = F.Checkbox(sc, K.PetText, "Text", pt)
	ptText:SetPoint("TOPLEFT", ptIcon, "BOTTOMLEFT", 0, -5)
	local ptBorder = F.Checkbox(sc, K.PetBorder, "Border", pt)
	ptBorder:SetPoint("LEFT", ptText, "RIGHT", 60, 0)

	local pthCb = F.Text(sc, "Castbar", "GameFontNormal")
	pthCb:SetPoint("TOPLEFT", ptText, "BOTTOMLEFT", 0, -15)
	local ptScale = F.Slider(sc, K.PetScale, "Castbar Scale", 0.1, 1.9, 0.05, pt)
	ptScale:SetPoint("TOPLEFT", pthCb, "BOTTOMLEFT", 0, -10)
	local ptX = F.Slider(sc, K.PetX, "Castbar X", -1000, 1000, 1, pt)
	ptX:SetPoint("TOPLEFT", ptScale, "BOTTOMLEFT", 0, -15)
	local ptY = F.Slider(sc, K.PetY, "Castbar Y", -1000, 1000, 1, pt)
	ptY:SetPoint("TOPLEFT", ptX, "BOTTOMLEFT", 0, -15)
	local ptW = F.Slider(sc, K.PetWidth, "Castbar Width", -50, 500, 1, pt)
	ptW:SetPoint("TOPLEFT", ptY, "BOTTOMLEFT", 0, -15)
	local ptH = F.Slider(sc, K.PetHeight, "Castbar Height", -5, 50, 1, pt)
	ptH:SetPoint("TOPLEFT", ptW, "BOTTOMLEFT", 0, -15)

	local pthIcon = F.Text(sc, "Icon", "GameFontNormal")
	pthIcon:SetPoint("TOPLEFT", ptH, "BOTTOMLEFT", 0, -15)
	local ptIconScale = F.Slider(sc, K.PetIconScale, "Icon Scale", 0.1, 1.9, 0.05, pt)
	ptIconScale:SetPoint("TOPLEFT", pthIcon, "BOTTOMLEFT", 0, -10)
	local ptIconX = F.Slider(sc, K.PetIconX, "Icon X", -1000, 1000, 1, pt)
	ptIconX:SetPoint("TOPLEFT", ptIconScale, "BOTTOMLEFT", 0, -15)
	local ptIconY = F.Slider(sc, K.PetIconY, "Icon Y", -1000, 1000, 1, pt)
	ptIconY:SetPoint("TOPLEFT", ptIconX, "BOTTOMLEFT", 0, -15)

	local pthTimer = F.Text(sc, "Timer", "GameFontNormal")
	pthTimer:SetPoint("TOPLEFT", ptIconY, "BOTTOMLEFT", 0, -15)
	local ptTimerScale = F.Slider(sc, K.PetTimerScale, "Timer Scale", 0.1, 1.9, 0.05, pt)
	ptTimerScale:SetPoint("TOPLEFT", pthTimer, "BOTTOMLEFT", 0, -10)
	local ptTimerX = F.Slider(sc, K.PetTimerX, "Timer X", -1000, 1000, 1, pt)
	ptTimerX:SetPoint("TOPLEFT", ptTimerScale, "BOTTOMLEFT", 0, -15)
	local ptTimerY = F.Slider(sc, K.PetTimerY, "Timer Y", -1000, 1000, 1, pt)
	ptTimerY:SetPoint("TOPLEFT", ptTimerX, "BOTTOMLEFT", 0, -15)

	local pthText = F.Text(sc, "Text", "GameFontNormal")
	pthText:SetPoint("TOPLEFT", ptTimerY, "BOTTOMLEFT", 0, -15)
	local ptTextScale = F.Slider(sc, K.PetTextScale, "Text Scale", 0.1, 1.9, 0.05, pt)
	ptTextScale:SetPoint("TOPLEFT", pthText, "BOTTOMLEFT", 0, -10)
	local ptTextX = F.Slider(sc, K.PetTextX, "Text X", -1000, 1000, 1, pt)
	ptTextX:SetPoint("TOPLEFT", ptTextScale, "BOTTOMLEFT", 0, -15)
	local ptTextY = F.Slider(sc, K.PetTextY, "Text Y", -1000, 1000, 1, pt)
	ptTextY:SetPoint("TOPLEFT", ptTextX, "BOTTOMLEFT", 0, -15)

	local ptReset = F.Button(sc, "Reset", function() F.ResetPrefix("Pet", pt) end)
	ptReset:SetPoint("TOPLEFT", ptTextY, "BOTTOMLEFT", 0, -15)

	F.BindChildren(ptIcon, {pthIcon, ptIconScale, ptIconX, ptIconY})
	F.BindChildren(ptTimer, {pthTimer, ptTimerScale, ptTimerX, ptTimerY})
	F.BindChildren(ptText, {pthText, ptTextScale, ptTextX, ptTextY})
	F.BindChildren(ptEnabled, {ptIcon, ptTimer, ptText, ptBorder, pthCb, ptScale, ptX, ptY, ptW, ptH, pthIcon, ptIconScale, ptIconX, ptIconY, pthTimer, ptTimerScale, ptTimerX, ptTimerY, pthText, ptTextScale, ptTextX, ptTextY})

	-----------------------------------------------------------------------
	-- Row 1 separators
	-----------------------------------------------------------------------
	-- Find longest column bottom for row separator
	local row1Bottom = plReset
	for _, r in ipairs({tgReset, ptReset}) do
		if r:GetBottom() and r:GetBottom() < (row1Bottom:GetBottom() or 0) then row1Bottom = r end
	end

	local vsep1 = F.VSeparator(sc)
	vsep1:SetPoint("TOPLEFT", ROW_TOP, "BOTTOMLEFT", COL_W, 0)
	vsep1:SetPoint("TOP", ROW_TOP, "BOTTOM", 0, 0)
	vsep1:SetPoint("BOTTOM", row1Bottom, "BOTTOM", 0, -10)

	local vsep2 = F.VSeparator(sc)
	vsep2:SetPoint("TOPLEFT", ROW_TOP, "BOTTOMLEFT", COL_W * 2, 0)
	vsep2:SetPoint("BOTTOM", row1Bottom, "BOTTOM", 0, -10)

	local hsep2 = F.HSeparator(sc)
	hsep2:SetPoint("TOP", row1Bottom, "BOTTOM", 0, -10)

	-----------------------------------------------------------------------
	-- Row 2, Column 1: Party
	-----------------------------------------------------------------------
	local pa = cfCastbars.UpdateParty
	local paHeader = F.Text(sc, "Party", "GameFontNormalLarge")
	paHeader:SetPoint("TOPLEFT", hsep2, "BOTTOMLEFT", COL1, -10)
	local paTest = F.Checkbox(sc, nil, "Test", function(c) cfCastbars.TestParty(c) end)
	paTest:SetPoint("TOPLEFT", paHeader, "BOTTOMLEFT", 0, -5)
	local paEnabled = F.Checkbox(sc, K.Party, "Castbar", pa)
	paEnabled:SetPoint("TOPLEFT", paTest, "BOTTOMLEFT", 0, -5)
	local paIcon = F.Checkbox(sc, K.PartyIcon, "Icon", pa)
	paIcon:SetPoint("TOPLEFT", paEnabled, "BOTTOMLEFT", 0, -5)
	local paTimer = F.Checkbox(sc, K.PartyTimer, "Timer", pa)
	paTimer:SetPoint("LEFT", paIcon, "RIGHT", 60, 0)
	local paText = F.Checkbox(sc, K.PartyText, "Text", pa)
	paText:SetPoint("TOPLEFT", paIcon, "BOTTOMLEFT", 0, -5)
	local paBorder = F.Checkbox(sc, K.PartyBorder, "Border", pa)
	paBorder:SetPoint("LEFT", paText, "RIGHT", 60, 0)

	local pahCb = F.Text(sc, "Castbar", "GameFontNormal")
	pahCb:SetPoint("TOPLEFT", paText, "BOTTOMLEFT", 0, -15)
	local paScale = F.Slider(sc, K.PartyScale, "Castbar Scale", 0.1, 1.9, 0.05, pa)
	paScale:SetPoint("TOPLEFT", pahCb, "BOTTOMLEFT", 0, -10)
	local paX = F.Slider(sc, K.PartyX, "Castbar X", -1000, 1000, 1, pa)
	paX:SetPoint("TOPLEFT", paScale, "BOTTOMLEFT", 0, -15)
	local paY = F.Slider(sc, K.PartyY, "Castbar Y", -1000, 1000, 1, pa)
	paY:SetPoint("TOPLEFT", paX, "BOTTOMLEFT", 0, -15)
	local paW = F.Slider(sc, K.PartyWidth, "Castbar Width", -50, 500, 1, pa)
	paW:SetPoint("TOPLEFT", paY, "BOTTOMLEFT", 0, -15)
	local paH = F.Slider(sc, K.PartyHeight, "Castbar Height", -5, 50, 1, pa)
	paH:SetPoint("TOPLEFT", paW, "BOTTOMLEFT", 0, -15)

	local pahIcon = F.Text(sc, "Icon", "GameFontNormal")
	pahIcon:SetPoint("TOPLEFT", paH, "BOTTOMLEFT", 0, -15)
	local paIconScale = F.Slider(sc, K.PartyIconScale, "Icon Scale", 0.1, 1.9, 0.05, pa)
	paIconScale:SetPoint("TOPLEFT", pahIcon, "BOTTOMLEFT", 0, -10)
	local paIconX = F.Slider(sc, K.PartyIconX, "Icon X", -1000, 1000, 1, pa)
	paIconX:SetPoint("TOPLEFT", paIconScale, "BOTTOMLEFT", 0, -15)
	local paIconY = F.Slider(sc, K.PartyIconY, "Icon Y", -1000, 1000, 1, pa)
	paIconY:SetPoint("TOPLEFT", paIconX, "BOTTOMLEFT", 0, -15)

	local pahTimer = F.Text(sc, "Timer", "GameFontNormal")
	pahTimer:SetPoint("TOPLEFT", paIconY, "BOTTOMLEFT", 0, -15)
	local paTimerScale = F.Slider(sc, K.PartyTimerScale, "Timer Scale", 0.1, 1.9, 0.05, pa)
	paTimerScale:SetPoint("TOPLEFT", pahTimer, "BOTTOMLEFT", 0, -10)
	local paTimerX = F.Slider(sc, K.PartyTimerX, "Timer X", -1000, 1000, 1, pa)
	paTimerX:SetPoint("TOPLEFT", paTimerScale, "BOTTOMLEFT", 0, -15)
	local paTimerY = F.Slider(sc, K.PartyTimerY, "Timer Y", -1000, 1000, 1, pa)
	paTimerY:SetPoint("TOPLEFT", paTimerX, "BOTTOMLEFT", 0, -15)

	local pahText = F.Text(sc, "Text", "GameFontNormal")
	pahText:SetPoint("TOPLEFT", paTimerY, "BOTTOMLEFT", 0, -15)
	local paTextScale = F.Slider(sc, K.PartyTextScale, "Text Scale", 0.1, 1.9, 0.05, pa)
	paTextScale:SetPoint("TOPLEFT", pahText, "BOTTOMLEFT", 0, -10)
	local paTextX = F.Slider(sc, K.PartyTextX, "Text X", -1000, 1000, 1, pa)
	paTextX:SetPoint("TOPLEFT", paTextScale, "BOTTOMLEFT", 0, -15)
	local paTextY = F.Slider(sc, K.PartyTextY, "Text Y", -1000, 1000, 1, pa)
	paTextY:SetPoint("TOPLEFT", paTextX, "BOTTOMLEFT", 0, -15)

	local paReset = F.Button(sc, "Reset", function() F.ResetPrefix("Party", pa) end)
	paReset:SetPoint("TOPLEFT", paTextY, "BOTTOMLEFT", 0, -15)

	F.BindChildren(paIcon, {pahIcon, paIconScale, paIconX, paIconY})
	F.BindChildren(paTimer, {pahTimer, paTimerScale, paTimerX, paTimerY})
	F.BindChildren(paText, {pahText, paTextScale, paTextX, paTextY})
	F.BindChildren(paEnabled, {paIcon, paTimer, paText, paBorder, pahCb, paScale, paX, paY, paW, paH, pahIcon, paIconScale, paIconX, paIconY, pahTimer, paTimerScale, paTimerX, paTimerY, pahText, paTextScale, paTextX, paTextY})

	-----------------------------------------------------------------------
	-- Register
	-----------------------------------------------------------------------
	cfCastbars.category = Settings.RegisterCanvasLayoutCategory(panel, "cfCastbars")
	Settings.RegisterAddOnCategory(cfCastbars.category)

	SettingsPanel:SetMovable(true)
	SettingsPanel:EnableMouse(true)
	SettingsPanel:RegisterForDrag("LeftButton")
	SettingsPanel:SetScript("OnDragStart", SettingsPanel.StartMoving)
	SettingsPanel:SetScript("OnDragStop", SettingsPanel.StopMovingOrSizing)
end
