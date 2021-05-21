--[[
TheNexusAvenger

Unit tests for the ColoredCutFrame class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local Gui = NexusButton:WaitForChild("Gui")

local ColoredCutFrame = require(Gui:WaitForChild("ColoredCutFrame"))
local ColoredCutFrameTest = NexusUnitTesting.UnitTest:Extend()



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest(ColoredCutFrameTest.new("Constructor"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the ColoredCutFrame class.
    local CuT = ColoredCutFrame.new(Frame)
    
    --Run the assertions.
    self:AssertEquals(CuT.ClassName,"ColoredCutFrame","ClassName is incorrect.")
end))

--[[
Tests the CutCorner function.
--]]
NexusUnitTesting:RegisterUnitTest(ColoredCutFrameTest.new("CutCorner"):SetRun(function(self)
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
    self:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0.1,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0.1,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Top.Point2,UDim.new(0.2,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Right.Point1,UDim.new(0.2,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Left.Point2,UDim.new(0.3,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Bottom.Point1,UDim.new(0.3,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Right.Point2,UDim.new(0.4,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Bottom.Point2,UDim.new(0.4,0),"Points not properly cut.")
end))

--[[
Tests the CutCorner function with a RelativeXX constraint.
--]]
NexusUnitTesting:RegisterUnitTest(ColoredCutFrameTest.new("CutCornerRelativeXX"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,200,0,100)
    
    --Create the ColoredCutFrame class.
    local CuT = ColoredCutFrame.new(Frame)
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0),"RelativeXX")
    
    --Run the assertions.
    self:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0.1,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0.2,0),"Points not properly cut.")
end))

--[[
Tests the CutCorner function with a RelativeYY constraint.
--]]
NexusUnitTesting:RegisterUnitTest(ColoredCutFrameTest.new("CutCornerRelativeYY"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,200)
    
    --Create the ColoredCutFrame class.
    local CuT = ColoredCutFrame.new(Frame)
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0),"RelativeYY")
    
    --Run the assertions.
    self:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0.2,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0.1,0),"Points not properly cut.")
end))

--[[
Tests the RemoveCut function.
--]]
NexusUnitTesting:RegisterUnitTest(ColoredCutFrameTest.new("RemoveCut"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the ColoredCutFrame class.
    local CuT = ColoredCutFrame.new(Frame)
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0),"RelativeYY")
    
    --Run the assertions.
    self:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0.1,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0.1,0),"Points not properly cut.")
    
    --Remove the cut.
    CuT:RemoveCut("Top","Left")
    
    --Run the assertions.
    self:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0,0),"Points not properly cut.")
end))

--[[
Tests setting the BackgroundColor3.
--]]
NexusUnitTesting:RegisterUnitTest(ColoredCutFrameTest.new("BackgroundColor3"):SetRun(function(self)
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
        self:AssertNil(SubFrame:FindFirstChildOfClass("UIGradient"),"Gradient was added.")
        if SubFrame:IsA("ImageLabel") then
            self:AssertEquals(SubFrame.ImageColor3,Color3.new(1,0,0),"Color is not set.")
        else
            self:AssertEquals(SubFrame.BackgroundColor3,Color3.new(1,0,0),"Color is not set.")
        end
    end
end))

--[[
Tests setting the BackgroundColor3 after cutting.
--]]
NexusUnitTesting:RegisterUnitTest(ColoredCutFrameTest.new("BackgroundColor3AfterCutting"):SetRun(function(self)
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
        self:AssertNil(SubFrame:FindFirstChildOfClass("UIGradient"),"Gradient was added.")
        if SubFrame:IsA("ImageLabel") then
            self:AssertEquals(SubFrame.ImageColor3,Color3.new(1,0,0),"Color is not set.")
        else
            self:AssertEquals(SubFrame.BackgroundColor3,Color3.new(1,0,0),"Color is not set.")
        end
    end
end))

--[[
Tests setting the BackgroundColor3 with ColorSequences.
--]]
NexusUnitTesting:RegisterUnitTest(ColoredCutFrameTest.new("BackgroundColor3ColorSequence"):SetRun(function(self)
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
    wait()
    
    --Run the assertions.
    self:AssertEquals(#CuT.TopLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints,2)
    self:AssertEquals(CuT.TopLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
    self:AssertEquals(CuT.TopLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,1)
    self:AssertEquals(CuT.TopLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(1,0,0))
    self:AssertEquals(CuT.TopLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(1,0,0))
    self:AssertEquals(#CuT.TopRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints,2)
    self:AssertEquals(CuT.TopRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
    self:AssertEquals(CuT.TopRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,1)
    self:AssertEquals(CuT.TopRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(0,1,0))
    self:AssertEquals(CuT.TopRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(0,1,0))
    self:AssertEquals(#CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints,4)
    self:AssertEquals(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
    self:AssertClose(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,0.8,0.01)
    self:AssertClose(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Time,0.8,0.01)
    self:AssertEquals(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Time,1)
    self:AssertEquals(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(1,0,0))
    self:AssertEquals(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(1,0,0))
    self:AssertEquals(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Value,Color3.new(0,1,0))
    self:AssertEquals(CuT.BottomLeftTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Value,Color3.new(0,1,0))
    self:AssertEquals(#CuT.BottomRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints,2)
    self:AssertEquals(CuT.BottomRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
    self:AssertEquals(CuT.BottomRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,1)
    self:AssertEquals(CuT.BottomRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(0,1,0))
    self:AssertEquals(CuT.BottomRightTriangle:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(0,1,0))
    self:AssertEquals(#CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints,4)
    self:AssertEquals(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
    self:AssertClose(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,0.5,0.01)
    self:AssertClose(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Time,0.5,0.01)
    self:AssertEquals(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Time,1)
    self:AssertEquals(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(1,0,0))
    self:AssertEquals(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(1,0,0))
    self:AssertEquals(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Value,Color3.new(0,1,0))
    self:AssertEquals(CuT.RectangleFrames[1]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Value,Color3.new(0,1,0))
    self:AssertEquals(#CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints,4)
    self:AssertEquals(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
    self:AssertClose(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,0.4/0.7,0.01)
    self:AssertClose(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Time,0.4/0.7,0.01)
    self:AssertEquals(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Time,1)
    self:AssertEquals(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(1,0,0))
    self:AssertEquals(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(1,0,0))
    self:AssertEquals(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Value,Color3.new(0,1,0))
    self:AssertEquals(CuT.RectangleFrames[2]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Value,Color3.new(0,1,0))
    self:AssertEquals(#CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints,4)
    self:AssertEquals(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
    self:AssertClose(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,0.4,0.01)
    self:AssertClose(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Time,0.4,0.01)
    self:AssertEquals(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Time,1)
    self:AssertEquals(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(1,0,0))
    self:AssertEquals(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(1,0,0))
    self:AssertEquals(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Value,Color3.new(0,1,0))
    self:AssertEquals(CuT.RectangleFrames[3]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Value,Color3.new(0,1,0))
    self:AssertEquals(#CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints,4)
    self:AssertEquals(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
    self:AssertClose(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,0.4/0.6,0.01)
    self:AssertClose(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Time,0.4/0.6,0.01)
    self:AssertEquals(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Time,1)
    self:AssertEquals(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(1,0,0))
    self:AssertEquals(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(1,0,0))
    self:AssertEquals(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[3].Value,Color3.new(0,1,0))
    self:AssertEquals(CuT.RectangleFrames[4]:FindFirstChildOfClass("UIGradient").Color.Keypoints[4].Value,Color3.new(0,1,0))
    self:AssertEquals(#CuT.RectangleFrames[5]:FindFirstChildOfClass("UIGradient").Color.Keypoints,2)
    self:AssertEquals(CuT.RectangleFrames[5]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Time,0)
    self:AssertEquals(CuT.RectangleFrames[5]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Time,1)
    self:AssertEquals(CuT.RectangleFrames[5]:FindFirstChildOfClass("UIGradient").Color.Keypoints[1].Value,Color3.new(0,1,0))
    self:AssertEquals(CuT.RectangleFrames[5]:FindFirstChildOfClass("UIGradient").Color.Keypoints[2].Value,Color3.new(0,1,0))
end))



return true