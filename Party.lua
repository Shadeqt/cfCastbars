cfCastbars.partyBars = {}
local bars = cfCastbars.partyBars
local K = cfCastbars.K

-- PartyMemberFrame always exists, even with compact CVar on
local hp = PartyMemberFrame1HealthBar
local baseW, baseH = hp:GetWidth(), hp:GetHeight()

function cfCastbars.CreatePartyCastbar(index)
	local frame = _G["PartyMemberFrame" .. index]
	if not frame then return end

	local bar = cfCastbars.CreateCastbar(frame, "party" .. index, baseW, baseH)
	bar:SetPoint("BOTTOM", frame, "TOP", 18, -8)
	bar:SetFrameLevel(frame:GetFrameLevel() + 3)
	bars[index] = bar
	return bar
end

local function ApplyStyle(bar, anchorFrame)
	local db = cfCastbarsDB
	local w = baseW + db[K.PartyWidth]
	local h = baseH + db[K.PartyHeight]
	bar:SetScale(db[K.PartyScale])
	bar:SetSize(w, h)
	bar.Spark:SetSize(h * 3.2, h * 3.2)
	bar.Border:SetSize(196 * (w / 150), 49 * (h / 10))

	-- Position
	if anchorFrame then
		local name = anchorFrame:GetName() or ""
		bar:ClearAllPoints()
		if name:match("^Compact") then
			bar:SetPoint("CENTER", anchorFrame, "CENTER", db[K.PartyX], db[K.PartyY])
		else
			bar:SetPoint("BOTTOM", anchorFrame, "TOP", 18 + db[K.PartyX], -8 + db[K.PartyY])
		end
	end

	-- Icon
	if db[K.PartyIcon] then
		bar.Icon:Show()
		bar.Icon:SetSize(h * 1.5, h * 1.5)
		bar.Icon:SetScale(db[K.PartyIconScale])
		bar.Icon:ClearAllPoints()
		bar.Icon:SetPoint("RIGHT", bar, "LEFT", -5 + db[K.PartyIconX], db[K.PartyIconY])
	else
		bar.Icon:Hide()
	end

	-- Timer
	if db[K.PartyTimer] then
		bar.Timer:Show()
		bar.Timer:SetScale(db[K.PartyTimerScale])
		bar.Timer:ClearAllPoints()
		bar.Timer:SetPoint("LEFT", bar, "RIGHT", 5 + db[K.PartyTimerX], db[K.PartyTimerY])
	else
		bar.Timer:Hide()
	end

	-- Text
	if db[K.PartyText] then
		bar.Text:Show()
		bar.Text:SetScale(db[K.PartyTextScale])
		bar.Text:ClearAllPoints()
		bar.Text:SetPoint("CENTER", bar, "CENTER", db[K.PartyTextX], db[K.PartyTextY])
	else
		bar.Text:Hide()
	end

	-- Border
	bar.Border:SetShown(db[K.PartyBorder])
end

function cfCastbars.UpdateParty()
	local db = cfCastbarsDB
	for _, bar in pairs(bars) do
		ApplyStyle(bar, bar:GetParent())
		if not db[K.Party] then
			CastingBarFrame_SetUnit(bar, nil)
			bar:Hide()
		end
	end
end

function cfCastbars.InitParty()
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("GROUP_ROSTER_UPDATE")
	f:RegisterEvent("CVAR_UPDATE")
	f:SetScript("OnEvent", function(_, event, cvar)
		if event == "CVAR_UPDATE" and cvar ~= "useCompactPartyFrames" then return end
		if not cfCastbarsDB[K.Party] then return end
		if GetCVarBool("useCompactPartyFrames") then
			for i = 1, MAX_RAID_MEMBERS do
				local frame = _G["CompactRaidFrame" .. i]
				if not frame then break end
				local unit = frame.unit
				if unit and UnitExists(unit) then
					if not bars[unit] then
						local bar = cfCastbars.CreateCastbar(frame, unit, baseW, baseH)
						bar:SetPoint("CENTER")
						bars[unit] = bar
					end
					ApplyStyle(bars[unit], frame)
					CastingBarFrame_SetUnit(bars[unit], unit)
				end
			end
		else
			for i = 1, MAX_PARTY_MEMBERS do
				local unit = "party" .. i
				if UnitExists(unit) then
					if not bars[i] then cfCastbars.CreatePartyCastbar(i) end
					ApplyStyle(bars[i], _G["PartyMemberFrame" .. i])
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
end
