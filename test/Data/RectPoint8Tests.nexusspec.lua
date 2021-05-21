--[[
TheNexusAvenger

Unit tests for the RectPoint8 class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local Data = NexusButton:WaitForChild("Data")

local RectSide = require(Data:WaitForChild("RectSide"))
local RectPoint8 = require(Data:WaitForChild("RectPoint8"))
local RectPoint8Test = NexusUnitTesting.UnitTest:Extend()



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest(RectPoint8Test.new("Constructor"):SetRun(function(self)
    local Point1 = UDim.new(0.25,0)
    local Point2 = UDim.new(0.75,0)
    
    --Create the RectPoint8 class.
    local Left = RectSide.new(Point1,Point2)
    local Right = RectSide.new(Point1,Point2)
    local Top = RectSide.new(Point1,Point2)
    local Bottom = RectSide.new(Point1,Point2)
    local CuT = RectPoint8.new(Left,Right,Top,Bottom)
    
    --Run the assertions.
    self:AssertEquals(CuT.ClassName,"RectPoint8","ClassName is incorrect.")
    self:AssertSame(Left,CuT.Left," is incorrect.")
    self:AssertSame(Right,CuT.Right," is incorrect.")
    self:AssertSame(Top,CuT.Top," is incorrect.")
    self:AssertSame(Bottom,CuT.Bottom," is incorrect.")
end))

--[[
Test that the constructor fails with incorrect arguments.
--]]
NexusUnitTesting:RegisterUnitTest(RectPoint8Test.new("ConstructorInvalidParameters"):SetRun(function(self)
    local Point1 = UDim.new(0.25,0)
    local Point2 = UDim.new(0.75,0)
    local Side = RectSide.new(Point1,Point2)
    local NotASide = "Fail"
    
    --Assert various errors.
    self:AssertErrors(function()
        RectPoint8.new()
    end,"Constructor accepted no parameters.")
    self:AssertErrors(function()
        RectPoint8.new(Side)
    end,"Constructor accepted 1 parameter.")
    self:AssertErrors(function()
        RectPoint8.new(Side,Side)
    end,"Constructor accepted 2 parameters.")
    self:AssertErrors(function()
        RectPoint8.new(Side,Side,Side)
    end,"Constructor accepted 3 parameters.")
    self:AssertErrors(function()
        RectPoint8.new(Side,NotASide,Side,Side)
    end,"Constructor accepted non-point parameter.")
end))



return true