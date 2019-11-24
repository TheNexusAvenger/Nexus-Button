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
	for _,SubAdornFrame in pairs(Frame:GetChildren()) do
		for _,SubFrame in pairs(SubAdornFrame:GetChildren()[1]:GetChildren()[1]:GetChildren()) do
			if SubFrame:IsA("ImageLabel") then
				UnitTest:AssertEquals(SubFrame.ImageColor3,Color3.new(1,0,0),"Color is not set.")
			else
				UnitTest:AssertEquals(SubFrame.BackgroundColor3,Color3.new(1,0,0),"Color is not set.")
			end
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
	for _,SubAdornFrame in pairs(Frame:GetChildren()) do
		for _,SubFrame in pairs(SubAdornFrame:GetChildren()[1]:GetChildren()[1]:GetChildren()) do
			if SubFrame:IsA("ImageLabel") then
				UnitTest:AssertEquals(SubFrame.ImageColor3,Color3.new(1,0,0),"Color is not set.")
			else
				UnitTest:AssertEquals(SubFrame.BackgroundColor3,Color3.new(1,0,0),"Color is not set.")
			end
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
	CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
	CuT.BackgroundColor3 = ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),
		ColorSequenceKeypoint.new(0.4,Color3.new(0,1,0)),
		ColorSequenceKeypoint.new(1,Color3.new(0,0,1)),
	})
	CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
	CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
	
	--Run the assertions.
	UnitTest:AssertEquals(#Frame:GetChildren(),2,"Wrong amount of adorn frames made.")
	for _,SubAdornFrame in pairs(Frame:GetChildren()) do
		if SubAdornFrame.AbsolutePosition.X == 0 then
			UnitTest:AssertEquals(SubAdornFrame.AbsoluteSize.X,40,"Clips frame size is incorrect.")
			
			for _,SubFrame in pairs(SubAdornFrame:GetChildren()[1]:GetChildren()[1]:GetChildren()) do
				if SubFrame:IsA("ImageLabel") then
					UnitTest:AssertEquals(SubFrame.ImageColor3,Color3.new(1,0,0),"Color is not set.")
				else
					UnitTest:AssertEquals(SubFrame.BackgroundColor3,Color3.new(1,0,0),"Color is not set.")
				end
			end
		elseif SubAdornFrame.AbsolutePosition.X == 40 then
			UnitTest:AssertEquals(SubAdornFrame.AbsoluteSize.X,60,"Clips frame size is incorrect.")
			
			for _,SubFrame in pairs(SubAdornFrame:GetChildren()[1]:GetChildren()[1]:GetChildren()) do
				if SubFrame:IsA("ImageLabel") then
					UnitTest:AssertEquals(SubFrame.ImageColor3,Color3.new(0,1,0),"Color is not set.")
				else
					UnitTest:AssertEquals(SubFrame.BackgroundColor3,Color3.new(0,1,0),"Color is not set.")
				end
			end
		else
			UnitTest:Fail("Incorrect clips frame position: "..tostring(SubAdornFrame.AbsolutePosition.X))
		end
	end
end)

--[[
Tests setting the BackgroundColor3 with ColorSequence with duplicate colors.
--]]
NexusUnitTesting:RegisterUnitTest("BackgroundColor3ColorSequenceEfficiency",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,100)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
	CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
	CuT.BackgroundColor3 = ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),
		ColorSequenceKeypoint.new(0.2,Color3.new(1,0,0)),
		ColorSequenceKeypoint.new(0.4,Color3.new(1,0,0)),
		ColorSequenceKeypoint.new(0.6,Color3.new(1,0,0)),
		ColorSequenceKeypoint.new(0.8,Color3.new(1,0,0)),
		ColorSequenceKeypoint.new(1,Color3.new(0,0,1)),
	})
	CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
	CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
	
	--Run the assertions.
	UnitTest:AssertEquals(#Frame:GetChildren(),1,"Wrong amount of adorn frames made.")
end)

--[[
Tests setting the BackgroundTransparency.
--]]
NexusUnitTesting:RegisterUnitTest("BackgroundTransparency",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,100)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
	CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
	CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
	CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
	CuT.BackgroundTransparency = 0.5
	
	--Run the assertions.
	for _,SubAdornFrame in pairs(Frame:GetChildren()) do
		for _,SubFrame in pairs(SubAdornFrame:GetChildren()[1]:GetChildren()[1]:GetChildren()) do
			if SubFrame:IsA("ImageLabel") then
				UnitTest:AssertEquals(SubFrame.ImageTransparency,0.5,"Transparency is not set.")
			else
				UnitTest:AssertEquals(SubFrame.BackgroundTransparency,0.5,"Transparency is not set.")
			end
		end
	end
end)

--[[
Tests setting the BackgroundTransparency after cutting.
--]]
NexusUnitTesting:RegisterUnitTest("BackgroundTransparencyAfterCutting",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,100)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
	CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
	CuT.BackgroundTransparency = 0.5
	CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
	CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
	
	--Run the assertions.
	for _,SubAdornFrame in pairs(Frame:GetChildren()) do
		for _,SubFrame in pairs(SubAdornFrame:GetChildren()[1]:GetChildren()[1]:GetChildren()) do
			if SubFrame:IsA("ImageLabel") then
				UnitTest:AssertEquals(SubFrame.ImageTransparency,0.5,"Transparency is not set.")
			else
				UnitTest:AssertEquals(SubFrame.BackgroundTransparency,0.5,"Transparency is not set.")
			end
		end
	end
end)

--[[
Tests setting the ZIndex.
--]]
NexusUnitTesting:RegisterUnitTest("ZIndex",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,100)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
	CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
	CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
	CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
	CuT.ZIndex = 3
	
	--Run the assertions.
	for _,SubAdornFrame in pairs(Frame:GetChildren()) do
		for _,SubFrame in pairs(SubAdornFrame:GetChildren()[1]:GetChildren()[1]:GetChildren()) do
			UnitTest:AssertEquals(SubFrame.ZIndex,3,"ZIndex is not set.")
		end
	end
end)

--[[
Tests setting the ZIndex after cutting.
--]]
NexusUnitTesting:RegisterUnitTest("ZIndexAfterCutting",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,100)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:CutCorner("Top","Left",UDim2.new(0.1,0,0.1,0))
	CuT:CutCorner("Top","Right",UDim2.new(0.2,0,0.2,0))
	CuT.ZIndex = 3
	CuT:CutCorner("Bottom","Left",UDim2.new(0.3,0,0.3,0))
	CuT:CutCorner("Bottom","Right",UDim2.new(0.4,0,0.4,0))
	
	--Run the assertions.
	for _,SubAdornFrame in pairs(Frame:GetChildren()) do
		for _,SubFrame in pairs(SubAdornFrame:GetChildren()[1]:GetChildren()[1]:GetChildren()) do
			UnitTest:AssertEquals(SubFrame.ZIndex,3,"ZIndex is not set.")
		end
	end
end)

--[[
Tests the Destroy function.
--]]
NexusUnitTesting:RegisterUnitTest("Destroy",function(UnitTest)
	local Frame = Instance.new("Frame")
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new(0,100,0,100)
	
	--Create the ColoredCutFrame class.
	local CuT = ColoredCutFrame.new(Frame)
	CuT:Destroy()
	
	--Run the assertions.
	UnitTest:AssertEquals(#Frame:GetChildren(),0,"Frames not destroyed.")
end)



return true