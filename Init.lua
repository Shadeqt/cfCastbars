cfCastbars = {}

EventUtil.ContinueOnAddOnLoaded("cfCastbars", function()
	cfCastbarsDB = cfCastbarsDB or {}
	local db = cfCastbarsDB

	-- Add new keys
	for key, value in pairs(cfCastbars.DEFAULTS) do
		if db[key] == nil then
			db[key] = value
		end
	end

	-- Remove stale keys
	for key in pairs(db) do
		if cfCastbars.DEFAULTS[key] == nil then
			db[key] = nil
		end
	end

	-- Init features
	cfCastbars.InitPet()
	cfCastbars.InitParty()
	cfCastbars.InitNameplate()
	cfCastbars.InitPlayer()
	cfCastbars.InitTarget()

	-- GUI
	cfCastbars.SetupSettings()

	SLASH_CFCB1 = "/cfcb"
	SlashCmdList["CFCB"] = function()
		Settings.OpenToCategory(cfCastbars.category:GetID())
	end

end)
