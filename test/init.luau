--Tests the NeuxsButton class.
--!strict

local NexusButton = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusButton"))

return function()
    local TextNexusButton = nil
    beforeEach(function()
        TextNexusButton = NexusButton.new()
    end)
    afterEach(function()
        TextNexusButton:Destroy()
    end)

    describe("A NexusButton ", function()
        it("should update the border size.", function()
            TextNexusButton.BorderSizePixel = 0
            TextNexusButton.BorderSizeScale = 0

            TextNexusButton.BorderSizePixel = 10
            expect(TextNexusButton.BorderSize).to.equal(UDim.new(0, 10))
            TextNexusButton.BorderSizeScale = 0.4
            expect(TextNexusButton.BorderSize).to.equal(UDim.new(0.4, 0))
        end)

        it("should update the transparency.", function()
            TextNexusButton.BackgroundTransparency = 0.25
            TextNexusButton.BorderTransparency = 0.75
            expect(TextNexusButton.BackgroundFrame.ImageTransparency).to.equal(0.25)
            expect(TextNexusButton.BorderFrame.ImageTransparency).to.equal(0.75)
        end)

        it("should map keys.", function()
            --Map several inputs and assert the mappings are correct.
            TextNexusButton:MapKey(Enum.KeyCode.A, Enum.UserInputType.MouseButton1)
            TextNexusButton:MapKey(Enum.KeyCode.B, "MouseButton1")
            TextNexusButton:MapKey("C", Enum.UserInputType.MouseButton2)
            TextNexusButton:MapKey("D", "MouseButton2")
            expect(TextNexusButton.MappedInputs[Enum.KeyCode.A]).to.equal(Enum.UserInputType.MouseButton1)
            expect(TextNexusButton.MappedInputs[Enum.KeyCode.B]).to.equal(Enum.UserInputType.MouseButton1)
            expect(TextNexusButton.MappedInputs[Enum.KeyCode.C]).to.equal(Enum.UserInputType.MouseButton2)
            expect(TextNexusButton.MappedInputs[Enum.KeyCode.D]).to.equal(Enum.UserInputType.MouseButton2)
            expect(TextNexusButton.MappedInputs[Enum.KeyCode.E]).to.equal(nil)

            --Remap and unmap several mappings and assert they are correct.
            TextNexusButton:UnmapKey(Enum.KeyCode.A)
            TextNexusButton:UnmapKey("B")
            TextNexusButton:MapKey(Enum.KeyCode.C, Enum.UserInputType.MouseButton1)
            TextNexusButton:MapKey("D", "MouseButton1")
            expect(TextNexusButton.MappedInputs[Enum.KeyCode.A]).to.equal(nil)
            expect(TextNexusButton.MappedInputs[Enum.KeyCode.B]).to.equal(nil)
            expect(TextNexusButton.MappedInputs[Enum.KeyCode.C]).to.equal(Enum.UserInputType.MouseButton1)
            expect(TextNexusButton.MappedInputs[Enum.KeyCode.D]).to.equal(Enum.UserInputType.MouseButton1)
            
            --Assert an error is thrown for an incorrect mapping.
            expect(function()
                TextNexusButton:MapKey(Enum.KeyCode.A, "FakeKey")
            end).to.throw()
        end)
    end)
end