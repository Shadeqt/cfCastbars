-- /cbt to toggle fake looping casts on all castbars

local testing = false
local testBars = {}
local forcedFrames = {}

local function FakeCast(bar, skipUnbind)
	bar.cbtUnit = bar.cbtUnit or bar.unit
	if not skipUnbind then CastingBarFrame_SetUnit(bar, nil) end

	bar:SetMinMaxValues(0, 3)
	bar:SetValue(0)
	bar.startCastColor = CreateColor(1, 0.7, 0)
	bar:SetStatusBarColor(1, 0.7, 0)
	bar.Icon:SetTexture("Interface\\Icons\\Spell_Nature_Lightning")
	bar.Icon:Show()
	bar.Text:SetText("Test Cast")
	bar.Flash:Hide()
	bar.cbtTestStart = GetTime()
	local width = bar:GetWidth()
	if not bar.cbtHooked then
		bar:HookScript("OnUpdate", function(self)
			if not self.cbtTestStart then return end
			self:SetAlpha(1)
			local elapsed = (GetTime() - self.cbtTestStart) % 3
			self:SetValue(elapsed)
			self:SetStatusBarColor(1, 0.7, 0)
			self.Flash:Hide()
			self.Spark:Show()
			self.Spark:SetPoint("CENTER", self, "LEFT", (elapsed / 3) * width, 0)
			if self.Timer then self.Timer:SetText(format("%.1f", 3 - elapsed)) end
		end)
		bar.cbtHooked = true
	end

	bar:Show()
	table.insert(testBars, bar)
end

local function StopFake(bar)
	bar.cbtTestStart = nil
	bar:Hide()
	if bar.cbtUnit then
		CastingBarFrame_SetUnit(bar, bar.cbtUnit)
		bar.cbtUnit = nil
	end
end

local function ForceShow(frame)
	if frame and not frame:IsShown() then
		if not frame.cbtHooked then
			hooksecurefunc(frame, "Hide", function(self)
				if testing then self:Show() end
			end)
			frame.cbtHooked = true
		end
		frame:Show()
		table.insert(forcedFrames, frame)
	end
end

local listener = CreateFrame("Frame")
listener:SetScript("OnEvent", function(_, _, unit)
	if cfCastbars.nameplateBars[unit] then FakeCast(cfCastbars.nameplateBars[unit]) end
end)

local function StopAll()
	testing = false
	listener:UnregisterAllEvents()
	for _, bar in ipairs(testBars) do
		StopFake(bar)
	end
	wipe(testBars)
	for _, frame in ipairs(forcedFrames) do
		frame:Hide()
	end
	wipe(forcedFrames)
end

local function StartAll()
	testing = true

	-- Player
	FakeCast(CastingBarFrame, true)

	-- Target + ToT
	ForceShow(TargetFrame)
	if TargetFrameToT then ForceShow(TargetFrameToT) end
	FakeCast(TargetFrameSpellBar, true)

	-- Pet
	ForceShow(PetFrame)
	if not cfCastbars.petBar then cfCastbars.CreatePetCastbar() end
	if cfCastbars.petBar then FakeCast(cfCastbars.petBar) end

	-- Party
	if GetCVarBool("useCompactPartyFrames") and IsInGroup() then
		for _, bar in pairs(cfCastbars.partyBars) do
			FakeCast(bar)
		end
	else
		for i = 1, MAX_PARTY_MEMBERS do
			ForceShow(_G["PartyMemberFrame" .. i])
			if not cfCastbars.partyBars[i] then cfCastbars.CreatePartyCastbar(i) end
			if cfCastbars.partyBars[i] then FakeCast(cfCastbars.partyBars[i]) end
		end
	end

	-- Nameplates
	for _, bar in pairs(cfCastbars.nameplateBars) do
		FakeCast(bar)
	end
	listener:RegisterEvent("NAME_PLATE_UNIT_ADDED")
end

SLASH_CFCBT1 = "/cbt"
SlashCmdList["CFCBT"] = function()
	if #testBars > 0 then
		StopAll()
		print("cfCastbars test: OFF")
	else
		StartAll()
		print("cfCastbars test: ON")
	end
end
