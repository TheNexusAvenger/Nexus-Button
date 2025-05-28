--"Factory" for creating buttons. Used to be able to set defaults once.
--!strict

local BORDER_COLOR_OFFSET = Color3.fromRGB(-30, -30, -30)

local NexusButton = require(script.Parent.Parent:WaitForChild("Button"))

local ButtonFactory = {}
ButtonFactory.__index = ButtonFactory

export type ButtonFactory = {
    Defaults: {[string]: any}
} & typeof(setmetatable({}, ButtonFactory))



--[[
Adds two Color3s.
--]]
function ButtonFactory.AddColor3(Color1: Color3, Color2: Color3): Color3
    return Color3.new(math.clamp(Color1.R + Color2.R, 0, 1), math.clamp(Color1.G + Color2.G, 0, 1), math.clamp(Color1.B + Color2.B, 0, 1))
end

--[[
Creates a button factory with the default style.
This is used by Nexus Development projects.
--]]
function ButtonFactory.CreateDefault(Color: Color3): ButtonFactory
    --Create the factory.
    local Factory = ButtonFactory.new()

    --Set the defaults.
    Factory:SetDefault("BackgroundColor3", Color)
    Factory:SetDefault("BorderColor3", ButtonFactory.AddColor3(Color, BORDER_COLOR_OFFSET))
    Factory:SetDefault("BorderTransparency", 0.25)

    --Return the factory.
    return Factory
end

--[[
Creates a button factory.
--]]
function ButtonFactory.new(): ButtonFactory
    return setmetatable({
        Defaults = {}
    }, ButtonFactory) :: ButtonFactory
end

--[[
Creates a button instance.
--]]
function ButtonFactory.Create(self: ButtonFactory): NexusButton.NexusInstanceNexusButton
    --Create the button.
    local Button = NexusButton.new()

    --Set the defaults.
    for PropertyName,PropertyValue in self.Defaults do
        (Button :: any)[PropertyName] = PropertyValue
    end

    --Return the button.
    return Button
end

--[[
Sets a default property.
--]]
function ButtonFactory.SetDefault(self: ButtonFactory, PropertyName: string, Property: any): ()
    self.Defaults[PropertyName] = Property
end

--[[
Unsets a default property.
--]]
function ButtonFactory.UnsetDefault(self: ButtonFactory, PropertyName: string): ()
    self.Defaults[PropertyName] = nil
end



return ButtonFactory