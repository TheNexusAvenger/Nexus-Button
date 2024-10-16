--Tests SimpleWrappedInstance.
--!strict

local SimpleWrappedInstance = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusButton"):WaitForChild("SimpleWrappedInstance"))

return function()
    describe("A SimpleWrappedInstance", function()
        local TestInstance, TestSimpleWrappedInstance = nil, nil
        beforeEach(function()
            TestInstance = Instance.new("Frame")
            TestSimpleWrappedInstance = SimpleWrappedInstance.new(TestInstance)
        end)
        afterEach(function()
            TestSimpleWrappedInstance:Destroy()
        end)

        it("should have the wrapped instance.", function()
            expect(TestSimpleWrappedInstance:GetWrappedInstance()).to.equal(TestInstance)
        end)

        it("should return instance properties.", function()
            expect(TestSimpleWrappedInstance.BackgroundColor3).to.equal(TestInstance.BackgroundColor3)
        end)

        it("should pass instance functions.", function()
            local TestFrame = Instance.new("Frame")
            TestFrame.Name = "TestFrame"
            TestFrame.Parent = TestInstance

            expect(TestSimpleWrappedInstance:FindFirstChild("TestFrame")).to.equal(TestFrame)
        end)

        it("should replicate changes to the instance.", function()
            TestSimpleWrappedInstance.Name = "TestFrame"
            expect(TestSimpleWrappedInstance.Name).to.equal("TestFrame")
            expect(TestInstance.Name).to.equal("TestFrame")
        end)

        it("should not replicate disabled changes to the instance.", function()
            TestSimpleWrappedInstance:DisableChangeReplication("Name")
            TestSimpleWrappedInstance.Name = "TestFrame"
            expect(TestSimpleWrappedInstance.Name).to.equal("TestFrame")
            expect(TestInstance.Name).to.never.equal("TestFrame")
        end)

        it("should replicate changes from the instance.", function()
            TestSimpleWrappedInstance.Name = "TestFrame1"
            expect(TestSimpleWrappedInstance.Name).to.equal("TestFrame1")
            expect(TestInstance.Name).to.equal("TestFrame1")

            local FiredPropertyName = nil
            local ChangesFired = 0
            TestInstance.Changed:Connect(function(PropertyName)
                FiredPropertyName = PropertyName
            end)
            TestInstance:GetPropertyChangedSignal("Name"):Connect(function()
                ChangesFired += 1
            end)
            TestInstance.Name = "TestFrame2"
            task.wait()
            expect(TestSimpleWrappedInstance.Name).to.equal("TestFrame2")
            expect(TestInstance.Name).to.equal("TestFrame2")
            expect(FiredPropertyName).to.equal("Name")
            expect(ChangesFired).to.equal(1)
        end)

        it("should fire changes from the instance that aren't stored in the object.", function()
            local FiredPropertyName = nil
            local ChangesFired = 0
            TestInstance.Changed:Connect(function(PropertyName)
                FiredPropertyName = PropertyName
            end)
            TestInstance:GetPropertyChangedSignal("Name"):Connect(function()
                ChangesFired += 1
            end)
            TestInstance.Name = "TestFrame"
            task.wait()
            expect(TestSimpleWrappedInstance.Name).to.equal("TestFrame")
            expect(FiredPropertyName).to.equal("Name")
            expect(ChangesFired).to.equal(1)
        end)

        it("should destroy the wrapped instance.", function()
            local Destroyed = false
            TestInstance.Destroying:Connect(function()
                Destroyed = true
            end)

            TestSimpleWrappedInstance:Destroy()
            task.wait()
            expect(Destroyed).to.equal(true)
        end)
    end)
end