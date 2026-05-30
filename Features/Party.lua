local _, addon = ...

addon.partyBars = {}           -- regular-frame bars, also reused by the test harness
local regularBars = addon.partyBars
local compactBars = {}
local baseW, baseH

local function EnsureBase()
	if not baseW then
		local hp = PartyMemberFrame1HealthBar
		baseW, baseH = hp:GetWidth(), hp:GetHeight()
	end
end

-- Build + place a party castbar. Single source of truth for party bar
-- geometry, shared by the production event handler and the /cfcb test harness.
function addon.BuildPartyRegularBar(frame, unit)
	EnsureBase()
	local bar = addon.CreateCastbar(frame, unit, baseW * 1.25, baseH)
	bar:SetPoint("TOP", frame, "BOTTOM", 10, 0)
	bar:SetFrameLevel(frame:GetFrameLevel() + 3)
	return bar
end

function addon.BuildPartyCompactBar(frame, unit)
	EnsureBase()
	local bar = addon.CreateCastbar(frame, unit, baseW, baseH)
	bar:SetPoint("CENTER")
	return bar
end

local function TearDown(t)
	for _, bar in pairs(t) do
		CastingBarFrame_SetUnit(bar, nil)
		bar:Hide()
	end
end

local function SetupRegular()
	TearDown(compactBars)
	for i = 1, MAX_PARTY_MEMBERS do
		local frame = _G["PartyMemberFrame" .. i]
		local unit = "party" .. i
		if frame and UnitExists(unit) then
			if not regularBars[i] then
				regularBars[i] = addon.BuildPartyRegularBar(frame, unit)
			end
			addon.AttachBar(regularBars[i], unit)
		elseif regularBars[i] then
			CastingBarFrame_SetUnit(regularBars[i], nil)
		end
	end
end

local function SetupCompact()
	TearDown(regularBars)
	for i = 1, MAX_RAID_MEMBERS do
		local frame = _G["CompactRaidFrame" .. i]
		if not frame then break end
		local unit = frame.unit
		if unit and UnitExists(unit) then
			if not compactBars[unit] then
				compactBars[unit] = addon.BuildPartyCompactBar(frame, unit)
			end
			addon.AttachBar(compactBars[unit], unit)
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("CVAR_UPDATE")
f:SetScript("OnEvent", function(_, event, cvar)
	if event == "CVAR_UPDATE" and cvar ~= "useCompactPartyFrames" then return end
	if GetCVarBool("useCompactPartyFrames") then
		SetupCompact()
	else
		SetupRegular()
	end
end)
