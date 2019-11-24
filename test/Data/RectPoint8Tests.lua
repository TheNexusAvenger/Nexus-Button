--[[
TheNexusAvenger

Unit tests for the RectPoint8 class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local Data = NexusButton:WaitForChild("Data")

local RectSide = require(Data:WaitForChild("RectSide"))
local RectPoint8 = require(Data:WaitForChild("RectPoint8"))



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local Point1 = UDim.new(0.25,0)
	local Point2 = UDim.new(0.75,0)
	
	--Create the RectPoint8 class.
	local Left = RectSide.new(Point1,Point2)
	local Right = RectSide.new(Point1,Point2)
	local Top = RectSide.new(Point1,Point2)
	local Bottom = RectSide.new(Point1,Point2)
	local CuT = RectPoint8.new(Left,Right,Top,Bottom)
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.ClassName,"RectPoint8","ClassName is incorrect.")
	UnitTest:AssertSame(Left,CuT.Left," is incorrect.")
	UnitTest:AssertSame(Right,CuT.Right," is incorrect.")
	UnitTest:AssertSame(Top,CuT.Top," is incorrect.")
	UnitTest:AssertSame(Bottom,CuT.Bottom," is incorrect.")
end)

--[[
Test that the constructor fails with incorrect arguments.
--]]
NexusUnitTesting:RegisterUnitTest("ConstructorInvalidParameters",function(UnitTest)
	local Point1 = UDim.new(0.25,0)
	local Point2 = UDim.new(0.75,0)
	local Side = RectSide.new(Point1,Point2)
	local NotASide = "Fail"
	
	--Assert various errors.
	UnitTest:AssertErrors(function()
		RectPoint8.new()
	end,"Constructor accepted no parameters.")
	UnitTest:AssertErrors(function()
		RectPoint8.new(Side)
	end,"Constructor accepted 1 parameter.")
	UnitTest:AssertErrors(function()
		RectPoint8.new(Side,Side)
	end,"Constructor accepted 2 parameters.")
	UnitTest:AssertErrors(function()
		RectPoint8.new(Side,Side,Side)
	end,"Constructor accepted 3 parameters.")
	UnitTest:AssertErrors(function()
		RectPoint8.new(Side,NotASide,Side,Side)
	end,"Constructor accepted non-point parameter.")
end)



return true