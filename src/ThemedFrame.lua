--[[
TheNexusAvenger

Frame that has the same theming for the buttons.
--]]

local NexusButton = require(script.Parent)
local NexusWrappedInstance = require(script.Parent:WaitForChild("NexusWrappedInstance"))

local ThemedFrame = NexusWrappedInstance:Extend()
ThemedFrame:SetClassName("ThemedFrame")


--[[
Creates the themed frame.
--]]
function ThemedFrame:__new()
    self:InitializeSuper("ImageLabel")
    self.BackgroundTransparency = 1

    --Connect replicating values.
    local ButtonPropertyOverrides = {}
    self:AddGenericPropertyFinalizer(function(PropertyName: string, Value: any)
        if not ButtonPropertyOverrides[PropertyName] then
            return
        end
        ButtonPropertyOverrides[PropertyName](Value)
    end)

    --Set the replication overrides.
    self:DisableChangeReplication("BackgroundColor3")
    ButtonPropertyOverrides["BackgroundColor3"] = function(NewBackgroundColor3: Color3)
        self.ImageColor3 = NewBackgroundColor3
    end
    self:DisableChangeReplication("BackgroundTransparency")
    ButtonPropertyOverrides["BackgroundTransparency"] = function(NewBackgroundTransparency: Color3)
        self.BackgroundTransparency = NewBackgroundTransparency
    end
    self:DisableChangeReplication("SliceScaleMultiplier")
    ButtonPropertyOverrides["SliceScaleMultiplier"] = function()
        self:UpdateSliceScale()
    end
    self:DisableChangeReplication("Theme")
    ButtonPropertyOverrides["Theme"] = function(NewTheme: string)
        local Theme = NexusButton.Themes[self.Theme]
        if not Theme then
            error("Unknown theme: "..tostring(NewTheme))
        end
        self.Image = Theme.MainButton.Image
        self.SliceCenter = Theme.MainButton.SliceCenter
        self:UpdateSliceScale()
    end
    self:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self:UpdateSliceScale()
    end)

    --Set the defaults.
    self.BackgroundColor3 = Color3.new(1, 1, 1)
    self.ScaleType = Enum.ScaleType.Slice
    self.SliceScaleMultiplier = 0.5
    self.Size = UDim2.new(0, 100, 0, 100)
    self.Theme = "CutCorners"
end

--[[
Updates the slice scale of the frame.
--]]
function ThemedFrame:UpdateSliceScale(): nil
    if not self.Theme then return end
    local Theme = NexusButton.Themes[self.Theme]
    self.SliceScale = math.min(self.AbsoluteSize.X, self.AbsoluteSize.Y) * Theme.MainButton.SliceScaleMultiplier * (self.SliceScaleMultiplier or 1)
end




return ThemedFrame