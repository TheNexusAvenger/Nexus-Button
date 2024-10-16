--Frame that has the same theming for the buttons.
--!strict

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
} :: {[string]: NexusButtonTheme}

local NexusInstance = require(script.Parent:WaitForChild("NexusInstance"))
local SimpleWrappedInstance = require(script.Parent:WaitForChild("SimpleWrappedInstance"))

local ThemedFrame = {}
ThemedFrame.Themes = DEFAULT_THEMES
ThemedFrame.__index = ThemedFrame
setmetatable(ThemedFrame, SimpleWrappedInstance)

export type NexusButtonThemeEntry = {
    Image: string,
    SliceCenter: Rect,
    SliceScaleMultiplier: number,
}
export type NexusButtonTheme = {
    MainButton: NexusButtonThemeEntry,
    GamepadIconBackground: NexusButtonThemeEntry,
}
export type ThemedFrame = {
    Theme: string,
    SubTheme: "MainButton" | "GamepadIconBackground",
    SliceScaleMultiplier: number,
} & typeof(setmetatable({}, ThemedFrame)) & SimpleWrappedInstance.SimpleWrappedInstance<ImageLabel>
export type NexusInstanceThemedFrame = NexusInstance.NexusInstance<ThemedFrame>



--[[
Creates the themed frame.
--]]
function ThemedFrame.__new(self: NexusInstanceThemedFrame)
    SimpleWrappedInstance.__new(self, Instance.new("ImageLabel"))
    self:GetWrappedInstance().BackgroundTransparency = 1

    --Set the initial them.
    self:DisableChangeReplication("Theme")
    self.Theme = "CutCorners"
    self:DisableChangeReplication("SubTheme")
    self.SubTheme = "MainButton"

    --Connect property changes.
    self:DisableChangeReplication("BackgroundColor3")
    self:OnPropertyChanged("BackgroundColor3", function(NewBackgroundColor3: Color3)
        self.ImageColor3 = NewBackgroundColor3
    end)
    self:DisableChangeReplication("BackgroundTransparency")
    self:OnPropertyChanged("BackgroundTransparency", function(NewBackgroundTransparency: number)
        self.ImageTransparency = NewBackgroundTransparency
    end)
    self:DisableChangeReplication("SliceScaleMultiplier")
    self:OnPropertyChanged("SliceScaleMultiplier", function()
        self:UpdateSliceScale()
    end)
    self:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self:UpdateSliceScale()
    end)

    --Connect changing the theme.
    self:OnPropertyChanged("Theme", function()
        self:UpdateTheme()
    end)
    self:OnPropertyChanged("SubTheme", function()
        self:UpdateTheme()
    end)

    --Set the defaults.
    self.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.BackgroundTransparency = 0
    self.ScaleType = Enum.ScaleType.Slice
    self.SliceScaleMultiplier = 1
    self.Size = UDim2.new(0, 100, 0, 100)
    self:UpdateTheme()
end

--[[
Updates the slice scale of the frame.
--]]
function ThemedFrame.UpdateSliceScale(self: NexusInstanceThemedFrame): ()
    local ThemeEntry = ThemedFrame.Themes[self.Theme][self.SubTheme]
    self.SliceScale = math.min(self.AbsoluteSize.X, self.AbsoluteSize.Y) * ThemeEntry.SliceScaleMultiplier * (self.SliceScaleMultiplier or 1)
end

--[[
Updates the theme of the frame.
--]]
function ThemedFrame.UpdateTheme(self: NexusInstanceThemedFrame): ()
    --Get the theme.
    local Theme = ThemedFrame.Themes[self.Theme]
    if not Theme then
        error(`Unknown theme: {self.Theme}`)
    end
    local ThemeEntry = Theme[self.SubTheme]
    if not ThemeEntry then
        error(`Unknown subtheme: {self.SubTheme}`)
    end

    --Update the theme.
    self.Image = ThemeEntry.Image
    self.SliceCenter = ThemeEntry.SliceCenter
    self:UpdateSliceScale()
end



return NexusInstance.ToInstance(ThemedFrame) :: NexusInstance.NexusInstanceClass<typeof(ThemedFrame), () -> (NexusInstanceThemedFrame)>