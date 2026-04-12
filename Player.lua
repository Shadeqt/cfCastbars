local bar = CastingBarFrame
local K = cfCastbars.K
local baseW, baseH

function cfCastbars.ApplyPlayerSettings()
	local db = cfCastbarsDB
	if not baseW then
		baseW, baseH = bar:GetWidth(), bar:GetHeight()
	end

	-- Bar
	local w = baseW + db[K.PlayerWidth]
	local h = baseH + db[K.PlayerHeight]
	bar:SetScale(db[K.PlayerScale])
	bar:SetSize(w, h)

	local T = cfCastbars.BlizzCastbars.Player
	bar.Spark:SetSize(T.sparkSize * (h / T.barH), T.sparkSize * (h / T.barH))
	bar.Border:SetSize(T.borderW * (w / T.barW), T.borderH * (h / T.barH))
	local s = w / baseW
	bar.BorderShield:SetSize(T.borderW * (w / T.barW) + 6 * s, T.borderH * (h / T.barH))
	bar.BorderShield:SetPoint("CENTER", -6 * s, 0)

	-- Icon
	if db[K.PlayerIcon] then
		bar.Icon:ClearAllPoints()
		bar.Icon:SetPoint("RIGHT", bar, "LEFT", -7 + db[K.PlayerIconX], 1 + db[K.PlayerIconY])
		bar.Icon:SetSize(w * 0.12, h * 1.8)
		bar.Icon:SetScale(db[K.PlayerIconScale])
		bar.Icon:Show()
	else
		bar.Icon:Hide()
	end

	-- Timer
	if db[K.PlayerTimer] then
		bar.Timer:ClearAllPoints()
		bar.Timer:SetPoint("LEFT", bar, "RIGHT", 10 + db[K.PlayerTimerX], db[K.PlayerTimerY])
		bar.Timer:SetScale(db[K.PlayerTimerScale])
		bar.Timer:Show()
	else
		bar.Timer:Hide()
	end

	-- Text
	if db[K.PlayerText] then
		bar.Text:Show()
		bar.Text:SetScale(db[K.PlayerTextScale])
		bar.Text:ClearAllPoints()
		bar.Text:SetPoint("CENTER", bar, "CENTER", db[K.PlayerTextX], db[K.PlayerTextY])
	else
		bar.Text:Hide()
	end

	-- Spark / Flash / Border / Shield
	bar.Spark:SetShown(db[K.PlayerSpark])
	bar.Flash:SetShown(db[K.PlayerFlash])
	if db[K.PlayerBorderShield] then
		bar.BorderShield:Show()
		bar.Border:Hide()
	else
		bar.BorderShield:Hide()
		bar.Border:SetShown(db[K.PlayerBorder])
	end

	-- Position
	local bp = bar.cfcbBasePos
	bar.cfcbHook = true
	bar:SetPoint(bp[1], bp[2], bp[3], bp[4] + db[K.PlayerX], bp[5] + db[K.PlayerY])
	bar.cfcbHook = nil
end

function cfCastbars.UpdatePlayer()
	cfCastbars.ApplyPlayerSettings()

	-- Enabled
	if not cfCastbarsDB[K.Player] then
		bar:Hide()
	elseif bar.cbtTestStart then
		bar:Show()
	end
end

function cfCastbars.InitPlayer()
	-- One-time setup
	cfCastbars.AddTimer(bar, "GameFontHighlight")
	bar.Border:ClearAllPoints()
	bar.Border:SetPoint("CENTER")
	bar.BorderShield:ClearAllPoints()
	bar.BorderShield:SetPoint("CENTER")
	bar.Icon:SetDrawLayer("OVERLAY", 2)
	cfCastbars.HookPosition(bar, K.PlayerX, K.PlayerY)

	hooksecurefunc(bar, "Show", function(self)
		if not cfCastbarsDB[K.Player] then self:Hide() return end
		if cfCastbarsDB[K.PlayerIcon] then self.Icon:Show() end
	end)

	cfCastbars.UpdatePlayer()
end
