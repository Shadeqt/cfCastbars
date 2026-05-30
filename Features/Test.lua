local _, addon = ...

-- /cfcb -- developer preview. Toggles a static display of every cfCastbars
-- target (player/target/pet/party/nameplate) so bars can be sized and placed.
-- It drives the *production* bars (addon.petBar / addon.partyBars /
-- addon.nameplateBars), never duplicates, and only force-shows frames that are
-- currently hidden -- so it's safe to toggle while grouped or with a pet/target.
-- Out-of-combat only, since it shows/hides protected frames.

local FAKE_ICON = "Interface\\Icons\\Spell_Nature_Lightning"

local shown = false
local forced = {}  -- frames WE force-showed (only ones hidden when we started)

-- A plain :Show() doesn't stick on unit-driven frames like PetFrame -- their
-- visibility gets reasserted by events. Per the archived harness: hook Hide and
-- re-Show, so any attempt to hide the frame is immediately reversed. Only act on
-- frames that are hidden, so we never "own" (and later hide) a real, live frame.
local function ForceShow(frame)
	if not frame or frame:IsShown() then return end
	if not forced[frame] then
		hooksecurefunc(frame, "Hide", function(self)
			if forced[self] and not InCombatLockdown() then self:Show() end
		end)
		forced[frame] = true
	end
	frame:Show()
end

-- Park a bar at a static-looking fill. casting=true keeps Blizzard's OnUpdate
-- from hiding it; the huge maxValue means value advances far too slowly to ever
-- "finish" in a session, so the fill stays put with no extra update logic.
local function FakeCast(bar)
	if not bar then return end
	bar.casting = true
	bar.channeling = false
	bar.fadeOut = nil
	bar.holdTime = 0
	bar.maxValue = 1000000
	bar.value = 600000
	bar:SetMinMaxValues(0, 1000000)
	bar:SetValue(600000)
	if bar.Text then bar.Text:SetText("Test Spell") end
	if bar.Icon then bar.Icon:SetTexture(FAKE_ICON); bar.Icon:Show() end
	bar:SetAlpha(1)
	bar:Show()
end

local function StopCast(bar)
	if not bar then return end
	bar.casting = false
	bar.channeling = false
	bar:Hide()
end

-- Nameplate bars only exist for plates currently on screen. We can't fabricate
-- one solo, so we fake-cast whatever exists and catch new plates as they appear.
local npListener = CreateFrame("Frame")
npListener:SetScript("OnEvent", function(_, _, unit)
	if shown and addon.nameplateBars[unit] then
		FakeCast(addon.nameplateBars[unit])
	end
end)

local function ShowAll()
	-- Player castbar (Blizzard frame, untouched in production).
	FakeCast(CastingBarFrame)

	-- Target frame + its castbar. (ToT omitted -- it overlaps the castbar.)
	ForceShow(TargetFrame)
	FakeCast(TargetFrameSpellBar)

	-- Pet frame + pet castbar (reuse the production bar; build it if absent).
	ForceShow(PetFrame)
	if not addon.petBar then addon.petBar = addon.BuildUnitBar(PetFrame, "pet") end
	FakeCast(addon.petBar)

	-- Party frames + party castbars (reuse the production bars; build if absent).
	for i = 1, MAX_PARTY_MEMBERS do
		local frame = _G["PartyMemberFrame" .. i]
		if frame then
			ForceShow(frame)
			if not addon.partyBars[i] then
				addon.partyBars[i] = addon.BuildUnitBar(frame, "party" .. i)
			end
			FakeCast(addon.partyBars[i])
		end
	end

	-- Nameplate castbars: drive any plates already visible, then catch new ones.
	for _, bar in pairs(addon.nameplateBars) do FakeCast(bar) end
	npListener:RegisterEvent("NAME_PLATE_UNIT_ADDED")

	shown = true
end

local function HideAll()
	StopCast(CastingBarFrame)
	StopCast(TargetFrameSpellBar)
	StopCast(addon.petBar)
	for _, bar in pairs(addon.partyBars) do StopCast(bar) end

	npListener:UnregisterAllEvents()
	for _, bar in pairs(addon.nameplateBars) do StopCast(bar) end

	-- Clear the force-show flag first (disarms the re-show hook), then hide.
	-- The frame's own event-driven logic restores correct visibility afterward.
	for frame in pairs(forced) do
		forced[frame] = nil
		if not InCombatLockdown() then frame:Hide() end
	end

	shown = false
end

SLASH_CFCB1 = "/cfcb"
SlashCmdList["CFCB"] = function()
	if InCombatLockdown() then
		print("|cff33ff99cfCastbars|r: /cfcb can't toggle in combat.")
		return
	end
	if shown then HideAll() else ShowAll() end
end
