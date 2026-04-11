local K = {}
cfCastbars.K = K

-----------------------------------------------------------------------
-- Pet
-----------------------------------------------------------------------
K.Pet              = "Pet"
K.PetIcon          = "PetIcon"
K.PetTimer         = "PetTimer"
K.PetText          = "PetText"
K.PetBorder        = "PetBorder"
K.PetScale         = "PetScale"
K.PetX             = "PetX"
K.PetY             = "PetY"
K.PetWidth         = "PetWidth"
K.PetHeight        = "PetHeight"
K.PetIconScale     = "PetIconScale"
K.PetIconX         = "PetIconX"
K.PetIconY         = "PetIconY"
K.PetTimerScale    = "PetTimerScale"
K.PetTimerX        = "PetTimerX"
K.PetTimerY        = "PetTimerY"
K.PetTextScale     = "PetTextScale"
K.PetTextX         = "PetTextX"
K.PetTextY         = "PetTextY"

-----------------------------------------------------------------------
-- Party
-----------------------------------------------------------------------
K.Party              = "Party"
K.PartyIcon          = "PartyIcon"
K.PartyTimer         = "PartyTimer"
K.PartyText          = "PartyText"
K.PartyBorder        = "PartyBorder"
K.PartyScale         = "PartyScale"
K.PartyX             = "PartyX"
K.PartyY             = "PartyY"
K.PartyWidth         = "PartyWidth"
K.PartyHeight        = "PartyHeight"
K.PartyIconScale     = "PartyIconScale"
K.PartyIconX         = "PartyIconX"
K.PartyIconY         = "PartyIconY"
K.PartyTimerScale    = "PartyTimerScale"
K.PartyTimerX        = "PartyTimerX"
K.PartyTimerY        = "PartyTimerY"
K.PartyTextScale     = "PartyTextScale"
K.PartyTextX         = "PartyTextX"
K.PartyTextY         = "PartyTextY"

-----------------------------------------------------------------------
-- Nameplate
-----------------------------------------------------------------------
K.Nameplate              = "Nameplate"
K.NameplateIcon          = "NameplateIcon"
K.NameplateTimer         = "NameplateTimer"
K.NameplateText          = "NameplateText"
K.NameplateBorder        = "NameplateBorder"
K.NameplateScale         = "NameplateScale"
K.NameplateX             = "NameplateX"
K.NameplateY             = "NameplateY"
K.NameplateWidth         = "NameplateWidth"
K.NameplateHeight        = "NameplateHeight"
K.NameplateIconScale     = "NameplateIconScale"
K.NameplateIconX         = "NameplateIconX"
K.NameplateIconY         = "NameplateIconY"
K.NameplateTimerScale    = "NameplateTimerScale"
K.NameplateTimerX        = "NameplateTimerX"
K.NameplateTimerY        = "NameplateTimerY"
K.NameplateTextScale     = "NameplateTextScale"
K.NameplateTextX         = "NameplateTextX"
K.NameplateTextY         = "NameplateTextY"

-----------------------------------------------------------------------
-- Player
-----------------------------------------------------------------------
K.Player              = "Player"
K.PlayerIcon          = "PlayerIcon"
K.PlayerTimer         = "PlayerTimer"
K.PlayerText          = "PlayerText"
K.PlayerBorder        = "PlayerBorder"
K.PlayerScale         = "PlayerScale"
K.PlayerX             = "PlayerX"
K.PlayerY             = "PlayerY"
K.PlayerWidth         = "PlayerWidth"
K.PlayerHeight        = "PlayerHeight"
K.PlayerIconScale     = "PlayerIconScale"
K.PlayerIconX         = "PlayerIconX"
K.PlayerIconY         = "PlayerIconY"
K.PlayerTimerScale    = "PlayerTimerScale"
K.PlayerTimerX        = "PlayerTimerX"
K.PlayerTimerY        = "PlayerTimerY"
K.PlayerTextScale     = "PlayerTextScale"
K.PlayerTextX         = "PlayerTextX"
K.PlayerTextY         = "PlayerTextY"

-----------------------------------------------------------------------
-- Target
-----------------------------------------------------------------------
K.Target              = "Target"
K.TargetIcon          = "TargetIcon"
K.TargetTimer         = "TargetTimer"
K.TargetText          = "TargetText"
K.TargetBorder        = "TargetBorder"
K.TargetScale         = "TargetScale"
K.TargetX             = "TargetX"
K.TargetY             = "TargetY"
K.TargetWidth         = "TargetWidth"
K.TargetHeight        = "TargetHeight"
K.TargetIconScale     = "TargetIconScale"
K.TargetIconX         = "TargetIconX"
K.TargetIconY         = "TargetIconY"
K.TargetTimerScale    = "TargetTimerScale"
K.TargetTimerX        = "TargetTimerX"
K.TargetTimerY        = "TargetTimerY"
K.TargetTextScale     = "TargetTextScale"
K.TargetTextX         = "TargetTextX"
K.TargetTextY         = "TargetTextY"

-----------------------------------------------------------------------
-- Defaults
-----------------------------------------------------------------------
local D = {}
cfCastbars.DEFAULTS = D

for key in pairs(K) do
	if key:match("Scale$") then
		D[key] = 1
	elseif key:match("X$") or key:match("Y$") or key:match("Width$") or key:match("Height$") then
		D[key] = 0
	else
		D[key] = true
	end
end

