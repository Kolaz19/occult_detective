local shapeState = require "shape.shapeState"
local vector = require 'lib.vector'


local function isUnderThresholdScreen()
    local curMousePos = vector.new(Cam:worldCoords(love.mouse.getPosition()))
    if curMousePos.y > Cam.y + 500 then
        return true
    else
        return false
    end
end

local function followMouse(shape)
    local curMousePos = vector.new(Cam:worldCoords(love.mouse.getPosition()))
    shape.physicsObject.body:setPosition(curMousePos.x, curMousePos.y)
end

return shapeState:new(
--Update state
function(shape)
    if not love.mouse.isDown(1) then
	if isUnderThresholdScreen() then
	    return ShapeStates.PROVIDED
	else
	    return ShapeStates.PLACED
	end
    end

    return ShapeStates.ACTIVE
end,

--Update
function(shape)
    followMouse(shape)
end,

--Enter
function(shape)
    shape.physicsObject.fixture:setSensor(true)
end,

--draw
function(shape)
    local scaleImg = 0.35
    local scaleShift = 10
    love.graphics.draw(shape.formVariant.iconImage,
        shape.pos.x - shape.formVariant.shiftX - scaleShift,
        shape.pos.y - shape.formVariant.shiftY - scaleShift,
        0,
        shape.formVariant.imgScale * scaleImg,
        shape.formVariant.imgScale * scaleImg)
    love.graphics.setColor(1, 1, 1)
end
)
