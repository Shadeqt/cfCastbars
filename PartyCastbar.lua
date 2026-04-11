cfCastbars.partyBars = {}
local bars = cfCastbars.partyBars

-- PartyMemberFrame always exists, even with compact CVar on
local hp = PartyMemberFrame1HealthBar
local W, H = hp:GetWidth(), hp:GetHeight()

function cfCastbars.CreatePartyCastbar(index)
	local frame = _G["PartyMemberFrame" .. index]
	if not frame then return end

	local bar = cfCastbars.CreateCastbar(frame, "party" .. index, W, H)
	bar:SetPoint("BOTTOM", frame, "TOP", 18, -8)
	bar:SetFrameLevel(frame:GetFrameLevel() + 3)
	bars[index] = bar
	return bar
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:SetScript("OnEvent", function()
	if GetCVarBool("useCompactPartyFrames") then
		for i = 1, MAX_RAID_MEMBERS do
			local frame = _G["CompactRaidFrame" .. i]
			if not frame then break end
			local unit = frame.unit
			if unit and UnitExists(unit) then
				if not bars[unit] then
					local bar = cfCastbars.CreateCastbar(frame, unit, W, H)
					bar:SetPoint("CENTER")
					bars[unit] = bar
				end
				CastingBarFrame_SetUnit(bars[unit], unit)
			end
		end
	else
		for i = 1, MAX_PARTY_MEMBERS do
			local unit = "party" .. i
			if UnitExists(unit) then
				if not bars[i] then cfCastbars.CreatePartyCastbar(i) end
				CastingBarFrame_SetUnit(bars[i], unit)
				if UnitCastingInfo(unit) or UnitChannelInfo(unit) then
					CastingBarFrame_OnEvent(bars[i], "PLAYER_ENTERING_WORLD")
				end
			else
				if bars[i] then CastingBarFrame_SetUnit(bars[i], nil) end
			end
		end
	end
end)
