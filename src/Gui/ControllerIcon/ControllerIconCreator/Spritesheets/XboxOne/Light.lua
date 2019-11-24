local Spritesheet = require(script.Parent.Parent.Parent.Spritesheet)
local Light = {}
Light.__index = Light
setmetatable(Light, Spritesheet)

local lightTexture = "rbxassetid://408462759"

function Light.new()
	local newLight = Spritesheet.new(lightTexture)
	setmetatable(newLight, Light)
	
	newLight:AddSprite("ButtonX", Vector2.new(318, 481), Vector2.new(95, 95))	
	newLight:AddSprite("ButtonY", Vector2.new(500, 587), Vector2.new(95, 95))
	newLight:AddSprite("ButtonA", Vector2.new(308, 587), Vector2.new(95, 95))
	newLight:AddSprite("ButtonB", Vector2.new(510, 481), Vector2.new(95, 95))
	newLight:AddSprite("ButtonR1", Vector2.new(0, 416), Vector2.new(115, 64))
	newLight:AddSprite("ButtonL1", Vector2.new(116, 416), Vector2.new(115, 64))
	newLight:AddSprite("ButtonR2", Vector2.new(616, 0), Vector2.new(105, 115))
	newLight:AddSprite("ButtonL2", Vector2.new(616, 328), Vector2.new(105, 115))
	newLight:AddSprite("ButtonR3", Vector2.new(616, 550), Vector2.new(105, 105))
	newLight:AddSprite("ButtonL3", Vector2.new(616, 116), Vector2.new(105, 105))
	newLight:AddSprite("ButtonSelect", Vector2.new(404, 587), Vector2.new(95, 95))
	newLight:AddSprite("DPadLeft", Vector2.new(616, 444), Vector2.new(105, 105))
	newLight:AddSprite("DPadRight", Vector2.new(0, 587), Vector2.new(105, 105))
	newLight:AddSprite("DPadUp", Vector2.new(616, 222), Vector2.new(105, 105))
	newLight:AddSprite("DPadDown", Vector2.new(212, 481), Vector2.new(105, 105))
	newLight:AddSprite("Thumbstick1", Vector2.new(0, 481), Vector2.new(105, 105))	
	newLight:AddSprite("Thumbstick2", Vector2.new(106, 587), Vector2.new(105, 105))
	newLight:AddSprite("DPad", Vector2.new(106, 481), Vector2.new(105, 105))
	newLight:AddSprite("Controller", Vector2.new(0, 0), Vector2.new(615, 415))
	newLight:AddSprite("RotateThumbstick1", Vector2.new(414, 481), Vector2.new(95, 95))
	newLight:AddSprite("RotateThumbstick2", Vector2.new(212, 587), Vector2.new(95, 95))
	
	return newLight
end

return Light
