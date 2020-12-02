--[[
TheNexusAvenger

Class representing a base button, including events.
--]]

--Threshold for registering a press.
local TRIGGER_PRESS_THRESHOLD = 0.9



local RootModule = script.Parent.Parent

local NexusInstance = require(RootModule:WaitForChild("NexusInstance"):WaitForChild("NexusInstance"))
local NexusEventCreator = require(RootModule:WaitForChild("NexusInstance"):WaitForChild("Event"):WaitForChild("NexusEventCreator"))

local BaseButton = NexusInstance:Extend()
BaseButton:SetClassName("BaseButton")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")



--[[
Creates an instance.
--]]
local function CreateInstance(InstanceName)
	local NewInstance = Instance.new(InstanceName)
	return NewInstance,NewInstance
end

--[[
Returns if a string or Enum is equvalent to an Enum.
--]]
local function IsEnumEquals(EnumItem,OtherEnumItem)
	return EnumItem == OtherEnumItem or string.match(tostring(EnumItem),".+%..+%.(.+)") == OtherEnumItem or string.match(tostring(OtherEnumItem),".+%..+%.(.+)") == EnumItem
end

--[[
Updates the Instance constructor if
Nexus VR Core is present.
--]]
local function UpdateInstanceConstructor()
	local NexusVRCore = ReplicatedStorage:FindFirstChild("NexusVRCore")
	if NexusVRCore and BaseButton.InstanceConstructor == CreateInstance then
		local NexusWrappedInstance = require(NexusVRCore):GetResource("NexusWrappedInstance")
		BaseButton.InstanceConstructor = function(InstanceName)
			local NewInstance = NexusWrappedInstance.new(InstanceName)
			return NewInstance,NewInstance:GetWrappedInstance()
		end
	end
end



--Connect NexusVRCore being added.
BaseButton.InstanceConstructor = CreateInstance
ReplicatedStorage.ChildAdded:Connect(UpdateInstanceConstructor)
UpdateInstanceConstructor()



--[[
Constructor of the Bass Button Class.
--]]
function BaseButton:__new()
	self:InitializeSuper()

	--Create the base frame.
	local LogicalFrame,BaseFrame = self.InstanceConstructor("Frame")
	self.LogicalFrame = LogicalFrame
	self.BaseFrame = BaseFrame
	
	--Create the events.
	self.MouseButton1Down = NexusEventCreator.CreateEvent()
	self.MouseButton1Up = NexusEventCreator.CreateEvent()
	self.MouseButton1Click = NexusEventCreator.CreateEvent()
	self.MouseButton2Down = NexusEventCreator.CreateEvent()
	self.MouseButton2Up = NexusEventCreator.CreateEvent()
	self.MouseButton2Click = NexusEventCreator.CreateEvent()
	
	--Set up the events.
	local InputsDown = {}
	self.__Events = {}
	self.__MappedInputs = {}
	
	--Set up clicking.
	table.insert(self.__Events,LogicalFrame.InputBegan:Connect(function(Input,Processed)
		if Processed then return end
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			self.MouseButton1Down:Fire()
			InputsDown[Enum.UserInputType.MouseButton1] = true
		elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
			self.MouseButton2Down:Fire()
			InputsDown[Enum.UserInputType.MouseButton2] = true
		end
	end))
	
	table.insert(self.__Events,LogicalFrame.InputEnded:Connect(function(Input,Processed)
		if Processed then return end
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			self.MouseButton1Up:Fire()
			if InputsDown[Enum.UserInputType.MouseButton1] then self.MouseButton1Click:Fire() end
			InputsDown[Enum.UserInputType.MouseButton1] = false
		elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
			self.MouseButton2Up:Fire()
			if InputsDown[Enum.UserInputType.MouseButton2] then self.MouseButton2Click:Fire() end
			InputsDown[Enum.UserInputType.MouseButton2] = false
		end
	end))
	
	--Set up button pressing.
	table.insert(self.__Events,UserInputService.InputBegan:Connect(function(Input,Processed)
		if Processed then return end
		
		--Get the inputs.
		local InputCode = Input.KeyCode
		local MappedInput = self:__GetMappedInput(InputCode)
		if not MappedInput then
			InputCode = Input.UserInputType
			MappedInput = self:__GetMappedInput(InputCode)
		end
		
		--If the inputs exist, fire the events.
		if MappedInput then
			InputsDown[InputCode] = true
			if MappedInput == Enum.UserInputType.MouseButton1 then
				self.MouseButton1Down:Fire()
			elseif MappedInput == Enum.UserInputType.MouseButton2 then
				self.MouseButton2Down:Fire()
			end
		end
	end))
	
	table.insert(self.__Events,UserInputService.InputEnded:Connect(function(Input,Processed)
		if Processed then return end
		
		--Get the inputs.
		local InputCode = Input.KeyCode
		local MappedInput = self:__GetMappedInput(InputCode)
		if not MappedInput then
			InputCode = Input.UserInputType
			MappedInput = self:__GetMappedInput(InputCode)
		end
		
		--If the inputs exist, fire the events.
		if MappedInput then
			if MappedInput == Enum.UserInputType.MouseButton1 then
				if InputsDown[InputCode] then self.MouseButton1Click:Fire() end
				self.MouseButton1Up:Fire()
			elseif MappedInput == Enum.UserInputType.MouseButton2 then
				if InputsDown[InputCode] then self.MouseButton2Click:Fire() end
				self.MouseButton2Up:Fire()
			end
			InputsDown[InputCode] = false
		end
	end))
	
	--Handle a controller selecting.
	InputsDown[Enum.KeyCode.ButtonR2] = false
	table.insert(self.__Events,UserInputService.InputChanged:Connect(function(Input)
		if Input.KeyCode == Enum.KeyCode.ButtonR2 then
			local NewTriggerDown = (Input.Position.Z >= TRIGGER_PRESS_THRESHOLD)
			if GuiService.SelectedObject == self.BaseFrame and NewTriggerDown ~= InputsDown[Input.KeyCode] then
				InputsDown[Input.KeyCode] = NewTriggerDown
				
				--Fire the events.
				if NewTriggerDown then
					self.MouseButton1Down:Fire()
				else
					self.MouseButton1Up:Fire()
					self.MouseButton1Click:Fire()
				end
			end
		end
	end))
end

--[[
Returns the mapped inputs.
--]]
function BaseButton:__GetMappedInput(EnumItem)
	for Input,MappedInputs in pairs(self.__MappedInputs) do
		if IsEnumEquals(EnumItem,Input) then
			return MappedInputs
		end
	end
end

--[[
Maps a key input to a mouse input for clicking.
--]]
function BaseButton:MapKey(KeyCode,MouseInput)
	--Throw an error if the mapping is incorrect.
	if not IsEnumEquals(Enum.UserInputType.MouseButton1,MouseInput) and not IsEnumEquals(Enum.UserInputType.MouseButton2,MouseInput) then
		error("Key map must be MouseButton1Down or MouseButton2Down, not "..tostring(MouseInput))
	end
	
	--Unmap the existing input.
	self:UnmapKey(KeyCode)
	
	--Map the new input.
	if IsEnumEquals(Enum.UserInputType.MouseButton1,MouseInput) then
		self.__MappedInputs[KeyCode] = Enum.UserInputType.MouseButton1
	elseif IsEnumEquals(Enum.UserInputType.MouseButton2,MouseInput) then
		self.__MappedInputs[KeyCode] = Enum.UserInputType.MouseButton2
	end
end

--[[
Unmaps a key input to a mouse input for clicking.
--]]
function BaseButton:UnmapKey(KeyCode)
	--Find the index.
	local Index
	for Key,_ in pairs(self.__MappedInputs) do
		if IsEnumEquals(Key,KeyCode) then
			Index = Key
			break
		end
	end
	
	--Unset the key.
	if Index then
		self.__MappedInputs[Index] = nil
	end
end

--[[
Destroys the frame and disconnects the events.
--]]
function BaseButton:Destroy()
	self.super:Destroy()
	
	--Disconnect the events.
	for _,Event in pairs(self.__Events) do
		Event:Disconnect()
	end
	self.__Events = {}
	
	--Destroy the frame.
	self.LogicalFrame:Destroy()
	self.BaseFrame:Destroy()
	
	--Disconnect the custom events.
	self.MouseButton1Down:Disconnect()
	self.MouseButton1Click:Disconnect()
	self.MouseButton1Up:Disconnect()
	self.MouseButton2Down:Disconnect()
	self.MouseButton2Click:Disconnect()
	self.MouseButton2Up:Disconnect()
end



return BaseButton