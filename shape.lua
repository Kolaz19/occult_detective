local shape = {}
shape.__index = shape

function shape:initPhysics(world, formVariant)
    self.physicsObject = {
        body = love.physics.newBody(world, self.x, self.y, "dynamic"),
    }
    if GetShapeFromVariant(formVariant) == FORM.square then
        self.physicsObject.shape = love.physics.newRectangleShape(self.width, self.height)
    elseif GetShapeFromVariant(formVariant) == FORM.circle then
        self.physicsObject.shape = love.physics.newCircleShape(self.height)
    end
    self.physicsObject.fixture = love.physics.newFixture(self.physicsObject.body, self.physicsObject.shape)
    self.physicsObject.fixture:setSensor(true)
end

---comment
---@param id string
---@param formVariant number
---@param connectionLimit number
---@param reach number
---@param height number
---@param width number
---@param x number
---@param y number
---@param score number
---@param world table physics world
---@return table
shape.new = function(id, formVariant, connectionLimit, reach, height, width, x, y, score, world)
    local shapeInstance = {}
    setmetatable(shapeInstance, shape)
    shapeInstance.id = id
    shapeInstance.formVariant = formVariant
    shapeInstance.isPlaced = false
    shapeInstance.connectionLimit = connectionLimit
    shapeInstance.reach = reach
    shapeInstance.height = height
    shapeInstance.width = width
    shapeInstance.x = x
    shapeInstance.y = y
    shapeInstance.score = score
    shapeInstance.connections = {}

    shapeInstance:initPhysics(world,formVariant)

    return shapeInstance
end

function shape:update()
    if self.isPlaced == true then return end
    if not love.mouse.isDown(1) then return end

end

return shape
