--[[
TheNexusAvenger

Unit tests for the BaseButton class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local Gui = NexusButton:WaitForChild("Gui")

local BaseButton = require(Gui:WaitForChild("BaseButton"))
local BaseButtonTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function BaseButtonTest:Setup()
    self.CuT = BaseButton.new()
end

--[[
Cleans up the test.
--]]
function BaseButtonTest:Teardown()
    self.CuT:Destroy()
end

--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest(BaseButtonTest.new("Constructor"):SetRun(function(self)
    self:AssertEquals(self.CuT.ClassName,"BaseButton","ClassName is incorrect.")
end))

--[[
Tests mapping and unmapping keys.
--]]
NexusUnitTesting:RegisterUnitTest(BaseButtonTest.new("KeyMapping"):SetRun(function(self)
    --Map several inputs and assert the mappings are correct.
    self.CuT:MapKey(Enum.KeyCode.A,Enum.UserInputType.MouseButton1)
    self.CuT:MapKey(Enum.KeyCode.B,"MouseButton1")
    self.CuT:MapKey("C",Enum.UserInputType.MouseButton2)
    self.CuT:MapKey("D","MouseButton2")
    self:AssertEquals(self.CuT:__GetMappedInput(Enum.KeyCode.A),Enum.UserInputType.MouseButton1,"Mapping is incorrect for input being an string and mapping being an string.")
    self:AssertEquals(self.CuT:__GetMappedInput(Enum.KeyCode.B),Enum.UserInputType.MouseButton1,"Mapping is incorrect for input being an string and mapping being a String.")
    self:AssertEquals(self.CuT:__GetMappedInput(Enum.KeyCode.C),Enum.UserInputType.MouseButton2,"Mapping is incorrect for input being a string and mapping being an string.")
    self:AssertEquals(self.CuT:__GetMappedInput(Enum.KeyCode.D),Enum.UserInputType.MouseButton2,"Mapping is incorrect for input being a string and mapping being a String.")
    self:AssertNil(self.CuT:__GetMappedInput(Enum.KeyCode.E),"Mapping is incorrect for input being a string and mapping being a String.")
    
    --Remap and unmap several mappings and assert they are correct.
    self.CuT:UnmapKey(Enum.KeyCode.A)
    self.CuT:UnmapKey("B")
    self.CuT:MapKey(Enum.KeyCode.C,Enum.UserInputType.MouseButton1)
    self.CuT:MapKey("D","MouseButton1")
    self:AssertNil(self.CuT:__GetMappedInput(Enum.KeyCode.A),"Mapping is incorrect for input being an string and mapping being an string.")
    self:AssertNil(self.CuT:__GetMappedInput(Enum.KeyCode.B),"Mapping is incorrect for input being an string and mapping being a String.")
    self:AssertEquals(self.CuT:__GetMappedInput(Enum.KeyCode.C),Enum.UserInputType.MouseButton1,"Mapping is incorrect for input being a string and mapping being an string.")
    self:AssertEquals(self.CuT:__GetMappedInput(Enum.KeyCode.D),Enum.UserInputType.MouseButton1,"Mapping is incorrect for input being a string and mapping being a String.")
    
    --Assert an error is thrown for an incorrect mapping.
    self:AssertErrors(function()
        self.CuT:MapKey(Enum.KeyCode.A,"FakeKey")
    end,"Error not thrown for wrong map.")
end))



return true