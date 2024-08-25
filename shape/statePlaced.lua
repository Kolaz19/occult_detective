local shapeState = require "shape.shapeState"

return shapeState:new(
--Update state
function(shape)
    return ShapeStates.PLACED
end,

--Update
function(shape)
end,

--Enter
function(shape)
    shape.physicsObject.fixture:setSensor(false)
end,

--draw
function(shape)
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
