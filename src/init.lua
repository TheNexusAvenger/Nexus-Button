--[[
TheNexusAvenger

Main module representing the button class. This button
is meant to provide an easy way to make "good looking", 
cross platform buttons.
--]]

--The amount cut on the top left and bottom right corners.
local CORNER_CUT_BACKGROUND_RELATIVE = 0.3
--Color multiplier when hovering.
local HOVER_COLOR_MULTIPLIER = 0.7
--Color multiplier when clicking.
local CLICK_COLOR_MULTIPLIER = 1/0.7
--The color of the last section for controllers.
local CONTROLLER_SECTION_COLOR = Color3.new(50/255,50/255,50/255)



local ColoredCutFrame = require(script:WaitForChild("Gui"):WaitForChild("ColoredCutFrame"))
local ControllerIcon = require(script:WaitForChild("Gui"):WaitForChild("ControllerIcon"))
local BaseButton = require(script:WaitForChild("Gui"):WaitForChild("BaseButton"))
local NexusInstance = require(script:WaitForChild("NexusInstance"):WaitForChild("NexusInstance"))

local NexusButton = NexusInstance:Extend()
NexusButton:SetClassName("NexusButton")



--[[
Multiplies a Color3.
--]]
local function MultiplyColor3(Color,Multiplier)
	--Multiply the R,G,B values.
	local NewR,NewG,NewB = Color.r * Multiplier,Color.g * Multiplier,Color.b * Multiplier
	
	--Clamp the values.
	NewR = math.clamp(NewR,0,1)
	NewG = math.clamp(NewG,0,1)
	NewB = math.clamp(NewB,0,1)
	
	--Return the color.
	return Color3.new(NewR,NewG,NewB)
end

--[[
Multiplies a ColorSequence.
--]]
local function MultiplyColorSequence(Sequence,Multiplier)
	local Keypoints = {}
	
	--Multiply the keypoints.
	for _,Keypoint in pairs(Sequence.Keypoints) do
		local MultipliedColor = MultiplyColor3(Keypoint.Value,Multiplier)
		table.insert(Keypoints,ColorSequenceKeypoint.new(Keypoint.Time,MultipliedColor))
	end
	
	--Return the new color sequence.
	return ColorSequence.new(Keypoints)
end

--[[
Truncates a color sequence at a given time and
sets the color sequence to the color.
--]]
local function TruncateColorSequence(Sequence,Time,FinalColor)
	local Keypoints = {}
	
	--Truncate the keypoints.
	for _,Keypoint in pairs(Sequence.Keypoints) do
		if Keypoint.Time < Time then
			table.insert(Keypoints,Keypoint)
		end
	end
	
	--Add the new keypooints.
	table.insert(Keypoints,ColorSequenceKeypoint.new(Time,FinalColor))
	table.insert(Keypoints,ColorSequenceKeypoint.new(1,FinalColor))
	
	--Return the new color sequence.
	return ColorSequence.new(Keypoints)
end



--[[
Creates a Nexus Button object.
--]]
function NexusButton:__new()
	self:InitializeSuper()
	self.__Hovered = false
	self.__Clicked = false
	self.BorderSizePixel = 0
	self.TopLeftCutEnabled = true
	self.BottomRightCutEnabled = true
	self.__Events = {}
	
	--Create the button as the adorn frame.
	local AdornButton = BaseButton.new()
	local AdornFrame = AdornButton.BaseFrame
	local LogicalAdornFrame = AdornButton.LogicalFrame
	LogicalAdornFrame.BackgroundTransparency = 1
	self.AdornButton = AdornButton
	self.AdornFrame = AdornFrame
	self.LogicalAdornFrame = LogicalAdornFrame
	rawset(self.object,"AdornFrame",self.AdornFrame)
	rawset(self.object,"LogicalAdornFrame",self.LogicalAdornFrame)
	
	--Create the border adorn and cut frames.
	local BorderAdorn = Instance.new("Frame")
	BorderAdorn.BackgroundTransparency = 1
	BorderAdorn.Parent = AdornFrame
	self.BorderAdorn = BorderAdorn
	
	--Create the contents adorn.
	local ContentsAdorn = Instance.new("Frame")
	ContentsAdorn.BackgroundTransparency = 1
	ContentsAdorn.Size = UDim2.new(1,0,1,0)
	ContentsAdorn.ZIndex = 5
	ContentsAdorn.Parent = AdornFrame
	self.ContentsAdorn = ContentsAdorn
	
	--Create the gamepad icon.
	local GamepadIcon = ControllerIcon.new()
	GamepadIcon.AdornFrame.Size = UDim2.new(1,0,1,0)
	GamepadIcon.AdornFrame.Position = UDim2.new(1,0,0,0)
	GamepadIcon.AdornFrame.SizeConstraint = "RelativeYY"
	GamepadIcon.AdornFrame.AnchorPoint = Vector2.new(1,0)
	GamepadIcon.AdornFrame.ZIndex = 5
	GamepadIcon.AdornFrame.Parent = AdornFrame
	self.GamepadIcon = GamepadIcon
	
	--Create the cut frames.
	self.BorderCutFrame = ColoredCutFrame.new(BorderAdorn)
	self.BackgroundCutFrame = ColoredCutFrame.new(AdornFrame)
	self.BackgroundCutFrame.ZIndex = 2
	
	--Set up the events.
	table.insert(self.__Events,LogicalAdornFrame.MouseEnter:Connect(function()
		self.__Hovered = true
		self:__UpdateColors()
	end))
	
	table.insert(self.__Events,LogicalAdornFrame.MouseLeave:Connect(function()
		self.__Hovered = false
		self:__UpdateColors()
	end))
	
	table.insert(self.__Events,AdornButton.MouseButton1Down:Connect(function()
		self.__Clicked = true
		self:__UpdateColors()
	end))
	
	table.insert(self.__Events,AdornButton.MouseButton1Up:Connect(function()
		self.__Clicked = false
		self:__UpdateColors()
	end))
	
	--Remap the events.
	self.MouseButton1Down = AdornButton.MouseButton1Down
	self.MouseButton1Click = AdornButton.MouseButton1Click
	self.MouseButton1Up = AdornButton.MouseButton1Up
	self.MouseButton2Down = AdornButton.MouseButton2Down
	self.MouseButton2Click = AdornButton.MouseButton2Click
	self.MouseButton2Up = AdornButton.MouseButton2Up
	
	--Set up replication.
	local CustomReplication = {}
	table.insert(self.__Events,self.Changed:Connect(function(PropertyName)
		--Fire a custtom replication method.
		local ReplicationMethod = CustomReplication[PropertyName]
		if ReplicationMethod then
			ReplicationMethod()
			return
		end
		
		--Replicate to the instance.
		LogicalAdornFrame[PropertyName] = self[PropertyName]
	end))
	table.insert(self.__Events,LogicalAdornFrame.Changed:Connect(function(PropertyName)
		local ExistingValue,NewProperty = self[PropertyName],LogicalAdornFrame[PropertyName]
		if self[PropertyName] ~= nil and ExistingValue ~= NewProperty then
			self[PropertyName] = NewProperty
		end
	end))
	
	--Add custom replication overrides.
	CustomReplication["__Hovered"] = function() end
	CustomReplication["__Clicked"] = function() end
	CustomReplication["AutoButtonColor"] = function()
		self:__UpdateColors()
	end
	CustomReplication["BackgroundColor3"] = function()
		self:__UpdateColors()
	end
	CustomReplication["BorderColor3"] = function()
		self.BorderCutFrame.BackgroundColor3 = self.BorderColor3 
	end
	CustomReplication["BorderSizePixel"] = function()
		BorderAdorn.Size = UDim2.new(1,0,1 + self.BorderSizeScale,self.BorderSizePixel)
		self:__UpdateCuts()
	end
	CustomReplication["BorderSizeScale"] = function()
		BorderAdorn.Size = UDim2.new(1,0,1 + self.BorderSizeScale,self.BorderSizePixel)
		self:__UpdateCuts()
	end
	CustomReplication["BackgroundTransparency"] = function()
		self.BackgroundCutFrame.BackgroundTransparency = self.BackgroundTransparency
	end
	CustomReplication["BorderTransparency"] = function()
		self.BorderCutFrame.BackgroundTransparency = self.BorderTransparency
	end
	CustomReplication["TopLeftCutEnabled"] = function()
		self:__UpdateCuts()
	end
	CustomReplication["BottomRightCutEnabled"] = function()
		self:__UpdateCuts()
	end
	
	--Set up events.
	table.insert(self.__Events,LogicalAdornFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if self.GamepadIcon.IconVisible then
			self:__UpdateColors()
		end
	end))
	table.insert(self.__Events,BorderAdorn:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if LogicalAdornFrame.AbsoluteSize.Y == 0 or not self.BottomRightCutEnabled then
			self.BorderCutFrame:RemoveCut("Bottom","Right")
		else
			local BorderSizeRelative = (BorderAdorn.AbsoluteSize.Y/LogicalAdornFrame.AbsoluteSize.Y) - 1
			local BorderCornerCutRelative = (CORNER_CUT_BACKGROUND_RELATIVE/math.sqrt(2)) / (1 + BorderSizeRelative)
			self.BorderCutFrame:CutCorner("Bottom","Right",UDim2.new(BorderCornerCutRelative,0,BorderCornerCutRelative,0),"RelativeYY")
		end
	end))
	table.insert(self.__Events,GamepadIcon:GetPropertyChangedSignal("IconVisible"):Connect(function()
		self:__UpdateColors()
	end))
	
	--Set the defaults.
	self.Size = UDim2.new(0,200,0,50)
	self.BackgroundColor3 = Color3.new(0.8,0.8,0.8)
	self.BorderColor3 = Color3.new(0,0,0)
	self.BorderSizeScale = 0.2
	self.BackgroundTransparency = 0
	self.BorderTransparency = 0
	self.AutoButtonColor = true
end

--[[
Creates an __index metamethod for an object. Used to
setup custom indexing.
--]]
function NexusButton:__createindexmethod(Object,Class,RootClass)
	--Get the base method.
	local BaseIndexMethod = self.super:__createindexmethod(Object,Class,RootClass)
	
	--Return a wrapped method.
	return function(MethodObject,Index)
		--Return the base return if it exists.
		local BaseReturn = BaseIndexMethod(MethodObject,Index)
		if BaseReturn ~= nil then
			return BaseReturn
		end
		
		--Return an instance property.
		local LogicalAdornFrame = rawget(Object.object,"LogicalAdornFrame")
		if LogicalAdornFrame then
			--Get the value in a protected call.
			local Worked,Return = pcall(function()
				local Value = LogicalAdornFrame[Index]
				if Value ~= nil then
					return Value
				end
			end)
			
			--Return the value.
			if Worked and Return ~= nil then
				return Return
			end
		end
	end
end

--[[
Updates the colors of the button.
--]]
function NexusButton:__UpdateColors()
	local BackgroundColor3 = self.BackgroundColor3
	local ColorMultiplier = 1
	
	--Determine the color multiplier.
	if self.AutoButtonColor then
		if self.__Clicked then
			ColorMultiplier = CLICK_COLOR_MULTIPLIER
		elseif self.__Hovered then
			ColorMultiplier = HOVER_COLOR_MULTIPLIER
		end
	end
	
	--Add the section for the gamepad icon if it is visible.
	if self.GamepadIcon.IconVisible then
		local SizeX,SizeY = self.LogicalAdornFrame.AbsoluteSize.X,self.LogicalAdornFrame.AbsoluteSize.Y
		local ColorPos = 1 - (SizeY/SizeX)
		
		if typeof(BackgroundColor3) == "ColorSequence" then
			BackgroundColor3 = TruncateColorSequence(BackgroundColor3,ColorPos,CONTROLLER_SECTION_COLOR)
		elseif typeof(BackgroundColor3) == "Color3" then
			BackgroundColor3 = ColorSequence.new({
				ColorSequenceKeypoint.new(0,BackgroundColor3),
				ColorSequenceKeypoint.new(ColorPos,CONTROLLER_SECTION_COLOR),
				ColorSequenceKeypoint.new(1,CONTROLLER_SECTION_COLOR),
			})
		end
	end
	
	--Multiply the color.
	if ColorMultiplier ~= 1 then
		if typeof(BackgroundColor3) == "Color3" then
			BackgroundColor3 = MultiplyColor3(BackgroundColor3,ColorMultiplier)
		elseif typeof(BackgroundColor3) == "ColorSequence" then
			BackgroundColor3 = MultiplyColorSequence(BackgroundColor3,ColorMultiplier)
		end
	end
		
	--Set the background color.
	self.BackgroundCutFrame.BackgroundColor3 = BackgroundColor3
end

--[[
Updates the cuts.
--]]
function NexusButton:__UpdateCuts()
	local BorderSizeY,BackgroundSizeY = self.BorderAdorn.AbsoluteSize.Y,self.LogicalAdornFrame.AbsoluteSize.Y
	
	--Set the background cuts.
	local BackgroundInnerCutRelative = (CORNER_CUT_BACKGROUND_RELATIVE/math.sqrt(2)) / (BackgroundSizeY/BorderSizeY)
	if self.BottomRightCutEnabled then
		self.BackgroundCutFrame:CutCorner("Bottom","Right",UDim2.new(BackgroundInnerCutRelative,0,BackgroundInnerCutRelative,0),"RelativeYY")
	else
		self.BackgroundCutFrame:RemoveCut("Bottom","Right")
	end
	if self.TopLeftCutEnabled then
		self.BackgroundCutFrame:CutCorner("Top","Left",UDim2.new(CORNER_CUT_BACKGROUND_RELATIVE,0,CORNER_CUT_BACKGROUND_RELATIVE,0),"RelativeYY")
	else
		self.BackgroundCutFrame:RemoveCut("Top","Left")
	end
	
	--Set the border cuts.
	local BorderMultiplier = BackgroundSizeY/BorderSizeY
	if self.BottomRightCutEnabled then
		self.BorderCutFrame:CutCorner("Bottom","Right",UDim2.new(CORNER_CUT_BACKGROUND_RELATIVE * BorderMultiplier,0,CORNER_CUT_BACKGROUND_RELATIVE * BorderMultiplier,0),"RelativeYY")
	else
		self.BorderCutFrame:RemoveCut("Bottom","Right")
	end
	if self.TopLeftCutEnabled then
		self.BorderCutFrame:CutCorner("Top","Left",UDim2.new(CORNER_CUT_BACKGROUND_RELATIVE * BorderMultiplier,0,CORNER_CUT_BACKGROUND_RELATIVE * BorderMultiplier,0),"RelativeYY")
	else
		self.BorderCutFrame:RemoveCut("Top","Left")
	end
end

--[[
Returns the adorn frame to parent frames to the button.
--]]
function NexusButton:GetAdornFrame()
	return self.ContentsAdorn
end

--[[
Sets the controller icon for the button.
--]]
function NexusButton:SetControllerIcon(KeyCode)
	self.GamepadIcon:SetIcon(KeyCode)
end

--[[
Maps a key input to a mouse input for clicking.
--]]
function NexusButton:MapKey(KeyCode,MouseInput)
	self.AdornButton:MapKey(KeyCode,MouseInput)
end

--[[
Unmaps a key input to a mouse input for clicking.
--]]
function NexusButton:UnmapKey(KeyCode)
	self.AdornButton:UnmapKey(KeyCode)
end

--[[
Destroys the frame and disconnects the events.
--]]
function NexusButton:Destroy()
	self.super:Destroy()
	
	--Disconnect the events.
	for _,Event in pairs(self.__Events) do
		Event:Disconnect()
	end
	self.__Events = {}
	
	--Destroy the frames.
	self.BackgroundCutFrame:Destroy()
	self.BorderCutFrame:Destroy()
	self.GamepadIcon:Destroy()
	self.AdornButton:Destroy()
end




return NexusButton