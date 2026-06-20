local _, addon = ...

-- The target castbar (TargetFrameSpellBar) uses the same SmallCastingBarFrame template as our built
-- bars, so it shares their icon placement: SetCastbarIcon with no args (the small-template default --
-- just left of the bar, rising with the shield), which happens to reproduce Blizzard's native target
-- icon. On every Show we re-place the icon (Blizzard re-anchors it on cast-start), sync icon visibility,
-- reset the shield (the Shield.lua trigger re-shows it for uninterruptible casts), and follow dark mode
-- on the icon (cfFrames darkens TargetFrameSpellBar's own border). The Shield trigger fires for this bar
-- because its unit is "target" (the trigger only skips player self-casts).

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	local bar = TargetFrameSpellBar
	if not bar then return end
	bar.cffOnShield = addon.SetCastbarIcon  -- re-place the icon when SetShield swaps the border
	hooksecurefunc(bar, "Show", function(self)
		addon.ApplyIconVisuals(self)
		if addon.SetShield then addon.SetShield(self, false) end  -- trigger re-shows for uninterruptible
		addon.SetCastbarIcon(self)
		addon.FollowDarkMode(self, false)  -- icon only; cfFrames darkens the target castbar border
	end)
end)
