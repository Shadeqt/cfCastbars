local _, addon = ...

-- /cfcb -- developer preview. Toggles a static display of every cfCastbars
-- target (player/target/pet/party/nameplate) so bars can be sized and placed.
-- It drives the *production* bars (addon.petBar / addon.partyBars /
-- addon.nameplateBars), never duplicates, and only force-shows frames that are
-- currently hidden -- so it's safe to toggle while grouped or with a pet/target.
-- Out-of-combat only, since it shows/hides protected frames.

local FAKE_ICON = "Interface\\Icons\\Spell_Nature_Lightning"

local shown = false
local testShield = false  -- /cfcb shield: force the shield border on, to tune its art
local forced = {}  -- frames WE force-showed (only ones hidden when we started)
-- Force the target castbar below the ToT frame so they don't overlap. The bar is
-- force-shown without a real cast, so Blizzard keeps re-anchoring it back; the
-- SetPoint hook (installed once, active only while the preview is up) reasserts our
-- spot. The `parking` guard stops our own SetPoint from re-triggering the hook.
local parking = false
local function ParkSpellbar()
	if parking or not TargetFrameSpellBar then return end
	parking = true
	TargetFrameSpellBar:ClearAllPoints()
	TargetFrameSpellBar:SetPoint("TOP", TargetFrame, "BOTTOM", -5, -18)
	parking = false
end
if TargetFrameSpellBar then
	hooksecurefunc(TargetFrameSpellBar, "SetPoint", function() if shown then ParkSpellbar() end end)
end

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
	if addon.SetShield then addon.SetShield(bar, testShield) end
end

-- Re-apply the shield state to every test bar currently on screen (used when
-- /cfcb shield is toggled while the preview is already up).
local function ApplyShields()
	local function set(bar) if bar and bar:IsShown() and addon.SetShield then addon.SetShield(bar, testShield) end end
	set(CastingBarFrame)
	set(TargetFrameSpellBar)
	set(addon.petBar)
	for _, bar in pairs(addon.partyBars) do set(bar) end
	for _, bar in pairs(addon.nameplateBars) do set(bar) end
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

	-- Target frame + its castbar, plus target-of-target. ToT has no castbar of its
	-- own (cfCastbars doesn't build one), so it's shown purely for layout context --
	-- note it sits near the target castbar and the two can overlap.
	ForceShow(TargetFrame)
	FakeCast(TargetFrameSpellBar)
	ForceShow(TargetFrameToT or TargetofTargetFrame)
	ParkSpellbar()  -- drop the castbar below the ToT, as Blizzard does for a live ToT

	-- Pet frame + pet castbar (reuse the production bar; build it if absent).
	ForceShow(PetFrame)
	addon.EnsurePetBar()
	FakeCast(addon.petBar)

	-- Party frames + party castbars (reuse the production bars; build if absent).
	for i = 1, MAX_PARTY_MEMBERS do
		local frame = _G["PartyMemberFrame" .. i]
		if frame then
			ForceShow(frame)
			addon.EnsurePartyBar(i)
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
SlashCmdList["CFCB"] = function(msg)
	if InCombatLockdown() then
		print("|cff33ff99cfCastbars|r: /cfcb can't toggle in combat.")
		return
	end
	if msg == "shield" then
		testShield = not testShield
		if shown then ApplyShields() end
		print("|cff33ff99cfCastbars|r: test shield " .. (testShield and "ON" or "OFF"))
		return
	end
	if shown then HideAll() else ShowAll() end
end
