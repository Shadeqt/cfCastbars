local _, addon = ...

addon.partyBars = {}           -- regular-frame bars, keyed by member index; reused by the /cfcb harness
local regularBars = addon.partyBars
local compactBars = {}

-- Regular-frame party castbar: built once, hung below the frame, scaled to 0.6. bar.hp -> the member's
-- health bar so the fill mirrors its texture each Show.
local function EnsureRegularBar(i)
	if not regularBars[i] then
		local frame = _G["PartyMemberFrame" .. i]
		local bar = addon.CreateCastbar(frame)
		bar:SetScale(0.6)
		bar:SetPoint("TOP", frame, "BOTTOM", 5, 0)
		bar.hp = _G["PartyMemberFrame" .. i .. "HealthBar"]
		regularBars[i] = bar
	end
	return regularBars[i]
end
addon.EnsurePartyBar = EnsureRegularBar

-- Compact-frame party castbar: built once, centered on the frame, scaled to 0.6.
local function EnsureCompactBar(unit, frame)
	if not compactBars[unit] then
		local bar = addon.CreateCastbar(frame)
		bar:SetScale(0.6)
		bar:SetPoint("CENTER")
		bar.hp = frame.healthBar
		compactBars[unit] = bar
	end
	return compactBars[unit]
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
			EnsureRegularBar(i)
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
			EnsureCompactBar(unit, frame)
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
