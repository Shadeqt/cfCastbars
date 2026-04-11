function cfCastbars.InitPlayer()
	local bar = CastingBarFrame

	-- Show icon
	local h = bar:GetHeight()
	bar.Icon:ClearAllPoints()
	bar.Icon:SetPoint("RIGHT", bar, "LEFT", -10, 3)
	bar.Icon:SetSize(h * 2, h * 2)
	bar.Icon:Show()
	hooksecurefunc(bar, "Show", function(self) self.Icon:Show() end)

	-- Timer
	cfCastbars.AddTimer(bar, "GameFontHighlight")
	bar.Timer:ClearAllPoints()
	bar.Timer:SetPoint("LEFT", bar, "RIGHT", 10, 3)
end
