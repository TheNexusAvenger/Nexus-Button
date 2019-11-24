--[[
TheNexusAvenger

Unit tests for the BaseButton class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local Gui = NexusButton:WaitForChild("Gui")

local BaseButton = require(Gui:WaitForChild("BaseButton"))



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	--Create the component under testing.
	local CuT = BaseButton.new()
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.ClassName,"BaseButton","ClassName is incorrect.")
	
	--Clean up the component under testing.
	CuT:Destroy()
end)

--[[
Tests mapping and unmapping keys.
--]]
NexusUnitTesting:RegisterUnitTest("KeyMapping",function(UnitTest)
	--Create the component under testing.
	local CuT = BaseButton.new()
	
	--Map several inputs and assert the mappings are correct.
	CuT:MapKey(Enum.KeyCode.A,Enum.UserInputType.MouseButton1)
	CuT:MapKey(Enum.KeyCode.B,"MouseButton1")
	CuT:MapKey("C",Enum.UserInputType.MouseButton2)
	CuT:MapKey("D","MouseButton2")
	UnitTest:AssertEquals(CuT:__GetMappedInput(Enum.KeyCode.A),Enum.UserInputType.MouseButton1,"Mapping is incorrect for input being an string and mapping being an string.")
	UnitTest:AssertEquals(CuT:__GetMappedInput(Enum.KeyCode.B),Enum.UserInputType.MouseButton1,"Mapping is incorrect for input being an string and mapping being a String.")
	UnitTest:AssertEquals(CuT:__GetMappedInput(Enum.KeyCode.C),Enum.UserInputType.MouseButton2,"Mapping is incorrect for input being a string and mapping being an string.")
	UnitTest:AssertEquals(CuT:__GetMappedInput(Enum.KeyCode.D),Enum.UserInputType.MouseButton2,"Mapping is incorrect for input being a string and mapping being a String.")
	UnitTest:AssertNil(CuT:__GetMappedInput(Enum.KeyCode.E),"Mapping is incorrect for input being a string and mapping being a String.")
	
	--Remap and unmap several mappings and assert they are correct.
	CuT:UnmapKey(Enum.KeyCode.A)
	CuT:UnmapKey("B")
	CuT:MapKey(Enum.KeyCode.C,Enum.UserInputType.MouseButton1)
	CuT:MapKey("D","MouseButton1")
	UnitTest:AssertNil(CuT:__GetMappedInput(Enum.KeyCode.A),"Mapping is incorrect for input being an string and mapping being an string.")
	UnitTest:AssertNil(CuT:__GetMappedInput(Enum.KeyCode.B),"Mapping is incorrect for input being an string and mapping being a String.")
	UnitTest:AssertEquals(CuT:__GetMappedInput(Enum.KeyCode.C),Enum.UserInputType.MouseButton1,"Mapping is incorrect for input being a string and mapping being an string.")
	UnitTest:AssertEquals(CuT:__GetMappedInput(Enum.KeyCode.D),Enum.UserInputType.MouseButton1,"Mapping is incorrect for input being a string and mapping being a String.")
	
	--Assert an error is thrown for an incorrect mapping.
	UnitTest:AssertErrors(function()
		CuT:MapKey(Enum.KeyCode.A,"FakeKey")
	end,"Error not thrown for wrong map.")
	
	--Clean up the component under testing.
	CuT:Destroy()
end)



return true