--[[
TheNexusAvenger

Unit tests for the RectSide class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local Data = NexusButton:WaitForChild("Data")

local RectSide = require(Data:WaitForChild("RectSide"))



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	local Point1 = UDim.new(0.25,0)
	local Point2 = UDim.new(0.75,0)
	
	--Create the RectSide class.
	local CuT = RectSide.new(Point1,Point2)
	
	--Run the assertions.
	UnitTest:AssertEquals(CuT.ClassName,"RectSide","ClassName is incorrect.")
	UnitTest:AssertEquals(Point1,CuT.Point1,"Point1 is incorrect.")
	UnitTest:AssertEquals(Point2,CuT.Point2,"Point2 is incorrect.")
end)

--[[
Test that the constructor fails with incorrect arguments.
--]]
NexusUnitTesting:RegisterUnitTest("ConstructorInvalidParameters",function(UnitTest)
	local Point1 = UDim.new(0.25,0)
	local Point2 = UDim.new(0.75,0)
	local NotAPoint = "Fail"
	
	--Assert various errors.
	UnitTest:AssertErrors(function()
		RectSide.new()
	end,"Constructor accepted no parameters.")
	UnitTest:AssertErrors(function()
		RectSide.new(Point1)
	end,"Constructor accepted 1 parameter.")
	UnitTest:AssertErrors(function()
		RectSide.new(nil,Point2)
	end,"Constructor accepted 1 parameter.")
	UnitTest:AssertErrors(function()
		RectSide.new(NotAPoint,Point2)
	end,"Constructor accepted non-point parameter.")
end)

--[[
Test that the points are immutable
--]]
NexusUnitTesting:RegisterUnitTest("Immutable",function(UnitTest)
	local Point1 = UDim.new(0.25,0)
	local Point2 = UDim.new(0.75,0)
	
	--Create the RectSide class.
	local CuT = RectSide.new(Point1,Point2)
	
	--Run the assertions.
	UnitTest:AssertErrors(function()
		CuT.Point1 = Point2
	end,"Point1 is mutable.")
	UnitTest:AssertErrors(function()
		CuT.Point2 = Point1
	end,"Point2 is mutable.")
end)

--[[
Tests the ReplacePoint function.
--]]
NexusUnitTesting:RegisterUnitTest("ReplacePoint",function(UnitTest)
	local Point1 = UDim.new(0.25,0)
	local Point2 = UDim.new(0.75,0)
	local Point3 = UDim.new(0.5,0)
	
	--Create the RectSide class.
	local CuT1 = RectSide.new(Point1,Point2)
	local CuT2 = CuT1:ReplacePoint("Point1",Point3)
	local CuT3 = CuT1:ReplacePoint("Point2",Point3)
	
	--Run the assertions.
	UnitTest:AssertEquals(Point1,CuT1.Point1,"Point1 is mutated.")
	UnitTest:AssertEquals(Point2,CuT1.Point2,"Point2 is mutated.")
	UnitTest:AssertEquals(Point3,CuT2.Point1,"Point1 is incorrect.")
	UnitTest:AssertEquals(Point2,CuT2.Point2,"Point2 is mutated.")
	UnitTest:AssertEquals(Point1,CuT3.Point1,"Point1 is mutated.")
	UnitTest:AssertEquals(Point3,CuT3.Point2,"Point2 is incorrect.")
end)

--[[
Tests the GetOrderedPoints function.
--]]
NexusUnitTesting:RegisterUnitTest("GetOrderedPoints",function(UnitTest)
	local Point1 = UDim.new(0,50)
	local Point2 = UDim.new(0.25,0)
	
	--Create the RectSide class.
	local CuT = RectSide.new(Point1,Point2)
	
	--[[
	Asserts that the order is correct for a specific length.
	--]]
	local function AssertOrder(Length,FirstPoint)
		local SecondPoint = (FirstPoint == Point1 and Point2) or Point1
		
		local ActualFirstPoint,ActualSecondPoint = CuT:GetOrderedPoints(Length)
		UnitTest:AssertEquals(FirstPoint,ActualFirstPoint,"First point is incorrect.")
		UnitTest:AssertEquals(SecondPoint,ActualSecondPoint,"Second point is incorrect.")
	end
	
	--Run the assertions.
	AssertOrder(-50,Point2)
	AssertOrder(0,Point2)
	AssertOrder(25,Point2)
	AssertOrder(100,Point1)
end)

--[[
Tests the GetOrderedPoints function with invalid parameters.
--]]
NexusUnitTesting:RegisterUnitTest("GetOrderedPointsInvalidParameters",function(UnitTest)
	local Point1 = UDim.new(0,50)
	local Point2 = UDim.new(0.75,0)
	
	--Create the RectSide class.
	local CuT = RectSide.new(Point1,Point2)
	
	--Assert various errors.
	UnitTest:AssertErrors(function()
		CuT:GetOrderedPointsInvalidParameters()
	end,"Accepted no parameters.")
	UnitTest:AssertErrors(function()
		CuT:GetOrderedPointsInvalidParameters("Fail")
	end,"Accepted non-number parameter.")
end)



return true