--Wrapper of EditableImage to add extra functions.
--!strict

local DEFAULT_CANVAS_SIZE = 512
local DEFAULT_COLOR = Color3.fromRGB(255, 255, 255)
local DEFAULT_TRANSPARENCY = 0

local EditableImageWrapper = {}
EditableImageWrapper.__index = EditableImageWrapper

export type Corner = "TopLeft" | "TopRight" | "BottomLeft" | "BottomRight" 
export type EditableImageWrapper = {
    EditableImage: EditableImage,
} & typeof(setmetatable({}, EditableImageWrapper))



--[[
Creates an editable image wrapper.
--]]
function EditableImageWrapper.new(SizeX: number?, SizeY: number?): EditableImageWrapper
    local Image = Instance.new("EditableImage")
    Image.Size = Vector2.new(SizeX or DEFAULT_CANVAS_SIZE, SizeY or DEFAULT_CANVAS_SIZE)
    return setmetatable({
        EditableImage = Image,
    }, EditableImageWrapper) :: EditableImageWrapper
end

--[[
Returns the editable image result.
--]]
function EditableImageWrapper.GetEditableImage(self: EditableImageWrapper): EditableImage
    return self.EditableImage
end

--[[
Sets the name of the editable image.
Returns the original wrapper to allow for chaining.
--]]
function EditableImageWrapper.WithName(self: EditableImageWrapper, Name: string): EditableImageWrapper
    self.EditableImage.Name = Name
    return self
end

--[[
Draws a rectangle.
Returns the original wrapper to allow for chaining.
--]]
function EditableImageWrapper.DrawRectangle(self: EditableImageWrapper, TopLeftPosition: Vector2, Size: Vector2, Color: Color3?, Transparency: number?): EditableImageWrapper
    self.EditableImage:DrawRectangle(TopLeftPosition, Size, Color or DEFAULT_COLOR, Transparency or DEFAULT_TRANSPARENCY, Enum.ImageCombineType.BlendSourceOver)
    return self
end

--[[
Draws a cut corner.
Returns the original wrapper to allow for chaining.
--]]
function EditableImageWrapper.DrawCutCorner(self: EditableImageWrapper, Corner: Corner, TopLeftPosition: Vector2, Size: number, Color: Color3?, Transparency: number?): EditableImageWrapper
    --Build the pixels.
    local ColorR, ColorG, ColorB = (Color or DEFAULT_COLOR).R, (Color or DEFAULT_COLOR).G, (Color or DEFAULT_COLOR).B
    local TransparentAlpha, EdgeAlpha, OpagueAlpha = 0, 0.5 * (1 - (Transparency or DEFAULT_TRANSPARENCY)), (1 - (Transparency or DEFAULT_TRANSPARENCY))
    local Pixels = table.create(4 * Size * Size)
    for i = 0, Size - 1 do
        --Determine how many visible pixels there are for the row.
        local VisiblePixelWidth = i
        if Corner == "BottomLeft" or Corner == "BottomRight" then
            VisiblePixelWidth = Size - i - 1
        end

        --Add the pixels.
        if Corner == "TopLeft" or Corner == "BottomLeft" then
            for _ = 1, Size - VisiblePixelWidth - 1 do
                table.insert(Pixels, ColorR)
                table.insert(Pixels, ColorG)
                table.insert(Pixels, ColorB)
                table.insert(Pixels, TransparentAlpha)
            end
            table.insert(Pixels, ColorR)
            table.insert(Pixels, ColorG)
            table.insert(Pixels, ColorB)
            table.insert(Pixels, EdgeAlpha)
            for _ = 1, VisiblePixelWidth do
                table.insert(Pixels, ColorR)
                table.insert(Pixels, ColorG)
                table.insert(Pixels, ColorB)
                table.insert(Pixels, OpagueAlpha)
            end
        else
            for _ = 1, VisiblePixelWidth do
                table.insert(Pixels, ColorR)
                table.insert(Pixels, ColorG)
                table.insert(Pixels, ColorB)
                table.insert(Pixels, OpagueAlpha)
            end
            table.insert(Pixels, ColorR)
            table.insert(Pixels, ColorG)
            table.insert(Pixels, ColorB)
            table.insert(Pixels, EdgeAlpha)
            for _ = 1, Size - VisiblePixelWidth - 1 do
                table.insert(Pixels, ColorR)
                table.insert(Pixels, ColorG)
                table.insert(Pixels, ColorB)
                table.insert(Pixels, TransparentAlpha)
            end
        end
    end

    --Apply the pixels.
    self.EditableImage:WritePixels(TopLeftPosition, Vector2.new(Size, Size), Pixels)

    --Return the wrapper.
    return self
end

--[[
Draws a rounded corner.
Returns the original wrapper to allow for chaining.
--]]
function EditableImageWrapper.DrawRoundedCorner(self: EditableImageWrapper, Corner: Corner, TopLeftPosition: Vector2, Radius: number, Color: Color3?, Transparency: number?): EditableImageWrapper
    --Create the base image with the corner.
    local CornerImage = Instance.new("EditableImage")
    CornerImage.Size = Vector2.new(Radius, Radius)
    local CircleCenter = Vector2.zero
    if Corner == "TopLeft" then
        CircleCenter = Vector2.new(Radius, Radius)
    elseif Corner == "TopRight" then
        CircleCenter = Vector2.new(0, Radius)
    elseif Corner == "BottomLeft" then
        CircleCenter = Vector2.new(Radius, 0)
    end
    CornerImage:DrawCircle(CircleCenter, Radius, Color or DEFAULT_COLOR, Transparency or DEFAULT_TRANSPARENCY, Enum.ImageCombineType.BlendSourceOver)

    --Apply the corner.
    self.EditableImage:DrawImage(TopLeftPosition, CornerImage, Enum.ImageCombineType.BlendSourceOver)

    --Return the wrapper.
    return self
end



return EditableImageWrapper