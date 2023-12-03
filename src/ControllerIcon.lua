--[[
TheNexusAvenger

Class representing a controller icon.
--]]
--!strict

local BASE_ICON_SIZE_RELATIVE = 0.9
local XBOX_SPRITESHEET = "rbxassetid://408444495"
local PLAYSTATION_SPRITESHEET = "rbxassetid://15530886548"

export type IconProperties = {
	Image: string,
	Size: Vector2,
	Offset: Vector2,
	Color: Color3?,
}

local GAMEPAD_ICONS = {
    Xbox = {
        ButtonA = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(95, 95),
            Offset = Vector2.new(318, 416),
        },
        ButtonB = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(95, 95),
            Offset = Vector2.new(520, 522),
        },
        ButtonX = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(95, 95),
            Offset = Vector2.new(510, 416),
        },
        ButtonY = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(95, 95),
            Offset = Vector2.new(616, 318),
        },
        DPadUp = {
            Image = XBOX_SPRITESHEET,
            Size =  Vector2.new(105, 105),
            Offset = Vector2.new(616, 530),
        },
        DPadDown = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(105, 105),
            Offset = Vector2.new(212, 522),
        },
        DPadLeft = {
            Image = XBOX_SPRITESHEET,
            Size =  Vector2.new(105, 105),
            Offset = Vector2.new(318, 522),
        },
        DPadRight = {
            Image = XBOX_SPRITESHEET,
            Size =  Vector2.new(105, 105),
            Offset = Vector2.new(212, 416),
        },
        ButtonSelect = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(95, 95),
            Offset = Vector2.new(424, 522),
        },
        ButtonLB = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(115, 64),
            Offset = Vector2.new(116, 628),
        },
        ButtonRB = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(115, 64),
            Offset = Vector2.new(0, 628),
        },
        ButtonLT = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(105, 115),
            Offset = Vector2.new(616, 0),
        },
        ButtonRT = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(105, 115),
            Offset = Vector2.new(616, 414),
        },
        ButtonLS = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(105, 105),
            Offset = Vector2.new(0, 522),
        },
        ButtonRS = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(105, 105),
            Offset = Vector2.new(0, 416),
        },
        Thumbstick1 = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(105, 105),
            Offset = Vector2.new(616, 116),
        },
        Thumbstick2 = {
            Image = XBOX_SPRITESHEET,
            Size = Vector2.new(105, 105),
            Offset = Vector2.new(106, 522),
        },
    },
    PlayStation = {
        ButtonCross = {
            Image = PLAYSTATION_SPRITESHEET,
            Size = Vector2.new(58, 58),
            Offset = Vector2.new(0, 0),
        },
        ButtonCircle = {
            Image = PLAYSTATION_SPRITESHEET,
            Size = Vector2.new(58, 58),
            Offset = Vector2.new(58, 0),
        },
        ButtonSquare = {
            Image = PLAYSTATION_SPRITESHEET,
            Size = Vector2.new(58, 58),
            Offset = Vector2.new(116, 0),
        },
        ButtonTriangle = {
            Image = PLAYSTATION_SPRITESHEET,
            Size = Vector2.new(58, 58),
            Offset = Vector2.new(0, 58),
        },
        ButtonL1 = {
            Image = PLAYSTATION_SPRITESHEET,
            Size = Vector2.new(58, 58),
            Offset = Vector2.new(58, 58),
        },
        ButtonR1 = {
            Image = PLAYSTATION_SPRITESHEET,
            Size = Vector2.new(58, 58),
            Offset = Vector2.new(116, 58),
        },
        ButtonL2 = {
            Image = PLAYSTATION_SPRITESHEET,
            Size = Vector2.new(58, 58),
            Offset = Vector2.new(0, 116),
        },
        ButtonR2 = {
            Image = PLAYSTATION_SPRITESHEET,
            Size = Vector2.new(58, 58),
            Offset = Vector2.new(58, 116),
        },
        ButtonTouchpad = {
            Image = PLAYSTATION_SPRITESHEET,
            Size = Vector2.new(58, 58),
            Offset = Vector2.new(116, 116),
        },
    },
} :: {[string]: {[string]: IconProperties}}
GAMEPAD_ICONS.Default = GAMEPAD_ICONS.Xbox
GAMEPAD_ICONS.Default.ButtonL1 = GAMEPAD_ICONS.Xbox.ButtonLB
GAMEPAD_ICONS.Default.ButtonR1 = GAMEPAD_ICONS.Xbox.ButtonRB
GAMEPAD_ICONS.Default.ButtonL2 = GAMEPAD_ICONS.Xbox.ButtonLT
GAMEPAD_ICONS.Default.ButtonR2 = GAMEPAD_ICONS.Xbox.ButtonRT
GAMEPAD_ICONS.Default.ButtonL3 = GAMEPAD_ICONS.Xbox.ButtonLS
GAMEPAD_ICONS.Default.ButtonR3 = GAMEPAD_ICONS.Xbox.ButtonRS



local UserInputService = game:GetService("UserInputService")

local NexusInstance = require(script.Parent:WaitForChild("NexusWrappedInstance"):WaitForChild("NexusInstance"):WaitForChild("NexusInstance"))

local ControllerIcon = NexusInstance:Extend()
ControllerIcon:SetClassName("ControllerIcon")

local WarnedPlatformNames = {}

export type ControllerIcon = {
    new: () -> ControllerIcon,
    Extend: (self: ControllerIcon) -> ControllerIcon,

    SetIcon: (self: ControllerIcon, KeyCode: Enum.KeyCode | string) -> (),
    SetScale: (self: ControllerIcon, NewScale: number) -> (),
} & NexusInstance.NexusInstance



--[[
Resolves the gamepad image properties for a KeyCode.
--]]
function ControllerIcon.ResolveImage(KeyCode: Enum.KeyCode): IconProperties
	--Get the name and fallback image.
	local PlatformKeyCodeName = UserInputService:GetStringForKeyCode(KeyCode)
	local FallbackImage = UserInputService:GetImageForKeyCode(KeyCode)

	--Return if a group matches.
	for GroupName, Images in GAMEPAD_ICONS do
		if not string.find(string.lower(FallbackImage), string.lower(GroupName)) then continue end
		if not Images[PlatformKeyCodeName] then continue end
		return Images[PlatformKeyCodeName]
	end

	--Return if the default exists.
	if GAMEPAD_ICONS.Default[PlatformKeyCodeName] then
		return GAMEPAD_ICONS.Default[PlatformKeyCodeName]
	end

	--Return the fallback case.
	if not WarnedPlatformNames[PlatformKeyCodeName] then
		warn(`No override exists for {PlatformKeyCodeName} (from {KeyCode.Name}) with {FallbackImage}. Returning default image.`)
		WarnedPlatformNames[PlatformKeyCodeName] = true
	end
	return {
		Image = FallbackImage,
		Size = Vector2.zero,
		Offset = Vector2.zero,
		Color = Color3.fromRGB(60, 60, 60),
	}
end

--[[
Constructor of the Controller Icon class.
--]]
function ControllerIcon:__new()
    NexusInstance.__new(self)

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
function ControllerIcon:UpdateVisibility(): ()
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
function ControllerIcon:SetIcon(KeyCode: Enum.KeyCode | string): ()
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
        KeyCode = (Enum.KeyCode :: any)[KeyCode]
    end

    --Destroy the existing icon.
    if self.Icon then
        self.Icon:Destroy()
    end

    --Create the new icon.
    local IconData = self.ResolveImage(KeyCode)
    local Icon = Instance.new("ImageLabel")
    Icon.BackgroundTransparency = 1
    Icon.AnchorPoint = Vector2.new(0.5, 0.5)
    Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    if IconData.Size.X > IconData.Size.Y then
        Icon.Size = UDim2.new(1, 0, IconData.Size.Y / IconData.Size.X, 0)
    elseif IconData.Size.X < IconData.Size.Y then
        Icon.Size = UDim2.new(IconData.Size.X / IconData.Size.Y, 0, 1, 0)
    else
        Icon.Size = UDim2.new(1, 0, 1, 0)
    end
    Icon.ZIndex = self.AdornFrame.ZIndex
    Icon.Image = IconData.Image
    Icon.ImageRectSize = IconData.Size
    Icon.ImageRectOffset = IconData.Offset
    Icon.ImageColor3 = IconData.Color or Color3.fromRGB(255, 255, 255)
    Icon.Parent = self.AdornFrame

    local IconUIScale = Instance.new("UIScale")
    IconUIScale.Scale = self.IconScale or 1
    IconUIScale.Parent = Icon
    self.IconUIScale = IconUIScale

    self.Icon = Icon
    self.KeyCode = KeyCode
    self:UpdateVisibility()
end

--[[
Sets the scale of the icon.
--]]
function ControllerIcon:SetScale(NewScale: number): ()
    self.IconScale = NewScale
    if self.IconUIScale then
        self.IconUIScale.Scale = NewScale
    end
end

--[[
Destroys the frame.
--]]
function ControllerIcon:Destroy(): ()
    NexusInstance.Destroy(self)

    --Disconnect the events.
    for _,Event in self.Events do
        Event:Disconnect()
    end
    self.Events = {}

    --Destroy the adorn frame.
    self.AdornFrame:Destroy()
end



return ControllerIcon :: ControllerIcon