--Tests the ControllerIcon class.
--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ControllerIcon = require(ReplicatedStorage.Packages.NexusButton.ControllerIcon)

return function()
    local TestControllerIcon = nil
    beforeEach(function()
        TestControllerIcon = ControllerIcon.new()
    end)
    afterEach(function()
        TestControllerIcon:Destroy()
    end)

    describe("A controller icon", function()
        it("should set an icon.", function()
            expect(TestControllerIcon.Icon).to.equal(nil)

            TestControllerIcon:SetIcon(Enum.KeyCode.ButtonA)
            expect((TestControllerIcon.Icon :: ImageLabel).Size).to.equal(UDim2.new(1, 0, 1, 0))
            expect((TestControllerIcon.IconUIScale :: UIScale).Scale).to.be.near(0.9)
            TestControllerIcon:SetIcon(Enum.KeyCode.ButtonL1)
            expect((TestControllerIcon.Icon :: ImageLabel).Size).to.equal(UDim2.new(1, 0, 64 / 115, 0))
            expect((TestControllerIcon.IconUIScale :: UIScale).Scale).to.be.near(0.9)
            
            TestControllerIcon:SetIcon(nil)
            expect(TestControllerIcon.Icon).to.equal(nil)
        end)

        it("should set a scale.", function()
            TestControllerIcon:SetIcon(Enum.KeyCode.ButtonA)

            TestControllerIcon:SetScale(0.6)
            expect((TestControllerIcon.IconUIScale :: UIScale).Scale).to.be.near(0.6)
        end)
    end)
end