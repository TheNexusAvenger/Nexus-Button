--Main module representing the button class. This button is meant to provide
--an easy way to make "good looking", cross platform buttons.
--!strict

local HOVER_COLOR_MULTIPLIER = 0.7
local PRESS_COLOR_MULTIPLIER = 1 / 0.7
local CONTROLLER_SECTION_THEME_MINIMUM_ASPECT_RATIO = 1.2
local CONTROLLER_SECTION_COLOR = Color3.fromRGB(50, 50, 50)

local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local NexusInstance = require(script:WaitForChild("NexusInstance"))
local ControllerIcon = require(script:WaitForChild("ControllerIcon"))
local SimpleWrappedInstance = require(script:WaitForChild("SimpleWrappedInstance"))
local ThemedFrame = require(script:WaitForChild("ThemedFrame"))

local NexusButton = {}
NexusButton.Themes = ThemedFrame.Themes
NexusButton.__index = NexusButton
setmetatable(NexusButton, SimpleWrappedInstance)

export type NexusButton = {
    Theme: string,
    BorderSize: UDim,
    BorderSizeScale: number,
    TweenDuration: number,
    BorderTransparency: number,
    ContentsAdorn: Frame,
    MouseButton1Down: NexusInstance.TypedEvent<number, number>,
    MouseButton1Up: NexusInstance.TypedEvent<number, number>,
    MouseButton1Click: NexusInstance.TypedEvent<>,
    MouseButton2Down: NexusInstance.TypedEvent<number, number>,
    MouseButton2Up: NexusInstance.TypedEvent<number, number>,
    MouseButton2Click: NexusInstance.TypedEvent<>,

    BackgroundFrame: ThemedFrame.NexusInstanceThemedFrame,
    BorderFrame: ThemedFrame.NexusInstanceThemedFrame,
    GamepadIcon: ControllerIcon.NexusInstanceControllerIcon,
    Hovering: boolean,
    Pressed: boolean,
    MappedInputs: {[Enum.KeyCode]: Enum.UserInputType},
    EventConnections: {RBXScriptConnection},
} & typeof(setmetatable({}, NexusButton)) & SimpleWrappedInstance.SimpleWrappedInstance<TextButton>
export type NexusInstanceNexusButton = NexusInstance.NexusInstance<NexusButton>



--[[
Multiplies a Color3.
--]]
local function MultiplyColor3(Color: Color3, Multiplier: number): Color3
    return Color3.new(math.clamp(Color.R * Multiplier, 0, 1), math.clamp(Color.G * Multiplier, 0, 1), math.clamp(Color.B * Multiplier, 0, 1))
end

--[[
Creates a Nexus Button object.
--]]
function NexusButton.__new(self: NexusInstanceNexusButton): ()
    SimpleWrappedInstance.__new(self, Instance.new("TextButton"))

    --Create the frames.
    local BaseButton = self:GetWrappedInstance()
    BaseButton.BackgroundTransparency = 1
    BaseButton.Text = ""

    local BorderFrame = ThemedFrame.new()
    BorderFrame.Parent = BaseButton
    self:DisableChangeReplication("BorderFrame")
    self.BorderFrame = BorderFrame

    local BackgroundFrame = ThemedFrame.new()
    BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    BackgroundFrame.ZIndex = 2
    BackgroundFrame.Parent = BaseButton
    self:DisableChangeReplication("BackgroundFrame")
    self.BackgroundFrame = BackgroundFrame

    BackgroundFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
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
    GamepadIcon.BackgroundColor3 = CONTROLLER_SECTION_COLOR
    GamepadIcon.Size = UDim2.new(1, 0, 1, 0)
    GamepadIcon.Position = UDim2.new(1, 0, 0, 0)
    GamepadIcon.SizeConstraint = Enum.SizeConstraint.RelativeYY
    GamepadIcon.AnchorPoint = Vector2.new(1, 0)
    GamepadIcon.ZIndex = 4
    GamepadIcon.Parent = BaseButton
    self:DisableChangeReplication("GamepadIcon")
    self.GamepadIcon = GamepadIcon

    --Prepare the wrapped events.
    self:DisableChangeReplication("MouseButton1Down")
    self.MouseButton1Down = self:CreateEvent() :: any
    self:GetWrappedInstance().MouseButton1Down:Connect(function(...)
        self.MouseButton1Down:Fire(...)
    end)
    self:DisableChangeReplication("MouseButton1Up")
    self.MouseButton1Up = self:CreateEvent()  :: any
    self:GetWrappedInstance().MouseButton1Up:Connect(function(...)
        self.MouseButton1Up:Fire(...)
    end)
    self:DisableChangeReplication("MouseButton1Click")
    self.MouseButton1Click = self:CreateEvent()  :: any
    self:GetWrappedInstance().MouseButton1Click:Connect(function()
        self.MouseButton1Click:Fire()
    end)
    self:DisableChangeReplication("MouseButton2Down")
    self.MouseButton2Down = self:CreateEvent()  :: any
    self:GetWrappedInstance().MouseButton2Down:Connect(function(...)
        self.MouseButton2Down:Fire(...)
    end)
    self:DisableChangeReplication("MouseButton2Up")
    self.MouseButton2Up = self:CreateEvent()  :: any
    self:GetWrappedInstance().MouseButton2Up:Connect(function(...)
        self.MouseButton2Up:Fire(...)
    end)
    self:DisableChangeReplication("MouseButton2Click")
    self.MouseButton2Click = self:CreateEvent() :: any
    self:GetWrappedInstance().MouseButton2Click:Connect(function()
        self.MouseButton2Click:Fire()
    end)

    --Set the replication overrides.
    self:DisableChangeReplication("TweenDuration")
    self:DisableChangeReplication("BackgroundColor3")
    self:OnPropertyChanged("BackgroundColor3", function()
        self:UpdateBorder(false)
    end)
    self:DisableChangeReplication("BackgroundTransparency")
    self:OnPropertyChanged("BackgroundTransparency", function(NewBackgroundTransparency: number)
        BackgroundFrame.BackgroundTransparency = NewBackgroundTransparency
    end)
    self:DisableChangeReplication("BorderSize")
    self:OnPropertyChanged("BorderSize", function()
        self:UpdateBorder(false)
    end)
    self:DisableChangeReplication("BorderSizePixel")
    self:OnPropertyChanged("BorderSizePixel", function(NewBorderSizePixel: number)
        self.BorderSize = UDim.new(0, NewBorderSizePixel)
    end)
    self:DisableChangeReplication("BorderSizeScale")
    self:OnPropertyChanged("BorderSizeScale", function(NewBorderSizeScale: number)
        self.BorderSize = UDim.new(NewBorderSizeScale, 0)
    end)
    self:DisableChangeReplication("BorderColor3")
    self:OnPropertyChanged("BorderColor3", function()
        self:UpdateBorder(false)
    end)
    self:DisableChangeReplication("BorderColor3")
    self:OnPropertyChanged("AutoButtonColor", function()
        self:UpdateBorder(false)
    end)
    self:DisableChangeReplication("BorderTransparency")
    self:OnPropertyChanged("BorderTransparency", function(NewBorderTransparency: number)
        BorderFrame.BackgroundTransparency = NewBorderTransparency
    end)
    self:DisableChangeReplication("Hovering")
    self:OnPropertyChanged("Hovering", function()
        self:UpdateBorder(true)
    end)
    self:DisableChangeReplication("Pressed")
    self:OnPropertyChanged("Pressed", function()
        self:UpdateBorder(true)
    end)
    self:DisableChangeReplication("Theme")
    self:OnPropertyChanged("Theme", function(NewTheme: string)
        BackgroundFrame.Theme = self.Theme
        BorderFrame.Theme = self.Theme
        GamepadIcon.Theme = self.Theme
    end)

    --Connect the events.
    self:DisableChangeReplication("MappedInputs")
    self.MappedInputs = {}
    self:DisableChangeReplication("EventConnections")
    self.EventConnections = {}
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
    table.insert(self.EventConnections, GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
        self:UpdateBorder(true)
    end))
    table.insert(self.EventConnections, UserInputService.InputBegan:Connect(function(Input, Processed)
        if Processed and (GuiService.SelectedObject ~= self:GetWrappedInstance() or Input.KeyCode == Enum.KeyCode.ButtonA) then return end
        if self.Pressed then return end
        if not self.MappedInputs[Input.KeyCode] then return end

        local MouseInput = self.MappedInputs[Input.KeyCode]
        local CenterPosition = self.AbsolutePosition + (self.AbsoluteSize / 2)
        if MouseInput == Enum.UserInputType.MouseButton1 then
            self.MouseButton1Down:Fire(CenterPosition.X, CenterPosition.Y)
        elseif MouseInput == Enum.UserInputType.MouseButton2 then
            self.MouseButton2Down:Fire(CenterPosition.X, CenterPosition.Y)
        end
    end))
    table.insert(self.EventConnections, UserInputService.InputEnded:Connect(function(Input)
        if not self.Pressed then return end
        if not self.MappedInputs[Input.KeyCode] then return end

        local MouseInput = self.MappedInputs[Input.KeyCode]
        local CenterPosition = self.AbsolutePosition + (self.AbsoluteSize / 2)
        if MouseInput == Enum.UserInputType.MouseButton1 then
            self.MouseButton1Up:Fire(CenterPosition.X, CenterPosition.Y)
            self.MouseButton1Click:Fire()
        elseif MouseInput == Enum.UserInputType.MouseButton2 then
            self.MouseButton2Up:Fire(CenterPosition.X, CenterPosition.Y)
            self.MouseButton2Click:Fire()
        end
    end))
    table.insert(self.EventConnections, UserInputService.InputEnded:Connect(function(Input)
        if not self.Pressed then return end
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        self.Pressed = false
    end))

    --Set the defaults.
    self.Size = UDim2.new(0, 200, 0, 50)
    self.BackgroundColor3 = Color3.fromRGB(204, 204, 204)
    self.BackgroundTransparency = 0
    self.BorderSize = UDim.new(0.15, 0)
    self.BorderColor3 = Color3.fromRGB(0, 0, 0)
    self.BorderTransparency = 0
    self.AutoButtonColor = true
    self.Hovering = false
    self.Pressed = false
    self.TweenDuration = 0.1
    self.Theme = "CutCorners"
end

--[[
Updates the background and border properties.
--]]
function NexusButton.UpdateBorder(self: NexusInstanceNexusButton, Tween: boolean?): ()
    --Get the border size.
    if not self.BorderSize then return end
    if not self.Theme then return end
    local ButtonSize = self.BackgroundFrame.AbsoluteSize
    local ButtonSizeY = ButtonSize.Y
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
    self.GamepadIcon.SubTheme = (((ButtonSize.X / ButtonSize.Y) < CONTROLLER_SECTION_THEME_MINIMUM_ASPECT_RATIO) and "MainButton" or "GamepadIconBackground") :: ThemedFrame.SubTheme
end

--[[
Returns the adorn frame to parent frames to the button.
--]]
function NexusButton.GetAdornFrame(self: NexusInstanceNexusButton): Frame
    return self.ContentsAdorn
end

--[[
Sets the controller icon for the button.
--]]
function NexusButton.SetControllerIcon(self: NexusInstanceNexusButton, KeyCode: Enum.KeyCode | string): ()
    self.GamepadIcon:SetIcon(KeyCode)
end

--[[
Maps a key input to a mouse input for clicking.
--]]
function NexusButton.MapKey(self: NexusInstanceNexusButton, KeyCode: Enum.KeyCode | string, MouseInput: Enum.UserInputType | string): ()
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
    self.MappedInputs[KeyCode :: Enum.KeyCode] = MouseInput :: Enum.UserInputType
end

--[[
Unmaps a key input to a mouse input for clicking.
--]]
function NexusButton.UnmapKey(self: NexusInstanceNexusButton, KeyCode: Enum.KeyCode | string): ()
    --Correct the input.
    if typeof(KeyCode) == "string" then
        KeyCode = (Enum.KeyCode :: any)[KeyCode]
    end

    --Remove the mapped input.
    self.MappedInputs[KeyCode :: Enum.KeyCode] = nil
end

--[[
Destroys the button and disconnects the events.
--]]
function NexusButton.Destroy(self: NexusInstanceNexusButton): ()
    SimpleWrappedInstance.Destroy(self)
    self.GamepadIcon:Destroy()

    --Disconnect the events.
    for _, EventConnection in self.EventConnections do
        EventConnection:Disconnect()
    end
    self.EventConnections = {}
end



return NexusInstance.ToInstance(NexusButton) :: NexusInstance.NexusInstanceClass<typeof(NexusButton), () -> (NexusInstanceNexusButton)>