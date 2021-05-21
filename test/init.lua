--[[
TheNexusAvenger

Unit tests for the NeuxsButton class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusButton"))
local NexusButtonTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function NexusButtonTest:Setup()
    self.CuT = NexusButton.new()
end

--[[
Cleans up the test.
--]]
function NexusButtonTest:Teardown()
    self.CuT:Destroy()
end

--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest(NexusButtonTest.new("Constructor"):SetRun(function(self)
    --Run the assertions.
    self:AssertEquals(self.CuT.ClassName,"NexusButton","ClassName is incorrect.")
end))

--[[
Tests replication of properties.
--]]
NexusUnitTesting:RegisterUnitTest(NexusButtonTest.new("Replication"):SetRun(function(self)
    local AdornFrame = self.CuT.AdornFrame
    
    --Assert properties that aren't set can be read from.
    self:AssertEquals(self.CuT.Name,AdornFrame.Name,"Name isn't passed through correctly.")
    self:AssertEquals(self.CuT.Size,AdornFrame.Size,"Size isn't passed through correctly.")
    self:AssertEquals(self.CuT.Parent,AdornFrame.Parent,"Parent isn't passed through correctly.")
    
    --Set values and assert they are replicated from the CuT to the frame.
    local TestFrame = Instance.new("Frame")
    self.CuT.Name = "Test1"
    self.CuT.Size = UDim2.new(1,2,3,4)
    self.CuT.Parent = TestFrame
    self:AssertEquals(self.CuT.Name,"Test1","Name wasn't set correctly.")
    self:AssertEquals(self.CuT.Size,UDim2.new(1,2,3,4),"Size wasn't set correctly.")
    self:AssertEquals(self.CuT.Parent,TestFrame,"Parent wasn't set correctly.")
    self:AssertEquals(AdornFrame.Name,"Test1","Name wasn't replicated correctly.")
    self:AssertEquals(AdornFrame.Size,UDim2.new(1,2,3,4),"Size wasn't replicated correctly.")
    self:AssertEquals(AdornFrame.Parent,TestFrame,"Parent wasn't replicated correctly.")
    
    --Set values and assert they are replicated from the frame to the CuT.
    AdornFrame.Name = "Test2"
    AdornFrame.Size = UDim2.new(5,6,7,8)
    AdornFrame.Parent = nil
    wait()
    self:AssertEquals(self.CuT.Name,"Test2","Name wasn't replicated correctly.")
    self:AssertEquals(self.CuT.Size,UDim2.new(5,6,7,8),"Size wasn't replicated correctly.")
    self:AssertEquals(self.CuT.Parent,nil,"Parent wasn't replicated correctly.")
    self:AssertEquals(AdornFrame.Name,"Test2","Name wasn't set correctly.")
    self:AssertEquals(AdornFrame.Size,UDim2.new(5,6,7,8),"Size wasn't set correctly.")
    self:AssertEquals(AdornFrame.Parent,nil,"Parent wasn't set correctly.")
end))

--[[
Tests the BorderSize properties.
--]]
NexusUnitTesting:RegisterUnitTest(NexusButtonTest.new("BorderSize"):SetRun(function(self)
    local BorderAdorn = self.CuT.BorderAdorn
    self.CuT.BorderSizePixel = 0
    self.CuT.BorderSizeScale = 0
    
    --Set the BorderSizePixel and asset the size is correct.
    self.CuT.BorderSizePixel = 10
    self:AssertEquals(BorderAdorn.Size,UDim2.new(1,0,1,10),"Border size is incorrect.")
    
    --Set the BorderSizeScale and asset the size is correct.
    self.CuT.BorderSizeScale = 0.4
    self:AssertEquals(BorderAdorn.Size,UDim2.new(1,0,1.4,10),"Border size is incorrect.")
end))

--[[
Tests the color properties.
--]]
NexusUnitTesting:RegisterUnitTest(NexusButtonTest.new("Colors"):SetRun(function(self)
    local BackgroundCutFrame = self.CuT.BackgroundCutFrame
    local BorderCutFrame = self.CuT.BorderCutFrame
    
    --Create the colors.
    local BaseBackgroundColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0.5,0.5,0.5)),ColorSequenceKeypoint.new(1,Color3.new(0.5,0.5,0.5))})
    local HoverBackgroundColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0.5 * 0.7,0.5 * 0.7,0.5 * 0.7)),ColorSequenceKeypoint.new(1,Color3.new(0.5 * 0.7,0.5 * 0.7,0.5 * 0.7))})
    local ClickBackgroundColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0.5 * 1/0.7,0.5 * 1/0.7,0.5 * 1/0.7)),ColorSequenceKeypoint.new(1,Color3.new(0.5 * 1/0.7,0.5 * 1/0.7,0.5 * 1/0.7))})
    local BaseBorderColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.5,0.5,0.5)),ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
    
    --Set the colors and assert they are correct.
    self.CuT.BackgroundColor3 = BaseBackgroundColor
    self.CuT.BorderColor3 = BaseBorderColor
    self:AssertEquals(BackgroundCutFrame.BackgroundColor3,BaseBackgroundColor,"Background color is incorrect.")
    self:AssertEquals(BorderCutFrame.BackgroundColor3,BaseBorderColor,"Border color is incorrect.")
    
    --Assert that the states change the colors correctly.
    self.CuT.__Hovered = true
    self.CuT:__UpdateColors()
    self:AssertEquals(BackgroundCutFrame.BackgroundColor3,HoverBackgroundColor,"Background color is incorrect.")
    self:AssertEquals(BorderCutFrame.BackgroundColor3,BaseBorderColor,"Border color is incorrect.")
    self.CuT.__Clicked = true
    self.CuT:__UpdateColors()
    self:AssertEquals(BackgroundCutFrame.BackgroundColor3,ClickBackgroundColor,"Background color is incorrect.")
    self:AssertEquals(BorderCutFrame.BackgroundColor3,BaseBorderColor,"Border color is incorrect.")
    self.CuT.AutoButtonColor = false
    self:AssertEquals(BackgroundCutFrame.BackgroundColor3,BaseBackgroundColor,"Background color is incorrect.")
    self:AssertEquals(BorderCutFrame.BackgroundColor3,BaseBorderColor,"Border color is incorrect.")
    self.CuT.AutoButtonColor = true
    self:AssertEquals(BackgroundCutFrame.BackgroundColor3,ClickBackgroundColor,"Background color is incorrect.")
    self:AssertEquals(BorderCutFrame.BackgroundColor3,BaseBorderColor,"Border color is incorrect.")
    self.CuT.__Hovered = false
    self.CuT:__UpdateColors()
    self:AssertEquals(BackgroundCutFrame.BackgroundColor3,ClickBackgroundColor,"Background color is incorrect.")
    self:AssertEquals(BorderCutFrame.BackgroundColor3,BaseBorderColor,"Border color is incorrect.")
    self.CuT.__Clicked = false
    self.CuT:__UpdateColors()
    self:AssertEquals(BackgroundCutFrame.BackgroundColor3,BaseBackgroundColor,"Background color is incorrect.")
    self:AssertEquals(BorderCutFrame.BackgroundColor3,BaseBorderColor,"Border color is incorrect.")
end))

--[[
Tests the transparency properties.
--]]
NexusUnitTesting:RegisterUnitTest(NexusButtonTest.new("Transparency"):SetRun(function(self)
    local BackgroundCutFrame = self.CuT.BackgroundCutFrame
    local BorderCutFrame = self.CuT.BorderCutFrame
    
    --Set the transparencies and assert they are correct.
    self.CuT.BackgroundTransparency = 0.25
    self.CuT.BorderTransparency = 0.75
    self:AssertEquals(BackgroundCutFrame.BackgroundTransparency,0.25,"Background transparency is incorrect.")
    self:AssertEquals(BorderCutFrame.BackgroundTransparency,0.75,"Border transparency is incorrect.")
end))

--[[
Tests the controller colors.
--]]
NexusUnitTesting:RegisterUnitTest(NexusButtonTest.new("ControllerColors"):SetRun(function(self)
    local BackgroundCutFrame = self.CuT.BackgroundCutFrame
    local GamepadIcon = self.CuT.GamepadIcon
    GamepadIcon.IconVisible = true
    self.CuT.Size = UDim2.new(0,200,0,50)
    
    --Create the colors.
    local SingleColor = Color3.new(0.5,0.5,0.5)
    local SingleControllerColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.5,0.5,0.5)),ColorSequenceKeypoint.new(0.75,Color3.new(50/255,50/255,50/255)),ColorSequenceKeypoint.new(1,Color3.new(50/255,50/255,50/255))})
    local MixedColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0.5,0.5,0.5)),ColorSequenceKeypoint.new(1,Color3.new(0.5,0.5,0.5))})
    local MixedControllerColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0.5,0.5,0.5)),ColorSequenceKeypoint.new(0.75,Color3.new(50/255,50/255,50/255)),ColorSequenceKeypoint.new(1,Color3.new(50/255,50/255,50/255))})
    
    --Set the color and assert it is correct.
    self.CuT.BackgroundColor3 = MixedColor
    self:AssertEquals(BackgroundCutFrame.BackgroundColor3,MixedControllerColor,"Background color is incorrect.")
    self.CuT.BackgroundColor3 = SingleColor
    self:AssertEquals(BackgroundCutFrame.BackgroundColor3,SingleControllerColor,"Background color is incorrect.")
    
    --Hide the controller icon and assert the color was reverted.
    GamepadIcon.IconVisible = false
    wait()
    self:AssertEquals(BackgroundCutFrame.BackgroundColor3,SingleColor,"Background color is incorrect.")
end))

--[[
Tests disabling cuts.
--]]
NexusUnitTesting:RegisterUnitTest(NexusButtonTest.new("DisableCuts"):SetRun(function(self)
    local BackgroundCutFrame = self.CuT.BackgroundCutFrame
    local BorderCutFrame = self.CuT.BorderCutFrame
    
    --Assert that the cuts exist.
    self:AssertNotNil(BackgroundCutFrame.__PersistentCuts["Top_Left"],"Cut doesn't exist.")
    self:AssertNotNil(BackgroundCutFrame.__PersistentCuts["Bottom_Right"],"Cut doesn't exist.")
    self:AssertNotNil(BorderCutFrame.__PersistentCuts["Top_Left"],"Cut doesn't exist.")
    self:AssertNotNil(BorderCutFrame.__PersistentCuts["Bottom_Right"],"Cut doesn't exist.")

    --Disable the top left cut and assert it is correct.
    self.CuT.TopLeftCutEnabled = false
    self:AssertNil(BackgroundCutFrame.__PersistentCuts["Top_Left"],"Cut exists.")
    self:AssertNotNil(BackgroundCutFrame.__PersistentCuts["Bottom_Right"],"Cut doesn't exist.")
    self:AssertNil(BorderCutFrame.__PersistentCuts["Top_Left"],"Cut exists.")
    self:AssertNotNil(BorderCutFrame.__PersistentCuts["Bottom_Right"],"Cut doesn't exist.")

    --Disable the bottom right cut and assert it is correct.
    self.CuT.BottomRightCutEnabled = false
    self:AssertNil(BackgroundCutFrame.__PersistentCuts["Top_Left"],"Cut exists.")
    self:AssertNil(BackgroundCutFrame.__PersistentCuts["Bottom_Right"],"Cut exists.")
    self:AssertNil(BorderCutFrame.__PersistentCuts["Top_Left"],"Cut exists.")
    self:AssertNil(BorderCutFrame.__PersistentCuts["Bottom_Right"],"Cut exists.")

    --Enable the top left cut and assert it is correct.
    self.CuT.TopLeftCutEnabled = true
    self:AssertNotNil(BackgroundCutFrame.__PersistentCuts["Top_Left"],"Cut doesn't exist.")
    self:AssertNil(BackgroundCutFrame.__PersistentCuts["Bottom_Right"],"Cut exists.")
    self:AssertNotNil(BorderCutFrame.__PersistentCuts["Top_Left"],"Cut doesn't exist.")
    self:AssertNil(BorderCutFrame.__PersistentCuts["Bottom_Right"],"Cut exists.")

    --Enable the bottom right cut and assert it is correct.
    self.CuT.BottomRightCutEnabled = true
    self:AssertNotNil(BackgroundCutFrame.__PersistentCuts["Top_Left"],"Cut doesn't exist.")
    self:AssertNotNil(BackgroundCutFrame.__PersistentCuts["Bottom_Right"],"Cut doesn't exist.")
    self:AssertNotNil(BorderCutFrame.__PersistentCuts["Top_Left"],"Cut doesn't exist.")
    self:AssertNotNil(BorderCutFrame.__PersistentCuts["Bottom_Right"],"Cut doesn't exist.")
end))



return true