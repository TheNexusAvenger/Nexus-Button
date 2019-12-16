--[[
TheNexusAvenger

"Factory" for creating buttons. Used to be able
to set defaults once.
--]]

--Offset of the color for the border for the default factory.
local BORDER_COLOR_OFFSET = Color3.new(-30/255,-30/255,-30/255)



local RootModule = script.Parent.Parent

local NexusInstance = require(RootModule:WaitForChild("NexusInstance"):WaitForChild("NexusInstance"))
local NexusButton = require(RootModule)

local ButtonFactory = NexusInstance:Extend()
ButtonFactory:SetClassName("ButtonFactory")



--[[
Adds two Color3s.
--]]
local function AddColor3(Color1,Color2)
	--Multiply the R,G,B values.
	local NewR,NewG,NewB = Color1.r + Color2.r,Color1.g + Color2.g,Color1.b + Color2.b
	
	--Clamp the values.
	NewR = math.clamp(NewR,0,1)
	NewG = math.clamp(NewG,0,1)
	NewB = math.clamp(NewB,0,1)
	
	--Return the color.
	return Color3.new(NewR,NewG,NewB)
end



--[[
Creates a button factory with the default style.
This is used by Nexus Development projects.
--]]
function ButtonFactory.CreateDefault(Color)
	--Create the factory.
	local Factory = ButtonFactory.new()
	
	--Set the defaults.
	Factory:SetDefault("BackgroundColor3",Color)
	Factory:SetDefault("BorderColor3",AddColor3(Color,BORDER_COLOR_OFFSET))
	Factory:SetDefault("BorderTransparency",0.25)
	
	--Return the factory.
	return Factory
end

--[[
Creates a button factory.
--]]
function ButtonFactory:__new()
	self:InitializeSuper()
	self.__Defaults = {}
end

--[[
Creates a button instance.
--]]
function ButtonFactory:Create()
	--Create the button.
	local Button = NexusButton.new()
	
	--Set the defaults.
	for PropertyName,PropertyValue in pairs(self.__Defaults) do
		Button[PropertyName] = PropertyValue
	end
	
	--Return the button.
	return Button
end

--[[
Sets a default property.
--]]
function ButtonFactory:SetDefault(PropertyName,Property)
	self.__Defaults[PropertyName] = Property
end

--[[
Unsets a default property.
--]]
function ButtonFactory:UnsetDefault(PropertyName)
	self.__Defaults[PropertyName] = nil
end



return ButtonFactory