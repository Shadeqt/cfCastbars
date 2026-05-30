local _, addon = ...

addon.createdBars = {}

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

	bar.Border:ClearAllPoints()
	bar.Border:SetSize(TEMPLATE_BORDER_W * sw, TEMPLATE_BORDER_H * sh)
	bar.Border:SetPoint("TOP", bar, "TOP", 0, TEMPLATE_BORDER_Y * sh)
	bar.Border:SetDrawLayer("OVERLAY")

	bar.Flash:ClearAllPoints()
	bar.Flash:SetSize(TEMPLATE_BORDER_W * sw, TEMPLATE_BORDER_H * sh)
	bar.Flash:SetPoint("TOP", bar, "TOP", 0, TEMPLATE_BORDER_Y * sh)

	bar.Spark:SetSize(TEMPLATE_SPARK * sh, TEMPLATE_SPARK * sh)

	bar.Icon:ClearAllPoints()
	bar.Icon:SetSize(height * 1.5, height * 1.5)
	bar.Icon:SetPoint("RIGHT", bar, "LEFT", -5 * sw, 0)

	bar:HookScript("OnShow", function(self) self.Icon:Show() end)

	bar:HookScript("OnEvent", function(self, event)
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
			CastingBarFrame_OnEvent(self, "PLAYER_ENTERING_WORLD")
		end
	end)

	table.insert(addon.createdBars, bar)
	if addon._initialTexture then
		bar:SetStatusBarTexture(addon._initialTexture)
	end

	return bar
end

local initial = CastingBarFrame:GetStatusBarTexture()
if initial then
	addon._initialTexture = initial:GetTexture()
end

hooksecurefunc(CastingBarFrame, "SetStatusBarTexture", function(_, tex)
	addon._initialTexture = tex
	for _, bar in ipairs(addon.createdBars) do
		bar:SetStatusBarTexture(tex)
	end
end)
