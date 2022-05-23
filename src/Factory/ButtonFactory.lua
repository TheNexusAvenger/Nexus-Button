--[[
TheNexusAvenger

"Factory" for creating buttons. Used to be able
to set defaults once.
--]]

local BORDER_COLOR_OFFSET = Color3.new(-30 / 255, -30 / 255, -30 / 255)



local RootModule = script.Parent.Parent

local NexusInstance = require(RootModule:WaitForChild("NexusWrappedInstance"):WaitForChild("NexusInstance"):WaitForChild("NexusInstance"))
local NexusButton = require(RootModule)

local ButtonFactory = NexusInstance:Extend()
ButtonFactory:SetClassName("ButtonFactory")



--[[
Adds two Color3s.
--]]
local function AddColor3(Color1: Color3, Color2: Color3): Color3
    return Color3.new(math.clamp(Color1.R + Color2.R, 0, 1), math.clamp(Color1.G + Color2.G, 0, 1), math.clamp(Color1.B + Color2.B, 0, 1))
end



--[[
Creates a button factory with the default style.
This is used by Nexus Development projects.
--]]
function ButtonFactory.CreateDefault(Color: Color3)
    --Create the factory.
    local Factory = ButtonFactory.new()

    --Set the defaults.
    Factory:SetDefault("BackgroundColor3", Color)
    Factory:SetDefault("BorderColor3", AddColor3(Color, BORDER_COLOR_OFFSET))
    Factory:SetDefault("BorderTransparency", 0.25)

    --Return the factory.
    return Factory
end

--[[
Creates a button factory.
--]]
function ButtonFactory:__new()
    self:InitializeSuper()
    self.Defaults = {}
end

--[[
Creates a button instance.
--]]
function ButtonFactory:Create()
    --Create the button.
    local Button = NexusButton.new()

    --Set the defaults.
    for PropertyName,PropertyValue in pairs(self.Defaults) do
        Button[PropertyName] = PropertyValue
    end

    --Return the button.
    return Button
end

--[[
Sets a default property.
--]]
function ButtonFactory:SetDefault(PropertyName: string, Property: any): nil
    self.Defaults[PropertyName] = Property
end

--[[
Unsets a default property.
--]]
function ButtonFactory:UnsetDefault(PropertyName: string): nil
    self.Defaults[PropertyName] = nil
end



return ButtonFactory