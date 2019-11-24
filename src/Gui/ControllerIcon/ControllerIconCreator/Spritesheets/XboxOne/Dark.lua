local Spritesheet = require(script.Parent.Parent.Parent.Spritesheet)
local Dark = {}
Dark.__index = Dark
setmetatable(Dark, Spritesheet)

local darkTexture = "rbxassetid://408444495"

function Dark.new()
	local newDark = Spritesheet.new(darkTexture)
	setmetatable(newDark, Dark)
	
	newDark:AddSprite("ButtonX", Vector2.new(510, 416), Vector2.new(95, 95))	
	newDark:AddSprite("ButtonY", Vector2.new(616, 318), Vector2.new(95, 95))
	newDark:AddSprite("ButtonA", Vector2.new(318, 416), Vector2.new(95, 95))
	newDark:AddSprite("ButtonB", Vector2.new(520, 522), Vector2.new(95, 95))
	newDark:AddSprite("ButtonR1", Vector2.new(0, 628), Vector2.new(115, 64))
	newDark:AddSprite("ButtonL1", Vector2.new(116, 628), Vector2.new(115, 64))
	newDark:AddSprite("ButtonR2", Vector2.new(616, 414), Vector2.new(105, 115))
	newDark:AddSprite("ButtonL2", Vector2.new(616, 0), Vector2.new(105, 115))
	newDark:AddSprite("ButtonR3", Vector2.new(0, 416), Vector2.new(105, 105))
	newDark:AddSprite("ButtonL3", Vector2.new(0, 522), Vector2.new(105, 105))
	newDark:AddSprite("ButtonSelect", Vector2.new(424, 522), Vector2.new(95, 95))
	newDark:AddSprite("DPadLeft", Vector2.new(318, 522), Vector2.new(105, 105))
	newDark:AddSprite("DPadRight", Vector2.new(212, 416), Vector2.new(105, 105))
	newDark:AddSprite("DPadUp", Vector2.new(616, 530), Vector2.new(105, 105))
	newDark:AddSprite("DPadDown", Vector2.new(212, 522), Vector2.new(105, 105))
	newDark:AddSprite("Thumbstick1", Vector2.new(616, 116), Vector2.new(105, 105))	
	newDark:AddSprite("Thumbstick2", Vector2.new(106, 522), Vector2.new(105, 105))
	newDark:AddSprite("DPad", Vector2.new(106, 416), Vector2.new(105, 105))
	newDark:AddSprite("Controller", Vector2.new(0, 0), Vector2.new(615, 415))
	newDark:AddSprite("RotateThumbstick1", Vector2.new(414, 416), Vector2.new(95, 95))
	newDark:AddSprite("RotateThumbstick2", Vector2.new(616, 222), Vector2.new(95, 95))
	
	return newDark
end

return Dark
