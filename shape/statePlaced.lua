local shapeState = require "shape.shapeState"

return shapeState:new(
--Update state
function(shape)
    return ShapeStates.PLACED
end,

--Update
function(shape)
    shapeState.removeConnectionsDistance(shape)
end,

--Enter
function(shape)
    shape.physicsObject.fixture:setSensor(false)
end,

--draw
function(shape)

    if shape.scoreCalcLeft > 0 then
        love.graphics.setColor(love.math.colorFromBytes(102, 255, 102))
    elseif shape.scoreCalcLeft < 0 then
        love.graphics.setColor(love.math.colorFromBytes(255, 102, 102))
    elseif shape.hintTimeCounter > 0 then
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
    shapeState.drawLines(shape)
end
)
