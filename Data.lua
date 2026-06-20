local _, addon = ...

-- Uninterruptible-cast data.
--
-- On Era the API can't tell us whether another unit's cast can be interrupted
-- (UnitCastingInfo's notInterruptible is always false for non-players, and the
-- INTERRUPTIBLE/NOT_INTERRUPTIBLE events never fire), so we carry the knowledge
-- ourselves. Two lookups:
--   noInterrupt       keyed by spellID OR spell name -> can never be interrupted
--   noInterruptByNpc  keyed by npcID .. spell name   -> only when that NPC casts it
--
-- Some casts share a name across many ranks/copies (mob "Fireball" vs the player
-- spell), so those are stored by name; the rest by spellID. Per-NPC entries cover
-- the case where the same spell is kickable on trash but not on a boss.

local noInterrupt = {
	-- Engineering / thrown ordnance
	[19821] = true, -- Arcane Bomb
	[4068]  = true, -- Iron Grenade
	[19769] = true, -- Thorium Grenade
	[13808] = true, -- M73 Frag Grenade
	[4069]  = true, -- Big Iron Bomb
	[12543] = true, -- Hi-Explosive Bomb
	[4064]  = true, -- Rough Copper Bomb
	[12421] = true, -- Mithril Frag Bomb
	[19784] = true, -- Dark Iron Bomb
	[4067]  = true, -- Big Bronze Bomb
	[4066]  = true, -- Small Bronze Bomb
	[4065]  = true, -- Large Copper Bomb
	[4061]  = true, -- Coarse Dynamite
	[4054]  = true, -- Rough Dynamite
	[8331]  = true, -- EZ-Thro Dynamite
	[23000] = true, -- EZ-Thro Dynamite II
	[4062]  = true, -- Heavy Dynamite
	[23063] = true, -- Dense Dynamite
	[12419] = true, -- Solid Dynamite
	[13278] = true, -- Gnomish Death Ray
	[8800]  = true, -- Dynamite
	[7978]  = true, -- Throw Dynamite
	[24024] = true, -- Unstable Concoction
	[22999] = true, -- Defibrillate

	-- Rogue poisons
	[11202] = true, -- Crippling Poison
	[3421]  = true, -- Crippling Poison II
	[2835]  = true, -- Deadly Poison
	[2837]  = true, -- Deadly Poison II
	[11355] = true, -- Deadly Poison III
	[11356] = true, -- Deadly Poison IV
	[25347] = true, -- Deadly Poison V
	[8681]  = true, -- Instant Poison
	[8686]  = true, -- Instant Poison II
	[8688]  = true, -- Instant Poison III
	[11338] = true, -- Instant Poison IV
	[11339] = true, -- Instant Poison V
	[11343] = true, -- Instant Poison VI
	[5761]  = true, -- Mind-numbing Poison
	[8693]  = true, -- Mind-numbing Poison II
	[11399] = true, -- Mind-numbing Poison III
	[13220] = true, -- Wound Poison
	[13228] = true, -- Wound Poison II
	[13229] = true, -- Wound Poison III
	[13230] = true, -- Wound Poison IV

	-- Class / racial abilities that can't be kicked
	[20589] = true, -- Escape Artist
	[20549] = true, -- War Stomp
	[1510]  = true, -- Volley
	[20904] = true, -- Aimed Shot
	[11605] = true, -- Slam
	[1804]  = true, -- Pick Lock
	[1842]  = true, -- Disarm Trap
	[2641]  = true, -- Dismiss Pet
	[746]   = true, -- First Aid
	[20577] = true, -- Cannibalize
	[16075] = true, -- Throw Axe
	[7121]  = true, -- Anti-Magic Shield
	[4979]  = true, -- Quick Flame Ward
	[4980]  = true, -- Quick Frost Ward
	[5106]  = true, -- Crystal Flash

	-- Creature abilities (by spellID)
	[23041] = true, -- Call Anathema
	[6925]  = true, -- Gift of the Xavian
	[7279]  = true, -- Black Sludge
	[13692] = true, -- Dire Growl
	[9612]  = true, -- Ink Spray
	[22661] = true, -- Enervate
	[22421] = true, -- Massive Geyser
	[22662] = true, -- Wither
	[1050]  = true, -- Sacrifice
	[22651] = true, -- Sacrifice
	[22478] = true, -- Intense Pain
	[24189] = true, -- Force Punch
	[24314] = true, -- Threatening Gaze
	[21188] = true, -- Stun Bomb Attack
	[22372] = true, -- Demon Portal
	[26102] = true, -- Sand Blast
	[25748] = true, -- Poison Stinger
	[21097] = true, -- Manastorm
	[785]   = true, -- True Fulfillment
	[28615] = true, -- Spike Volley
	[28614] = true, -- Pointy Spike
	[28089] = true, -- Polarity Shift
	[28785] = true, -- Locust Swarm
	[18159] = true, -- Curse of the Fallen Magram
	[23511] = true, -- Demoralizing Shout
	[17238] = true, -- Drain Life
	[17243] = true, -- Drain Mana
	[17503] = true, -- Frostbolt
	[16869] = true, -- Ice Tomb
	[16788] = true, -- Fireball
	[16419] = true, -- Flamestrike
	[16390] = true, -- Flame Breath
	[13899] = true, -- Fire Storm
	[15668] = true, -- Fiery Burst
	[17235] = true, -- Raise Undead Scarab
	[4962]  = true, -- Encasing Webs
	[16418] = true, -- Crypt Scarabs
	[18327] = true, -- Silence
}

-- Casts matched by name -- covers every rank/copy that shares the name.
local namedSpells = {
	2480,   -- Shoot Bow
	7918,   -- Shoot Gun
	7919,   -- Shoot Crossbow
	10436,  -- Attack (totems)
	8858,   -- Bomb
	9483,   -- Boulder
	14146,  -- Clone
	16594,  -- Crypt Scarabs
	8995,   -- Shoot
	2764,   -- Throw
	1510,   -- Volley
	18431,  -- Bellowing Roar
	18500,  -- Wing Buffet
	22539,  -- Shadow Flame
	16868,  -- Banshee Wail
	22479,  -- Frost Breath
	26103,  -- Sweep
	30732,  -- Worm Sweep
	15847,  -- Tail Sweep
	7588,   -- Void Bolt
	26381,  -- Burrow
	27794,  -- Cleave
	28995,  -- Stoneskin
	28783,  -- Impale
	7951,   -- Toxic Spit
	7054,   -- Forsaken Skills
	-- Season of Discovery (harmless if the realm doesn't know the spell)
	433797, -- Bladestorm
	404373, -- Bubble Beam
	404316, -- Greater Frostbolt
	414370, -- Aqua Shell
	407819, -- Frost Arrow
	407568, -- Freezing Arrow
}

-- npcID -> {spellID, ...}. Same spell may be interruptible elsewhere; here it
-- isn't when this creature casts it.
local creatureSpells = {
	-- Molten Core
	[12118] = { 20604 },                         -- Lucifron: Dominate Mind
	[12119] = { 20604 },                         -- Flamewaker Protector: Dominate Mind
	[12259] = { 686 },                           -- Gehennas: Shadow Bolt
	-- Onyxia's Lair
	[10184] = { 9573, 133 },                     -- Onyxia: Flame Breath, Fireball
	-- Blackwing Lair
	[11983] = { 18500 },                         -- Firemaw: Wing Buffet
	[14020] = { 23310, 23316, 23309, 23187, 23314 }, -- Chromaggus: Time Lapse, Ignite Flesh, Incinerate, Frost Burn, Corrosive Acid
	[12465] = { 22425 },                         -- Death Talon Wyrmkin: Fireball Volley
	[12468] = { 2120 },                          -- Death Talon Hatcher: Flamestrike
	[13020] = { 9573 },                          -- Vaelastrasz the Corrupt: Flame Breath
	[12435] = { 22425 },                         -- Razorgore the Untamed: Fireball Volley
	[12459] = { 25417 },                         -- Blackwing Warlock: Shadow Bolt
	-- Molten Core (cont.)
	[12264] = { 1449 },                          -- Shazzrah: Arcane Explosion
	[12265] = { 133 },                           -- Lava Spawn: Fireball
	[12557] = { 14515 },                         -- Grethok the Controller: Dominate Mind
	-- Temple of Ahn'Qiraj
	[15276] = { 26006 },                         -- Emperor Vek'lor: Shadow Bolt
	[15589] = { 26134 },                         -- Eye of C'Thun: Eye Beam
	[15727] = { 26134 },                         -- C'Thun: Eye Beam
	-- Ruins of Ahn'Qiraj
	[15246] = { 11981, 17194, 22919 },           -- Qiraji Mindslayer: Mana Burn, Mind Blast, Mind Flay
	[15247] = { 11981, 16568 },                  -- Qiraji Brainwasher: Mana Burn, Mind Flay
	[15311] = { 26069, 11922, 12542, 26072 },    -- Anubisath Warder: Silence, Entangling Roots, Fear, Dust Cloud
	[15335] = { 21067 },                         -- Flesh Hunter: Poison Bolt
	[11729] = { 19452 },                         -- Hive'Zora Hive Sister: Toxic Spit
	-- World bosses
	[12397] = { 15245 },                         -- Lord Kazzak: Shadow Bolt Volley
	[14887] = { 16247 },                         -- Ysondre: Curse of Thorns
	-- Zul'Gurub
	[11372] = { 24011 },                         -- Razzashi Adder: Venom Spit
	[14834] = { 24322 },                         -- Hakkar: Blood Siphon
	[14507] = { 14914 },                         -- High Priest Venoxis: Holy Fire
	-- Dire Maul
	[11492] = { 9616 },                          -- Alzzin the Wildshaper: Wild Regeneration
	[11359] = { 16430 },                         -- Soulflayer: Soul Tap
	[11487] = { 7645, 15407 },                   -- Magister Kalendris: Dominate Mind, Mind Flay
	-- Naxxramas
	[16146] = { 17473 },                         -- Death Knight: Raise Dead
	[16368] = { 9081 },                          -- Necropolis Acolyte: Shadow Bolt Volley
	[16022] = { 16568 },                         -- Surgical Assistant: Mind Flay
	[8519]  = { 16554 },                         -- Blighted Surge: Toxic Bolt
	[16021] = { 1397, 1339, 28294 },             -- Living Monstrosity: Fear, Chain Lightning, Lightning Totem
	[16215] = { 1467 },                          -- Unholy Staff: Arcane Explosion
	[16452] = { 1467, 11829 },                   -- Necro Knight Guardian: Arcane Explosion, Flamestrike
	[16165] = { 1467, 11829 },                   -- Necro Knight: Arcane Explosion, Flamestrike
	-- Scarlet Monastery
	[4543]  = { 9613, 8814 },                    -- Bloodmage Thalnos: Shadow Bolt, Flame Spike
	[3977]  = { 9481, 12039, 9232 },             -- High Inquisitor Whitemane: Holy Smite, Heal, Scarlet Resurrection
	-- Scholomance
	[1853]  = { 18702, 5143 },                   -- Darkmaster Gandling: Curse of the Darkmaster, Arcane Missiles
	[10502] = { 14515, 12528, 12542 },           -- Lady Illucia Barov: Dominate Mind, Silence, Fear
	-- Stratholme
	[10438] = { 116 },                           -- Maleki the Pallid: Frostbolt
	[10440] = { 17393 },                         -- Baron Rivendare: Shadow Bolt
	[9029]  = { 15245 },                         -- Eviscerator: Shadow Bolt Volley
	-- Razorfen Downs / misc
	[7358]  = { 15530 },                         -- Amnennar the Coldbringer: Frostbolt
	-- Blackrock Depths
	[8983]  = { 15305 },                         -- Golem Lord Argelmach: Chain Lightning
	-- Season of Discovery
	[212969] = { 429825 },                       -- Kazragore: Chain Lightning
	[213334] = { 429168, 429356 },               -- Aku'mai: Corrosive Blast, Void Blast
}

-- Resolve names at load. Guarded: an unknown spellID returns nil, and a nil
-- table key (or nil concat) would error -- so skip anything that won't resolve.
local SpellName = C_Spell.GetSpellName

for _, id in ipairs(namedSpells) do
	local name = SpellName(id)
	if name then noInterrupt[name] = true end
end

local noInterruptByNpc = {}
for npcID, spells in pairs(creatureSpells) do
	for _, id in ipairs(spells) do
		local name = SpellName(id)
		if name then noInterruptByNpc[npcID .. name] = true end
	end
end

addon.noInterrupt = noInterrupt
addon.noInterruptByNpc = noInterruptByNpc
