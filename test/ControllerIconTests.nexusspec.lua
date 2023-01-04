--[[
TheNexusAvenger

Unit tests for the ControllerIcon class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")
_G.EnsureNexusWrappedInstanceSingleton = false

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local ControllerIcon = require(NexusButton:WaitForChild("ControllerIcon"))
local ControllerIconTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function ControllerIconTest:Setup()
    self.CuT = ControllerIcon.new()
end

--[[
Cleans up the test.
--]]
function ControllerIconTest:Teardown()
    self.CuT:Destroy()
end

--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest(ControllerIconTest.new("Constructor"):SetRun(function(self)
    --Run the assertions.
    self:AssertEquals(self.CuT.ClassName, "ControllerIcon", "ClassName is incorrect.")

    --Clean up the component under testing.
    self.CuT:Destroy()
end))

--[[
Tests the SetIcon method.
--]]
NexusUnitTesting:RegisterUnitTest(ControllerIconTest.new("SetIcon"):SetRun(function(self)
    self:AssertNil(self.CuT.Icon,"Icon already exists.")

    --Set the icon to an enum and assert the size is correct.
    self.CuT:SetIcon(Enum.KeyCode.ButtonA)
    self:AssertEquals(self.CuT.Icon.Size,UDim2.new(0.9, 0, 0.9, 0), "Size is incorrect.")

    --Set the icon to a string and assert the size is correct.
    self.CuT:SetIcon(Enum.KeyCode.ButtonL1)
    self:AssertEquals(self.CuT.Icon.Size,UDim2.new(0.9, 0, 0.45, 0), "Size is incorrect.")

    --Set the icon to nil and assert the size is correct.
    self.CuT:SetIcon(nil)
    self:AssertNil(self.CuT.Icon, "Icon exists.")
end))

--[[
Tests the SetScale method.
--]]
NexusUnitTesting:RegisterUnitTest(ControllerIconTest.new("SetScale"):SetRun(function(self)
    self.CuT:SetIcon(Enum.KeyCode.ButtonA)

    --Set the scale and assert the size is correct.
    self.CuT:SetScale(0.6)
    self:AssertEquals(self.CuT.Icon.Size, UDim2.new(0.6, 0, 0.6, 0), "Size is incorrect.")

    --Set the icon to a string and assert the size is correct.
    self.CuT:SetIcon(Enum.KeyCode.ButtonL1)
    self:AssertEquals(self.CuT.Icon.Size, UDim2.new(0.6, 0, 0.3, 0), "Size is incorrect.")
end))



return true