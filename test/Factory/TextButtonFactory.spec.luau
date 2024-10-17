--Tests the TextButtonFactory class.
--!strict

local TextButtonFactory = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusButton"):WaitForChild("Factory"):WaitForChild("TextButtonFactory"))

return function()
    describe("A text button factory", function()
        it("should set default properties.", function()
            local TestButtonFactory = TextButtonFactory.new()
            TestButtonFactory:SetTextDefault("Text", "TestLabel")
            TestButtonFactory:SetTextDefault("Font", Enum.Font.Arcade)

            local Button1, TextLabel1 = TestButtonFactory:Create()
            expect(TextLabel1.Text).to.equal("TestLabel")
            expect(TextLabel1.Font).to.equal(Enum.Font.Arcade)
            Button1:Destroy()
        
            TestButtonFactory:UnsetTextDefault("Text")
            local Button2, TextLabel2 = TestButtonFactory:Create()
            expect(TextLabel2.Text).never.to.equal("TestLabel")
            expect(TextLabel2.Font).to.equal(Enum.Font.Arcade)
            Button2:Destroy()
        end)

        it("should be created from a default preset.", function()
            local TestButtonFactory = TextButtonFactory.CreateDefault(Color3.fromRGB(0, 170, 255))

            local Button, TextLabel = TestButtonFactory:Create()
            expect(Button.BackgroundColor3).to.equal(Color3.fromRGB(0, 170, 255))
            expect(Button.BorderColor3).to.equal(Color3.fromRGB(0, 140, 225))
            expect(Button.BorderTransparency).to.equal(0.25)
            expect(TextLabel.Font).to.equal(Enum.Font.SourceSans)
            expect(TextLabel.TextColor3).to.equal(Color3.fromRGB(255, 255, 255))
            expect(TextLabel.TextStrokeColor3).to.equal(Color3.fromRGB(0, 0, 0))
            expect(TextLabel.TextStrokeTransparency).to.equal(0)
            expect(TextLabel.TextScaled).to.equal(true)
            Button:Destroy()
        end)
    end)
end