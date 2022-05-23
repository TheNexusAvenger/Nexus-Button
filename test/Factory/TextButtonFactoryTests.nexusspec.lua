--[[
TheNexusAvenger

Unit tests for the TextButtonFactory class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusButton = game:GetService("ReplicatedStorage"):WaitForChild("NexusButton")
local Factory = NexusButton:WaitForChild("Factory")

local TextButtonFactory = require(Factory:WaitForChild("TextButtonFactory"))
local TextButtonFactoryTest = NexusUnitTesting.UnitTest:Extend()



--[[
Test that the constructor works without failing.
--]]
NexusUnitTesting:RegisterUnitTest(TextButtonFactoryTest.new("Constructor"):SetRun(function(self)
    --Create the component under testing.
    local CuT = TextButtonFactory.new()

    --Run the assertions.
    self:AssertEquals(CuT.ClassName, "TextButtonFactory", "ClassName is incorrect.")
end))

--[[
Test that the CreateDefault method.
--]]
NexusUnitTesting:RegisterUnitTest(TextButtonFactoryTest.new("CreateDefault"):SetRun(function(self)
    --Create the component under testing.
    local CuT = TextButtonFactory.CreateDefault(Color3.new(0, 170 / 255, 1))

    --Create a button and assert the defaults are correct.
    local Button,TextLabel = CuT:Create()
    self:AssertEquals(Button.BackgroundColor3, Color3.new(0, 170 / 255, 1), "Background color is incorrect.")
    self:AssertEquals(Button.BorderColor3, Color3.new(0, 140 / 255, 225 / 255), "Border color is incorrect.")
    self:AssertEquals(Button.BorderTransparency, 0.25 ,"Border transparency is incorrect.")
    self:AssertEquals(TextLabel.Font, Enum.Font.SourceSans, "Font is incorrect.")
    self:AssertEquals(TextLabel.TextColor3, Color3.new(1, 1, 1), "TextColor3 is incorrect.")
    self:AssertEquals(TextLabel.TextStrokeColor3, Color3.new(0,0,0), "TextStrokeColor3 is incorrect.")
    self:AssertEquals(TextLabel.TextStrokeTransparency, 0, "TextStrokeTransparency is incorrect.")
    self:AssertEquals(TextLabel.TextScaled, true, "TextScaled is incorrect.")

    --Destroy the button.
    Button:Destroy()
end))

--[[
Test that the SetTextDefault and UnsetTextDefault methods.
--]]
NexusUnitTesting:RegisterUnitTest(TextButtonFactoryTest.new("SetTextDefault"):SetRun(function(self)
    --Create the component under testing.
    local CuT = TextButtonFactory.new()

    --Set several defaults.
    CuT:SetTextDefault("Text", "TestLabel")
    CuT:SetTextDefault("Font", Enum.Font.Arcade)

    --Create a button and assert the defaults are correct.
    local Button1,TextLabel1 = CuT:Create()
    self:AssertEquals(TextLabel1.Text, "TestLabel", "Text is incorrect.")
    self:AssertEquals(TextLabel1.Font, Enum.Font.Arcade, "Font is incorrect.")

    --Unset a default.
    CuT:UnsetTextDefault("Text")

    --Create a button and assert the defaults are correct.
    local Button2,TextLabel2 = CuT:Create()
    self:AssertNotEquals(TextLabel2.Text, "TestLabel", "Text is incorrect.")
    self:AssertEquals(TextLabel2.Font, Enum.Font.Arcade, "Font is incorrect.")

    --Destroy the buttons.
    Button1:Destroy()
    Button2:Destroy()
end))



return true