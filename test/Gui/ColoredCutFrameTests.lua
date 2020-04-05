--[[
TheNexusAvenger

Unit tests for the ColoredCutFrame class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local Data = NexusButton:WaitForChild("Data")
local Gui = NexusButton:WaitForChild("Gui")

local RectPoint8 = require(Data:WaitForChild("RectPoint8"))
local ColoredCutFrame = require(Gui:WaitForChild("ColoredCutFrame"))



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,100)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.ClassName,"ColoredCutFrame","ClassName is incorrect.")
end)

--[[
Tests the CutCorner function.
--]]
NexusUnitTesting:RegisterUnitTest("CutCorner",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,100)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
	CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
	CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
	CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0.1,0),"Points not properly cut.")
	UnitTest:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0.1,0),"Points not properly cut.")
	UnitTest:AssertEquals(CuT.CutPoints.Top.Point2,UDim.new(0.2,0),"Points not properly cut.")
	UnitTest:AssertEquals(CuT.CutPoints.Right.Point1,UDim.new(0.2,0),"Points not properly cut.")
	UnitTest:AssertEquals(CuT.CutPoints.Left.Point2,UDim.new(0.3,0),"Points not properly cut.")
	UnitTest:AssertEquals(CuT.CutPoints.Bottom.Point1,UDim.new(0.3,0),"Points not properly cut.")
	UnitTest:AssertEquals(CuT.CutPoints.Right.Point2,UDim.new(0.4,0),"Points not properly cut.")
	UnitTest:AssertEquals(CuT.CutPoints.Bottom.Point2,UDim.new(0.4,0),"Points not properly cut.")
end)

--[[
Tests the CutCorner function with a RelativeXX constraint.
--]]
NexusUnitTesting:RegisterUnitTest("CutCornerRelativeXX",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,200,0,100)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0),"RelativeXX")
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0.1,0),"Points not properly cut.")
	UnitTest:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0.2,0),"Points not properly cut.")
end)

--[[
Tests the CutCorner function with a RelativeYY constraint.
--]]
NexusUnitTesting:RegisterUnitTest("CutCornerRelativeYY",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,200)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0),"RelativeYY")
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0.2,0),"Points not properly cut.")
	UnitTest:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0.1,0),"Points not properly cut.")
end)

--[[
Tests the RemoveCut function.
--]]
NexusUnitTesting:RegisterUnitTest("RemoveCut",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,100)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0),"RelativeYY")
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0.1,0),"Points not properly cut.")
	UnitTest:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0.1,0),"Points not properly cut.")
	
	--Remove the cut.
	CuT:RemoveCut("Top","Left")
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0,0),"Points not properly cut.")
	UnitTest:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0,0),"Points not properly cut.")
end)

--[[
Tests setting the BackgroundColor3.
--]]
NexusUnitTesting:RegisterUnitTest("BackgroundColor3",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,100)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
	CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
	CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
	CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
	CuT.BackgroundColor3 = Color3.new(1,0,0)
	
	--Run the assertions.
	for _,SubFrame in pairs(Frame:GetChildren()) do
		UnitTest:AssertNil(SubFrame:FindFirstChildOfClass("UIGradient"),"Gradient was added.")
		if SubFrame:IsA("ImageLabel") then
			UnitTest:AssertEquals(SubFrame.ImageColor3,Color3.new(1,0,0),"Color is not set.")
		else
			UnitTest:AssertEquals(SubFrame.BackgroundColor3,Color3.new(1,0,0),"Color is not set.")
		end
	end
end)

--[[
Tests setting the BackgroundColor3 after cutting.
--]]
NexusUnitTesting:RegisterUnitTest("BackgroundColor3AfterCutting",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,100)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
	CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
	CuT.BackgroundColor3 = Color3.new(1,0,0)
	CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
	CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
	
	--Run the assertions.
	for _,SubFrame in pairs(Frame:GetChildren()) do
		UnitTest:AssertNil(SubFrame:FindFirstChildOfClass("UIGradient"),"Gradient was added.")
		if SubFrame:IsA("ImageLabel") then
			UnitTest:AssertEquals(SubFrame.ImageColor3,Color3.new(1,0,0),"Color is not set.")
		else
			UnitTest:AssertEquals(SubFrame.BackgroundColor3,Color3.new(1,0,0),"Color is not set.")
		end
	end
end)

--[[
Tests setting the BackgroundColor3 with ColorSequences.
--]]
NexusUnitTesting:RegisterUnitTest("BackgroundColor3ColorSequence",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,100)

	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
	CuT:CutCorner("Top","Right",UDim2.new(0.3,0,0.2,0))
	CuT.BackgroundColor3 = ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),
		ColorSequenceKeypoint.new(0.4,Color3.new(0,1,0)),
		ColorSequenceKeypoint.new(1,Color3.new(0,0,1)),
	})
	CuT:CutCorner("Bottom","Left",UDim2.new(0.5,0,0.3,0))
	CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
	
	--Run the assertions.
	UnitTest:AssertEquals(#CuT.TopLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints,2)
	UnitTest:AssertEquals(CuT.TopLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
	UnitTest:AssertEquals(CuT.TopLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,1)
	UnitTest:AssertEquals(CuT.TopLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(1,0,0))
	UnitTest:AssertEquals(CuT.TopLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(1,0,0))
	UnitTest:AssertEquals(#CuT.TopRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints,2)
	UnitTest:AssertEquals(CuT.TopRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
	UnitTest:AssertEquals(CuT.TopRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,1)
	UnitTest:AssertEquals(CuT.TopRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(CuT.TopRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(#CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints,4)
	UnitTest:AssertEquals(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
	UnitTest:AssertClose(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,0.8,0.01)
	UnitTest:AssertClose(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Time,0.8,0.01)
	UnitTest:AssertEquals(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Time,1)
	UnitTest:AssertEquals(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(1,0,0))
	UnitTest:AssertEquals(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(1,0,0))
	UnitTest:AssertEquals(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(#CuT.BottomRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints,2)
	UnitTest:AssertEquals(CuT.BottomRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
	UnitTest:AssertEquals(CuT.BottomRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,1)
	UnitTest:AssertEquals(CuT.BottomRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(CuT.BottomRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(#CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints,4)
	UnitTest:AssertEquals(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
	UnitTest:AssertClose(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,0.5,0.01)
	UnitTest:AssertClose(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Time,0.5,0.01)
	UnitTest:AssertEquals(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Time,1)
	UnitTest:AssertEquals(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(1,0,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(1,0,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(#CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints,4)
	UnitTest:AssertEquals(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
	UnitTest:AssertClose(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,0.4/0.7,0.01)
	UnitTest:AssertClose(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Time,0.4/0.7,0.01)
	UnitTest:AssertEquals(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Time,1)
	UnitTest:AssertEquals(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(1,0,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(1,0,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(#CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints,4)
	UnitTest:AssertEquals(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
	UnitTest:AssertClose(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,0.4,0.01)
	UnitTest:AssertClose(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Time,0.4,0.01)
	UnitTest:AssertEquals(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Time,1)
	UnitTest:AssertEquals(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(1,0,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(1,0,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(#CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints,4)
	UnitTest:AssertEquals(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
	UnitTest:AssertClose(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,0.4/0.6,0.01)
	UnitTest:AssertClose(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Time,0.4/0.6,0.01)
	UnitTest:AssertEquals(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Time,1)
	UnitTest:AssertEquals(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(1,0,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(1,0,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(#CuT.RectangleFrames[5]:FindFirstChildOfClass("UIGradient").Color.Keypoints,2)
	UnitTest:AssertEquals(CuT.RectangleFrames[5]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
	UnitTest:AssertEquals(CuT.RectangleFrames[5]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,1)
	UnitTest:AssertEquals(CuT.RectangleFrames[5]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(0,1,0))
	UnitTest:AssertEquals(CuT.RectangleFrames[5]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(0,1,0))
end)



return true