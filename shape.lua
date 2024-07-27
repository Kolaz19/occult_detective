local shape = {}
local vector = require 'lib.vector'
shape.__index = shape

function shape:initPhysics(world, formVariant)
    self.physicsObject = {
        body = love.physics.newBody(world, self.pos.x, self.pos.y, "dynamic"),
    }
    if formVariant.form == FORM.square then
        self.physicsObject.shape = love.physics.newRectangleShape(self.width, self.height)
    elseif formVariant.form == FORM.circle then
        self.physicsObject.shape = love.physics.newCircleShape(self.height)
    end
    self.physicsObject.fixture = love.physics.newFixture(self.physicsObject.body, self.physicsObject.shape)
    self.physicsObject.fixture:setSensor(true)
end

---comment
---@param id number
---@param formVariant table
---@param height number
---@param width number
---@param x number
---@param y number
---@param score number
---@param world table physics world
---@return table
shape.new = function(id, formVariant, height, width, x, y, score, world)
    local shapeInstance = {}
    setmetatable(shapeInstance, shape)

    ShapeIdentifier = id + 1
    shapeInstance.id = ShapeIdentifier

    shapeInstance.formVariant = formVariant
    shapeInstance.isPlaced = false
    shapeInstance.isActive = false
    shapeInstance.height = height
    shapeInstance.width = width
    shapeInstance.pos = vector.new(x, y)
    shapeInstance.score = score
    shapeInstance.connections = {}
    print(#FORM_VARIANTS)

    shapeInstance:initPhysics(world, formVariant)

    return shapeInstance
end

local getRandomVariant = function()
    local randomNumber = love.math.random(VARIANT_COUNT)

    for index, value in pairs(FORM_VARIANTS) do
        if (value.id == randomNumber) then
            return FORM_VARIANTS[index]
        end
    end
end

local generateShapes = function(amount, world)
    local shapes = {}
    for i = 1, amount, 1 do
        local newShape = shape.new(ShapeIdentifier, getRandomVariant(), 50, 0, 0, 0, 100, world)
        table.insert(shapes, newShape)
    end

    return shapes
end

function shape:update()
    self.pos.x, self.pos.y = self.physicsObject.body:getPosition()
    if self.isPlaced == true then return end
    if not love.mouse.isDown(1) then
        return
    else
        self.physicsObject.fixture:setSensor(true)
    end

    local curMousePos = vector.new(Cam:worldCoords(love.mouse.getPosition()))
    local distance = self.pos:dist(curMousePos)

    if distance < self.physicsObject.shape:getRadius() then
        self.physicsObject.fixture:setSensor(false)
        self.physicsObject.body:setPosition(curMousePos.x, curMousePos.y)
    end
end

return shape, generateShapes
