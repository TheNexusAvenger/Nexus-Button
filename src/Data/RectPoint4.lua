--[[
TheNexusAvenger

Class representing 4 points of a rectangle
(4 points).

This class is mutable.
--]]

local RootModule = script.Parent.Parent
local NexusInstance = require(RootModule:WaitForChild("NexusInstance"):WaitForChild("src"):WaitForChild("NexusInstance"))

local RectPoint4 = NexusInstance:Extend()
RectPoint4:SetClassName("RectPoint4")



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
Constructor of the RectPoint4 class.
The parameter order is left, right, top, and bottom.
--]]
function RectPoint4:__new(Left,Right,Top,Bottom)
	--Throw an error if the points are invalid.
	ValidateParameter("Top",Top,"UDim")
	ValidateParameter("Right",Right,"UDim")
	ValidateParameter("Bottom",Bottom,"UDim")
	ValidateParameter("Left",Left,"UDim")
	
	--Initialize the super class.
	self:InitializeSuper()
	
	--Store the sides.
	self.Left = Left
	self.Right = Right
	self.Top = Top
	self.Bottom = Bottom
end



return RectPoint4