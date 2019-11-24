--[[
TheNexusAvenger

Unit tests for the ControllerIcon class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local Gui = NexusButton:WaitForChild("Gui")

local ControllerIcon = require(Gui:WaitForChild("ControllerIcon"))



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	--Create the component under testing.
	local CuT = ControllerIcon.new()
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.ClassName,"ControllerIcon","ClassName is incorrect.")
	
	--Clean up the component under testing.
	CuT:Destroy()
end)

--[[
Tests the SetIcon method.
--]]
NexusUnitTesting:RegisterUnitTest("SetIcon",function(UnitTest)
	--Create the component under testing.
	local CuT = ControllerIcon.new()
	UnitTest:AssertNil(CuT.Icon,"Icon already exists.")
	
	--Set the icon to an enum and assert the size is correct.
	CuT:SetIcon(Enum.KeyCode.ButtonA)
	UnitTest:AssertEquals(CuT.Icon.Size,UDim2.new(0.9,0,0.9,0),"Size is incorrect.")
	
	--Set the icon to a string and assert the size is correct.
	CuT:SetIcon(Enum.KeyCode.ButtonL1)
	UnitTest:AssertEquals(CuT.Icon.Size,UDim2.new(0.9,0,0.45,0),"Size is incorrect.")
	
	--Set the icon to nil and assert the size is correct.
	CuT:SetIcon(nil)
	UnitTest:AssertNil(CuT.Icon,"Icon exists.")
	
	--Clean up the component under testing.
	CuT:Destroy()
end)

--[[
Tests the SetScale method.
--]]
NexusUnitTesting:RegisterUnitTest("SetScale",function(UnitTest)
	--Create the component under testing.
	local CuT = ControllerIcon.new()
	CuT:SetIcon(Enum.KeyCode.ButtonA)
	
	--Set the scale and assert the size is correct.
	CuT:SetScale(0.6)
	UnitTest:AssertEquals(CuT.Icon.Size,UDim2.new(0.6,0,0.6,0),"Size is incorrect.")
	
	--Set the icon to a string and assert the size is correct.
	CuT:SetIcon(Enum.KeyCode.ButtonL1)
	UnitTest:AssertEquals(CuT.Icon.Size,UDim2.new(0.6,0,0.3,0),"Size is incorrect.")
	
	--Clean up the component under testing.
	CuT:Destroy()
end)



return true