local _, addon = ...

-- Castbar construction, based on cfFramesTest's newest model: build from Blizzard's SmallCastingBarFrame
-- template and keep it close to native -- border, shield, spark and text keep the template's own
-- anchors/layers/textures, and the consumer applies a uniform SetScale (0.6 pet/party, 0.8 nameplate)
-- so the template's fixed-size art keeps its fit. The icon is the exception: the template doesn't place
-- it on a generic instance, so we place it ourselves (SetCastbarIcon), shield-aware.
--
-- What stays cfCastbars-specific:
--   * texture  -> mirror the unit's own HP-bar texture each Show (bar.hp), set by each driver.
--   * darkmode -> consume cfDarkMode's public API: its presence is the on/off signal, cfDarkMode.Darken
--                 tints our own bar borders, cfDarkMode.Style styles the spell icon. nil-checked, so
--                 cfCastbars still runs standalone (no cfDarkMode = no dark styling, correct: nothing to match).
--   * shield   -> the uninterruptible trigger lives in Shield.lua + Data.lua (cfFramesTest had none).

-- Dark icon styling: delegate to cfDarkMode.Style so castbar icons share the exact zoom/border/
-- darkness of action-bar and aura icons. It stores the created border on frame.cffBorder.
local function StyleDarkIcon(frame)
	if not cfDarkMode then return end
	cfDarkMode.Style(frame)
	-- Only show the border when the icon actually has a texture (loot/herb/open casts have none).
	if frame.cffBorder then
		frame.cffBorder:SetShown(frame.Icon and frame.Icon:GetTexture() ~= nil)
	end
end

-- Follow dark mode via cfDarkMode's public API (presence = on). ownBorder=true darkens the bar's own
-- Border/BorderShield (our built pet/party/nameplate bars); the player + target bars' borders are darkened
-- by cfDarkMode itself, so they pass false (icon only). Called from each bar's Show.
function addon.FollowDarkMode(bar, ownBorder)
	if not cfDarkMode then return end  -- no producer -> nothing to follow
	if ownBorder then
		cfDarkMode.Darken(bar.Border)
		if bar.BorderShield then cfDarkMode.Darken(bar.BorderShield) end
	end
	StyleDarkIcon(bar)
end

-- Place a castbar's spell icon: ~1.6x bar height, just left of the bar, shield-aware rise. A no-arg call
-- gives the small-template default (x=-5, y rides the active border: +2 with the shield, flush otherwise).
-- The player bar (larger CastingBarFrame) overrides x/y. Called on Show and whenever SetShield swaps the
-- border (via bar.cffOnShield).
function addon.SetCastbarIcon(bar, x, y)
	local s = bar:GetHeight() * 1.6
	local rise = (bar.BorderShield and bar.BorderShield:IsShown()) and 2 or 0
	bar.Icon:ClearAllPoints()
	bar.Icon:SetSize(s, s)
	bar.Icon:SetPoint("RIGHT", bar, "LEFT", x or -5, y or rise)
end

-- Re-fit the shield border to the bar's box, offset by x/y (Blizzard's native anchor can miss a restyled
-- bar). Only the player bar needs it; the small-template bars leave the shield native.
function addon.SetCastbarShield(bar, x, y)
	if not bar.BorderShield then return end
	bar.BorderShield:ClearAllPoints()
	bar.BorderShield:SetPoint("TOPLEFT", bar.Border, "TOPLEFT", x, y)
	bar.BorderShield:SetPoint("BOTTOMRIGHT", bar.Border, "BOTTOMRIGHT", x, y)
end

-- Per-cast icon visibility: the icon texture changes per cast and is empty on textureless casts. The
-- dark-icon border show/hide is handled inside StyleDarkIcon (via FollowDarkMode); here we just toggle
-- the icon itself. Shared with the player/target bars, which restyle Blizzard frames the same way.
function addon.ApplyIconVisuals(bar)
	bar.Icon:SetShown(bar.Icon:GetTexture() ~= nil)
end

function addon.CreateCastbar(parent)
	local bar = CreateFrame("StatusBar", nil, parent, "SmallCastingBarFrameTemplate")
	bar:Hide()
	-- No unit: built unit-agnostic; the driver binds it via addon.AttachBar (registers cast events).
	CastingBarFrame_OnLoad(bar)

	-- Let SetShield re-place the icon when it swaps the border (icon Y differs per border).
	bar.cffOnShield = addon.SetCastbarIcon

	bar:HookScript("OnShow", function(self)
		-- Blizzard's CastingBarFrame_OnShow recomputes self.value from the *unit-less*
		-- CastingInfo()/ChannelInfo() -- the PLAYER's cast, not self.unit's. On a non-player bar that
		-- corrupts the fill with the player's progress whenever the player is mid-cast, so the unit's
		-- bar starts partway full and finishes early. Re-derive value from our real unit.
		if self.unit and self.unit ~= "player" then
			if self.casting then
				local _, _, _, startTime = UnitCastingInfo(self.unit)
				if startTime then self.value = GetTime() - (startTime / 1000) end
			elseif self.channeling then
				local _, _, _, _, endTime = UnitChannelInfo(self.unit)
				if endTime then self.value = (endTime / 1000) - GetTime() end
			end
		end

		addon.ApplyIconVisuals(self)
		-- Default to no shield on every show; the cast-start trigger (Shield.lua) re-shows it if the
		-- cast is uninterruptible. Keeps recycled bars from inheriting a previous unit's shield.
		if addon.SetShield then addon.SetShield(self, false) end
		addon.SetCastbarIcon(self)  -- re-asserted each show (Blizzard re-anchors the icon on cast-start)
		addon.FollowDarkMode(self, true)  -- observe cfFrames' dark-mode tint -> our border + icon

		-- Mirror the unit's own HP-bar texture (driver sets self.hp). SetStatusBarTexture RESETS the
		-- fill's draw layer (so the fill would draw over the template's border) AND clears its color, so
		-- capture the layer before the swap and restore it after, and re-apply the color. Surface
		-- observation -- matches whoever skinned that frame.
		local t = self.hp and self.hp:GetStatusBarTexture()
		if not t then return end
		local oldFill = self:GetStatusBarTexture()
		local layer, sublevel
		if oldFill then layer, sublevel = oldFill:GetDrawLayer() end
		local r, g, b, a = self:GetStatusBarColor()
		self:SetStatusBarTexture(t:GetTexture())
		if layer then self:GetStatusBarTexture():SetDrawLayer(layer, sublevel) end
		self:SetStatusBarColor(r, g, b, a)
	end)

	return bar
end

-- Bind a created bar to a unit and immediately paint any in-progress cast (PLAYER_ENTERING_WORLD forces
-- CastingBarFrame to repopulate state).
function addon.AttachBar(bar, unit)
	CastingBarFrame_SetUnit(bar, unit)
	if UnitCastingInfo(unit) or UnitChannelInfo(unit) then
		CastingBarFrame_OnEvent(bar, "PLAYER_ENTERING_WORLD")
	end
end
