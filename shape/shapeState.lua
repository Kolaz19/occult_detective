---@class shapeState
---@field updateState fun(shape: shape): states
---@field update fun(shape: shape)
local shapeState = {}
shapeState.__index = shapeState

---@param updateState fun(shape: shape): string
---@param update fun(shape: shape)
function shapeState:new(updateState, update)
    local new = setmetatable({},self)
    new.updateState = updateState
    new.update = update
end

---@enum states
local states = {
    PLACED = nil,
    ACTIVE = nil,
    PROVIDED = nil
}

local function isMouseInsideShape(shape)
    local vector = require 'lib.vector'
    local curMousePos = vector.new(Cam:worldCoords(love.mouse.getPosition()))
    local distance = shape.pos:dist(curMousePos)

    if distance < shape.physicsObject.shape:getRadius() then
        return true
    else
        return false
    end
end

local function isUnderThresholdScreen()
    local vector = require 'lib.vector'
    local curMousePos = vector.new(Cam:worldCoords(love.mouse.getPosition()))
    if curMousePos.y > Cam.y + 500 then
        return true
    else
        return false
    end
end

states.PLACED = shapeState:new(
function(shape)
    return states.PLACED
end,
function(shape)
end
)

states.ACTIVE = shapeState:new(
function(shape)
    if not love.mouse.isDown(1) then
	if isUnderThresholdScreen() then
	    return states.PROVIDED
	else
	    return states.PLACED
	end
    end

	return 

	--we also have to remove connection in connected shape
	for key, val in ipairs(self.connections) do
	    for keyIn, valIn in ipairs(val.connections) do
		if valIn == self then
		    table.remove(val.connections, keyIn)
		end
	    end
	    self.connections[key] = nil
	end
    end
    return states.ACTIVE
end,
function(shape)
    shape.physicsObject.fixture:setSensor(true)
end
)

states.PROVIDED = shapeState:new(
function(shape)
    if love.mouse.isDown(1) and isMouseInsideShape(shape) then
	return states.ACTIVE
    end
    return states.PROVIDED
end,
function(shape)
    shape.physicsObject.fixture:setSensor(false)
end
)
return states
