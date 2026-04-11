local bar = CastingBarFrame
local K = cfCastbars.K
local baseW, baseH

function cfCastbars.UpdatePlayer()
	local db = cfCastbarsDB
	if not baseW then
		baseW, baseH = bar:GetWidth(), bar:GetHeight()
	end

	-- Bar
	local w = baseW + db[K.PlayerWidth]
	local h = baseH + db[K.PlayerHeight]
	bar:SetScale(db[K.PlayerScale])
	bar:SetSize(w, h)

	-- 256x64 is the real border size at the template's default 195x13
	bar.Spark:SetSize(h * 3.2, h * 3.2)
	bar.Border:SetSize(256 * (w / 195), 64 * (h / 13))

	-- Icon
	if db[K.PlayerIcon] then
		bar.Icon:ClearAllPoints()
		bar.Icon:SetPoint("RIGHT", bar, "LEFT", -10 + db[K.PlayerIconX], db[K.PlayerIconY])
		bar.Icon:SetSize(h * 2, h * 2)
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

	-- Border
	bar.Border:SetShown(db[K.PlayerBorder])

	-- Position
	local bp = bar.cfcbBasePos
	bar.cfcbHook = true
	bar:SetPoint(bp[1], bp[2], bp[3], bp[4] + db[K.PlayerX], bp[5] + db[K.PlayerY])
	bar.cfcbHook = nil

	-- Enabled
	if not db[K.Player] then
		bar:Hide()
	end
end

function cfCastbars.InitPlayer()
	-- One-time setup
	cfCastbars.AddTimer(bar, "GameFontHighlight")
	bar.Border:ClearAllPoints()
	bar.Border:SetPoint("CENTER")
	bar.Icon:SetDrawLayer("OVERLAY", 2)
	cfCastbars.HookPosition(bar, K.PlayerX, K.PlayerY)

	hooksecurefunc(bar, "Show", function(self)
		if not cfCastbarsDB[K.Player] then self:Hide() return end
		if cfCastbarsDB[K.PlayerIcon] then self.Icon:Show() end
	end)

	cfCastbars.UpdatePlayer()
end
