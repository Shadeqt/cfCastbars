local bar = TargetFrameSpellBar
local K = cfCastbars.K
local baseW, baseH

function cfCastbars.UpdateTarget()
	local db = cfCastbarsDB
	if not baseW then
		baseW, baseH = bar:GetWidth(), bar:GetHeight()
	end

	-- Bar
	local w = baseW + db[K.TargetWidth]
	local h = baseH + db[K.TargetHeight]
	bar:SetScale(db[K.TargetScale])
	bar:SetSize(w, h)

	-- 196x49 is the real border size at the template's default 150x10
	bar.Spark:SetSize(h * 3.2, h * 3.2)
	bar.Border:SetSize(196 * (w / 150), 49 * (h / 10))

	-- Icon
	if db[K.TargetIcon] then
		bar.Icon:ClearAllPoints()
		bar.Icon:SetPoint("RIGHT", bar, "LEFT", -5 + db[K.TargetIconX], db[K.TargetIconY])
		bar.Icon:SetSize(h * 1.5, h * 1.5)
		bar.Icon:SetScale(db[K.TargetIconScale])
		bar.Icon:Show()
	else
		bar.Icon:Hide()
	end

	-- Timer
	if db[K.TargetTimer] then
		bar.Timer:ClearAllPoints()
		bar.Timer:SetPoint("LEFT", bar, "RIGHT", 5 + db[K.TargetTimerX], db[K.TargetTimerY])
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

	-- Border
	bar.Border:SetShown(db[K.TargetBorder])

	-- Position
	local bp = bar.cfcbBasePos
	if bp and bp[4] then
		bar.cfcbHook = true
		bar:SetPoint(bp[1], bp[2], bp[3], bp[4] + db[K.TargetX], bp[5] + db[K.TargetY] + (bar.cbtYOffset or 0))
		bar.cfcbHook = nil
	end

	-- Enabled
	if not db[K.Target] then
		bar:Hide()
	end
end

function cfCastbars.InitTarget()
	-- One-time setup
	cfCastbars.AddTimer(bar, "GameFontHighlight")
	bar.Border:ClearAllPoints()
	bar.Border:SetPoint("CENTER")
	bar.Icon:SetDrawLayer("OVERLAY", 2)
	cfCastbars.HookPosition(bar, K.TargetX, K.TargetY)

	hooksecurefunc(bar, "Show", function(self)
		if not cfCastbarsDB[K.Target] then self:Hide() end
	end)

	cfCastbars.UpdateTarget()
end
