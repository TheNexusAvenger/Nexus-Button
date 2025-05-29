--Tests the ButtonFactory class.
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ButtonFactory = require(ReplicatedStorage.Packages.NexusButton.Factory.ButtonFactory)

return function()
    describe("A button factory", function()
        it("should set default properties.", function()
            local TestButtonFactory = ButtonFactory.new()
            TestButtonFactory:SetDefault("Name", "TestButton")
            TestButtonFactory:SetDefault("Size", UDim2.new(1, 2, 3, 4))

            local Button1 = TestButtonFactory:Create()
            expect(Button1.Name).to.equal("TestButton")
            expect(Button1.Size).to.equal(UDim2.new(1, 2, 3, 4))
            Button1:Destroy()
        
            TestButtonFactory:UnsetDefault("Name")
            local Button2 = TestButtonFactory:Create()
            expect(Button2.Name).never.to.equal("TestButton")
            expect(Button2.Size).to.equal(UDim2.new(1, 2, 3, 4))
            Button2:Destroy()
        end)

        it("should be created from a default preset.", function()
            local TestButtonFactory = ButtonFactory.CreateDefault(Color3.fromRGB(0, 170, 255))

            local Button = TestButtonFactory:Create()
            expect(Button.BackgroundColor3).to.equal(Color3.fromRGB(0, 170, 255))
            expect(Button.BorderColor3).to.equal(Color3.fromRGB(0, 140, 225))
            expect(Button.BorderTransparency).to.equal(0.25)
            Button:Destroy()
        end)
    end)
end