local _, addon = ...

local TEMPLATE_BAR_W = 150
local TEMPLATE_BAR_H = 10
local TEMPLATE_BORDER_W = 196
local TEMPLATE_BORDER_H = 49
local TEMPLATE_BORDER_Y = 20
local TEMPLATE_SPARK = 32

-- DarkMode following. Dark mode is not surface-backed, so we read its state off CastingBarFrame.Border
-- -- cfFrames darkens it to ~0.25; with no cfFrames it stays 1,1,1 and everything here is a no-op. We
-- mirror that tint onto our own bar borders and give our icons the same zoom + dark backdrop that
-- cfFrames' DarkModeIcons gives Blizzard icons (replicated here -- consumers can't call into cfFrames).
local ICON_ZOOM = { 0.02, 0.98, 0.02, 0.98 }
local ICON_OFFSET = { -1.2, 1.2, 1.2, -1.2 }

local function StyleDarkIcon(frame, r, g, b)
	local icon = frame.Icon
	if not icon then return end
	if not frame.cffZoom then
		frame.cffZoom = true
		icon:SetTexCoord(unpack(ICON_ZOOM))
	end
	if not frame.cffIconBorder then
		local border = CreateFrame("Frame", nil, frame, "BackdropTemplate")
		border:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 8.5 })
		border:SetPoint("TOPLEFT", icon, ICON_OFFSET[1], ICON_OFFSET[2])
		border:SetPoint("BOTTOMRIGHT", icon, ICON_OFFSET[3], ICON_OFFSET[4])
		frame.cffIconBorder = border
	end
	frame.cffIconBorder:SetBackdropBorderColor(r, g, b, 1)
	-- Only show the border when the icon actually has a texture. Loot/opening/herbing
	-- casts have no spell icon, so the slot is empty and a border would float over nothing.
	frame.cffIconBorder:SetShown(icon:GetTexture() ~= nil)
end

-- ownBorder: mirror the tint onto the bar's own Border (our created pet/party/nameplate bars). The
-- player castbar's border is darkened by cfFrames itself, so Player.lua passes false and only its
-- icon is styled here. Called from each bar's OnShow, so it follows the live dark-mode state.
function addon.FollowDarkMode(bar, ownBorder)
	local r, g, b = CastingBarFrame.Border:GetVertexColor()
	if ownBorder then
		bar.Border:SetVertexColor(r, g, b)
		if bar.BorderShield then bar.BorderShield:SetVertexColor(r, g, b) end
	end
	if r < 0.9 then StyleDarkIcon(bar, r, g, b) end  -- dark mode on
end

function addon.CreateCastbar(parent, unit, width, height)
	local bar = CreateFrame("StatusBar", nil, parent, "SmallCastingBarFrameTemplate")
	bar:Hide()
	CastingBarFrame_OnLoad(bar, unit)
	bar:SetSize(width, height)

	local sw = width / TEMPLATE_BAR_W
	local sh = height / TEMPLATE_BAR_H

	local borderW, borderH, borderY = TEMPLATE_BORDER_W * sw, TEMPLATE_BORDER_H * sh, TEMPLATE_BORDER_Y * sh
	for _, region in ipairs({ bar.Border, bar.Flash }) do
		region:ClearAllPoints()
		-- +2 (1px per side) nudges the centred border out past a sub-pixel
		-- rounding seam where the fill would otherwise bleed over the frame
		region:SetSize(borderW + 2, borderH)
		region:SetPoint("TOP", bar, "TOP", 0, borderY)
	end
	bar.Border:SetDrawLayer("OVERLAY")

	bar.Spark:SetSize(TEMPLATE_SPARK * sh, TEMPLATE_SPARK * sh)

	bar.Icon:ClearAllPoints()
	bar.Icon:SetSize(height * 1.5, height * 1.5)
	bar.Icon:SetPoint("RIGHT", bar, "LEFT", -5 * sw, 0)

	-- Mirror the unit's own health-bar texture each time the bar shows (the
	-- feature sets bar.hp), so it matches its frame no matter who/how/when the
	-- texture changed -- the next cast always re-reads the live value.
	bar:HookScript("OnShow", function(self)
		-- Blizzard's CastingBarFrame_OnShow (the template's OnShow) recomputes
		-- self.value from the *unit-less* CastingInfo()/ChannelInfo(), which are
		-- the PLAYER's cast -- not self.unit's. On a non-player bar that corrupts
		-- the fill with the player's own cast progress whenever the player is
		-- mid-cast, so the unit's bar starts partway full and finishes early. This
		-- hook runs right after that OnShow, so re-derive value from our real unit.
		if self.unit and self.unit ~= "player" then
			if self.casting then
				local _, _, _, startTime = UnitCastingInfo(self.unit)
				if startTime then self.value = GetTime() - (startTime / 1000) end
			elseif self.channeling then
				local _, _, _, _, endTime = UnitChannelInfo(self.unit)
				if endTime then self.value = (endTime / 1000) - GetTime() end
			end
		end
		self.Icon:SetShown(self.Icon:GetTexture() ~= nil)
		addon.FollowDarkMode(self, true)  -- mirror cfFrames' dark-mode tint onto our border + icon
		local t = self.hp and self.hp:GetStatusBarTexture()
		if not t then return end
		local r, g, b, a = self:GetStatusBarColor()  -- SetStatusBarTexture clears color
		self:SetStatusBarTexture(t:GetTexture())
		self:SetStatusBarColor(r, g, b, a)
	end)

	return bar
end

-- Bind a created bar to a unit and immediately paint any in-progress cast
-- (the PLAYER_ENTERING_WORLD event forces CastingBarFrame to repopulate state).
function addon.AttachBar(bar, unit)
	CastingBarFrame_SetUnit(bar, unit)
	if UnitCastingInfo(unit) or UnitChannelInfo(unit) then
		CastingBarFrame_OnEvent(bar, "PLAYER_ENTERING_WORLD")
	end
end

-- Build a castbar hanging below a unit frame (pet, regular party): 1.25x the
-- frame's health-bar width, raised above the frame, following its HP texture.
function addon.BuildUnitBar(frame, unit)
	local hp = _G[frame:GetName() .. "HealthBar"]
	local bar = addon.CreateCastbar(frame, unit, hp:GetWidth() * 1.25, hp:GetHeight())
	bar.hp = hp
	bar:SetPoint("TOP", frame, "BOTTOM", 10, 0)
	bar:SetFrameLevel(frame:GetFrameLevel() + 3)
	return bar
end
