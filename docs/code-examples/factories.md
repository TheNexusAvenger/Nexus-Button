# Factories
A factory in software refers to a class that
creates objects. This design pattern is used
over just calling the constructor to do additional
processing ot initialize other components.

## `ButtonFactory`
The `ButtonFactory` is used to create buttons
with default values. This is done so the
same values don't need to be entered each time
an object is created. The `ButtonFactory` works
as an object, so it does need to be created. When
it is created, `ButtonFactory:SetDefault(PropertyName,Property)`
and `ButtonFactory:UnsetDefault(PropertyName)` can
be used to set and unset the default properties.
`ButtonFactory:Create()` is then used to create
buttons.

```lua
--Create a button factory.
local ButtonFactory = require(game.ReplicatedStorage:WaitForChild("NexusButton"):WaitForChild("Factory"):WaitForChild("ButtonFactory"))
local Factory = ButtonFactory.new()

--Set the defaults.
Factory:SetDefault("Name","CustomName")
Factory:SetDefault("BackgroundColor3",Color3.new(1,1,1))
Factory:SetDefault("BorderSizeScale",0.1)

--Create a button.
local Button = Factory:Create()
print(Button.Name) --CustomName
print(Button.BackgroundColor3) --1, 1, 1
print(Button.BorderSizeScale) --0.1

--Unset a default.
Factory:UnsetDefault("BorderSizeScale")

--Create a button.
local Button = Factory:Create()
print(Button.Name) --CustomName
print(Button.BackgroundColor3) --1, 1, 1
print(Button.BorderSizeScale) --0.2
```

To use the style used in other projects,
a default factory can be used which takes
the base color as a parameter.
```lua
--Create a button factory.
local ButtonFactory = require(game.ReplicatedStorage:WaitForChild("NexusButton"):WaitForChild("Factory"):WaitForChild("ButtonFactory"))
local Factory = ButtonFactory.CreateDefault(Color3.new(0,170/255,255/255))

--Create a button.
local Button = Factory:Create()
print(Button.BackgroundColor3) --0, 0.666667, 1
print(Button.BorderColor3) --0, 0.54902, 0.882353
print(Button.BorderTransparency) --0.25
```

## `TextButtonFactory`
Nexus Button differs from Nexus Button Class
(previous concept) where text isn't integrated
into the button. To get around this, a
`TextButtonFactory` can be used. TThe create method
is a bit difference since it returns the button
and the `TextLabel` in the button. TextLabel defaults
can be set and unset with `ButtonFactory:SetTextDefault(PropertyName,Property)`
and `ButtonFactory:UnsetTextDefault(PropertyName)`.

```lua
--Create a button factory.
local TextButtonFactory = require(game.ReplicatedStorage:WaitForChild("NexusButton"):WaitForChild("Factory"):WaitForChild("TextButtonFactory"))
local Factory = TextButtonFactory.CreateDefault(Color3.new(0,170/255,255/255))

--Set the defaults.
Factory:SetDefault("Name","CustomName")
Factory:SetDefault("BackgroundColor3",Color3.new(1,1,1))
Factory:SetDefault("BorderSizeScale",0.1)
Factory:SetTextDefault("Font","SciFi")
Factory:SetTextDefault("Text","Button")

--Create a button.
local Button,TextLabel = Factory:Create()
print(Button.Name) --CustomName
print(Button.BackgroundColor3) --1, 1, 1
print(Button.BorderSizeScale) --0.1
print(TextLabel.Font) --Enum.Font.SciFi
print(TextLabel.Text) --Button

--Unset a default.
Factory:UnsetDefault("BorderSizeScale")
Factory:UnsetTextDefault("Text")

--Create a button.
local Button,TextLabel = Factory:Create()
print(Button.Name) --CustomName
print(Button.BackgroundColor3) --1, 1, 1
print(Button.BorderSizeScale) --0.2
print(TextLabel.Font) --Enum.Font.SciFi
print(TextLabel.Text) --Label
```

Like the `ButtonFactory`, there is a default 
factory used by other projects.

```lua
--Create a button factory.
local TextButtonFactory = require(game.ReplicatedStorage:WaitForChild("NexusButton"):WaitForChild("Factory"):WaitForChild("TextButtonFactory"))
local Factory = TextButtonFactory.CreateDefault(Color3.new(0,170/255,255/255))

--Create a button.
local Button,TextLabel = Factory:Create()
TextLabel.Text = "Button"
```