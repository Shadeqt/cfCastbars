local _, addon = ...

local bar = CastingBarFrame
local size = bar:GetHeight() * 2
bar.Icon:SetSize(size, size)
bar.Icon:ClearAllPoints()
bar.Icon:SetPoint("RIGHT", bar, "LEFT", -10, 3)

-- Icon-only: cfFrames owns (darkens) the player castbar's border; we own this icon (we resized it),
-- so we give it the same dark zoom + backdrop. false = don't touch the border.
hooksecurefunc(bar, "Show", function(self)
	-- Textureless casts (loot/opening/herbing) have no spell icon; keep the slot hidden then.
	self.Icon:SetShown(self.Icon:GetTexture() ~= nil)
	addon.FollowDarkMode(self, false)
end)
