--[[
TheNexusAvenger

Tests the ControllerIcon class.
--]]
--!strict

local ControllerIcon = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusButton"):WaitForChild("ControllerIcon"))

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
            expect(TestControllerIcon.Icon.Size).to.equal(UDim2.new(0.9, 0, 0.9, 0))
            TestControllerIcon:SetIcon(Enum.KeyCode.ButtonL1)
            expect(TestControllerIcon.Icon.Size).to.equal(UDim2.new(0.9, 0, 0.45, 0))
            
            TestControllerIcon:SetIcon(nil)
            expect(TestControllerIcon.Icon).to.equal(nil)
        end)

        it("should set a scale.", function()
            TestControllerIcon:SetIcon(Enum.KeyCode.ButtonA)

            TestControllerIcon:SetScale(0.6)
            expect(TestControllerIcon.Icon.Size).to.equal(UDim2.new(0.6, 0, 0.6, 0))
            TestControllerIcon:SetIcon(Enum.KeyCode.ButtonL1)
            expect(TestControllerIcon.Icon.Size).to.equal(UDim2.new(0.6, 0, 0.3, 0))
        end)
    end)
end