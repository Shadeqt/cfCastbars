local _, addon = ...

local TEMPLATE_BAR_W = 150
local TEMPLATE_BAR_H = 10
local TEMPLATE_BORDER_W = 196
local TEMPLATE_BORDER_H = 49
local TEMPLATE_BORDER_Y = 20
local TEMPLATE_SPARK = 32

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
		region:SetSize(borderW, borderH)
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
		self.Icon:Show()
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
