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

	cfCastbars.ApplyBarSettings(bar, "Target", "Target")

	-- Position
	local bp = bar.cfcbBasePos
	if bp and bp[4] then
		bar.cfcbHook = true
		bar:SetPoint(bp[1], bp[2], bp[3], bp[4] + db[K.TargetX], bp[5] + db[K.TargetY] + (bar.cfcbYOffset or 0))
		bar.cfcbHook = nil
	end
end

function cfCastbars.UpdateTarget()
	cfCastbars.ApplyTargetSettings()

	-- Enabled
	if not cfCastbarsDB[K.Target] then
		bar:Hide()
	elseif cfCastbars.testing.Target then
		bar:Show()
	end
end

function cfCastbars.InitTarget()
	-- One-time setup
	cfCastbars.AddTimer(bar)
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
