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

	cfCastbars.ApplyBarSettings(bar, "Player", "Player")

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
	elseif cfCastbars.testing.Player then
		bar:Show()
	end
end

function cfCastbars.InitPlayer()
	-- One-time setup
	cfCastbars.AddTimer(bar, "GameFontHighlight")
	bar.Border:ClearAllPoints()
	bar.BorderShield:ClearAllPoints()
	bar.Flash:ClearAllPoints()
	bar.Icon:SetDrawLayer("OVERLAY", 2)
	cfCastbars.HookPosition(bar, K.PlayerX, K.PlayerY)

	hooksecurefunc(bar, "Show", function(self)
		if not cfCastbarsDB[K.Player] then self:Hide() return end
		if cfCastbarsDB[K.PlayerIcon] then self.Icon:Show() end
	end)

	cfCastbars.UpdatePlayer()
end
