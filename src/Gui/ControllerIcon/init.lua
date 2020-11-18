--[[
TheNexusAvenger

Class representing a controller icon.
--]]

--The default size of the controller icon.
local BASE_ICON_SIZE_RELATIVE = 0.9

--Custom multipliers for specific keys.
local CUSTOM_MULTIPLIERS = {
	[Enum.KeyCode.ButtonL1] = {1,0.5},
	[Enum.KeyCode.ButtonR1] = {1,0.5},
}



local RootModule = script.Parent.Parent

local ControllerIconCreator = require(script:WaitForChild("ControllerIconCreator"))
local NexusInstance = require(RootModule:WaitForChild("NexusInstance"):WaitForChild("NexusInstance"))

local ControllerIcon = NexusInstance:Extend()
ControllerIcon:SetClassName("ControllerIcon")

local UserInputService = game:GetService("UserInputService")



--[[
Constructor of the Controller Icon Class.
--]]
function ControllerIcon:__new(KeyCode)
	self:InitializeSuper()

	--Create the adorn frame.
	local AdornFrame = Instance.new("Frame")
	AdornFrame.BackgroundTransparency = 1
	self.AdornFrame = AdornFrame
	self.IconScale = BASE_ICON_SIZE_RELATIVE
	
	--Connect the events.
	self.__Events = {}
	table.insert(self.__Events,UserInputService.GamepadConnected:Connect(function()
		self:__UpdateVisibility()
	end))
	table.insert(self.__Events,UserInputService.GamepadDisconnected:Connect(function()
		self:__UpdateVisibility()
	end))
	
	--Update the visibility.
	self:__UpdateVisibility()
end

--[[
Updates the visibility of the icon.
--]]
function ControllerIcon:__UpdateVisibility()
	--Set the visibility to false if there is no icon.
	if not self.Icon then
		self.IconVisible = false
		return
	end
	
	--Determine if a controller is connected.
	local ControllerConnected = (#UserInputService:GetConnectedGamepads() ~= 0)
	
	--Set the visibility.
	self.Icon.Visible = ControllerConnected
	self.IconVisible = ControllerConnected
end

--[[
Sets the icon.
--]]
function ControllerIcon:SetIcon(KeyCode)
	--Return if the KeyCode is nil.
	if KeyCode == nil then
		self.KeyCode = nil
		self.Icon:Destroy()
		self.Icon = nil
		self:__UpdateVisibility()
		return
	end
	
	--Covert the KeyCode from a string.
	if type(KeyCode) == "string" then
		KeyCode = Enum.KeyCode[KeyCode]
	end
	
	--Destroy the existing icon.
	if self.Icon then
		self.Icon:Destroy()
	end
	
	--Create the new icon.
	local Icon = ControllerIconCreator:GetImageLabel(KeyCode,"Dark","XboxOne")
	Icon.Position = UDim2.new(0.5,0,0.5,0)
	Icon.AnchorPoint = Vector2.new(0.5,0.5)
	Icon.ZIndex = self.AdornFrame.ZIndex
	Icon.Parent = self.AdornFrame
	self.Icon = Icon
	self.KeyCode = KeyCode
	self:__UpdateVisibility()
	self:SetScale(self.IconScale)
end


--[[
Sets the scale of the icon.
--]]
function ControllerIcon:SetScale(NewScale)
	self.IconScale = NewScale
	
	--Set the size.
	if self.KeyCode and self.Icon then
		local ScaleMultipliers = CUSTOM_MULTIPLIERS[self.KeyCode] or {1,1}
		self.Icon.Size = UDim2.new(self.IconScale * ScaleMultipliers[1],0,self.IconScale * ScaleMultipliers[2],0)
	end
end

--[[
Destroys the frame.
--]]
function ControllerIcon:Destroy()
	self.super:Destroy()
	
	--Disconnect the events.
	for _,Event in pairs(self.__Events) do
		Event:Disconnect()
	end
	self.__Events = {}
	
	--Destroy the adorn frame.
	self.AdornFrame:Destroy()
end



return ControllerIcon