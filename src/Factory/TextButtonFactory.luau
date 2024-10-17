--"Factory" for creating text buttons. Used to be able to set defaults once.
--!strict

local BORDER_COLOR_OFFSET = Color3.fromRGB(-30, -30, -30)

local NexusButton = require(script.Parent.Parent)
local ButtonFactory = require(script.Parent:WaitForChild("ButtonFactory"))

local TextButtonFactory = {}
TextButtonFactory.__index = TextButtonFactory
setmetatable(TextButtonFactory, ButtonFactory)

export type TextButtonFactory = {
    TextDefaults: {[string]: any},
} & typeof(setmetatable({}, TextButtonFactory)) & ButtonFactory.ButtonFactory



--[[
Creates a text button factory with the default
style. This is used by Nexus Development projects.
--]]
function TextButtonFactory.CreateDefault(Color: Color3): TextButtonFactory
    --Create the factory.
    local Factory = TextButtonFactory.new()

    --Set the defaults.
    Factory:SetDefault("BackgroundColor3", Color)
    Factory:SetDefault("BorderColor3", ButtonFactory.AddColor3(Color, BORDER_COLOR_OFFSET))
    Factory:SetDefault("BorderTransparency", 0.25)
    Factory:SetTextDefault("Font", Enum.Font.SourceSans)
    Factory:SetTextDefault("TextColor3", Color3.fromRGB(255, 255, 255))
    Factory:SetTextDefault("TextStrokeColor3", Color3.fromRGB(0, 0, 0))
    Factory:SetTextDefault("TextStrokeTransparency", 0)
    Factory:SetTextDefault("TextScaled", true)

    --Return the factory.
    return Factory
end

--[[
Creates a text button factory.
--]]
function TextButtonFactory.new(): TextButtonFactory
    local self = setmetatable(ButtonFactory.new(), TextButtonFactory) :: TextButtonFactory
    self.TextDefaults = {}
    return self
end

--[[
Creates a text button instance.
--]]
function TextButtonFactory.Create(self: TextButtonFactory): (NexusButton.NexusButton, TextLabel)
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
    for PropertyName,PropertyValue in self.TextDefaults do
        (TextLabel :: any)[PropertyName] = PropertyValue
    end

    --Return the button and textlabel.
    return Button, TextLabel
end

--[[
Sets a default text property.
--]]
function TextButtonFactory.SetTextDefault(self: TextButtonFactory, PropertyName: string, Property: any): ()
    self.TextDefaults[PropertyName] = Property
end

--[[
Unsets a default text property.
--]]
function TextButtonFactory.UnsetTextDefault(self: TextButtonFactory, PropertyName: string): ()
    self.TextDefaults[PropertyName] = nil
end



return TextButtonFactory