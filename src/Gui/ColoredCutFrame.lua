--[[
TheNexusAvenger

Class representing a "cut" frame, but with mutliple
colors able to be done horizontally. The BackgroundColor3
can be a Color3 or a ColorSequence.
--]]

local RootModule = script.Parent.Parent
local Gui = RootModule:WaitForChild("Gui")

local CutFrame = require(Gui:WaitForChild("CutFrame"))

local ColoredCutFrame = CutFrame:Extend()
ColoredCutFrame:SetClassName("ColoredCutFrame")



--[[
The constructor fo the colored cut frame. Requires
an adorn frame.
--]]
function ColoredCutFrame:__new(AdornFrame)
	self:InitializeSuper(AdornFrame)
	
	--Set up the base properties.
	self.BackgroundColor3 = Color3.new(1,1,1)
	self.BackgroundTransparency = 0
end

--[[
Removes a gradient from the frame.
--]]
function ColoredCutFrame:__RemoveGradient(Frame)
	--Remove the UI gradient.
	local UIGradient = Frame:FindFirstChildOfClass("UIGradient")
	if UIGradient then
		UIGradient:Destroy()
	end
end

--[[
Sets the gradient of a frame.
--]]
function ColoredCutFrame:__SetGradient(Frame,Start,End)
	--Return if the start and end are the same.
	if Start == End then
		return
	end

	--Add the UI gradient.
	local UIGradient = Frame:FindFirstChildOfClass("UIGradient")
	if not UIGradient then
		UIGradient = Instance.new("UIGradient")
		UIGradient.Parent = Frame
	end

	--Create the keypoints.
	local Keypoints = {}
	local ColorKeypoints = self.BackgroundColor3.Keypoints
	for i = 1,#ColorKeypoints - 1 do
		local Keypoint = ColorKeypoints[i]
		local NextKeypoint = ColorKeypoints[i + 1]

		--Convert the time.
		local NewTimeUnclamped = (Keypoint.Time - Start)/(End - Start)
		local NewTime = math.clamp(NewTimeUnclamped,0,1)
		local NextNewTimeUnclamped = (NextKeypoint.Time - Start)/(End - Start)
		local NextNewTime = math.clamp(NextNewTimeUnclamped,0,1)

		--Add the keypoint.
		if NewTime ~= NextNewTime then
			local NewKeypoint = ColorSequenceKeypoint.new(NewTime,Keypoint.Value)

			if NextNewTime == 1 then
				table.insert(Keypoints,NewKeypoint)
				table.insert(Keypoints,ColorSequenceKeypoint.new(NextNewTime,Keypoint.Value))
			else
				table.insert(Keypoints,NewKeypoint)
				table.insert(Keypoints,ColorSequenceKeypoint.new(NextNewTime - 0.0001,Keypoint.Value))
			end
		end
	end

	--Set the colors.
	if #Keypoints == 0 then
		table.insert(Keypoints,ColorKeypoints[1])
	end
	if Keypoints[#Keypoints].Time ~= 1 then
		table.insert(Keypoints,ColorSequenceKeypoint.new(1,Keypoints[#Keypoints].Value))
	end
	UIGradient.Color = ColorSequence.new(Keypoints)
end

--[[
Updates the color and transparency of the
frames. Should be run after ColoredCutFrame:__UpdateFrames().
--]]
function ColoredCutFrame:__UpdateVisibleFrames()
	self.super:__UpdateVisibleFrames()
	
	local SizeX = math.floor(self.AdornFrame.AbsoluteSize.X + 0.5)
	if typeof(self.BackgroundColor3) == "ColorSequence" then
		--Set the gradients.
		self:__SetGradient(self.TopLeftTriangle,0,self.TopLeftTriangle.Size.X.Offset/SizeX)
		self:__SetGradient(self.TopRightTriangle,self.TopRightTriangle.Position.X.Offset/SizeX,1)
		self:__SetGradient(self.BottomLeftTriangle,0,self.BottomLeftTriangle.Size.X.Offset/SizeX)
		self:__SetGradient(self.BottomRightTriangle,self.BottomRightTriangle.Position.X.Offset/SizeX,1)
		for _,Frame in pairs(self.RectangleFrames) do
			self:__SetGradient(Frame,Frame.Position.X.Offset/SizeX,(Frame.Position.X.Offset + Frame.Size.X.Offset)/SizeX)
		end
	else
		--Remove the gradients.
		self:__RemoveGradient(self.TopLeftTriangle)
		self:__RemoveGradient(self.TopRightTriangle)
		self:__RemoveGradient(self.BottomLeftTriangle)
		self:__RemoveGradient(self.BottomRightTriangle)
		for _,Frame in pairs(self.RectangleFrames) do
			self:__RemoveGradient(Frame)
		end
	end
end



return ColoredCutFrame