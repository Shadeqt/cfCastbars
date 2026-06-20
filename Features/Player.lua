local _, addon = ...

-- Restyle Blizzard's own player castbar (CastingBarFrame); we don't build it. Re-place its icon and
-- re-fit its shield through the shared placers, and follow dark mode on the icon only (cfFrames darkens
-- the player castbar's own border). Blizzard re-anchors the icon/shield when the bar shows, so we
-- re-assert on every Show.

-- Player overrides: x = -7 and a fixed y = 3 (not shield-aware, unlike the small-template bars).
local function PinIcon(bar)
	addon.SetCastbarIcon(bar, -7, 3)
end

local bar = CastingBarFrame
PinIcon(bar)
hooksecurefunc(bar, "Show", function(self)
	PinIcon(self)
	addon.ApplyIconVisuals(self)
	-- Re-fit the shield to the restyled bar's box (Blizzard re-anchors it on show, like the icon).
	addon.SetCastbarShield(self, -7, -1)
	addon.FollowDarkMode(self, false)  -- icon only; cfFrames darkens the player castbar border
end)
