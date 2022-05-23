--[[
TheNexusAvenger

Class representing a controller icon.
--]]

local BASE_ICON_SIZE_RELATIVE = 0.9
local CUSTOM_MULTIPLIERS = {
    [Enum.KeyCode.ButtonL1] = {1, 0.5},
    [Enum.KeyCode.ButtonR1] = {1, 0.5},
}



local UserInputService = game:GetService("UserInputService")

local ControllerIconCreator = require(script:WaitForChild("ControllerIconCreator"))
local NexusInstance = require(script.Parent:WaitForChild("NexusWrappedInstance"):WaitForChild("NexusInstance"):WaitForChild("NexusInstance"))

local ControllerIcon = NexusInstance:Extend()
ControllerIcon:SetClassName("ControllerIcon")



--[[
Constructor of the Controller Icon class.
--]]
function ControllerIcon:__new()
    self:InitializeSuper()

    --Create the adorn frame.
    local AdornFrame = Instance.new("ImageLabel")
    AdornFrame.BackgroundTransparency = 1
    self.AdornFrame = AdornFrame
    self.IconScale = BASE_ICON_SIZE_RELATIVE

    --Connect the events.
    self.Events = {}
    table.insert(self.Events, UserInputService.GamepadConnected:Connect(function()
        self:UpdateVisibility()
    end))
    table.insert(self.Events, UserInputService.GamepadDisconnected:Connect(function()
        self:UpdateVisibility()
    end))

    --Update the visibility.
    self:UpdateVisibility()
end

--[[
Updates the visibility of the icon.
--]]
function ControllerIcon:UpdateVisibility(): nil
    --Set the visibility to false if there is no icon.
    if not self.Icon then
        self.AdornFrame.Visible = false
        self.IconVisible = false
        return
    end

    --Determine if a controller is connected.
    local ControllerConnected = (#UserInputService:GetConnectedGamepads() ~= 0)

    --Set the visibility.
    self.AdornFrame.Visible = ControllerConnected
    self.IconVisible = ControllerConnected
end

--[[
Sets the icon.
--]]
function ControllerIcon:SetIcon(KeyCode: Enum.KeyCode | string): nil
    --Return if the KeyCode is nil.
    if KeyCode == nil then
        self.KeyCode = nil
        self.Icon:Destroy()
        self.Icon = nil
        self:UpdateVisibility()
        return
    end

    --Covert the KeyCode from a string.
    if type(KeyCode) == "string" then
        KeyCode = Enum.KeyCode[KeyCode]
    end

    --Destroy the existing icon.
    if self.Icon then
        self.Icon:Destroy()
    end

    --Create the new icon.
    local Icon = ControllerIconCreator:GetImageLabel(KeyCode, "Dark", "XboxOne")
    Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    Icon.AnchorPoint = Vector2.new(0.5, 0.5)
    Icon.ZIndex = self.AdornFrame.ZIndex
    Icon.Parent = self.AdornFrame
    self.Icon = Icon
    self.KeyCode = KeyCode
    self:UpdateVisibility()
    self:SetScale(self.IconScale)
end

--[[
Sets the scale of the icon.
--]]
function ControllerIcon:SetScale(NewScale: number): nil
    self.IconScale = NewScale

    --Set the size.
    if self.KeyCode and self.Icon then
        local ScaleMultipliers = CUSTOM_MULTIPLIERS[self.KeyCode] or {1, 1}
        self.Icon.Size = UDim2.new(self.IconScale * ScaleMultipliers[1], 0, self.IconScale * ScaleMultipliers[2], 0)
    end
end

--[[
Destroys the frame.
--]]
function ControllerIcon:Destroy(): nil
    self.super:Destroy()

    --Disconnect the events.
    for _,Event in pairs(self.Events) do
        Event:Disconnect()
    end
    self.Events = {}

    --Destroy the adorn frame.
    self.AdornFrame:Destroy()
end



return ControllerIcon