-- Per-domain test toggles + /cbt for all

cfCastbars.testing = {}
local testing = cfCastbars.testing
local testBars = { Player = {}, Target = {}, Party = {}, Pet = {}, Nameplate = {} }
local forcedFrames = {}

local savedUnits = {}
local hookedBars = {}
local forcedSet = {}

local function FakeCast(domain, bar, skipUnbind)
	savedUnits[bar] = savedUnits[bar] or bar.unit
	if not skipUnbind then CastingBarFrame_SetUnit(bar, nil) end

	bar:SetMinMaxValues(0, 3)
	bar:SetValue(0)
	bar.Icon:SetTexture("Interface\\Icons\\Spell_Nature_Lightning")
	bar.Icon:Show()
	bar.Text:SetText("Test Cast")
	local startTime = GetTime()
	if not hookedBars[bar] then
		bar:HookScript("OnUpdate", function(self)
			if not testing[domain] then return end
			self:SetAlpha(1)
			local elapsed = (GetTime() - startTime) % 3
			self:SetValue(elapsed)
			self:SetStatusBarColor(1, 0.7, 0)
			self.Spark:SetPoint("CENTER", self, "LEFT", (elapsed / 3) * self:GetWidth(), 0)
			if self.Timer then self.Timer:SetText(format("%.1f", 3 - elapsed)) end
		end)
		hookedBars[bar] = true
	end

	bar:Show()
	table.insert(testBars[domain], bar)
end

local function ForceShow(frame)
	if frame and not frame:IsShown() then
		if not forcedSet[frame] then
			hooksecurefunc(frame, "Hide", function(self)
				if forcedSet[self] and not InCombatLockdown() then self:Show() end
			end)
			forcedSet[frame] = true
		end
		if not InCombatLockdown() then frame:Show() end
		table.insert(forcedFrames, frame)
	end
end

local function StopDomain(domain)
	testing[domain] = nil
	for _, bar in ipairs(testBars[domain]) do
		bar:Hide()
		if savedUnits[bar] then
			CastingBarFrame_SetUnit(bar, savedUnits[bar])
			savedUnits[bar] = nil
		end
	end
	wipe(testBars[domain])
end

local listener = CreateFrame("Frame")
listener:SetScript("OnEvent", function(_, _, unit)
	if testing.Nameplate and cfCastbars.nameplateBars[unit] then
		FakeCast("Nameplate", cfCastbars.nameplateBars[unit])
	end
end)

-----------------------------------------------------------------------
-- Player
-----------------------------------------------------------------------
function cfCastbars.TestPlayer(on)
	if on then
		testing.Player = true
		FakeCast("Player", CastingBarFrame, true)
		cfCastbars.ApplyPlayerSettings()
	else
		StopDomain("Player")
	end
end

-----------------------------------------------------------------------
-- Target
-----------------------------------------------------------------------
function cfCastbars.TestTarget(on)
	if on then
		testing.Target = true
		if not InCombatLockdown() then
			ForceShow(TargetFrame)
			if TargetFrameToT then ForceShow(TargetFrameToT) end
		end
		TargetFrameSpellBar.cfcbYOffset = -40
		FakeCast("Target", TargetFrameSpellBar, true)
		cfCastbars.ApplyTargetSettings()
	else
		TargetFrameSpellBar.cfcbYOffset = nil
		StopDomain("Target")
	end
end

-----------------------------------------------------------------------
-- Party
-----------------------------------------------------------------------
function cfCastbars.TestParty(on)
	if on then
		testing.Party = true
		if not IsInGroup() or not GetCVarBool("useCompactPartyFrames") then
			for i = 1, MAX_PARTY_MEMBERS do
				ForceShow(_G["PartyMemberFrame" .. i])
				if not cfCastbars.partyBars[i] then cfCastbars.CreatePartyCastbar(i) end
			end
		end
		for _, bar in pairs(cfCastbars.partyBars) do
			FakeCast("Party", bar)
			cfCastbars.ApplyPartySettings(bar, bar:GetParent())
		end
	else
		StopDomain("Party")
	end
end

-----------------------------------------------------------------------
-- Pet
-----------------------------------------------------------------------
function cfCastbars.TestPet(on)
	if on then
		testing.Pet = true
		ForceShow(PetFrame)
		cfCastbars.UpdatePet()
		if cfCastbars.petBar then
			FakeCast("Pet", cfCastbars.petBar)
			cfCastbars.ApplyPetSettings()
		end
	else
		StopDomain("Pet")
	end
end

-----------------------------------------------------------------------
-- Nameplate
-----------------------------------------------------------------------
function cfCastbars.TestNameplate(on)
	if on then
		testing.Nameplate = true
		cfCastbars.UpdateNameplate()
		for _, bar in pairs(cfCastbars.nameplateBars) do
			FakeCast("Nameplate", bar)
			cfCastbars.ApplyNameplateSettings(bar)
		end
		listener:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	else
		listener:UnregisterAllEvents()
		StopDomain("Nameplate")
	end
end

-----------------------------------------------------------------------
-- All
-----------------------------------------------------------------------
local function SetTestCBs(on)
	if cfCastbars.testCBs then
		for _, cb in pairs(cfCastbars.testCBs) do cb:SetChecked(on) end
	end
end

function cfCastbars.StartTest()
	SetTestCBs(true)
	cfCastbars.TestPlayer(true)
	cfCastbars.TestTarget(true)
	cfCastbars.TestParty(true)
	cfCastbars.TestPet(true)
	cfCastbars.TestNameplate(true)
end

function cfCastbars.StopTest()
	SetTestCBs(false)
	cfCastbars.TestPlayer(false)
	cfCastbars.TestTarget(false)
	cfCastbars.TestParty(false)
	cfCastbars.TestPet(false)
	cfCastbars.TestNameplate(false)
	for _, frame in ipairs(forcedFrames) do
		forcedSet[frame] = nil
		if not InCombatLockdown() then frame:Hide() end
	end
	wipe(forcedFrames)
end

local function AnyTesting()
	return testing.Player or testing.Target or testing.Party or testing.Pet or testing.Nameplate
end

SLASH_CFCBT1 = "/cbt"
SlashCmdList["CFCBT"] = function()
	if AnyTesting() then
		cfCastbars.StopTest()
		print("cfCastbars test: OFF")
	else
		cfCastbars.StartTest()
		print("cfCastbars test: ON")
	end
end

