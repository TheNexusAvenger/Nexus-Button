--[[
TheNexusAvenger

"Factory" for creating text buttons. Used to be
able to set defaults once.
--]]

local BORDER_COLOR_OFFSET = Color3.new(-30 / 255, -30 / 255, -30 / 255)



local RootModule = script.Parent.Parent

local ButtonFactory = require(RootModule:WaitForChild("Factory"):WaitForChild("ButtonFactory"))

local TextButtonFactory = ButtonFactory:Extend()
TextButtonFactory:SetClassName("TextButtonFactory")



--[[
Adds two Color3s.
--]]
local function AddColor3(Color1: Color3, Color2: Color3): Color3
    return Color3.new(math.clamp(Color1.R + Color2.R, 0, 1), math.clamp(Color1.G + Color2.G, 0, 1), math.clamp(Color1.B + Color2.B, 0, 1))
end



--[[
Creates a text button factory with the default
style. This is used by Nexus Development projects.
--]]
function TextButtonFactory.CreateDefault(Color: Color3)
    --Create the factory.
    local Factory = TextButtonFactory.new()

    --Set the defaults.
    Factory:SetDefault("BackgroundColor3", Color)
    Factory:SetDefault("BorderColor3", AddColor3(Color, BORDER_COLOR_OFFSET))
    Factory:SetDefault("BorderTransparency", 0.25)
    Factory:SetTextDefault("Font", Enum.Font.SourceSans)
    Factory:SetTextDefault("TextColor3", Color3.new(1,1,1))
    Factory:SetTextDefault("TextStrokeColor3", Color3.new(0,0,0))
    Factory:SetTextDefault("TextStrokeTransparency", 0)
    Factory:SetTextDefault("TextScaled", true)

    --Return the factory.
    return Factory
end

--[[
Creates a text button factory.
--]]
function TextButtonFactory:__new()
    ButtonFactory.__new(self)
    self.TextDefaults = {}
end

--[[
Creates a text button instance.
--]]
function TextButtonFactory:Create()
    --Create the button.
    local Button = ButtonFactory.Create(self)

    --Add a text label.
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.ZIndex = 5
    TextLabel.Parent = Button:GetAdornFrame()

    --Set the text defaults.
    for PropertyName,PropertyValue in pairs(self.TextDefaults) do
        TextLabel[PropertyName] = PropertyValue
    end

    --Return the button and textlabel.
    return Button, TextLabel
end

--[[
Sets a default text property.
--]]
function ButtonFactory:SetTextDefault(PropertyName: string, Property: any): nil
    self.TextDefaults[PropertyName] = Property
end

--[[
Unsets a default text property.
--]]
function ButtonFactory:UnsetTextDefault(PropertyName: string)
    self.TextDefaults[PropertyName] = nil
end



return TextButtonFactory