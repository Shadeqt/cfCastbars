function cfCastbars.AddTimer(bar, font)
	bar.Timer = bar:CreateFontString(nil, "OVERLAY", font or "GameFontHighlightSmall")
	bar.Timer:SetPoint("LEFT", bar, "RIGHT", 5, 0)
	bar:HookScript("OnUpdate", function(self)
		if not self.Timer then return end
		local val = self:GetValue()
		local _, maxVal = self:GetMinMaxValues()
		if maxVal <= 0 or not self:IsShown() then self.Timer:SetText("") return end
		local remaining = self.channeling and val or (maxVal - val)
		if remaining <= 0 then self.Timer:SetText("") return end
		self.Timer:SetText(format("%.1f", remaining))
	end)
end

function cfCastbars.HookPosition(bar, keyX, keyY)
	local p, rel, relp, x, y = bar:GetPoint(1)
	if p then bar.cfcbBasePos = { p, rel, relp, x, y } end

	hooksecurefunc(bar, "SetPoint", function(self)
		if self.cfcbHook then return end
		local p2, rel2, relp2, x2, y2 = self:GetPoint(1)
		self.cfcbBasePos = { p2, rel2, relp2, x2, y2 }
		local ox = cfCastbarsDB[keyX]
		local oy = cfCastbarsDB[keyY] + (self.cbtYOffset or 0)
		if ox == 0 and oy == 0 then return end
		self.cfcbHook = true
		self:SetPoint(p2, rel2, relp2, x2 + ox, y2 + oy)
		self.cfcbHook = nil
	end)
end

function cfCastbars.CreateCastbar(parent, unit, width, height)
	local bar = CreateFrame("StatusBar", nil, parent, "SmallCastingBarFrameTemplate")
	bar:Hide()
	CastingBarFrame_OnLoad(bar, unit)

	bar:SetSize(width, height)

	-- 196x49 is the real border size at the template's default 150x10
	local bw = 196 * (width / 150)
	local bh = 49 * (height / 10)
	bar.Border:SetDrawLayer("OVERLAY")
	bar.Border:ClearAllPoints()
	bar.Border:SetSize(bw, bh)
	bar.Border:SetPoint("CENTER")
	bar.Flash:ClearAllPoints()
	bar.Flash:SetSize(bw, bh)
	bar.Flash:SetPoint("CENTER")
	bar.Flash:Hide()

	bar.Icon:ClearAllPoints()
	bar.Icon:SetPoint("RIGHT", bar, "LEFT", -5, 0)
	bar.Icon:SetSize(height * 1.5, height * 1.5)

	bar.Text:ClearAllPoints()
	bar.Text:SetPoint("CENTER")

	-- 32x32 is the real spark size at the template's default 150x10 (ratio 3.2)
	bar.Spark:SetSize(height * 3.2, height * 3.2)

	cfCastbars.AddTimer(bar)

	-- Draw above border
	bar.Icon:SetDrawLayer("OVERLAY", 2)
	bar.Text:SetDrawLayer("OVERLAY", 2)
	bar.Timer:SetDrawLayer("OVERLAY", 2)

	bar:HookScript("OnEvent", function(self, event)
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
			CastingBarFrame_OnEvent(self, "PLAYER_ENTERING_WORLD")
		end
	end)

	return bar
end
