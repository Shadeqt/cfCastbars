local bar = CastingBarFrame
local size = bar:GetHeight() * 2
bar.Icon:SetSize(size, size)
bar.Icon:ClearAllPoints()
bar.Icon:SetPoint("RIGHT", bar, "LEFT", -10, 3)

hooksecurefunc(bar, "Show", function(self) self.Icon:Show() end)
