--[[
TheNexusAvenger

Main module representing the button class. This button
is meant to provide an easy way to make "good looking",
cross platform buttons.
--]]
--!strict

local HOVER_COLOR_MULTIPLIER = 0.7
local PRESS_COLOR_MULTIPLIER = 1 / 0.7
local CONTROLLER_SECTION_COLOR = Color3.new(50 / 255, 50 / 255, 50 / 255)
local DEFAULT_THEMES = {
    CutCorners = {
        MainButton = {
            Image = "rbxassetid://9708818802",
            SliceCenter = Rect.new(500, 500, 524, 524),
            SliceScaleMultiplier = 0.2 / 500,
        },
        GamepadIconBackground = {
            Image = "rbxassetid://9708824372",
            SliceCenter = Rect.new(500, 500, 524, 524),
            SliceScaleMultiplier = 0.2 / 500,
        },
    },
    CutTopLeftCorner = {
        MainButton = {
            Image = "rbxassetid://9708819815",
            SliceCenter = Rect.new(500, 500, 524, 524),
            SliceScaleMultiplier = 0.2 / 500,
        },
        GamepadIconBackground = {
            Image = "rbxassetid://9708825225",
            SliceCenter = Rect.new(500, 500, 524, 524),
            SliceScaleMultiplier = 0.2 / 500,
        },
    },
    CutBottomRightCorner = {
        MainButton = {
            Image = "rbxassetid://9708824372",
            SliceCenter = Rect.new(500, 500, 524, 524),
            SliceScaleMultiplier = 0.2 / 500,
        },
        GamepadIconBackground = {
            Image = "rbxassetid://9708824372",
            SliceCenter = Rect.new(500, 500, 524, 524),
            SliceScaleMultiplier = 0.2 / 500,
        },
    },
    RoundedCorners = {
        MainButton = {
            Image = "rbxassetid://9704725601",
            SliceCenter = Rect.new(500, 500, 524, 524),
            SliceScaleMultiplier = 0.2 / 500,
        },
        GamepadIconBackground = {
            Image = "rbxassetid://9704725809",
            SliceCenter = Rect.new(500, 500, 524, 524),
            SliceScaleMultiplier = 0.2 / 500,
        },
    },
}



local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ControllerIcon = require(script:WaitForChild("ControllerIcon"))
local NexusWrappedInstance = require(script:WaitForChild("NexusWrappedInstance"))

local NexusButton = NexusWrappedInstance:Extend()
NexusButton.Themes = DEFAULT_THEMES
NexusButton:SetClassName("NexusButton")

export type NexusButtonTheme = {
    MainButton: {
        Image: string,
        SliceCenter: Rect,
        SliceScaleMultiplier: number,
    },
    GamepadIconBackground: {
        Image: string,
        SliceCenter: Rect,
        SliceScaleMultiplier: number,
    },
}
export type NexusButton = {
    new: () -> NexusButton,
    Extend: (self: NexusButton) -> NexusButton,

    BorderSizeScale: number,
    TweenDuration: number,
    Theme: string,
    OverrideButtonProperty: (self: NexusButton, PropertyName: string, SetFunction: (any) -> ()) -> (),
    GetAdornFrame: (self: NexusButton) -> Frame,
    SetControllerIcon: (self: NexusButton, KeyCode: Enum.KeyCode | string) -> (),
    MapKey: (self: NexusButton, KeyCode: Enum.KeyCode | string, MouseInput: Enum.UserInputType | string) -> (),
    UnmapKey: (KeyCode: Enum.KeyCode | string) -> (),
} & NexusWrappedInstance.NexusWrappedInstance & TextButton



--[[
Multiplies a Color3.
--]]
local function MultiplyColor3(Color: Color3, Multiplier: number): Color3
    return Color3.new(math.clamp(Color.R * Multiplier, 0, 1), math.clamp(Color.G * Multiplier, 0, 1), math.clamp(Color.B * Multiplier, 0, 1))
end

--[[
Creates a Nexus Button object.
--]]
function NexusButton:__new(): ()
    NexusWrappedInstance.__new(self, "TextButton")

    --Create the frames.
    local BaseButton = self:GetWrappedInstance()
    BaseButton.BackgroundTransparency = 1
    BaseButton.Text = ""

    local BorderFrame = Instance.new("ImageLabel")
    BorderFrame.BackgroundTransparency = 1
    BorderFrame.ScaleType = Enum.ScaleType.Slice
    BorderFrame.Parent = BaseButton
    self:DisableChangeReplication("BorderFrame")
    self.BorderFrame = BorderFrame

    local BackgroundFrame = Instance.new("ImageLabel")
    BackgroundFrame.BackgroundTransparency = 1
    BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    BackgroundFrame.ZIndex = 2
    BackgroundFrame.ScaleType = Enum.ScaleType.Slice
    BackgroundFrame.Parent = BaseButton
    self:DisableChangeReplication("BackgroundFrame")
    self.BackgroundFrame = BackgroundFrame

    BackgroundFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self:UpdateSliceScale()
        self:UpdateBorder(false)
    end)

    local ContentsAdorn = Instance.new("Frame")
    ContentsAdorn.BackgroundTransparency = 1
    ContentsAdorn.Size = UDim2.new(1, 0, 1, 0)
    ContentsAdorn.ZIndex = 3
    ContentsAdorn.Parent = BaseButton
    self:DisableChangeReplication("ContentsAdorn")
    self.ContentsAdorn = ContentsAdorn

    local GamepadIcon = ControllerIcon.new()
    GamepadIcon.AdornFrame.ImageColor3 = CONTROLLER_SECTION_COLOR
    GamepadIcon.AdornFrame.Size = UDim2.new(1, 0, 1, 0)
    GamepadIcon.AdornFrame.Position = UDim2.new(1, 0, 0, 0)
    GamepadIcon.AdornFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
    GamepadIcon.AdornFrame.AnchorPoint = Vector2.new(1, 0)
    GamepadIcon.AdornFrame.ZIndex = 4
    GamepadIcon.AdornFrame.ScaleType = Enum.ScaleType.Slice
    GamepadIcon.AdornFrame.Parent = BaseButton
    self:DisableChangeReplication("GamepadIcon")
    self.GamepadIcon = GamepadIcon

    --Connect replicating values.
    local ButtonPropertyOverrides = {}
    self:DisableChangeReplication("ButtonPropertyOverrides")
    self.ButtonPropertyOverrides = ButtonPropertyOverrides
    self:AddGenericPropertyFinalizer(function(PropertyName: string, Value: any)
        if not ButtonPropertyOverrides[PropertyName] then
            return
        end
        ButtonPropertyOverrides[PropertyName](Value)
    end)

    --Set the replication overrides.
    self:DisableChangeReplication("TweenDuration")
    self:OverrideButtonProperty("BackgroundColor3", function()
        self:UpdateBorder(false)
    end)
    self:OverrideButtonProperty("BackgroundTransparency", function(NewBackgroundTransparency: number)
        BackgroundFrame.ImageTransparency = NewBackgroundTransparency
    end)
    self:OverrideButtonProperty("BorderSize", function()
        self:UpdateBorder(false)
    end)
    self:OverrideButtonProperty("BorderSizePixel", function(NewBorderSizePixel: number)
        self.BorderSize = UDim.new(0, NewBorderSizePixel)
    end)
    self:OverrideButtonProperty("BorderSizeScale", function(NewBorderSizeScale: number)
        self.BorderSize = UDim.new(NewBorderSizeScale, 0)
    end)
    self:OverrideButtonProperty("BorderColor3", function()
        self:UpdateBorder(false)
    end)
    self:OverrideButtonProperty("AutoButtonColor", function()
        self:UpdateBorder(false)
    end)
    self:OverrideButtonProperty("BorderTransparency", function(NewBorderTransparency: number)
        BorderFrame.ImageTransparency = NewBorderTransparency
    end)
    self:OverrideButtonProperty("Hovering", function()
        self:UpdateBorder(true)
    end)
    self:OverrideButtonProperty("Pressed", function()
        self:UpdateBorder(true)
    end)
    self:OverrideButtonProperty("Theme", function(NewTheme: string)
        local Theme = NexusButton.Themes[NewTheme]
        if not Theme then
            error("Unknown theme: "..tostring(NewTheme))
        end
        BackgroundFrame.Image = Theme.MainButton.Image
        BackgroundFrame.SliceCenter = Theme.MainButton.SliceCenter
        BorderFrame.Image = Theme.MainButton.Image
        BorderFrame.SliceCenter = Theme.MainButton.SliceCenter
        GamepadIcon.AdornFrame.Image = Theme.GamepadIconBackground.Image
        GamepadIcon.AdornFrame.SliceCenter = Theme.GamepadIconBackground.SliceCenter
        self:UpdateSliceScale()
    end)

    --Connect the events.
    self:DisableChangeReplication("MappedInputs")
    self.MappedInputs = {}
    self:DisableChangeReplication("Events")
    self.Events = {}
    self.MouseEnter:Connect(function()
        self.Hovering = true
    end)
    self.MouseLeave:Connect(function()
        self.Hovering = false
    end)
    self.MouseButton1Down:Connect(function()
        self.Pressed = true
    end)
    self.MouseButton1Up:Connect(function()
        self.Pressed = false
    end)
    table.insert(self.Events, GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
        self:UpdateBorder(true)
    end))
    table.insert(self.Events, UserInputService.InputBegan:Connect(function(Input, Processed)
        if Processed and (GuiService.SelectedObject ~= self:GetWrappedInstance() or Input.KeyCode == Enum.KeyCode.ButtonA) then return end
        if self.Pressed then return end
        if not self.MappedInputs[Input.KeyCode] then return end

        local MouseInput = self.MappedInputs[Input.KeyCode]
        if MouseInput == Enum.UserInputType.MouseButton1 then
            self.MouseButton1Down:Fire()
        elseif MouseInput == Enum.UserInputType.MouseButton2 then
            self.MouseButton2Down:Fire()
        end
    end))
    table.insert(self.Events, UserInputService.InputEnded:Connect(function(Input)
        if not self.Pressed then return end
        if not self.MappedInputs[Input.KeyCode] then return end

        local MouseInput = self.MappedInputs[Input.KeyCode]
        if MouseInput == Enum.UserInputType.MouseButton1 then
            self.MouseButton1Up:Fire()
            self.MouseButton1Click:Fire()
        elseif MouseInput == Enum.UserInputType.MouseButton2 then
            self.MouseButton2Up:Fire()
            self.MouseButton2Click:Fire()
        end
    end))

    --Set the defaults.
    self.Size = UDim2.new(0, 200, 0, 50)
    self.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    self.BackgroundTransparency = 0
    self.BorderSize = UDim.new(0.15, 0)
    self.BorderColor3 = Color3.new(0, 0, 0)
    self.BorderTransparency = 0
    self.AutoButtonColor = true
    self.Hovering = false
    self.Pressed = false
    self.TweenDuration = 0.1
    self.Theme = "CutCorners"
end

--[[
Overrides the replication of a property for the button.
--]]
function NexusButton:OverrideButtonProperty(PropertyName: string, SetFunction: (any) -> ()): ()
    self:DisableChangeReplication(PropertyName)
    self.ButtonPropertyOverrides[PropertyName] = SetFunction
end

--[[
Updates the slice scales of the background and border.
--]]
function NexusButton:UpdateSliceScale(): ()
    local Theme = NexusButton.Themes[self.Theme]
    local ButtonSize = math.min(self.AbsoluteSize.X, self.AbsoluteSize.Y)
    local SliceScale = ButtonSize * Theme.MainButton.SliceScaleMultiplier
    self.BackgroundFrame.SliceScale = SliceScale
    self.BorderFrame.SliceScale = SliceScale
    self.GamepadIcon.AdornFrame.SliceScale = SliceScale
end

--[[
Updates the background and border properties.
--]]
function NexusButton:UpdateBorder(Tween: boolean?): ()
    --Get the border size.
    if not self.BorderSize then return end
    if not self.Theme then return end
    local ButtonSizeY = self.BackgroundFrame.AbsoluteSize.Y
    local BorderSize = (ButtonSizeY * self.BorderSize.Scale) + self.BorderSize.Offset
    local BackgroundColor3 = self.BackgroundColor3
    local BorderColor3 = self.BorderColor3

    --Modify the properties.
    if self.AutoButtonColor ~= false then
        if self.Pressed then
            BackgroundColor3 = MultiplyColor3(BackgroundColor3, PRESS_COLOR_MULTIPLIER)
            BorderColor3 = MultiplyColor3(BorderColor3, PRESS_COLOR_MULTIPLIER)
            BorderSize = BorderSize * 0.25
        elseif self.Hovering or GuiService.SelectedObject == self:GetWrappedInstance() then
            BackgroundColor3 = MultiplyColor3(BackgroundColor3, HOVER_COLOR_MULTIPLIER)
            BorderColor3 = MultiplyColor3(BorderColor3, HOVER_COLOR_MULTIPLIER)
            BorderSize = BorderSize * 0.75
        end
    end

    --Apply the properties.
    if Tween and self.TweenDuration and self.TweenDuration > 0 then
        TweenService:Create(self.BackgroundFrame:GetWrappedInstance(), TweenInfo.new(self.TweenDuration), {
            ImageColor3 = BackgroundColor3,
        }):Play()
        TweenService:Create(self.BorderFrame:GetWrappedInstance(), TweenInfo.new(self.TweenDuration), {
            ImageColor3 = BorderColor3,
            Size = UDim2.new(1, 0, 1, BorderSize),
        }):Play()
    else
        self.BackgroundFrame.ImageColor3 = BackgroundColor3
        self.BorderFrame.ImageColor3 = BorderColor3
        self.BorderFrame.Size = UDim2.new(1, 0, 1, BorderSize)
    end
end

--[[
Returns the adorn frame to parent frames to the button.
--]]
function NexusButton:GetAdornFrame(): Frame
    return self.ContentsAdorn:GetWrappedInstance()
end

--[[
Sets the controller icon for the button.
--]]
function NexusButton:SetControllerIcon(KeyCode: Enum.KeyCode | string): ()
    self.GamepadIcon:SetIcon(KeyCode)
end

--[[
Maps a key input to a mouse input for clicking.
--]]
function NexusButton:MapKey(KeyCode: Enum.KeyCode | string, MouseInput: Enum.UserInputType | string): ()
    --Correct the inputs.
    if typeof(KeyCode) == "string" then
        KeyCode = (Enum.KeyCode :: any)[KeyCode]
    end
    if typeof(MouseInput) == "string" then
        MouseInput = (Enum.UserInputType :: any)[MouseInput]
    end

    --Throw an error if the mouse input is invalid.
    if MouseInput ~= Enum.UserInputType.MouseButton1 and MouseInput ~= Enum.UserInputType.MouseButton2 then
        error("Mouse input must be either MouseButton1 or MouseButton2.")
    end

    --Store the mapped input.
    self.MappedInputs[KeyCode] = MouseInput
end

--[[
Unmaps a key input to a mouse input for clicking.
--]]
function NexusButton:UnmapKey(KeyCode: Enum.KeyCode | string): ()
    --Correct the input.
    if typeof(KeyCode) == "string" then
        KeyCode = (Enum.KeyCode :: any)[KeyCode]
    end

    --Remove the mapped input.
    self.MappedInputs[KeyCode] = nil
end

--[[
Destroys the button and disconnects the events.
--]]
function NexusButton:Destroy(): ()
    NexusWrappedInstance.Destroy(self)
    self.GamepadIcon:Destroy()

    --Disconnect the events.
    for _, Event in self.Events do
        Event:Disconnect()
    end
    self.Events = {}
end



return NexusButton :: NexusButton