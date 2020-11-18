--[[
TheNexusAvenger

"Factory" for creating text buttons. Used to be
able to set defaults once.
--]]

--Offset of the color for the border for the default factory.
local BORDER_COLOR_OFFSET = Color3.new(-30/255,-30/255,-30/255)



local RootModule = script.Parent.Parent

local ButtonFactory = require(RootModule:WaitForChild("Factory"):WaitForChild("ButtonFactory"))
local NexusButton = require(RootModule)

local TextButtonFactory = ButtonFactory:Extend()
TextButtonFactory:SetClassName("TextButtonFactory")



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
Creates a text button factory with the default
style. This is used by Nexus Development projects.
--]]
function TextButtonFactory.CreateDefault(Color)
	--Create the factory.
	local Factory = TextButtonFactory.new()
	
	--Set the defaults.
	Factory:SetDefault("BackgroundColor3",Color)
	Factory:SetDefault("BorderColor3",AddColor3(Color,BORDER_COLOR_OFFSET))
	Factory:SetDefault("BorderTransparency",0.25)
	Factory:SetTextDefault("Font",Enum.Font.SciFi)
	Factory:SetTextDefault("TextColor3",Color3.new(1,1,1))
	Factory:SetTextDefault("TextStrokeColor3",Color3.new(0,0,0))
	Factory:SetTextDefault("TextStrokeTransparency",0)
	Factory:SetTextDefault("TextScaled",true)
	
	--Return the factory.
	return Factory
end

--[[
Creates a text button factory.
--]]
function TextButtonFactory:__new()
	self:InitializeSuper()
	self.__TextDefaults = {}
end

--[[
Creates a text button instance.
--]]
function TextButtonFactory:Create()
	--Create the button.
	local Button = self.super:Create()
	
	--Add a text label.
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Size = UDim2.new(1,0,1,0)
	TextLabel.AnchorPoint = Vector2.new(0.5,0.5)
	TextLabel.Position = UDim2.new(0.5,0,0.5,0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.ZIndex = 5
	TextLabel.Parent = Button:GetAdornFrame()
	
	--Set the text defaults.
	for PropertyName,PropertyValue in pairs(self.__TextDefaults) do
		TextLabel[PropertyName] = PropertyValue
	end
	
	--Return the button and textlabel.
	return Button,TextLabel
end

--[[
Sets a default text property.
--]]
function ButtonFactory:SetTextDefault(PropertyName,Property)
	self.__TextDefaults[PropertyName] = Property
end

--[[
Unsets a default text property.
--]]
function ButtonFactory:UnsetTextDefault(PropertyName)
	self.__TextDefaults[PropertyName] = nil
end



return TextButtonFactory