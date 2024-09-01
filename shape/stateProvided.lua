local shapeState = require "shape.shapeState"



local function setPositionForProvided(shape)
    --Calculate base position
    shape.pos.x = (Cam.x + 1900 - 1920) / 2
    shape.pos.y = (Cam.y + 500 + 1080) / 2
    --Offset based on index
    shape.pos.x = shape.pos.x + (200 * (shape.roundIndex - 1))
    shape.physicsObject.body:setPosition(shape.pos.x, shape.pos.y)
end

return shapeState:new(
--Update state
function(shape)
    if love.mouse.isDown(1) and shape:isMouseInsideShape() then
	return ShapeStates.ACTIVE
    end
    return ShapeStates.PROVIDED
end,

--Update
function(shape)
end,

--Enter
function(shape)
    setPositionForProvided(shape)
    shape.physicsObject.fixture:setSensor(true)
    --we also have to remove connection in connected shape
    for key, val in ipairs(shape.connections) do
	for keyIn, valIn in ipairs(val.connections) do
	    if valIn == shape then
		table.remove(val.connections, keyIn)
	    end
	end
	shape.connections[key] = nil
    end
end,

--draw
function(shape)
    if shape.hintTimeCounter > 0 then
        --Highlight object when mouse hovered
        love.graphics.setColor(love.math.colorFromBytes(255, 255, 153))
    end
    local scaleImg = 0.3
    local scaleShift = 0
    love.graphics.draw(shape.formVariant.iconImage,
        shape.pos.x - shape.formVariant.shiftX - scaleShift,
        shape.pos.y - shape.formVariant.shiftY - scaleShift,
        0,
        shape.formVariant.imgScale * scaleImg,
        shape.formVariant.imgScale * scaleImg)
    love.graphics.setColor(1, 1, 1)
end
)
