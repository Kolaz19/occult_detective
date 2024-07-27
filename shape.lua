local shape = {}
local vector = require 'lib.vector'
shape.__index = shape

function shape:initPhysics(world, formVariant)
    self.physicsObject = {
        body = love.physics.newBody(world, self.pos.x, self.pos.y, "dynamic"),
    }

    self.physicsObject.shape = love.physics.newCircleShape(self.height)
    self.physicsObject.fixture = love.physics.newFixture(self.physicsObject.body, self.physicsObject.shape)
    self.physicsObject.fixture:setSensor(true)
end

---comment
---@param formVariant table
---@param world table physics world
---@return table
shape.new = function(formVariant, world)
    local shapeInstance = {}
    setmetatable(shapeInstance, shape)
    local height = 0
    local width = 0
    if formVariant.form == FORM.circle then
        height = formVariant.radius * 2
        width = 0
    else
        height = formVariant.height
        width = formVariant.width
    end

    ShapeIdentifier = ShapeIdentifier + 1
    shapeInstance.id = ShapeIdentifier

    shapeInstance.formVariant = formVariant
    shapeInstance.isPlaced = false
    shapeInstance.isActive = false
    shapeInstance.height = height
    shapeInstance.width = width
    shapeInstance.pos = vector.new(0, 0)
    shapeInstance.score = 100
    shapeInstance.connections = {}

    shapeInstance:initPhysics(world, formVariant)

    return shapeInstance
end



local function followMouse(self)
    local curMousePos = vector.new(Cam:worldCoords(love.mouse.getPosition()))
    self.physicsObject.body:setPosition(curMousePos.x, curMousePos.y)
end

local function isMouseInsideShape(self)
    local curMousePos = vector.new(Cam:worldCoords(love.mouse.getPosition()))
    local distance = self.pos:dist(curMousePos)

    if distance < self.physicsObject.shape:getRadius() then
	return true
    else
	return false
    end
end

function shape:update()
    self.pos.x, self.pos.y = self.physicsObject.body:getPosition()
    if self.isPlaced then return end

    if self.isActive then
	if love.mouse.isDown(1) then
	    followMouse(self)
	else
	    self.isActive = false
	    --place or logic to place it back
	    --self.physicsObject.fixture:setSensor(true)
	end
    else
	if love.mouse.isDown(1) and isMouseInsideShape(self) then
	    --follow when inside shape
	    self.isActive = true
	    self.physicsObject.fixture:setSensor(false)
	    followMouse(self)
	else
	    return
	end
    end


end

return shape
