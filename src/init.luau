--Main module for Nexus Button.
--!strict

local ButtonFactory = require(script:WaitForChild("Factory"):WaitForChild("ButtonFactory"))
local TextButtonFactory = require(script:WaitForChild("Factory"):WaitForChild("TextButtonFactory"))
local NexusInstance = require(script:WaitForChild("Packages"):WaitForChild("NexusInstance"))
local Button = require(script:WaitForChild("Button"))
local ControllerIcon = require(script:WaitForChild("ControllerIcon"))
local ThemedFrame = require(script:WaitForChild("ThemedFrame"))

local NexusButton = {}
NexusButton.ButtonFactory = ButtonFactory
NexusButton.TextButtonFactory = TextButtonFactory
NexusButton.ControllerIcon = ControllerIcon
NexusButton.ThemedFrame = ThemedFrame

export type ButtonFactory = ButtonFactory.ButtonFactory
export type TextButtonFactory = TextButtonFactory.TextButtonFactory
export type NexusButton = Button.NexusButton
export type NexusInstanceNexusButton = Button.NexusInstanceNexusButton
export type ControllerIcon = ControllerIcon.ControllerIcon
export type NexusInstanceControllerIcon = ControllerIcon.NexusInstanceControllerIcon
export type ThemedFrame = ThemedFrame.ThemedFrame
export type NexusInstanceThemedFrame = ThemedFrame.NexusInstanceThemedFrame

return (setmetatable(NexusButton, Button) :: any) :: typeof(NexusButton) & NexusInstance.NexusInstanceClass<typeof(NexusButton), () -> (NexusInstanceNexusButton)>