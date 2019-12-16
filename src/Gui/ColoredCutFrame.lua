--[[
TheNexusAvenger

Class representing a "cut" frame, but with mutliple
colors able to be done horizontally. The BackgroundColor3
can be a Color3 or a ColorSequence.
--]]

local RootModule = script.Parent.Parent
local Data = RootModule:WaitForChild("Data")
local Gui = RootModule:WaitForChild("Gui")

local NexusInstance = require(RootModule:WaitForChild("NexusInstance"):WaitForChild("NexusInstance"))
local RectSide = require(Data:WaitForChild("RectSide"))
local RectPoint8 = require(Data:WaitForChild("RectPoint8"))
local CutFrame = require(Gui:WaitForChild("CutFrame"))

local ColoredCutFrame = NexusInstance:Extend()
ColoredCutFrame:SetClassName("ColoredCutFrame")



--[[
The constructor fo the colored cut frame. Requires
an adorn frame.
--]]
function ColoredCutFrame:__new(AdornFrame)
	self:InitializeSuper()
	
	--Set up the base properties.
	self.BackgroundColor3 = Color3.new(1,1,1)
	self.BackgroundTransparency = 0
	
	--Set up the "cut points".
	local DefaultSide = RectSide.new(UDim.new(0,0),UDim.new(0,0))
	self.CutPoints = RectPoint8.new(DefaultSide,DefaultSide,DefaultSide,DefaultSide)
	
	--Set up the adorn frames.
	self.AdornFrame = AdornFrame
	self:LockProperty("AdornFrame")
	
	--Set up the frames.
	self.CutFrames = {}
	self:LockProperty("CutFrames")
	self:__InitializeEvents()
	self:__UpdateFrames()
	self:__CutPointsUpdated()
	
	--Set up automatic cutting.
	self:__InitializeCutting()
end

--[[
Initializes automatic cutting. This is done when the
size constraint isn't RelativeXY.
--]]
function ColoredCutFrame:__InitializeCutting()
	CutFrame.__InitializeCutting(self)
end

--[[
Sets up the events.
--]]
function ColoredCutFrame:__InitializeEvents()
	local Events = {}
	self.__Events = {}

	table.insert(Events,self:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
		--Optimize the BackgroundColor3.
		if typeof(self.BackgroundColor3) == "ColorSequence" then
			self.BackgroundColor3 = self:OptimizeColorSequence(self.BackgroundColor3)
		end
		
		--Update the frames.
		self:__UpdateFrames()
	end))
	table.insert(Events,self:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
		self:__UpdateVisibleFrames()
	end))
	table.insert(Events,self:GetPropertyChangedSignal("ZIndex"):Connect(function()
		self:__UpdateVisibleFrames()
	end))
	table.insert(Events,self.AdornFrame:GetPropertyChangedSignal("Size"):Connect(function()
		self:__UpdateFrames()
	end))
	table.insert(Events,self.AdornFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		self:__UpdateFrames()
	end))
	table.insert(Events,self:GetPropertyChangedSignal("CutPoints"):Connect(function()
		self:__CutPointsUpdated()
	end))
end

--[[
Invoked the the CutPoints is updated.
--]]
function ColoredCutFrame:__CutPointsUpdated()
	table.insert(self.__Events,self.CutPoints.Changed:Connect(function()
		for _,Frame in pairs(self.CutFrames) do
			Frame[3].CutPoints = self.CutPoints
		end
	end))
	
	for _,Frame in pairs(self.CutFrames) do
		Frame[3].CutPoints = self.CutPoints
	end
end

--[[
Updates the color and transparency of the
frames. Should be run after ColoredCutFrame:__UpdateFrames().
--]]
function ColoredCutFrame:__UpdateVisibleFrames()
	local Color = self.BackgroundColor3
	
	--Set the colors nad background transparencies.
	if typeof(Color) == "ColorSequence" then
		local Keypoints = Color.Keypoints
		for i,Frame in pairs(self.CutFrames) do
			Frame[3].BackgroundColor3 = Keypoints[i].Value
			Frame[3].BackgroundTransparency = self.BackgroundTransparency
			Frame[3].ZIndex = self.ZIndex
		end
	else
		for _,Frame in pairs(self.CutFrames) do
			Frame[3].BackgroundColor3 = Color
			Frame[3].BackgroundTransparency = self.BackgroundTransparency
			Frame[3].ZIndex = self.ZIndex
		end
	end
end

--[[
Updates the size, positions, and parents of the
adorned frames for the current cuts.
--]]
function ColoredCutFrame:__UpdateFrames()
	--Determine the amount of needed frames.
	local NeededFrames = 1
	if typeof(self.BackgroundColor3) == "ColorSequence" then
		NeededFrames = #self.BackgroundColor3.Keypoints - 1
	end
	
	--Add/remove cut frames.
	for i = 1,NeededFrames - #self.CutFrames do
		local ClipFrame = Instance.new("Frame")
		ClipFrame.BackgroundTransparency = 1
		ClipFrame.ClipsDescendants = true
		ClipFrame.Parent = self.AdornFrame
		
		local SubAdornFrame = Instance.new("Frame")
		SubAdornFrame.BackgroundTransparency = 1
		SubAdornFrame.Parent = ClipFrame
		
		local AdornedCutFrame = CutFrame.new(SubAdornFrame)
		AdornedCutFrame.CutPoints = self.CutPoints
		
		table.insert(self.CutFrames,{ClipFrame,SubAdornFrame,AdornedCutFrame})
	end
	
	for i = 1,#self.CutFrames - NeededFrames do
		local FrameData = self.CutFrames[#self.CutFrames]
		FrameData[1]:Destroy()
		FrameData[3]:Destroy()
		table.remove(self.CutFrames,#self.CutFrames)
	end
	
	--Set the frame positions.
	local SizeX,SizeY = self.AdornFrame.AbsoluteSize.X,self.AdornFrame.AbsoluteSize.Y
	local LastPos = 0
	for i,FrameData in pairs(self.CutFrames) do
		--Get the size and position.
		local WidthRelative = 1
		if typeof(self.BackgroundColor3) == "ColorSequence" then
			local Keypoints = self.BackgroundColor3.Keypoints
			local Start,End = Keypoints[i].Time,Keypoints[i + 1].Time
			WidthRelative = End - Start
		end
		
		--Set the size and positions.
		local NewSizeX = math.floor((SizeX * WidthRelative) + 0.5)
		local ClipFrame,SubAdornFrame,AdornedCutFrame = FrameData[1],FrameData[2],FrameData[3]
		ClipFrame.Size = UDim2.new(0,NewSizeX,1,0)
		ClipFrame.Position = UDim2.new(0,LastPos,0,0)
		SubAdornFrame.Size = UDim2.new(0,SizeX,0,SizeY)
		SubAdornFrame.Position = UDim2.new(0,-LastPos,0,0)
		LastPos = math.floor(LastPos + NewSizeX)
	end
	
	--Update the properties.
	self:__UpdateVisibleFrames()
end

--[[
Cuts a corner (horizontal and veritcal side) with
a given UDim2 "cut" and relative constraint.
--]]
function ColoredCutFrame:__CutCorner(HorizontalSideName,VerticalSideName,CutSize,Constraint)
	CutFrame.__CutCorner(self,HorizontalSideName,VerticalSideName,CutSize,Constraint)
	self:__UpdateFrames()
end


	
--[[
Optimizes a ColorSequence and removes common colors.
--]]
function ColoredCutFrame:OptimizeColorSequence(Sequence)
	local Keypoints = {}
	local LastColor
	
	--Add the colors.
	for _,Keypoint in pairs(Sequence.Keypoints) do
		if Keypoint.Time == 1 or Keypoint.Value ~= LastColor then
			LastColor = Keypoint.Value
			table.insert(Keypoints,Keypoint)
		end
	end
	
	--Return the new sequence.
	return ColorSequence.new(Keypoints)
end

--[[
Cuts a corner (horizontal and veritcal side) with
a given UDim2 "cut" and relative constraint.
--]]
function ColoredCutFrame:CutCorner(HorizontalSideName,VerticalSideName,CutSize,Constraint)
	CutFrame.CutCorner(self,HorizontalSideName,VerticalSideName,CutSize,Constraint)
end

--[[
Removes a cut from a corner (horizontal and veritcal side).
--]]
function ColoredCutFrame:RemoveCut(HorizontalSideName,VerticalSideName)
	CutFrame.RemoveCut(self,HorizontalSideName,VerticalSideName)
	self:__UpdateFrames()
end

--[[
Disconnects all events and destroys the adorned frames.
--]]
function ColoredCutFrame:Destroy()
	--Disconnect the events.
	for _,Event in pairs(self.__Events) do
		Event:Disconnect()
	end
	
	--Destory the frames.
	for _,Frame in pairs(self.CutFrames) do
		Frame[1]:Destroy()
		Frame[3]:Destroy()
	end
end



return ColoredCutFrame