--[[
TheNexusAvenger

Class representing 8 points of a rectangle
(4 sides).

This class is mutable.
--]]

local RootModule = script.Parent.Parent
local NexusInstance = require(RootModule:WaitForChild("NexusInstance"):WaitForChild("NexusInstance"))

local RectPoint8 = NexusInstance:Extend()
RectPoint8:SetClassName("RectPoint8")



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
Constructor of the RectPoint8 class.
The parameter order is left, right, top, and bottom.
--]]
function RectPoint8:__new(Left,Right,Top,Bottom)
	--Throw an error if the points are invalid.
	ValidateParameter("Top",Top,"RectSide")
	ValidateParameter("Right",Right,"RectSide")
	ValidateParameter("Bottom",Bottom,"RectSide")
	ValidateParameter("Left",Left,"RectSide")
	
	--Initialize the super class.
	self:InitializeSuper()
	
	--Store the sides.
	self.Left = Left
	self.Right = Right
	self.Top = Top
	self.Bottom = Bottom
end



return RectPoint8