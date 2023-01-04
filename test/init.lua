--[[
TheNexusAvenger

Unit tests for the NeuxsButton class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")
_G.EnsureNexusWrappedInstanceSingleton = false

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
    self:AssertEquals(self.CuT.ClassName, "NexusButton", "ClassName is incorrect.")
end))

--[[
Tests the BorderSize properties.
--]]
NexusUnitTesting:RegisterUnitTest(NexusButtonTest.new("BorderSize"):SetRun(function(self)
    self.CuT.BorderSizePixel = 0
    self.CuT.BorderSizeScale = 0

    --Set the BorderSizePixel and asset the size is correct.
    self.CuT.BorderSizePixel = 10
    self:AssertEquals(self.CuT.BorderSize, UDim.new(0, 10), "Border size is incorrect.")

    --Set the BorderSizeScale and asset the size is correct.
    self.CuT.BorderSizeScale = 0.4
    self:AssertEquals(self.CuT.BorderSize, UDim.new(0.4, 0), "Border size is incorrect.")
end))

--[[
Tests the transparency properties.
--]]
NexusUnitTesting:RegisterUnitTest(NexusButtonTest.new("Transparency"):SetRun(function(self)
    --Set the transparencies and assert they are correct.
    self.CuT.BackgroundTransparency = 0.25
    self.CuT.BorderTransparency = 0.75
    self:AssertEquals(self.CuT.BackgroundFrame.ImageTransparency, 0.25, "Background transparency is incorrect.")
    self:AssertEquals(self.CuT.BorderFrame.ImageTransparency, 0.75, "Border transparency is incorrect.")
end))

--[[
Tests mapping and unmapping keys.
--]]
NexusUnitTesting:RegisterUnitTest(NexusButtonTest.new("KeyMapping"):SetRun(function(self)
    --Map several inputs and assert the mappings are correct.
    self.CuT:MapKey(Enum.KeyCode.A, Enum.UserInputType.MouseButton1)
    self.CuT:MapKey(Enum.KeyCode.B, "MouseButton1")
    self.CuT:MapKey("C", Enum.UserInputType.MouseButton2)
    self.CuT:MapKey("D", "MouseButton2")
    self:AssertEquals(self.CuT.MappedInputs[Enum.KeyCode.A], Enum.UserInputType.MouseButton1, "Mapping is incorrect for input being an string and mapping being an string.")
    self:AssertEquals(self.CuT.MappedInputs[Enum.KeyCode.B], Enum.UserInputType.MouseButton1, "Mapping is incorrect for input being an string and mapping being a String.")
    self:AssertEquals(self.CuT.MappedInputs[Enum.KeyCode.C], Enum.UserInputType.MouseButton2, "Mapping is incorrect for input being a string and mapping being an string.")
    self:AssertEquals(self.CuT.MappedInputs[Enum.KeyCode.D], Enum.UserInputType.MouseButton2, "Mapping is incorrect for input being a string and mapping being a String.")
    self:AssertNil(self.CuT.MappedInputs[Enum.KeyCode.E], "Mapping is incorrect for input being a string and mapping being a String.")

    --Remap and unmap several mappings and assert they are correct.
    self.CuT:UnmapKey(Enum.KeyCode.A)
    self.CuT:UnmapKey("B")
    self.CuT:MapKey(Enum.KeyCode.C, Enum.UserInputType.MouseButton1)
    self.CuT:MapKey("D", "MouseButton1")
    self:AssertNil(self.CuT.MappedInputs[Enum.KeyCode.A], "Mapping is incorrect for input being an string and mapping being an string.")
    self:AssertNil(self.CuT.MappedInputs[Enum.KeyCode.B], "Mapping is incorrect for input being an string and mapping being a String.")
    self:AssertEquals(self.CuT.MappedInputs[Enum.KeyCode.C], Enum.UserInputType.MouseButton1, "Mapping is incorrect for input being a string and mapping being an string.")
    self:AssertEquals(self.CuT.MappedInputs[Enum.KeyCode.D], Enum.UserInputType.MouseButton1, "Mapping is incorrect for input being a string and mapping being a String.")

    --Assert an error is thrown for an incorrect mapping.
    self:AssertErrors(function()
        self.CuT:MapKey(Enum.KeyCode.A, "FakeKey")
    end,"Error not thrown for wrong map.")
end))



return true