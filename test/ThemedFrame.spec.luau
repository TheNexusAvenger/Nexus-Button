--Tests ThemedFrame.
--!strict

local ThemedFrame = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusButton"):WaitForChild("ThemedFrame"))

return function()
    describe("A ThemedFrame", function()
        local TestThemedFrame = nil
        beforeEach(function()
            TestThemedFrame = ThemedFrame.new()
        end)
        afterEach(function()
            TestThemedFrame:Destroy()
        end)

        it("should initialize with defaults.", function()
            expect(TestThemedFrame.BackgroundColor3).to.equal(Color3.fromRGB(255, 255, 255))
            expect(TestThemedFrame.BackgroundTransparency).to.equal(0)
            expect(TestThemedFrame.ScaleType).to.equal(Enum.ScaleType.Slice)
            expect(TestThemedFrame.Size).to.equal(UDim2.new(0, 100, 0, 100))

            local WrappedInstance = TestThemedFrame:GetWrappedInstance()
            expect(WrappedInstance.BackgroundTransparency).to.equal(1)
            expect(WrappedInstance.ImageTransparency).to.equal(0)
            expect(WrappedInstance.ImageColor3).to.equal(Color3.fromRGB(255, 255, 255))
            expect(WrappedInstance.Image).to.equal("rbxassetid://9708818802")
            expect(WrappedInstance.SliceCenter).to.equal(Rect.new(500, 500, 524, 524))
        end)

        it("should change the background color.", function()
            TestThemedFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

            local WrappedInstance = TestThemedFrame:GetWrappedInstance()
            expect(WrappedInstance.ImageColor3).to.equal(Color3.fromRGB(0, 0, 0))
        end)

        it("should change the background transparency.", function()
            TestThemedFrame.BackgroundTransparency = 0.5

            local WrappedInstance = TestThemedFrame:GetWrappedInstance()
            expect(WrappedInstance.BackgroundTransparency).to.equal(1)
            expect(WrappedInstance.ImageTransparency).to.equal(0.5)
        end)

        it("should change themes.", function()
            TestThemedFrame.Theme = "RoundedCorners"
            task.wait()

            local WrappedInstance = TestThemedFrame:GetWrappedInstance()
            expect(WrappedInstance.Image).to.equal("rbxassetid://9704725601")
            expect(WrappedInstance.SliceCenter).to.equal(Rect.new(500, 500, 524, 524))
        end)

        it("should change subthemes.", function()
            TestThemedFrame.SubTheme = "GamepadIconBackground"
            task.wait()
            
            local WrappedInstance = TestThemedFrame:GetWrappedInstance()
            expect(WrappedInstance.Image).to.equal("rbxassetid://9708824372")
            expect(WrappedInstance.SliceCenter).to.equal(Rect.new(500, 500, 524, 524))
        end)
    end)
end