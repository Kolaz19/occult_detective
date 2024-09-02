local shapeState = require "shape.shapeState"

local function drawLines(shape)
    for _, con in ipairs(shape.connections) do
	if con.currentState == ShapeStates.PLACED then
	    love.graphics.setColor(love.math.colorFromBytes(153, 0, 0))
	else
	    love.graphics.setColor(love.math.colorFromBytes(0, 204, 0))
	end
        love.graphics.line(shape.pos.x, shape.pos.y, con.pos.x, con.pos.y)
        love.graphics.setColor(1, 1, 1)
    end
end

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
    drawLines(shape)
    love.graphics.setColor(1, 1, 1)
end
)
