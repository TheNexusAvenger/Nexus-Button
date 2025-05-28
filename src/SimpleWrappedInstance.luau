--Simple instance wrapper for getting and setting instance values.
--!strict

local NexusInstance = require(script.Parent:WaitForChild("Packages"):WaitForChild("NexusInstance"))

local SimpleWrappedInstance = {}
SimpleWrappedInstance.__index = SimpleWrappedInstance

export type SimpleWrappedInstance<T> = {
    WrappedInstance: T,
    DisabledReplicationProperties: {[string]: boolean},
} & typeof(setmetatable({}, SimpleWrappedInstance)) & T
export type NexusInstanceSimpleWrappedInstance<T> = NexusInstance.NexusInstance<SimpleWrappedInstance<T>>



--[[
Creates a simple wrapped instance.
--]]
function SimpleWrappedInstance.__new<T>(self: NexusInstanceSimpleWrappedInstance<T>, WrappedInstance: T): ()
    --Store the wrapped instance.
    local DisabledReplicationProperties = {}
    self.WrappedInstance = WrappedInstance
    self.DisabledReplicationProperties = DisabledReplicationProperties

    --Modify __index.
    local Metatable = getmetatable(self) :: any
    local OriginalIndex = Metatable.__index
    Metatable.__index = function(self, Index: any): any
        --Return the object's value.
        local ObjectValue = OriginalIndex(self, Index)
        if ObjectValue ~= nil then
            return ObjectValue
        end

        --Return the instance's value.
        if DisabledReplicationProperties[Index] then return nil end
        local InstanceValue = (WrappedInstance :: any)[Index]
        if typeof(InstanceValue) == "function" then
            return function(_, ...)
                return InstanceValue(WrappedInstance, ...)
            end
        end
        return InstanceValue
    end

    --Replicate changes.
    self:OnAnyPropertyChanged(function(PropertyName, Value)
        if DisabledReplicationProperties[PropertyName] then return end
        (WrappedInstance :: any)[PropertyName] = Value
    end)
    if typeof(WrappedInstance) == "Instance" then
        WrappedInstance.Changed:Connect(function(PropertyName)
            if DisabledReplicationProperties[PropertyName] then return end

            --Replicate the change back if the object has a set value.
            local ObjectValue = OriginalIndex(self, PropertyName)
            if ObjectValue ~= nil then
                (self :: any)[PropertyName] = (WrappedInstance :: any)[PropertyName]
                return
            end

            --Fire the changed events.
            self.Changed:Fire(PropertyName)
            local PropertyChangedEvent = self.PropertyChangedEvents[PropertyName]
            if PropertyChangedEvent then
                PropertyChangedEvent:Fire()
            end
        end)
    end
end

--[[
Disables changes being replicated to the wrapped
instance for a specific property.
--]]
function SimpleWrappedInstance.DisableChangeReplication<T>(self: NexusInstanceSimpleWrappedInstance<T>, PropertyName: string): ()
    self.DisabledReplicationProperties[PropertyName] = true
end

--[[
Returns the wrapped instance.
--]]
function SimpleWrappedInstance.GetWrappedInstance<T>(self: NexusInstanceSimpleWrappedInstance<T>): T
    return self.WrappedInstance
end

--[[
Destroys the wrapped instance.
--]]
function SimpleWrappedInstance.Destroy<T>(self: NexusInstanceSimpleWrappedInstance<T>): ()
    if typeof(self.WrappedInstance) ~= "Instance" then return end
    self.WrappedInstance:Destroy()
end



return NexusInstance.ToInstance(SimpleWrappedInstance) :: NexusInstance.NexusInstanceClass<typeof(SimpleWrappedInstance), <T>(WrappedInstance: T) -> (NexusInstanceSimpleWrappedInstance<T>)>