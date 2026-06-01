local _, addon = ...

local bar = CastingBarFrame
local size = bar:GetHeight() * 2
bar.Icon:SetSize(size, size)
bar.Icon:ClearAllPoints()
bar.Icon:SetPoint("RIGHT", bar, "LEFT", -10, 3)

-- Icon-only: cfFrames owns (darkens) the player castbar's border; we own this icon (we resized it),
-- so we give it the same dark zoom + backdrop. false = don't touch the border.
hooksecurefunc(bar, "Show", function(self)
	self.Icon:Show()
	addon.FollowDarkMode(self, false)
end)
