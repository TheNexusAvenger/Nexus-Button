--[[
TheNexusAvenger

Class representing a "cut" frame. The design is to
have corners "cut" from the frame. All 4 can be
cut, representing by the RectPoint8 class.
--]]

local TRIANGLE_TEXTURES = "rbxassetid://4449507744"
local TRIANGLE_TEXTURE_SIZE = Vector2.new(512,512)
local TOP_LEFT_TRIANGLE_OFFSET = Vector2.new(0,0)
local BOTTOM_LEFT_TRIANGLE_OFFSET = Vector2.new(0,512)
local TOP_RIGHT_TRIANGLE_OFFSET = Vector2.new(512,0)
local BOTTOM_RIGHT_TRIANGLE_OFFSET = Vector2.new(512,512)



local RootModule = script.Parent.Parent
local Data = RootModule:WaitForChild("Data")

local NexusInstance = require(RootModule:WaitForChild("NexusInstance"):WaitForChild("NexusInstance"))
local RectSide = require(Data:WaitForChild("RectSide"))
local RectPoint8 = require(Data:WaitForChild("RectPoint8"))

local CutFrame = NexusInstance:Extend()
CutFrame:SetClassName("CutFrame")



--[[
The constructor fo the cut frame. Requires an
adorn frame.
--]]
function CutFrame:__new(AdornFrame)
	self:InitializeSuper()
	
	--Set up the base properties.
	self.BackgroundColor3 = Color3.new(1,1,1)
	self.BackgroundTransparency = 0
	self.ZIndex = 1
	
	--Set up the "cut points".
	local DefaultSide = RectSide.new(UDim.new(0,0),UDim.new(0,0))
	self.CutPoints = RectPoint8.new(DefaultSide,DefaultSide,DefaultSide,DefaultSide)
	
	--Set up the adorn frames.
	self.AdornFrame = AdornFrame
	self:LockProperty("AdornFrame")
	
	--Set up the frames.
	self:__InitializeFrames()
	self:__InitializeEvents()
	self:__InitializeCutting()
	self:__CutPointsUpdated()
end

--[[
Initilizes the triangle frames.
--]]
function CutFrame:__InitializeFrames()
	self.RectangleFrames = {}
	
	local TopLeftTriangle = Instance.new("ImageLabel")
	TopLeftTriangle.BackgroundTransparency = 1
	TopLeftTriangle.Image = TRIANGLE_TEXTURES
	TopLeftTriangle.ImageRectSize = TRIANGLE_TEXTURE_SIZE
	TopLeftTriangle.ImageRectOffset = TOP_LEFT_TRIANGLE_OFFSET
	self.TopLeftTriangle = TopLeftTriangle
	self:LockProperty("TopLeftTriangle")
	
	local TopRightTriangle = Instance.new("ImageLabel")
	TopRightTriangle.BackgroundTransparency = 1
	TopRightTriangle.Image = TRIANGLE_TEXTURES
	TopRightTriangle.ImageRectSize = TRIANGLE_TEXTURE_SIZE
	TopRightTriangle.ImageRectOffset = TOP_RIGHT_TRIANGLE_OFFSET
	self.TopRightTriangle = TopRightTriangle
	self:LockProperty("TopRightTriangle")
	
	local BottomLeftTriangle = Instance.new("ImageLabel")
	BottomLeftTriangle.BackgroundTransparency = 1
	BottomLeftTriangle.Image = TRIANGLE_TEXTURES
	BottomLeftTriangle.ImageRectSize = TRIANGLE_TEXTURE_SIZE
	BottomLeftTriangle.ImageRectOffset = BOTTOM_LEFT_TRIANGLE_OFFSET
	self.BottomLeftTriangle = BottomLeftTriangle
	self:LockProperty("BottomLeftTriangle")
	
	local BottomRightTriangle = Instance.new("ImageLabel")
	BottomRightTriangle.BackgroundTransparency = 1
	BottomRightTriangle.Image = TRIANGLE_TEXTURES
	BottomRightTriangle.ImageRectSize = TRIANGLE_TEXTURE_SIZE
	BottomRightTriangle.ImageRectOffset = BOTTOM_RIGHT_TRIANGLE_OFFSET
	self.BottomRightTriangle = BottomRightTriangle
	self:LockProperty("BottomRightTriangle")
end

--[[
Sets up the events.
--]]
function CutFrame:__InitializeEvents()
	local Events = {}
	self.__Events = Events
	
	table.insert(Events,self:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
		self.object:__UpdateVisibleFrames()
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
	table.insert(Events,self:GetPropertyChangedSignal("CutPoints"):Connect(function()
		self:__CutPointsUpdated()
	end))
end

--[[
Initializes automatic cutting. This is done when the
size constraint isn't RelativeXY.
--]]
function CutFrame:__InitializeCutting()
	self.__PersistentCuts = {}
	self:LockProperty("__PersistentCuts")
	
	--[[
	Re-cuts the frame.
	--]]
	local function RecutFrame()
		for _,Cut in pairs(self.__PersistentCuts) do
			local HorizontalSideName,VerticalSideName = Cut[1],Cut[2]
			local CutSize,Constraint = Cut[3],Cut[4]
			self:__CutCorner(HorizontalSideName,VerticalSideName,CutSize,Constraint)
		end
	end
	
	--Set up size changes.
	table.insert(self.__Events,self.AdornFrame:GetPropertyChangedSignal("Size"):Connect(RecutFrame))
	table.insert(self.__Events,self.AdornFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(RecutFrame))
end

--[[
Invoked the the CutPoints is updated.
--]]
function CutFrame:__CutPointsUpdated()
	table.insert(self.__Events,self.CutPoints.Changed:Connect(function()
		self:__UpdateFrames()
	end))
	
	self:__UpdateFrames()
end

--[[
Updates the color and transparency of the
frames. Should be run after CutFrame:__UpdateFrames().
--]]
function CutFrame:__UpdateVisibleFrames()
	--Update the triangles.
	if typeof(self.BackgroundColor3) == "Color3" then
		self.TopLeftTriangle.ImageColor3 = self.BackgroundColor3
		self.TopRightTriangle.ImageColor3 = self.BackgroundColor3
		self.BottomLeftTriangle.ImageColor3 = self.BackgroundColor3
		self.BottomRightTriangle.ImageColor3 = self.BackgroundColor3
	else
		self.TopLeftTriangle.ImageColor3 = Color3.new(1,1,1)
		self.TopRightTriangle.ImageColor3 = Color3.new(1,1,1)
		self.BottomLeftTriangle.ImageColor3 = Color3.new(1,1,1)
		self.BottomRightTriangle.ImageColor3 = Color3.new(1,1,1)
	end
	self.TopLeftTriangle.ImageTransparency = self.BackgroundTransparency
	self.TopLeftTriangle.ZIndex = self.ZIndex
	self.TopRightTriangle.ImageTransparency = self.BackgroundTransparency
	self.TopRightTriangle.ZIndex = self.ZIndex
	self.BottomLeftTriangle.ImageTransparency = self.BackgroundTransparency
	self.BottomLeftTriangle.ZIndex = self.ZIndex
	self.BottomRightTriangle.ImageTransparency = self.BackgroundTransparency
	self.BottomRightTriangle.ZIndex = self.ZIndex
	
	--Update the frames.
	for _,Frame in pairs(self.RectangleFrames) do
		if typeof(self.BackgroundColor3) == "Color3" then
			Frame.BackgroundColor3 = self.BackgroundColor3
		else
			Frame.BackgroundColor3 = Color3.new(1,1,1)
		end
		Frame.BackgroundTransparency = self.BackgroundTransparency
		Frame.ZIndex = self.ZIndex
	end
end

--[[
Updates the size, positions, and parents of the
adorned frames for the current cuts.
--]]
function CutFrame:__UpdateFrames()
	--Get the base lengths and points.
	local SizeX,SizeY = math.floor(self.AdornFrame.AbsoluteSize.X + 0.5),math.floor(self.AdornFrame.AbsoluteSize.Y + 0.5)
	local TopPoint1,TopPoint2 = self.CutPoints.Top:GetOrderedPoints(SizeX)
	local BottomPoint1,BottomPoint2 = self.CutPoints.Bottom:GetOrderedPoints(SizeX)
	local LeftPoint1,LeftPoint2 = self.CutPoints.Left:GetOrderedPoints(SizeY)
	local RightPoint1,RightPoint2 = self.CutPoints.Right:GetOrderedPoints(SizeY)
	
	--Get the cut lengths.
	local TopLength1,TopLength2 = (SizeX * TopPoint1.Scale) + TopPoint1.Offset,(SizeX * TopPoint2.Scale) + TopPoint2.Offset
	TopLength1,TopLength2 = math.floor(TopLength1 + 0.5),math.floor(TopLength2 + 0.5)
	local BottomLength1,BottomLength2 = (SizeX * BottomPoint1.Scale) + BottomPoint1.Offset,(SizeX * BottomPoint2.Scale) + BottomPoint2.Offset
	BottomLength1,BottomLength2 = math.floor(BottomLength1 + 0.5),math.floor(BottomLength2 + 0.5)
	local LeftLength1,LeftLength2 = (SizeY * LeftPoint1.Scale) + LeftPoint1.Offset,(SizeY * LeftPoint2.Scale) + LeftPoint2.Offset
	LeftLength1,LeftLength2 = math.floor(LeftLength1 + 0.5),math.floor(LeftLength2 + 0.5)
	local RightLength1,RightLength2 = (SizeY * RightPoint1.Scale) + RightPoint1.Offset,(SizeY * RightPoint2.Scale) + RightPoint2.Offset
	RightLength1,RightLength2 = math.floor(RightLength1 + 0.5),math.floor(RightLength2 + 0.5)
	
	--Parent the triangles and set the sizes.
	self.TopLeftTriangle.Parent = ((TopLength1 > 0 and LeftLength1 > 0) and self.AdornFrame) or nil
	self.TopLeftTriangle.Size = UDim2.new(0,TopLength1,0,LeftLength1)
	self.TopRightTriangle.Parent = ((TopLength2 > 0 and RightLength1 > 0) and self.AdornFrame) or nil
	self.TopRightTriangle.Size = UDim2.new(0,TopLength2,0,RightLength1)
	self.TopRightTriangle.Position = UDim2.new(0,SizeX - TopLength2,0,0)
	self.BottomLeftTriangle.Parent = ((BottomLength1 > 0 and LeftLength2 > 0) and self.AdornFrame) or nil
	self.BottomLeftTriangle.Size = UDim2.new(0,BottomLength1,0,LeftLength2)
	self.BottomLeftTriangle.Position = UDim2.new(0,0,0,SizeY - LeftLength2)
	self.BottomRightTriangle.Parent = ((BottomLength2 > 0 and RightLength2 > 0) and self.AdornFrame) or nil
	self.BottomRightTriangle.Size = UDim2.new(0,BottomLength2,0,RightLength2)
	self.BottomRightTriangle.Position = UDim2.new(0,SizeX - BottomLength2,0,SizeY - RightLength2)
	
	--Create the possible rectangle end points on the vertical axis.
	local VerticalRectanglePoints = {}
	local VerticalRectanglePointsMap = {
		[0] = true,
		[LeftLength1] = true,
		[SizeY - LeftLength2] = true,
		[RightLength1] = true,
		[SizeY - RightLength2] = true,
		[SizeY]=true,
	}
	
	for Y,_ in pairs(VerticalRectanglePointsMap) do
		table.insert(VerticalRectanglePoints,Y)
	end
	table.sort(VerticalRectanglePoints,function(a,b) return a < b end)
	
	--Determine the rectanlges to create.
	local Rectangles = {}
	local VerticalLines = {
		{0,LeftLength1,TopLength1},
		{0,RightLength1,SizeX - TopLength2},
		{LeftLength1,SizeY - LeftLength2,0},
		{RightLength1,SizeY - RightLength2,SizeX},
		{SizeY - LeftLength2,SizeY,BottomLength1},
		{SizeY - RightLength2,SizeY,SizeX - BottomLength2},
	}
	
	for i = 1,#VerticalRectanglePoints - 1 do
		local StartY,EndY = VerticalRectanglePoints[i],VerticalRectanglePoints[i + 1]
		local MidpointY = (StartY + EndY)/2
		local XPoints = {}
		
		--Find where the rectangles intersect the lines.
		for _,Line in pairs(VerticalLines) do
			if MidpointY > Line[1] and MidpointY < Line[2] then
				table.insert(XPoints,Line[3])
			end
		end
		table.sort(XPoints,function(a,b) return a < b end)
		table.insert(Rectangles,{XPoints[1],XPoints[2],StartY,EndY})
	end
	
	--Add/remove rectangles.
	for i = 1,#Rectangles - #self.RectangleFrames do
		local Frame = Instance.new("Frame")
		Frame.BorderSizePixel = 0
		Frame.Parent = self.AdornFrame
		table.insert(self.RectangleFrames,Frame)
	end
	
	for i = 1,#self.RectangleFrames - #Rectangles do
		self.RectangleFrames[#self.RectangleFrames]:Destroy()
		table.remove(self.RectangleFrames,#self.RectangleFrames)
	end
	
	--Set the frame positions.
	for i,Frame in pairs(self.RectangleFrames) do
		local RectangleData = Rectangles[i]
		local StartX,EndX = RectangleData[1],RectangleData[2]
		local StartY,EndY = RectangleData[3],RectangleData[4]
		
		Frame.Size = UDim2.new(0,math.ceil(EndX - StartX),0,math.ceil(EndY - StartY))
		Frame.Position = UDim2.new(0,StartX,0,StartY)
	end
	
	--Update the properties.
	self.object:__UpdateVisibleFrames()
end

--[[
Cuts a corner (horizontal and veritcal side) with
a given UDim2 "cut" and relative constraint.
--]]
function CutFrame:__CutCorner(HorizontalSideName,VerticalSideName,CutSize,Constraint)
	--Determine the horizontal and vertical point names.
	local HorizontalPointName = (VerticalSideName == "Left" and "Point1") or "Point2"
	local VerticalPointName = (HorizontalSideName == "Top" and "Point1") or "Point2"
	
	--Get the scale and offsets.
	local HorizontalScale = CutSize.X.Scale
	local HorizontalOffset = CutSize.X.Offset
	local VerticalScale = CutSize.Y.Scale
	local VerticalOffset = CutSize.Y.Offset
	
	--Change the scales if the constraint is specified.
	local SizeX,SizeY = self.AdornFrame.AbsoluteSize.X,self.AdornFrame.AbsoluteSize.Y
	if Constraint == Enum.SizeConstraint.RelativeXX or Constraint == "RelativeXX" then
		VerticalScale = VerticalScale * (SizeX/SizeY)
	elseif Constraint == Enum.SizeConstraint.RelativeYY or Constraint == "RelativeYY" then
		HorizontalScale = HorizontalScale * (SizeY/SizeX)
	end
	
	--Set the sides.
	local NewHorizontalPoint = UDim.new(HorizontalScale,HorizontalOffset)
	local NewVerticalPoint = UDim.new(VerticalScale,VerticalOffset)
	self.CutPoints[HorizontalSideName] = self.CutPoints[HorizontalSideName]:ReplacePoint(HorizontalPointName,NewHorizontalPoint)
	self.CutPoints[VerticalSideName] = self.CutPoints[VerticalSideName]:ReplacePoint(VerticalPointName,NewVerticalPoint)
end



--[[
Cuts a corner (horizontal and veritcal side) with
a given UDim2 "cut" and relative constraint.
--]]
function CutFrame:CutCorner(HorizontalSideName,VerticalSideName,CutSize,Constraint)
	--Correct the contraint.
	Constraint = Constraint or Enum.SizeConstraint.RelativeXY
	if Constraint == "RelativeXY" then Constraint = Enum.SizeConstraint.RelativeXY end
	if Constraint == "RelativeXX" then Constraint = Enum.SizeConstraint.RelativeXX end
	if Constraint == "RelativeYY" then Constraint = Enum.SizeConstraint.RelativeYY end
	
	--Add the cut.
	self.__PersistentCuts[HorizontalSideName.."_"..VerticalSideName] = {HorizontalSideName,VerticalSideName,CutSize,Constraint}
	
	--Perform the cut.
	self:__CutCorner(HorizontalSideName,VerticalSideName,CutSize,Constraint)
end

--[[
Removes a cut from a corner (horizontal and veritcal side).
--]]
function CutFrame:RemoveCut(HorizontalSideName,VerticalSideName)
	self.__PersistentCuts[HorizontalSideName.."_"..VerticalSideName] = nil
	self:__CutCorner(HorizontalSideName,VerticalSideName,UDim2.new(0,0,0),Enum.SizeConstraint.RelativeXY)
end
	
--[[
Disconnects all events and destroys the adorned frames.
--]]
function CutFrame:Destroy()
	self.super:Destroy()
	
	--Disconnect the events.
	for _,Event in pairs(self.__Events) do
		Event:Disconnect()
	end
	
	--Destory the frames.
	self.TopLeftTriangle:Destroy()
	self.TopRightTriangle:Destroy()
	self.BottomLeftTriangle:Destroy()
	self.BottomRightTriangle:Destroy()
	for _,Frame in pairs(self.RectangleFrames) do
		Frame:Destroy()
	end
end



return CutFrame
