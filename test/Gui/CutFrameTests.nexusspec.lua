--[[
TheNexusAvenger

Unit tests for the CutFrame class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local Gui = NexusButton:WaitForChild("Gui")

local CutFrame = require(Gui:WaitForChild("CutFrame"))
local CutFrameTest = NexusUnitTesting.UnitTest:Extend()



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("Constructor"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    
    --Run the assertions.
    self:AssertEquals(CuT.ClassName,"CutFrame","ClassName is incorrect.")
end))

--[[
Tests the CutCorner function.
--]]
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("CutCorner"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
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
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("CutCornerRelativeXX"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,200,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0),"RelativeXX")
    
    --Run the assertions.
    self:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0.1,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0.2,0),"Points not properly cut.")
end))

--[[
Tests the CutCorner function with a RelativeYY constraint.
--]]
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("CutCornerRelativeYY"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,200)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0),"RelativeYY")
    
    --Run the assertions.
    self:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0.2,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0.1,0),"Points not properly cut.")
end))

--[[
Tests the CutCorner function persists after resizing.
--]]
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("CutCornerResize"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,200)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0),"RelativeYY")
    
    --Run the assertions.
    Frame.Size = UDim2.new(0,100,0,400)
    wait()
    self:AssertEquals(CuT.CutPoints.Top.Point1,UDim.new(0.4,0),"Points not properly cut.")
    self:AssertEquals(CuT.CutPoints.Left.Point1,UDim.new(0.1,0),"Points not properly cut.")
end))

--[[
Tests the CutCorner function's efficieny with asymmetic cuts.
--]]
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("CutCornerEfficiencyAsymmetic"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    self:AssertEquals(#Frame:GetChildren(),1,"Frame count not efficient.")
    
    --Test 1 cut.
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
    wait()
    self:AssertEquals(#Frame:GetChildren(),1 + 2,"Frame count not efficient.")
    
    --Test 2 cuts.
    CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
    wait()
    self:AssertEquals(#Frame:GetChildren(),2 + 3,"Frame count not efficient.")
    
    --Test 3 cuts.
    CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
    wait()
    self:AssertEquals(#Frame:GetChildren(),3 + 4,"Frame count not efficient.")
    
    --Test 4 cuts.
    CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
    wait()
    self:AssertEquals(#Frame:GetChildren(),4 + 5,"Frame count not efficient.")
end))

--[[
Tests the CutCorner function's efficieny with symmetic cuts.
--]]
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("CutCornerEfficiencySymmetic"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    self:AssertEquals(#Frame:GetChildren(),1,"Frame count not efficient.")
    
    --Test 1 cut.
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
    wait()
    self:AssertEquals(#Frame:GetChildren(),1 + 2,"Frame count not efficient.")
    
    --Test 2 cuts.
    CuT:CutCorner("Top","Right",UDim2.new(0.1,0,0.1,0))
    wait()
    self:AssertEquals(#Frame:GetChildren(),2 + 2,"Frame count not efficient.")
    
    --Test 3 cuts.
    CuT:CutCorner("Bottom","Left",UDim2.new(0.1,0,0.1,0))
    wait()
    self:AssertEquals(#Frame:GetChildren(),3 + 3,"Frame count not efficient.")
    
    --Test 4 cuts.
    CuT:CutCorner("Bottom","Right",UDim2.new(0.1,0,0.1,0))
    wait()
    self:AssertEquals(#Frame:GetChildren(),4 + 3,"Frame count not efficient.")
end))

--[[
Tests the RemoveCut function.
--]]
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("RemoveCut"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
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
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("BackgroundColor3"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
    CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
    CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
    CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
    CuT.BackgroundColor3 = Color3.new(1,0,0)
    
    --Run the assertions.
    for _,SubFrame in pairs(Frame:GetChildren()) do
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
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("BackgroundColor3AfterCutting"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
    CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
    CuT.BackgroundColor3 = Color3.new(1,0,0)
    CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
    CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
    
    --Run the assertions.
    for _,SubFrame in pairs(Frame:GetChildren()) do
        if SubFrame:IsA("ImageLabel") then
            self:AssertEquals(SubFrame.ImageColor3,Color3.new(1,0,0),"Color is not set.")
        else
            self:AssertEquals(SubFrame.BackgroundColor3,Color3.new(1,0,0),"Color is not set.")
        end
    end
end))

--[[
Tests setting the BackgroundTransparency.
--]]
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("BackgroundTransparency"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
    CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
    CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
    CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
    CuT.BackgroundTransparency = 0.5
    
    --Run the assertions.
    for _,SubFrame in pairs(Frame:GetChildren()) do
        if SubFrame:IsA("ImageLabel") then
            self:AssertEquals(SubFrame.ImageTransparency,0.5,"Transparency is not set.")
        else
            self:AssertEquals(SubFrame.BackgroundTransparency,0.5,"Transparency is not set.")
        end
    end
end))

--[[
Tests setting the BackgroundTransparency after cutting.
--]]
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("BackgroundTransparencyAfterCutting"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
    CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
    CuT.BackgroundTransparency = 0.5
    CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
    CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
    
    --Run the assertions.
    for _,SubFrame in pairs(Frame:GetChildren()) do
        if SubFrame:IsA("ImageLabel") then
            self:AssertEquals(SubFrame.ImageTransparency,0.5,"Transparency is not set.")
        else
            self:AssertEquals(SubFrame.BackgroundTransparency,0.5,"Transparency is not set.")
        end
    end
end))

--[[
Tests setting the ZIndex.
--]]
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("ZIndex"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
    CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
    CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
    CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
    CuT.ZIndex = 3
    
    --Run the assertions.
    for _,SubFrame in pairs(Frame:GetChildren()) do
        self:AssertEquals(SubFrame.ZIndex,3,"ZIndex is not set.")
    end
end))

--[[
Tests setting the ZIndex after cutting.
--]]
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("ZIndexAfterCutting"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
    CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
    CuT.ZIndex = 3
    CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
    CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
    
    --Run the assertions.
    for _,SubFrame in pairs(Frame:GetChildren()) do
        self:AssertEquals(SubFrame.ZIndex,3,"ZIndex is not set.")
    end
end))

--[[
Tests the Destroy function.
--]]
NexusUnitTesting:RegisterUnitTest(CutFrameTest.new("Destroy"):SetRun(function(self)
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0,100,0,100)
    
    --Create the CutFrame class.
    local CuT = CutFrame.new(Frame)
    CuT:Destroy()
    
    --Run the assertions.
    self:AssertEquals(#Frame:GetChildren(),0,"Frames not destroyed.")
end))



return true