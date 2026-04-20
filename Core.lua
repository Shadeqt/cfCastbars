cfCastbars.BlizzCastbars = {
	Player = {
		barW = 195, barH = 13,
		borderW = 256, borderH = 64, borderY = 28,
		shieldW = 256, shieldH = 64, shieldX = -5, shieldY = 28,
		sparkSize = 32, sparkY = 2,
		iconSize = 16 * 1.3,
		textW = 185, textH = 16, textX = 1, textY = 4.5,
		timerX = 10,
	},
	Target = {
		barW = 150, barH = 10,
		borderW = 196, borderH = 49, borderY = 20,
		shieldW = 196, shieldH = 49, shieldX = -5, shieldY = 20,
		sparkSize = 32, sparkY = 0,
		iconSize = 16,
		textW = 0, textH = 16, textX = 0, textY = 4,
		timerX = 5,
	},
}

local function ApplyFontOutline(fs, value)
	local path, size = fs:GetFont()
	if not path then return end
	if value == "DEFAULT" then
		fs:SetFont(path, size, "")
		fs:SetShadowOffset(1, -1)
	else
		fs:SetFont(path, size, value)
		fs:SetShadowOffset(0, 0)
	end
end

function cfCastbars.ApplyBarSettings(bar, template, prefix)
	local T = cfCastbars.BlizzCastbars[template]
	local K = cfCastbars.K
	local db = cfCastbarsDB
	local w, h = bar:GetSize()
	local scaleW = w / T.barW
	local scaleH = h / T.barH

	-- Border
	local bw = T.borderW * scaleW
	local bh = T.borderH * scaleH
	local by = T.borderY * scaleH
	bar.Border:ClearAllPoints()
	bar.Border:SetSize(bw, bh)
	bar.Border:SetPoint("TOP", bar, "TOP", 0, by)
	bar.Border:SetShown(db[K[prefix .. "Border"]])

	-- Flash (same geometry as Border)
	bar.Flash:ClearAllPoints()
	bar.Flash:SetSize(bw, bh)
	bar.Flash:SetPoint("TOP", bar, "TOP", 0, by)
	bar.Flash:SetShown(db[K[prefix .. "Flash"]])
	local fc = db[K[prefix .. "FlashColor"]]
	if fc then bar.Flash:SetVertexColor(fc.r, fc.g, fc.b) end

	-- BorderShield (draw above Border)
	local sw = T.shieldW * scaleW
	local sh = T.shieldH * scaleH
	local sx = T.shieldX * scaleW
	local sy = T.shieldY * scaleH
	local bLayer = bar.Border:GetDrawLayer()
	bar.BorderShield:SetDrawLayer(bLayer, 1)
	bar.BorderShield:ClearAllPoints()
	bar.BorderShield:SetSize(sw, sh)
	bar.BorderShield:SetPoint("TOP", bar, "TOP", sx, sy)
	bar.BorderShield:SetShown(db[K[prefix .. "BorderShield"]])

	-- Spark
	local ss = T.sparkSize * scaleH
	bar.Spark:SetSize(ss, ss)
	bar.Spark:SetShown(db[K[prefix .. "Spark"]])

	-- Text
	local textX = db[K[prefix .. "TextX"]]
	local textY = db[K[prefix .. "TextY"]]
	local th = T.textH * scaleH
	local ty = T.textY * scaleH + textY
	bar.Text:ClearAllPoints()
	if T.textW > 0 then
		bar.Text:SetSize(T.textW * scaleW, th)
		bar.Text:SetPoint("TOP", bar, "TOP", T.textX * scaleW + textX, ty)
	else
		bar.Text:SetHeight(th)
		bar.Text:SetPoint("TOPLEFT", bar, "TOPLEFT", textX, ty)
		bar.Text:SetPoint("TOPRIGHT", bar, "TOPRIGHT", textX, ty)
	end
	if db[K[prefix .. "Text"]] then
		bar.Text:SetScale(db[K[prefix .. "TextScale"]])
		bar.Text:Show()
	else
		bar.Text:Hide()
	end

	-- Font outline
	ApplyFontOutline(bar.Text, db[K[prefix .. "TextFontOutline"]])

	-- Timer Y (Text visual center from Blizzard base)
	local baseTextY = T.textY * scaleH
	local timerY = h / 2 + baseTextY - th / 2

	-- Icon
	local iconX = db[K[prefix .. "IconX"]]
	local iconY = db[K[prefix .. "IconY"]]
	bar.Icon:ClearAllPoints()
	bar.Icon:SetSize(T.iconSize * scaleW, T.iconSize * scaleH)
	bar.Icon:SetPoint("RIGHT", bar, "LEFT", -5 * scaleW + iconX, timerY + iconY)
	if db[K[prefix .. "Icon"]] then
		bar.Icon:SetScale(db[K[prefix .. "IconScale"]])
		bar.Icon:Show()
	else
		bar.Icon:Hide()
	end

	-- Timer
	if db[K[prefix .. "Timer"]] then
		bar.Timer:ClearAllPoints()
		bar.Timer:SetPoint("LEFT", bar, "RIGHT", T.timerX + db[K[prefix .. "TimerX"]], timerY + db[K[prefix .. "TimerY"]])
		bar.Timer:SetScale(db[K[prefix .. "TimerScale"]])
		ApplyFontOutline(bar.Timer, db[K[prefix .. "TimerFontOutline"]])
		bar.Timer:Show()
	else
		bar.Timer:Hide()
	end
end

function cfCastbars.AddTimer(bar, font)
	bar.Timer = bar:CreateFontString(nil, "OVERLAY", font or "SystemFont_Shadow_Small")
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

function cfCastbars.CreateCastbar(parent, unit, width, height)
	local bar = CreateFrame("StatusBar", nil, parent, "SmallCastingBarFrameTemplate")
	bar:Hide()
	CastingBarFrame_OnLoad(bar, unit)

	bar:SetSize(width, height)

	cfCastbars.AddTimer(bar)

	-- Promote layers so bar elements draw above parent frame
	bar.Border:SetDrawLayer("OVERLAY")
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

function cfCastbars.HookPosition(bar, keyX, keyY)
	local p, rel, relp, x, y = bar:GetPoint(1)
	if p then bar.cfcbBasePos = { p, rel, relp, x, y } end

	hooksecurefunc(bar, "SetPoint", function(self)
		if self.cfcbHook then return end
		local p2, rel2, relp2, x2, y2 = self:GetPoint(1)
		self.cfcbBasePos = { p2, rel2, relp2, x2, y2 }
		local ox = cfCastbarsDB[keyX]
		local oy = cfCastbarsDB[keyY] + (self.cfcbYOffset or 0)
		if ox == 0 and oy == 0 then return end
		self.cfcbHook = true
		self:SetPoint(p2, rel2, relp2, x2 + ox, y2 + oy)
		self.cfcbHook = nil
	end)
end
