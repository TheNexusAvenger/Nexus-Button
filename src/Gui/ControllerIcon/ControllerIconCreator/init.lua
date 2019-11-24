local ControllerImageLibrary = {}

local spritesheets = {}
for _, platform in pairs(script.Spritesheets:GetChildren()) do
	spritesheets[platform.Name] = {}
	for _, style in pairs(platform:GetChildren()) do
		spritesheets[platform.Name][style.Name] = require(style).new()
	end
end

local function getImageInstance(instanceType, index, style)
	local platform = "XboxOne"
	if type(index)== "userdata" then
		index = string.sub(tostring(index), 14)
	end
	local sheet = spritesheets[platform][style]
	if not sheet then
		warn("Could not find style: " .. style)
		return
	end
	local element = sheet:GetSprite(instanceType, index)
	return element
end

function ControllerImageLibrary:GetImageLabel(index, style, platform)
	return getImageInstance("ImageLabel", index, style, platform)
end

function ControllerImageLibrary:GetImageButton(index, style, platform)
	return getImageInstance("ImageButton", index, style, platform)
end

return ControllerImageLibrary
