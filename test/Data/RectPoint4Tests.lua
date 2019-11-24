--[[
TheNexusAvenger

Unit tests for the RectPoint4 class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local Data = NexusButton:WaitForChild("Data")

local RectPoint4 = require(Data:WaitForChild("RectPoint4"))



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	--Create the RectPoint4 class.
	local Left = UDim.new(0.1,0)
	local Right = UDim.new(0.2,0)
	local Top = UDim.new(0.3,0)
	local Bottom = UDim.new(0.4,0)
	local CuT = RectPoint4.new(Left,Right,Top,Bottom)
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.ClassName,"RectPoint4","ClassName is incorrect.")
	UnitTest:AssertSame(Left,CuT.Left," is incorrect.")
	UnitTest:AssertSame(Right,CuT.Right," is incorrect.")
	UnitTest:AssertSame(Top,CuT.Top," is incorrect.")
	UnitTest:AssertSame(Bottom,CuT.Bottom," is incorrect.")
end)

--[[
Test that the constructor fails with incorrect arguments.
--]]
NexusUnitTesting:RegisterUnitTest("ConstructorInvalidParameters",function(UnitTest)
	local Point = UDim.new(0.25,0)
	local NotAPoint = "Fail"
	
	--Assert various errors.
	UnitTest:AssertErrors(function()
		RectPoint4.new()
	end,"Constructor accepted no parameters.")
	UnitTest:AssertErrors(function()
		RectPoint4.new(Point)
	end,"Constructor accepted 1 parameter.")
	UnitTest:AssertErrors(function()
		RectPoint4.new(Point,Point)
	end,"Constructor accepted 2 parameters.")
	UnitTest:AssertErrors(function()
		RectPoint4.new(Point,Point,Point)
	end,"Constructor accepted 3 parameters.")
	UnitTest:AssertErrors(function()
		RectPoint4.new(Point,NotAPoint,Point,Point)
	end,"Constructor accepted non-point parameter.")
end)



return true