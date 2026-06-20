local _, addon = ...

local noInterrupt = addon.noInterrupt
local noInterruptByNpc = addon.noInterruptByNpc
local SpellName = C_Spell.GetSpellName

-- Swap between the normal border and the shield border. Color (dark-mode tint)
-- is handled separately by FollowDarkMode, so we only toggle visibility here.
function addon.SetShield(bar, on)
	if not bar.BorderShield then return end
	if on then
		bar.BorderShield:Show()
		bar.Border:Hide()
	else
		bar.BorderShield:Hide()
		bar.Border:Show()
	end
	-- The active border changed, so the icon's shield-aware rise may differ -- re-place it.
	-- No-op unless the bar opted in (bar.cffOnShield = SetCastbarIcon, set in CreateCastbar / Target).
	if bar.cffOnShield then bar.cffOnShield(bar) end
end

-- Can the unit's current cast/channel not be interrupted? eventSpellID is the
-- spellID handed to us by the cast/channel-start event, used as a fallback for
-- channels (UnitChannelInfo returns nothing for other units on Era).
local function isProtected(unit, eventSpellID)
	-- UnitCastingInfo and UnitChannelInfo return different layouts: notInterruptible
	-- and spellID sit at 8/9 for a cast but 7/8 for a channel (no castID field).
	local name, _, _, _, _, _, _, notInterruptible, spellID = UnitCastingInfo(unit)
	if not name then
		name, _, _, _, _, _, notInterruptible, spellID = UnitChannelInfo(unit)
		if not name and eventSpellID then
			spellID = eventSpellID
			name = SpellName(eventSpellID)
		end
	end
	if not name then return false end

	if notInterruptible then return true end -- player self-casts; never true for Era enemies
	if noInterrupt[spellID] or noInterrupt[name] then return true end

	if not UnitIsPlayer(unit) then
		local guid = UnitGUID(unit)
		if guid then
			local npcID = select(6, strsplit("-", guid))
			if npcID and noInterruptByNpc[npcID .. name] then return true end
		end
	end
	return false
end

addon.IsUninterruptible = isProtected

-- Every template castbar -- ours plus the player bar and TargetFrameSpellBar --
-- is driven by the global CastingBarFrame_OnEvent. One hook covers them all; it
-- runs after Blizzard's handling, so our decision wins.
local START = {
	UNIT_SPELLCAST_START = true,
	UNIT_SPELLCAST_CHANNEL_START = true,
}

hooksecurefunc("CastingBarFrame_OnEvent", function(self, event, unit, _, spellID)
	if not START[event] then return end
	if not self.BorderShield then return end

	local barUnit = self.unit
	-- Player self-casts already shield correctly via Blizzard; skip them.
	if not barUnit or barUnit == "player" then return end
	-- The handler fires for events on any unit; only act on this bar's unit.
	if unit and unit ~= barUnit then return end

	addon.SetShield(self, isProtected(barUnit, spellID))
end)
