local Spritesheet = {}
Spritesheet.__index = Spritesheet

function Spritesheet.new(texture)
	local newSpritesheet = {}
	setmetatable(newSpritesheet, Spritesheet)
	
	newSpritesheet.Texture = texture
	newSpritesheet.Sprites = {}	
	
	return newSpritesheet
end

function Spritesheet:AddSprite(index, position, size)
	local Sprite = {Position=position,Size=size}
	self.Sprites[index] = Sprite
end

function Spritesheet:GetSprite(instanceType, index)
	if not index then
		warn("Image name cannot be nil")
		return false
	end
	local sprite = self.Sprites[index]
	if not sprite then 
		warn("Could not find sprite for: " .. index) 
		return false
	end
	local element = Instance.new(instanceType)
	element.BackgroundTransparency = 1
	element.BorderSizePixel = 1
	element.Image = self.Texture
	element.Size = UDim2.new(0, sprite.Size.X, 0, sprite.Size.Y)
	element.ImageRectOffset = sprite.Position
	element.ImageRectSize = sprite.Size
	
	return element
end

return Spritesheet
