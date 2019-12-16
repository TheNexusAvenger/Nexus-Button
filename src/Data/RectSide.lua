--[[
TheNexusAvenger

Class representing 2 UDim points for a side
of a rectangle. 4 are used by the RectPoint8
class for the CutFrame.
The first point is the distance from the start
and the second point is the distance from the 
end.

This class is immutable.
--]]

local RootModule = script.Parent.Parent
local NexusInstance = require(RootModule:WaitForChild("NexusInstance"):WaitForChild("NexusInstance"))

local RectSide = NexusInstance:Extend()
RectSide:SetClassName("RectSide")



--[[
Checks if a type matches and throws and error if
it doesn't match.
--]]
local function ValidateParameter(Name,Parameter,Type)
	local ParameterType = typeof(Parameter)
	local HasIsA = false
	
	--Replace the type if it is a table and has a ClassName.
	if ParameterType == "table" and Parameter.IsA then
		HasIsA = true
		ParameterType = Parameter.ClassName
	end
	
	--Throw the error.
	if (ParameterType ~= Type) or (HasIsA and not Parameter:IsA(Type)) then
		error(tostring(Name).." must be a "..tostring(Type)..", got \""..tostring(Parameter).."\" (a "..tostring(ParameterType).." value)")
	end
end



--[[
Constructor of the RectSide class.
--]]
function RectSide:__new(Point1,Point2)
	--Throw an error if the points are invalid.
	ValidateParameter("Point1",Point1,"UDim")
	ValidateParameter("Point2",Point2,"UDim")
		
	--Initialize the super class.
	self:InitializeSuper()
	
	--Store and lock the points.
	self.Point1 = Point1
	self.Point2 = Point2
	self:LockProperty("Point1")
	self:LockProperty("Point2")
end

--[[
Returns a new RectSide with 1 point replaced.
--]]
function RectSide:ReplacePoint(PointName,Point)
	if PointName == "Point1" then
		return RectSide.new(Point,self.Point2)
	else
		return RectSide.new(self.Point1,Point)
	end
end

--[[
Returns the points in order of how they appear.
--]]
function RectSide:GetOrderedPoints(SideLength)
	--Throw an error if the side length is invalid.
	ValidateParameter("SideLength",SideLength,"number")
		
	--Get the points and positions along the line.
	local Point1,Point2 = self.Point1,self.Point2
	local Pos1 = (SideLength * Point1.Scale) + Point1.Offset
	local Pos2 = SideLength - ((SideLength * Point2.Scale) + Point2.Offset)
	
	--Return the ordered points.
	if Pos1 < Pos2 then
		return Point1,Point2
	else
		return Point2,Point1
	end
end



return RectSide