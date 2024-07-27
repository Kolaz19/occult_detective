local shape = {}
local vector = require 'lib.vector'
shape.__index = shape

function shape:initPhysics(world)
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

    ShapeIdentifier = ShapeIdentifier + 1
    shapeInstance.id = ShapeIdentifier

    shapeInstance.formVariant = formVariant
    shapeInstance.isPlaced = false
    shapeInstance.isActive = false
    shapeInstance.height = formVariant.radius * 2
    shapeInstance.width = 0
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

local function setPositionForProvided(self, index)
    --Calculate base position
    self.pos.x = Cam.x + 90 - love.graphics.getWidth() / 2
    self.pos.y = Cam.y - 120 + love.graphics.getHeight() / 2
    --Offset based on index
    self.pos.x = self.pos.x + (80 * (index - 1))
    self.physicsObject.body:setPosition(self.pos.x, self.pos.y)
end

function shape:updateStatus()
    if self.isPlaced then return end
    if self.isActive and love.mouse.isDown(1) then
        self.physicsObject.fixture:setSensor(true)
        return self.isActive
    elseif love.mouse.isDown(1) and isMouseInsideShape(self) then
        self.isActive = true
        self.physicsObject.fixture:setSensor(true)
        return self.isActive
    elseif self.isActive and not love.mouse.isDown(1) then
        self.isActive = false
        self.isPlaced = true
        self.physicsObject.fixture:setSensor(false)
        return self.isActive
    end
end

---@param index integer Index in placedTiles table
function shape:updatePos(index)
    self.pos.x, self.pos.y = self.physicsObject.body:getPosition()
    if self.isPlaced then return end

    if self.isActive then
        followMouse(self)
    else
        setPositionForProvided(self, index)
    end
end

return shape
