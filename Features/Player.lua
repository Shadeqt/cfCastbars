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
	-- Blizzard places the player BorderShield too high and too far right for our
	-- restyled bar; pin it to the (correctly placed) normal border's box so it lands
	-- like the shield on our other castbars.
	if self.BorderShield then
		self.BorderShield:ClearAllPoints()
		-- Match the border box, nudged 2px left and 1px down to line up the shield art.
		self.BorderShield:SetPoint("TOPLEFT", self.Border, "TOPLEFT", -10, -1)
		self.BorderShield:SetPoint("BOTTOMRIGHT", self.Border, "BOTTOMRIGHT", -10, -1)
	end
	addon.FollowDarkMode(self, false)
end)
