local _, addon = ...

local regularBars = {}
local compactBars = {}
local baseW, baseH

local function TearDownRegular()
	for _, bar in pairs(regularBars) do
		CastingBarFrame_SetUnit(bar, nil)
		bar:Hide()
	end
end

local function TearDownCompact()
	for _, bar in pairs(compactBars) do
		CastingBarFrame_SetUnit(bar, nil)
		bar:Hide()
	end
end

local function SetupRegular()
	TearDownCompact()
	for i = 1, MAX_PARTY_MEMBERS do
		local frame = _G["PartyMemberFrame" .. i]
		local unit = "party" .. i
		if frame and UnitExists(unit) then
			if not regularBars[i] then
				local bar = addon.CreateCastbar(frame, unit, baseW, baseH)
				bar:SetPoint("BOTTOM", frame, "TOP", 18, -8)
				bar:SetFrameLevel(frame:GetFrameLevel() + 3)
				regularBars[i] = bar
			end
			CastingBarFrame_SetUnit(regularBars[i], unit)
			if UnitCastingInfo(unit) or UnitChannelInfo(unit) then
				CastingBarFrame_OnEvent(regularBars[i], "PLAYER_ENTERING_WORLD")
			end
		elseif regularBars[i] then
			CastingBarFrame_SetUnit(regularBars[i], nil)
		end
	end
end

local function SetupCompact()
	TearDownRegular()
	for i = 1, MAX_RAID_MEMBERS do
		local frame = _G["CompactRaidFrame" .. i]
		if not frame then break end
		local unit = frame.unit
		if unit and UnitExists(unit) then
			if not compactBars[unit] then
				local bar = addon.CreateCastbar(frame, unit, baseW, baseH)
				bar:SetPoint("CENTER")
				compactBars[unit] = bar
			end
			CastingBarFrame_SetUnit(compactBars[unit], unit)
			if UnitCastingInfo(unit) or UnitChannelInfo(unit) then
				CastingBarFrame_OnEvent(compactBars[unit], "PLAYER_ENTERING_WORLD")
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("CVAR_UPDATE")
f:SetScript("OnEvent", function(_, event, cvar)
	if event == "CVAR_UPDATE" and cvar ~= "useCompactPartyFrames" then return end
	if not baseW then
		local hp = PartyMemberFrame1HealthBar
		baseW, baseH = hp:GetWidth(), hp:GetHeight()
	end
	if GetCVarBool("useCompactPartyFrames") then
		SetupCompact()
	else
		SetupRegular()
	end
end)
