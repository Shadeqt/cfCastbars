function cfCastbars.SetupPetGUI()
	local F = cfCastbars.F
	local K = cfCastbars.K

	local panel = CreateFrame("Frame", "cfCastbarsPanel")
	panel:Hide()

	local sc = F.ScrollPanel(panel)

	local title = F.Text(sc, "cfCastbars", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)

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
	local plDeco = F.CastbarDeco(sc, 0.75, 0.75, 0.75)
	plDeco:SetPoint("TOPLEFT", plHeader, "BOTTOMLEFT", 0, -5)
	local plTest = F.Checkbox(sc, nil, "Test", function(c) cfCastbars.TestPlayer(c) end)
	cfCastbars.testCBs = cfCastbars.testCBs or {}
	cfCastbars.testCBs.Player = plTest
	plTest:SetPoint("TOPLEFT", plDeco, "BOTTOMLEFT", 0, -5)
	local plEnabled = F.Checkbox(sc, K.Player, "Castbar", pl)
	plEnabled:SetPoint("TOPLEFT", plTest, "BOTTOMLEFT", 0, -5)
	local plIcon = F.Checkbox(sc, K.PlayerIcon, "Icon", pl)
	plIcon:SetPoint("LEFT", plEnabled, "RIGHT", 60, 0)
	local plTimer = F.Checkbox(sc, K.PlayerTimer, "Timer", pl)
	plTimer:SetPoint("TOPLEFT", plEnabled, "BOTTOMLEFT", 0, -5)
	local plText = F.Checkbox(sc, K.PlayerText, "Text", pl)
	plText:SetPoint("LEFT", plTimer, "RIGHT", 60, 0)
	local plBorder = F.Checkbox(sc, K.PlayerBorder, "Border", pl)
	plBorder:SetPoint("TOPLEFT", plTimer, "BOTTOMLEFT", 0, -5)
	local plSpark = F.Checkbox(sc, K.PlayerSpark, "Spark", pl)
	plSpark:SetPoint("LEFT", plBorder, "RIGHT", 60, 0)
	local plShield = F.Checkbox(sc, K.PlayerBorderShield, "Shield", pl)
	plShield:SetPoint("TOPLEFT", plBorder, "BOTTOMLEFT", 0, -5)
	local plFlash = F.Checkbox(sc, K.PlayerFlash, "Flash", pl)
	plFlash:SetPoint("LEFT", plShield, "RIGHT", 60, 0)

	local plhCb = F.Text(sc, "Castbar", "GameFontNormal")
	plhCb:SetPoint("TOPLEFT", plShield, "BOTTOMLEFT", 0, -15)
	local plScale = F.Slider(sc, K.PlayerScale, "Castbar Scale", 0.1, 1.9, 0.05, pl)
	plScale:SetPoint("TOPLEFT", plhCb, "BOTTOMLEFT", 0, -10)
	local plX = F.Slider(sc, K.PlayerX, "Castbar X", -300, 300, 1, pl)
	plX:SetPoint("TOPLEFT", plScale, "BOTTOMLEFT", 0, -15)
	local plY = F.Slider(sc, K.PlayerY, "Castbar Y", -300, 300, 1, pl)
	plY:SetPoint("TOPLEFT", plX, "BOTTOMLEFT", 0, -15)
	local plW = F.Slider(sc, K.PlayerWidth, "Castbar Width", -150, 150, 1, pl)
	plW:SetPoint("TOPLEFT", plY, "BOTTOMLEFT", 0, -15)
	local plH = F.Slider(sc, K.PlayerHeight, "Castbar Height", -10, 30, 1, pl)
	plH:SetPoint("TOPLEFT", plW, "BOTTOMLEFT", 0, -15)

	local plhIcon = F.Text(sc, "Icon", "GameFontNormal")
	plhIcon:SetPoint("TOPLEFT", plH, "BOTTOMLEFT", 0, -15)
	local plIconScale = F.Slider(sc, K.PlayerIconScale, "Icon Scale", 0.1, 1.9, 0.05, pl)
	plIconScale:SetPoint("TOPLEFT", plhIcon, "BOTTOMLEFT", 0, -10)
	local plIconX = F.Slider(sc, K.PlayerIconX, "Icon X", -300, 300, 1, pl)
	plIconX:SetPoint("TOPLEFT", plIconScale, "BOTTOMLEFT", 0, -15)
	local plIconY = F.Slider(sc, K.PlayerIconY, "Icon Y", -300, 300, 1, pl)
	plIconY:SetPoint("TOPLEFT", plIconX, "BOTTOMLEFT", 0, -15)

	local plhTimer = F.Text(sc, "Timer", "GameFontNormal")
	plhTimer:SetPoint("TOPLEFT", plIconY, "BOTTOMLEFT", 0, -15)
	local plTimerScale = F.Slider(sc, K.PlayerTimerScale, "Timer Scale", 0.1, 1.9, 0.05, pl)
	plTimerScale:SetPoint("TOPLEFT", plhTimer, "BOTTOMLEFT", 0, -10)
	local plTimerX = F.Slider(sc, K.PlayerTimerX, "Timer X", -300, 300, 1, pl)
	plTimerX:SetPoint("TOPLEFT", plTimerScale, "BOTTOMLEFT", 0, -15)
	local plTimerY = F.Slider(sc, K.PlayerTimerY, "Timer Y", -300, 300, 1, pl)
	plTimerY:SetPoint("TOPLEFT", plTimerX, "BOTTOMLEFT", 0, -15)

	local plhText = F.Text(sc, "Text", "GameFontNormal")
	plhText:SetPoint("TOPLEFT", plTimerY, "BOTTOMLEFT", 0, -15)
	local plTextScale = F.Slider(sc, K.PlayerTextScale, "Text Scale", 0.1, 1.9, 0.05, pl)
	plTextScale:SetPoint("TOPLEFT", plhText, "BOTTOMLEFT", 0, -10)
	local plTextX = F.Slider(sc, K.PlayerTextX, "Text X", -300, 300, 1, pl)
	plTextX:SetPoint("TOPLEFT", plTextScale, "BOTTOMLEFT", 0, -15)
	local plTextY = F.Slider(sc, K.PlayerTextY, "Text Y", -300, 300, 1, pl)
	plTextY:SetPoint("TOPLEFT", plTextX, "BOTTOMLEFT", 0, -15)

	local plReset = F.Button(sc, "Reset", function() F.ResetPrefix("Player", pl) end)
	plReset:SetPoint("TOPLEFT", plTextY, "BOTTOMLEFT", 0, -15)

	F.BindChildren(plIcon, {plhIcon, plIconScale, plIconX, plIconY})
	F.BindChildren(plTimer, {plhTimer, plTimerScale, plTimerX, plTimerY})
	F.BindChildren(plText, {plhText, plTextScale, plTextX, plTextY})
	F.BindChildren(plShield, {plBorder}, true)
	F.BindChildren(plEnabled, {plIcon, plTimer, plText, plBorder, plSpark, plShield, plFlash, plhCb, plScale, plX, plY, plW, plH, plhIcon, plIconScale, plIconX, plIconY, plhTimer, plTimerScale, plTimerX, plTimerY, plhText, plTextScale, plTextX, plTextY})
	-----------------------------------------------------------------------
	-- Column 2: Target
	-----------------------------------------------------------------------
	local tg = cfCastbars.UpdateTarget
	local tgHeader = F.Text(sc, "Target", "GameFontNormalLarge")
	tgHeader:SetPoint("TOPLEFT", ROW_TOP, "BOTTOMLEFT", COL2, -10)
	local tgDeco = F.CastbarDeco(sc, 0.93, 0.93, 0)
	tgDeco:SetPoint("TOPLEFT", tgHeader, "BOTTOMLEFT", 0, -5)
	local tgTest = F.Checkbox(sc, nil, "Test", function(c) cfCastbars.TestTarget(c) end)
	cfCastbars.testCBs.Target = tgTest
	tgTest:SetPoint("TOPLEFT", tgDeco, "BOTTOMLEFT", 0, -5)
	local tgEnabled = F.Checkbox(sc, K.Target, "Castbar", tg)
	tgEnabled:SetPoint("TOPLEFT", tgTest, "BOTTOMLEFT", 0, -5)
	local tgIcon = F.Checkbox(sc, K.TargetIcon, "Icon", tg)
	tgIcon:SetPoint("LEFT", tgEnabled, "RIGHT", 60, 0)
	local tgTimer = F.Checkbox(sc, K.TargetTimer, "Timer", tg)
	tgTimer:SetPoint("TOPLEFT", tgEnabled, "BOTTOMLEFT", 0, -5)
	local tgText = F.Checkbox(sc, K.TargetText, "Text", tg)
	tgText:SetPoint("LEFT", tgTimer, "RIGHT", 60, 0)
	local tgBorder = F.Checkbox(sc, K.TargetBorder, "Border", tg)
	tgBorder:SetPoint("TOPLEFT", tgTimer, "BOTTOMLEFT", 0, -5)
	local tgSpark = F.Checkbox(sc, K.TargetSpark, "Spark", tg)
	tgSpark:SetPoint("LEFT", tgBorder, "RIGHT", 60, 0)
	local tgShield = F.Checkbox(sc, K.TargetBorderShield, "Shield", tg)
	tgShield:SetPoint("TOPLEFT", tgBorder, "BOTTOMLEFT", 0, -5)
	local tgFlash = F.Checkbox(sc, K.TargetFlash, "Flash", tg)
	tgFlash:SetPoint("LEFT", tgShield, "RIGHT", 60, 0)

	local tghCb = F.Text(sc, "Castbar", "GameFontNormal")
	tghCb:SetPoint("TOPLEFT", tgShield, "BOTTOMLEFT", 0, -15)
	local tgScale = F.Slider(sc, K.TargetScale, "Castbar Scale", 0.1, 1.9, 0.05, tg)
	tgScale:SetPoint("TOPLEFT", tghCb, "BOTTOMLEFT", 0, -10)
	local tgX = F.Slider(sc, K.TargetX, "Castbar X", -300, 300, 1, tg)
	tgX:SetPoint("TOPLEFT", tgScale, "BOTTOMLEFT", 0, -15)
	local tgY = F.Slider(sc, K.TargetY, "Castbar Y", -300, 300, 1, tg)
	tgY:SetPoint("TOPLEFT", tgX, "BOTTOMLEFT", 0, -15)
	local tgW = F.Slider(sc, K.TargetWidth, "Castbar Width", -100, 100, 1, tg)
	tgW:SetPoint("TOPLEFT", tgY, "BOTTOMLEFT", 0, -15)
	local tgH = F.Slider(sc, K.TargetHeight, "Castbar Height", -5, 20, 1, tg)
	tgH:SetPoint("TOPLEFT", tgW, "BOTTOMLEFT", 0, -15)

	local tghIcon = F.Text(sc, "Icon", "GameFontNormal")
	tghIcon:SetPoint("TOPLEFT", tgH, "BOTTOMLEFT", 0, -15)
	local tgIconScale = F.Slider(sc, K.TargetIconScale, "Icon Scale", 0.1, 1.9, 0.05, tg)
	tgIconScale:SetPoint("TOPLEFT", tghIcon, "BOTTOMLEFT", 0, -10)
	local tgIconX = F.Slider(sc, K.TargetIconX, "Icon X", -300, 300, 1, tg)
	tgIconX:SetPoint("TOPLEFT", tgIconScale, "BOTTOMLEFT", 0, -15)
	local tgIconY = F.Slider(sc, K.TargetIconY, "Icon Y", -300, 300, 1, tg)
	tgIconY:SetPoint("TOPLEFT", tgIconX, "BOTTOMLEFT", 0, -15)

	local tghTimer = F.Text(sc, "Timer", "GameFontNormal")
	tghTimer:SetPoint("TOPLEFT", tgIconY, "BOTTOMLEFT", 0, -15)
	local tgTimerScale = F.Slider(sc, K.TargetTimerScale, "Timer Scale", 0.1, 1.9, 0.05, tg)
	tgTimerScale:SetPoint("TOPLEFT", tghTimer, "BOTTOMLEFT", 0, -10)
	local tgTimerX = F.Slider(sc, K.TargetTimerX, "Timer X", -300, 300, 1, tg)
	tgTimerX:SetPoint("TOPLEFT", tgTimerScale, "BOTTOMLEFT", 0, -15)
	local tgTimerY = F.Slider(sc, K.TargetTimerY, "Timer Y", -300, 300, 1, tg)
	tgTimerY:SetPoint("TOPLEFT", tgTimerX, "BOTTOMLEFT", 0, -15)

	local tghText = F.Text(sc, "Text", "GameFontNormal")
	tghText:SetPoint("TOPLEFT", tgTimerY, "BOTTOMLEFT", 0, -15)
	local tgTextScale = F.Slider(sc, K.TargetTextScale, "Text Scale", 0.1, 1.9, 0.05, tg)
	tgTextScale:SetPoint("TOPLEFT", tghText, "BOTTOMLEFT", 0, -10)
	local tgTextX = F.Slider(sc, K.TargetTextX, "Text X", -300, 300, 1, tg)
	tgTextX:SetPoint("TOPLEFT", tgTextScale, "BOTTOMLEFT", 0, -15)
	local tgTextY = F.Slider(sc, K.TargetTextY, "Text Y", -300, 300, 1, tg)
	tgTextY:SetPoint("TOPLEFT", tgTextX, "BOTTOMLEFT", 0, -15)

	local tgReset = F.Button(sc, "Reset", function() F.ResetPrefix("Target", tg) end)
	tgReset:SetPoint("TOPLEFT", tgTextY, "BOTTOMLEFT", 0, -15)

	F.BindChildren(tgIcon, {tghIcon, tgIconScale, tgIconX, tgIconY})
	F.BindChildren(tgTimer, {tghTimer, tgTimerScale, tgTimerX, tgTimerY})
	F.BindChildren(tgText, {tghText, tgTextScale, tgTextX, tgTextY})
	F.BindChildren(tgShield, {tgBorder}, true)
	F.BindChildren(tgEnabled, {tgIcon, tgTimer, tgText, tgBorder, tgSpark, tgShield, tgFlash, tghCb, tgScale, tgX, tgY, tgW, tgH, tghIcon, tgIconScale, tgIconX, tgIconY, tghTimer, tgTimerScale, tgTimerX, tgTimerY, tghText, tgTextScale, tgTextX, tgTextY})
	-----------------------------------------------------------------------
	-- Column 3: Pet
	-----------------------------------------------------------------------
	local pt = cfCastbars.UpdatePet
	local ptHeader = F.Text(sc, "Pet", "GameFontNormalLarge")
	ptHeader:SetPoint("TOPLEFT", ROW_TOP, "BOTTOMLEFT", COL3, -10)
	local ptDeco = F.CastbarDeco(sc, 0, 0.44, 0.87)
	ptDeco:SetPoint("TOPLEFT", ptHeader, "BOTTOMLEFT", 0, -5)
	local ptTest = F.Checkbox(sc, nil, "Test", function(c) cfCastbars.TestPet(c) end)
	cfCastbars.testCBs.Pet = ptTest
	ptTest:SetPoint("TOPLEFT", ptDeco, "BOTTOMLEFT", 0, -5)
	local ptEnabled = F.Checkbox(sc, K.Pet, "Castbar", pt)
	ptEnabled:SetPoint("TOPLEFT", ptTest, "BOTTOMLEFT", 0, -5)
	local ptIcon = F.Checkbox(sc, K.PetIcon, "Icon", pt)
	ptIcon:SetPoint("LEFT", ptEnabled, "RIGHT", 60, 0)
	local ptTimer = F.Checkbox(sc, K.PetTimer, "Timer", pt)
	ptTimer:SetPoint("TOPLEFT", ptEnabled, "BOTTOMLEFT", 0, -5)
	local ptText = F.Checkbox(sc, K.PetText, "Text", pt)
	ptText:SetPoint("LEFT", ptTimer, "RIGHT", 60, 0)
	local ptBorder = F.Checkbox(sc, K.PetBorder, "Border", pt)
	ptBorder:SetPoint("TOPLEFT", ptTimer, "BOTTOMLEFT", 0, -5)
	local ptSpark = F.Checkbox(sc, K.PetSpark, "Spark", pt)
	ptSpark:SetPoint("LEFT", ptBorder, "RIGHT", 60, 0)
	local ptShield = F.Checkbox(sc, K.PetBorderShield, "Shield", pt)
	ptShield:SetPoint("TOPLEFT", ptBorder, "BOTTOMLEFT", 0, -5)
	local ptFlash = F.Checkbox(sc, K.PetFlash, "Flash", pt)
	ptFlash:SetPoint("LEFT", ptShield, "RIGHT", 60, 0)

	local pthCb = F.Text(sc, "Castbar", "GameFontNormal")
	pthCb:SetPoint("TOPLEFT", ptShield, "BOTTOMLEFT", 0, -15)
	local ptScale = F.Slider(sc, K.PetScale, "Castbar Scale", 0.1, 1.9, 0.05, pt)
	ptScale:SetPoint("TOPLEFT", pthCb, "BOTTOMLEFT", 0, -10)
	local ptX = F.Slider(sc, K.PetX, "Castbar X", -300, 300, 1, pt)
	ptX:SetPoint("TOPLEFT", ptScale, "BOTTOMLEFT", 0, -15)
	local ptY = F.Slider(sc, K.PetY, "Castbar Y", -300, 300, 1, pt)
	ptY:SetPoint("TOPLEFT", ptX, "BOTTOMLEFT", 0, -15)
	local ptW = F.Slider(sc, K.PetWidth, "Castbar Width", -100, 100, 1, pt)
	ptW:SetPoint("TOPLEFT", ptY, "BOTTOMLEFT", 0, -15)
	local ptH = F.Slider(sc, K.PetHeight, "Castbar Height", -5, 20, 1, pt)
	ptH:SetPoint("TOPLEFT", ptW, "BOTTOMLEFT", 0, -15)

	local pthIcon = F.Text(sc, "Icon", "GameFontNormal")
	pthIcon:SetPoint("TOPLEFT", ptH, "BOTTOMLEFT", 0, -15)
	local ptIconScale = F.Slider(sc, K.PetIconScale, "Icon Scale", 0.1, 1.9, 0.05, pt)
	ptIconScale:SetPoint("TOPLEFT", pthIcon, "BOTTOMLEFT", 0, -10)
	local ptIconX = F.Slider(sc, K.PetIconX, "Icon X", -300, 300, 1, pt)
	ptIconX:SetPoint("TOPLEFT", ptIconScale, "BOTTOMLEFT", 0, -15)
	local ptIconY = F.Slider(sc, K.PetIconY, "Icon Y", -300, 300, 1, pt)
	ptIconY:SetPoint("TOPLEFT", ptIconX, "BOTTOMLEFT", 0, -15)

	local pthTimer = F.Text(sc, "Timer", "GameFontNormal")
	pthTimer:SetPoint("TOPLEFT", ptIconY, "BOTTOMLEFT", 0, -15)
	local ptTimerScale = F.Slider(sc, K.PetTimerScale, "Timer Scale", 0.1, 1.9, 0.05, pt)
	ptTimerScale:SetPoint("TOPLEFT", pthTimer, "BOTTOMLEFT", 0, -10)
	local ptTimerX = F.Slider(sc, K.PetTimerX, "Timer X", -300, 300, 1, pt)
	ptTimerX:SetPoint("TOPLEFT", ptTimerScale, "BOTTOMLEFT", 0, -15)
	local ptTimerY = F.Slider(sc, K.PetTimerY, "Timer Y", -300, 300, 1, pt)
	ptTimerY:SetPoint("TOPLEFT", ptTimerX, "BOTTOMLEFT", 0, -15)

	local pthText = F.Text(sc, "Text", "GameFontNormal")
	pthText:SetPoint("TOPLEFT", ptTimerY, "BOTTOMLEFT", 0, -15)
	local ptTextScale = F.Slider(sc, K.PetTextScale, "Text Scale", 0.1, 1.9, 0.05, pt)
	ptTextScale:SetPoint("TOPLEFT", pthText, "BOTTOMLEFT", 0, -10)
	local ptTextX = F.Slider(sc, K.PetTextX, "Text X", -300, 300, 1, pt)
	ptTextX:SetPoint("TOPLEFT", ptTextScale, "BOTTOMLEFT", 0, -15)
	local ptTextY = F.Slider(sc, K.PetTextY, "Text Y", -300, 300, 1, pt)
	ptTextY:SetPoint("TOPLEFT", ptTextX, "BOTTOMLEFT", 0, -15)

	local ptReset = F.Button(sc, "Reset", function() F.ResetPrefix("Pet", pt) end)
	ptReset:SetPoint("TOPLEFT", ptTextY, "BOTTOMLEFT", 0, -15)

	F.BindChildren(ptIcon, {pthIcon, ptIconScale, ptIconX, ptIconY})
	F.BindChildren(ptTimer, {pthTimer, ptTimerScale, ptTimerX, ptTimerY})
	F.BindChildren(ptText, {pthText, ptTextScale, ptTextX, ptTextY})
	F.BindChildren(ptShield, {ptBorder}, true)
	F.BindChildren(ptEnabled, {ptIcon, ptTimer, ptText, ptBorder, ptSpark, ptShield, ptFlash, pthCb, ptScale, ptX, ptY, ptW, ptH, pthIcon, ptIconScale, ptIconX, ptIconY, pthTimer, ptTimerScale, ptTimerX, ptTimerY, pthText, ptTextScale, ptTextX, ptTextY})
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
	local paDeco = F.CastbarDeco(sc, 0, 0.7, 0)
	paDeco:SetPoint("TOPLEFT", paHeader, "BOTTOMLEFT", 0, -5)
	local paTest = F.Checkbox(sc, nil, "Test", function(c) cfCastbars.TestParty(c) end)
	cfCastbars.testCBs.Party = paTest
	paTest:SetPoint("TOPLEFT", paDeco, "BOTTOMLEFT", 0, -5)
	local paEnabled = F.Checkbox(sc, K.Party, "Castbar", pa)
	paEnabled:SetPoint("TOPLEFT", paTest, "BOTTOMLEFT", 0, -5)
	local paIcon = F.Checkbox(sc, K.PartyIcon, "Icon", pa)
	paIcon:SetPoint("LEFT", paEnabled, "RIGHT", 60, 0)
	local paTimer = F.Checkbox(sc, K.PartyTimer, "Timer", pa)
	paTimer:SetPoint("TOPLEFT", paEnabled, "BOTTOMLEFT", 0, -5)
	local paText = F.Checkbox(sc, K.PartyText, "Text", pa)
	paText:SetPoint("LEFT", paTimer, "RIGHT", 60, 0)
	local paBorder = F.Checkbox(sc, K.PartyBorder, "Border", pa)
	paBorder:SetPoint("TOPLEFT", paTimer, "BOTTOMLEFT", 0, -5)
	local paSpark = F.Checkbox(sc, K.PartySpark, "Spark", pa)
	paSpark:SetPoint("LEFT", paBorder, "RIGHT", 60, 0)
	local paShield = F.Checkbox(sc, K.PartyBorderShield, "Shield", pa)
	paShield:SetPoint("TOPLEFT", paBorder, "BOTTOMLEFT", 0, -5)
	local paFlash = F.Checkbox(sc, K.PartyFlash, "Flash", pa)
	paFlash:SetPoint("LEFT", paShield, "RIGHT", 60, 0)

	local pahCb = F.Text(sc, "Castbar", "GameFontNormal")
	pahCb:SetPoint("TOPLEFT", paShield, "BOTTOMLEFT", 0, -15)
	local paScale = F.Slider(sc, K.PartyScale, "Castbar Scale", 0.1, 1.9, 0.05, pa)
	paScale:SetPoint("TOPLEFT", pahCb, "BOTTOMLEFT", 0, -10)
	local paX = F.Slider(sc, K.PartyX, "Castbar X", -300, 300, 1, pa)
	paX:SetPoint("TOPLEFT", paScale, "BOTTOMLEFT", 0, -15)
	local paY = F.Slider(sc, K.PartyY, "Castbar Y", -300, 300, 1, pa)
	paY:SetPoint("TOPLEFT", paX, "BOTTOMLEFT", 0, -15)
	local paW = F.Slider(sc, K.PartyWidth, "Castbar Width", -100, 100, 1, pa)
	paW:SetPoint("TOPLEFT", paY, "BOTTOMLEFT", 0, -15)
	local paH = F.Slider(sc, K.PartyHeight, "Castbar Height", -5, 20, 1, pa)
	paH:SetPoint("TOPLEFT", paW, "BOTTOMLEFT", 0, -15)

	local pahIcon = F.Text(sc, "Icon", "GameFontNormal")
	pahIcon:SetPoint("TOPLEFT", paH, "BOTTOMLEFT", 0, -15)
	local paIconScale = F.Slider(sc, K.PartyIconScale, "Icon Scale", 0.1, 1.9, 0.05, pa)
	paIconScale:SetPoint("TOPLEFT", pahIcon, "BOTTOMLEFT", 0, -10)
	local paIconX = F.Slider(sc, K.PartyIconX, "Icon X", -300, 300, 1, pa)
	paIconX:SetPoint("TOPLEFT", paIconScale, "BOTTOMLEFT", 0, -15)
	local paIconY = F.Slider(sc, K.PartyIconY, "Icon Y", -300, 300, 1, pa)
	paIconY:SetPoint("TOPLEFT", paIconX, "BOTTOMLEFT", 0, -15)

	local pahTimer = F.Text(sc, "Timer", "GameFontNormal")
	pahTimer:SetPoint("TOPLEFT", paIconY, "BOTTOMLEFT", 0, -15)
	local paTimerScale = F.Slider(sc, K.PartyTimerScale, "Timer Scale", 0.1, 1.9, 0.05, pa)
	paTimerScale:SetPoint("TOPLEFT", pahTimer, "BOTTOMLEFT", 0, -10)
	local paTimerX = F.Slider(sc, K.PartyTimerX, "Timer X", -300, 300, 1, pa)
	paTimerX:SetPoint("TOPLEFT", paTimerScale, "BOTTOMLEFT", 0, -15)
	local paTimerY = F.Slider(sc, K.PartyTimerY, "Timer Y", -300, 300, 1, pa)
	paTimerY:SetPoint("TOPLEFT", paTimerX, "BOTTOMLEFT", 0, -15)

	local pahText = F.Text(sc, "Text", "GameFontNormal")
	pahText:SetPoint("TOPLEFT", paTimerY, "BOTTOMLEFT", 0, -15)
	local paTextScale = F.Slider(sc, K.PartyTextScale, "Text Scale", 0.1, 1.9, 0.05, pa)
	paTextScale:SetPoint("TOPLEFT", pahText, "BOTTOMLEFT", 0, -10)
	local paTextX = F.Slider(sc, K.PartyTextX, "Text X", -300, 300, 1, pa)
	paTextX:SetPoint("TOPLEFT", paTextScale, "BOTTOMLEFT", 0, -15)
	local paTextY = F.Slider(sc, K.PartyTextY, "Text Y", -300, 300, 1, pa)
	paTextY:SetPoint("TOPLEFT", paTextX, "BOTTOMLEFT", 0, -15)

	local paReset = F.Button(sc, "Reset", function() F.ResetPrefix("Party", pa) end)
	paReset:SetPoint("TOPLEFT", paTextY, "BOTTOMLEFT", 0, -15)

	F.BindChildren(paIcon, {pahIcon, paIconScale, paIconX, paIconY})
	F.BindChildren(paTimer, {pahTimer, paTimerScale, paTimerX, paTimerY})
	F.BindChildren(paText, {pahText, paTextScale, paTextX, paTextY})
	F.BindChildren(paShield, {paBorder}, true)
	F.BindChildren(paEnabled, {paIcon, paTimer, paText, paBorder, paSpark, paShield, paFlash, pahCb, paScale, paX, paY, paW, paH, pahIcon, paIconScale, paIconX, paIconY, pahTimer, paTimerScale, paTimerX, paTimerY, pahText, paTextScale, paTextX, paTextY})
	-----------------------------------------------------------------------
	-- Row 2, Column 2: Nameplate
	-----------------------------------------------------------------------
	local np = cfCastbars.UpdateNameplate
	local npHeader = F.Text(sc, "Nameplate", "GameFontNormalLarge")
	npHeader:SetPoint("TOPLEFT", hsep2, "BOTTOMLEFT", COL2, -10)
	local npDeco = F.CastbarDeco(sc, 0.8, 0.13, 0.13)
	npDeco:SetPoint("TOPLEFT", npHeader, "BOTTOMLEFT", 0, -5)
	local npTest = F.Checkbox(sc, nil, "Test", function(c) cfCastbars.TestNameplate(c) end)
	cfCastbars.testCBs.Nameplate = npTest
	npTest:SetPoint("TOPLEFT", npDeco, "BOTTOMLEFT", 0, -5)
	local npEnabled = F.Checkbox(sc, K.Nameplate, "Castbar", np)
	npEnabled:SetPoint("TOPLEFT", npTest, "BOTTOMLEFT", 0, -5)
	local npIcon = F.Checkbox(sc, K.NameplateIcon, "Icon", np)
	npIcon:SetPoint("LEFT", npEnabled, "RIGHT", 60, 0)
	local npTimer = F.Checkbox(sc, K.NameplateTimer, "Timer", np)
	npTimer:SetPoint("TOPLEFT", npEnabled, "BOTTOMLEFT", 0, -5)
	local npText = F.Checkbox(sc, K.NameplateText, "Text", np)
	npText:SetPoint("LEFT", npTimer, "RIGHT", 60, 0)
	local npBorder = F.Checkbox(sc, K.NameplateBorder, "Border", np)
	npBorder:SetPoint("TOPLEFT", npTimer, "BOTTOMLEFT", 0, -5)
	local npSpark = F.Checkbox(sc, K.NameplateSpark, "Spark", np)
	npSpark:SetPoint("LEFT", npBorder, "RIGHT", 60, 0)
	local npShield = F.Checkbox(sc, K.NameplateBorderShield, "Shield", np)
	npShield:SetPoint("TOPLEFT", npBorder, "BOTTOMLEFT", 0, -5)
	local npFlash = F.Checkbox(sc, K.NameplateFlash, "Flash", np)
	npFlash:SetPoint("LEFT", npShield, "RIGHT", 60, 0)

	local nphCb = F.Text(sc, "Castbar", "GameFontNormal")
	nphCb:SetPoint("TOPLEFT", npShield, "BOTTOMLEFT", 0, -15)
	local npScale = F.Slider(sc, K.NameplateScale, "Castbar Scale", 0.1, 1.9, 0.05, np)
	npScale:SetPoint("TOPLEFT", nphCb, "BOTTOMLEFT", 0, -10)
	local npX = F.Slider(sc, K.NameplateX, "Castbar X", -300, 300, 1, np)
	npX:SetPoint("TOPLEFT", npScale, "BOTTOMLEFT", 0, -15)
	local npY = F.Slider(sc, K.NameplateY, "Castbar Y", -300, 300, 1, np)
	npY:SetPoint("TOPLEFT", npX, "BOTTOMLEFT", 0, -15)
	local npW = F.Slider(sc, K.NameplateWidth, "Castbar Width", -100, 100, 1, np)
	npW:SetPoint("TOPLEFT", npY, "BOTTOMLEFT", 0, -15)
	local npH = F.Slider(sc, K.NameplateHeight, "Castbar Height", -5, 20, 1, np)
	npH:SetPoint("TOPLEFT", npW, "BOTTOMLEFT", 0, -15)

	local nphIcon = F.Text(sc, "Icon", "GameFontNormal")
	nphIcon:SetPoint("TOPLEFT", npH, "BOTTOMLEFT", 0, -15)
	local npIconScale = F.Slider(sc, K.NameplateIconScale, "Icon Scale", 0.1, 1.9, 0.05, np)
	npIconScale:SetPoint("TOPLEFT", nphIcon, "BOTTOMLEFT", 0, -10)
	local npIconX = F.Slider(sc, K.NameplateIconX, "Icon X", -300, 300, 1, np)
	npIconX:SetPoint("TOPLEFT", npIconScale, "BOTTOMLEFT", 0, -15)
	local npIconY = F.Slider(sc, K.NameplateIconY, "Icon Y", -300, 300, 1, np)
	npIconY:SetPoint("TOPLEFT", npIconX, "BOTTOMLEFT", 0, -15)

	local nphTimer = F.Text(sc, "Timer", "GameFontNormal")
	nphTimer:SetPoint("TOPLEFT", npIconY, "BOTTOMLEFT", 0, -15)
	local npTimerScale = F.Slider(sc, K.NameplateTimerScale, "Timer Scale", 0.1, 1.9, 0.05, np)
	npTimerScale:SetPoint("TOPLEFT", nphTimer, "BOTTOMLEFT", 0, -10)
	local npTimerX = F.Slider(sc, K.NameplateTimerX, "Timer X", -300, 300, 1, np)
	npTimerX:SetPoint("TOPLEFT", npTimerScale, "BOTTOMLEFT", 0, -15)
	local npTimerY = F.Slider(sc, K.NameplateTimerY, "Timer Y", -300, 300, 1, np)
	npTimerY:SetPoint("TOPLEFT", npTimerX, "BOTTOMLEFT", 0, -15)

	local nphText = F.Text(sc, "Text", "GameFontNormal")
	nphText:SetPoint("TOPLEFT", npTimerY, "BOTTOMLEFT", 0, -15)
	local npTextScale = F.Slider(sc, K.NameplateTextScale, "Text Scale", 0.1, 1.9, 0.05, np)
	npTextScale:SetPoint("TOPLEFT", nphText, "BOTTOMLEFT", 0, -10)
	local npTextX = F.Slider(sc, K.NameplateTextX, "Text X", -300, 300, 1, np)
	npTextX:SetPoint("TOPLEFT", npTextScale, "BOTTOMLEFT", 0, -15)
	local npTextY = F.Slider(sc, K.NameplateTextY, "Text Y", -300, 300, 1, np)
	npTextY:SetPoint("TOPLEFT", npTextX, "BOTTOMLEFT", 0, -15)

	local npReset = F.Button(sc, "Reset", function() F.ResetPrefix("Nameplate", np) end)
	npReset:SetPoint("TOPLEFT", npTextY, "BOTTOMLEFT", 0, -15)

	F.BindChildren(npIcon, {nphIcon, npIconScale, npIconX, npIconY})
	F.BindChildren(npTimer, {nphTimer, npTimerScale, npTimerX, npTimerY})
	F.BindChildren(npText, {nphText, npTextScale, npTextX, npTextY})
	F.BindChildren(npShield, {npBorder}, true)
	F.BindChildren(npEnabled, {npIcon, npTimer, npText, npBorder, npSpark, npShield, npFlash, nphCb, npScale, npX, npY, npW, npH, nphIcon, npIconScale, npIconX, npIconY, nphTimer, npTimerScale, npTimerX, npTimerY, nphText, npTextScale, npTextX, npTextY})
	-----------------------------------------------------------------------
	-- Row 2 separator
	-----------------------------------------------------------------------
	local row2Bottom = paReset
	for _, r in ipairs({npReset}) do
		if r:GetBottom() and r:GetBottom() < (row2Bottom:GetBottom() or 0) then row2Bottom = r end
	end

	local vsep3 = F.VSeparator(sc)
	vsep3:SetPoint("TOPLEFT", hsep2, "BOTTOMLEFT", COL_W, 0)
	vsep3:SetPoint("BOTTOM", row2Bottom, "BOTTOM", 0, -10)

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
