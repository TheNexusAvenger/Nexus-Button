--[[
TheNexusAvenger

Unit tests for the NeuxsButton class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local Data = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton"):WaitForChild("Data")
local Gui = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton"):WaitForChild("Gui")

local NexusButton = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusButton"))
local RectPoint4 = require(Data:WaitForChild("RectPoint4"))



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	--Create the NexusButton object.
	local CuT = NexusButton.new()
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.ClassName,"NexusButton","ClassName is incorrect.")
	
	--Clean up the component under testing.
	CuT:Destroy()
end)

--[[
Tests replication of properties.
--]]
NexusUnitTesting:RegisterUnitTest("Replication",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusButton.new()
	local AdornFrame = CuT.AdornFrame
	
	--Assert properties that aren't set can be read from.
	UnitTest:AssertEquals(CuT.Name,AdornFrame.Name,"Name isn't passed through correctly.")
	UnitTest:AssertEquals(CuT.Size,AdornFrame.Size,"Size isn't passed through correctly.")
	UnitTest:AssertEquals(CuT.Parent,AdornFrame.Parent,"Parent isn't passed through correctly.")
	
	--Set values and assert they are replicated from the CuT to the frame.
	local TestFrame = Instance.new("Frame")
	CuT.Name = "Test1"
	CuT.Size = UDim2.new(1,2,3,4)
	CuT.Parent = TestFrame
	UnitTest:AssertEquals(CuT.Name,"Test1","Name wasn't set correctly.")
	UnitTest:AssertEquals(CuT.Size,UDim2.new(1,2,3,4),"Size wasn't set correctly.")
	UnitTest:AssertEquals(CuT.Parent,TestFrame,"Parent wasn't set correctly.")
	UnitTest:AssertEquals(AdornFrame.Name,"Test1","Name wasn't replicated correctly.")
	UnitTest:AssertEquals(AdornFrame.Size,UDim2.new(1,2,3,4),"Size wasn't replicated correctly.")
	UnitTest:AssertEquals(AdornFrame.Parent,TestFrame,"Parent wasn't replicated correctly.")
	
	--Set values and assert they are replicated from the frame to the CuT.
	AdornFrame.Name = "Test2"
	AdornFrame.Size = UDim2.new(5,6,7,8)
	AdornFrame.Parent = nil
	UnitTest:AssertEquals(CuT.Name,"Test2","Name wasn't replicated correctly.")
	UnitTest:AssertEquals(CuT.Size,UDim2.new(5,6,7,8),"Size wasn't replicated correctly.")
	UnitTest:AssertEquals(CuT.Parent,nil,"Parent wasn't replicated correctly.")
	UnitTest:AssertEquals(AdornFrame.Name,"Test2","Name wasn't set correctly.")
	UnitTest:AssertEquals(AdornFrame.Size,UDim2.new(5,6,7,8),"Size wasn't set correctly.")
	UnitTest:AssertEquals(AdornFrame.Parent,nil,"Parent wasn't set correctly.")
	
	--Clean up the component under testing.
	CuT:Destroy()
end)

--[[
Tests the BorderSize properties.
--]]
NexusUnitTesting:RegisterUnitTest("BorderSize",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusButton.new()
	local BorderAdorn = CuT.BorderAdorn
	CuT.BorderSizePixel = 0
	CuT.BorderSizeScale = 0
	
	--Set the BorderSizePixel and asset the size is correct.
	CuT.BorderSizePixel = 10
	UnitTest:AssertEquals(BorderAdorn.Size,UDim2.new(1,0,1,10),"Border size is incorrect.")
	
	--Set the BorderSizeScale and asset the size is correct.
	CuT.BorderSizeScale = 0.4
	UnitTest:AssertEquals(BorderAdorn.Size,UDim2.new(1,0,1.4,10),"Border size is incorrect.")
	
	--Clean up the component under testing.
	CuT:Destroy()
end)

--[[
Tests the color properties.
--]]
NexusUnitTesting:RegisterUnitTest("Colors",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusButton.new()
	local BackgroundCutFrame = CuT.BackgroundCutFrame
	local BorderCutFrame = CuT.BorderCutFrame
	
	--Create the colors.
	local BaseBackgroundColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0.5,0.5,0.5)),ColorSequenceKeypoint.new(1,Color3.new(0.5,0.5,0.5))})
	local HoverBackgroundColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0.5 * 0.7,0.5 * 0.7,0.5 * 0.7)),ColorSequenceKeypoint.new(1,Color3.new(0.5 * 0.7,0.5 * 0.7,0.5 * 0.7))})
	local ClickBackgroundColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0.5 * 1/0.7,0.5 * 1/0.7,0.5 * 1/0.7)),ColorSequenceKeypoint.new(1,Color3.new(0.5 * 1/0.7,0.5 * 1/0.7,0.5 * 1/0.7))})
	local BaseBorderColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.5,0.5,0.5)),ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
	
	--Set the colors and assert they are correct.
	CuT.BackgroundColor3 = BaseBackgroundColor
	CuT.BorderColor3 = BaseBorderColor
	UnitTest:AssertEquals(BackgroundCutFrame.BackgroundColor3,BaseBackgroundColor,"Background color is incorrect.")
	UnitTest:AssertEquals(BorderCutFrame.BackgroundColor3,BaseBorderColor,"Border color is incorrect.")
	
	--Assert that the states change the colors correctly.
	CuT.__Hovered = true
	CuT:__UpdateColors()
	UnitTest:AssertEquals(BackgroundCutFrame.BackgroundColor3,HoverBackgroundColor,"Background color is incorrect.")
	UnitTest:AssertEquals(BorderCutFrame.BackgroundColor3,BaseBorderColor,"Border color is incorrect.")
	CuT.__Clicked = true
	CuT:__UpdateColors()
	UnitTest:AssertEquals(BackgroundCutFrame.BackgroundColor3,ClickBackgroundColor,"Background color is incorrect.")
	UnitTest:AssertEquals(BorderCutFrame.BackgroundColor3,BaseBorderColor,"Border color is incorrect.")
	CuT.__Hovered = false
	CuT:__UpdateColors()
	UnitTest:AssertEquals(BackgroundCutFrame.BackgroundColor3,ClickBackgroundColor,"Background color is incorrect.")
	UnitTest:AssertEquals(BorderCutFrame.BackgroundColor3,BaseBorderColor,"Border color is incorrect.")
	CuT.__Clicked = false
	CuT:__UpdateColors()
	UnitTest:AssertEquals(BackgroundCutFrame.BackgroundColor3,BaseBackgroundColor,"Background color is incorrect.")
	UnitTest:AssertEquals(BorderCutFrame.BackgroundColor3,BaseBorderColor,"Border color is incorrect.")
	
	--Clean up the component under testing.
	CuT:Destroy()
end)

--[[
Tests the transparency properties.
--]]
NexusUnitTesting:RegisterUnitTest("Transparency",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusButton.new()
	local BackgroundCutFrame = CuT.BackgroundCutFrame
	local BorderCutFrame = CuT.BorderCutFrame
	
	--Set the transparencies and assert they are correct.
	CuT.BackgroundTransparency = 0.25
	CuT.BorderTransparency = 0.75
	UnitTest:AssertEquals(BackgroundCutFrame.BackgroundTransparency,0.25,"Background transparency is incorrect.")
	UnitTest:AssertEquals(BorderCutFrame.BackgroundTransparency,0.75,"Border transparency is incorrect.")
	
	--Clean up the component under testing.
	CuT:Destroy()
end)

--[[
Tests the controller colors.
--]]
NexusUnitTesting:RegisterUnitTest("ControllerColors",function(UnitTest)
	--Create the component under testing.
	local CuT = NexusButton.new()
	local BackgroundCutFrame = CuT.BackgroundCutFrame
	local GamepadIcon = CuT.GamepadIcon
	GamepadIcon.IconVisible = true
	CuT.Size = UDim2.new(0,200,0,50)
	
	--Create the colors.
	local SingleColor = Color3.new(0.5,0.5,0.5)
	local SingleControllerColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.5,0.5,0.5)),ColorSequenceKeypoint.new(0.75,Color3.new(50/255,50/255,50/255)),ColorSequenceKeypoint.new(1,Color3.new(50/255,50/255,50/255))})
	local MixedColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0.5,0.5,0.5)),ColorSequenceKeypoint.new(1,Color3.new(0.5,0.5,0.5))})
	local MixedControllerColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0.5,0.5,0.5)),ColorSequenceKeypoint.new(0.75,Color3.new(50/255,50/255,50/255)),ColorSequenceKeypoint.new(1,Color3.new(50/255,50/255,50/255))})
	
	--Set the color and assert it is correct.
	CuT.BackgroundColor3 = MixedColor
	UnitTest:AssertEquals(BackgroundCutFrame.BackgroundColor3,MixedControllerColor,"Background color is incorrect.")
	CuT.BackgroundColor3 = SingleColor
	UnitTest:AssertEquals(BackgroundCutFrame.BackgroundColor3,SingleControllerColor,"Background color is incorrect.")
	
	--Hide the controller icon and assert the color was reverted.
	GamepadIcon.IconVisible = false
	UnitTest:AssertEquals(BackgroundCutFrame.BackgroundColor3,SingleColor,"Background color is incorrect.")
	
	--Clean up the component under testing.
	CuT:Destroy()
end)



return true