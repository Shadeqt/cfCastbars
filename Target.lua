local bar = TargetFrameSpellBar
local K = cfCastbars.K
local baseW, baseH

function cfCastbars.ApplyTargetSettings()
	local db = cfCastbarsDB
	if not baseW then
		baseW, baseH = bar:GetWidth(), bar:GetHeight()
	end

	-- Bar
	local w = baseW + db[K.TargetWidth]
	local h = baseH + db[K.TargetHeight]
	bar:SetScale(db[K.TargetScale])
	bar:SetSize(w, h)

	local T = cfCastbars.BlizzCastbars.Target
	bar.Spark:SetSize(T.sparkSize * (h / T.barH), T.sparkSize * (h / T.barH))
	bar.Border:SetSize(T.borderW * (w / T.barW), T.borderH * (h / T.barH))
	local s = w / baseW
	bar.BorderShield:SetSize(T.borderW * (w / T.barW) + 6 * s, T.borderH * (h / T.barH))
	bar.BorderShield:SetPoint("CENTER", -4 * s, 0)

	-- Icon
	if db[K.TargetIcon] then
		bar.Icon:ClearAllPoints()
		bar.Icon:SetPoint("RIGHT", bar, "LEFT", -5 + db[K.TargetIconX], 1 + db[K.TargetIconY])
		bar.Icon:SetSize(w * 0.12, h * 1.8)
		bar.Icon:SetScale(db[K.TargetIconScale])
		bar.Icon:Show()
	else
		bar.Icon:Hide()
	end

	-- Timer
	if db[K.TargetTimer] then
		bar.Timer:ClearAllPoints()
		bar.Timer:SetPoint("LEFT", bar, "RIGHT", 10 + db[K.TargetTimerX], db[K.TargetTimerY])
		bar.Timer:SetScale(db[K.TargetTimerScale])
		bar.Timer:Show()
	else
		bar.Timer:Hide()
	end

	-- Text
	if db[K.TargetText] then
		bar.Text:Show()
		bar.Text:SetScale(db[K.TargetTextScale])
		bar.Text:ClearAllPoints()
		bar.Text:SetPoint("CENTER", bar, "CENTER", db[K.TargetTextX], db[K.TargetTextY])
	else
		bar.Text:Hide()
	end

	-- Spark / Flash / Border / Shield
	bar.Spark:SetShown(db[K.TargetSpark])
	bar.Flash:SetShown(db[K.TargetFlash])
	if db[K.TargetBorderShield] then
		bar.BorderShield:Show()
		bar.Border:Hide()
	else
		bar.BorderShield:Hide()
		bar.Border:SetShown(db[K.TargetBorder])
	end

	-- Position
	local bp = bar.cfcbBasePos
	if bp and bp[4] then
		bar.cfcbHook = true
		bar:SetPoint(bp[1], bp[2], bp[3], bp[4] + db[K.TargetX], bp[5] + db[K.TargetY] + (bar.cbtYOffset or 0))
		bar.cfcbHook = nil
	end
end

function cfCastbars.UpdateTarget()
	cfCastbars.ApplyTargetSettings()

	-- Enabled
	if not cfCastbarsDB[K.Target] then
		bar:Hide()
	elseif bar.cbtTestStart then
		bar:Show()
	end
end

function cfCastbars.InitTarget()
	-- One-time setup
	cfCastbars.AddTimer(bar, "GameFontHighlight")
	bar.Border:ClearAllPoints()
	bar.Border:SetPoint("CENTER")
	bar.BorderShield:ClearAllPoints()
	bar.BorderShield:SetPoint("CENTER")
	bar.Icon:SetDrawLayer("OVERLAY", 2)
	cfCastbars.HookPosition(bar, K.TargetX, K.TargetY)

	hooksecurefunc(bar, "Show", function(self)
		if not cfCastbarsDB[K.Target] then self:Hide() end
	end)

	cfCastbars.UpdateTarget()
end
