--[[
TheNexusAvenger

Unit tests for the ButtonFactory class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local Factory = NexusButton:WaitForChild("Factory")

local ButtonFactory = require(Factory:WaitForChild("ButtonFactory"))



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	--Create the component under testing.
	local CuT = ButtonFactory.new()
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.ClassName,"ButtonFactory","ClassName is incorrect.")
end)

--[[
Test that the CreateDefault method.
--]]
NexusUnitTesting:RegisterUnitTest("CreateDefault",function(UnitTest)
	--Create the component under testing.
	local CuT = ButtonFactory.CreateDefault(Color3.new(0,170/255,1))
	
	--Create a button and assert the defaults are correct.
	local Button = CuT:Create()
	UnitTest:AssertEquals(Button.BackgroundColor3,Color3.new(0,170/255,1),"Background color is incorrect.")
	UnitTest:AssertEquals(Button.BorderColor3,Color3.new(0,140/255,225/255),"Border color is incorrect.")
	UnitTest:AssertEquals(Button.BorderTransparency,0.25,"Border transparency is incorrect.")
	
	--Destroy the button.
	Button:Destroy()
end)

--[[
Test that the SetDefault and UnsetDefault methods.
--]]
NexusUnitTesting:RegisterUnitTest("SetDefault",function(UnitTest)
	--Create the component under testing.
	local CuT = ButtonFactory.new()
	
	--Set several defaults.
	CuT:SetDefault("Name","TestButton")
	CuT:SetDefault("Size",UDim2.new(1,2,3,4))
	
	--Create a button and assert the defaults are correct.
	local Button1 = CuT:Create()
	UnitTest:AssertEquals(Button1.Name,"TestButton","Name is incorrect.")
	UnitTest:AssertEquals(Button1.Size,UDim2.new(1,2,3,4),"Size is incorrect.")
	
	--Unset a default.
	CuT:UnsetDefault("Name")
	
	--Create a button and assert the defaults are correct.
	local Button2 = CuT:Create()
	UnitTest:AssertNotEquals(Button2.Name,"TestButton","Name is incorrect.")
	UnitTest:AssertEquals(Button2.Size,UDim2.new(1,2,3,4),"Size is incorrect.")
	
	--Destroy the buttons.
	Button1:Destroy()
	Button2:Destroy()
end)



return true