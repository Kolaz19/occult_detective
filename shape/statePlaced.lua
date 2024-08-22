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
end
)
