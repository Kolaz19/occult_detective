local shape = {}
shape.__index = shape

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

    shapeInstance.physicsObject = {
        body = love.physics.newBody(world, x, y, "dynamic"),
    }
    if GetShapeFromVariant(formVariant) == FORM.SQUARE then
        shapeInstance.physicsObject.shape = love.physics.newRectangleShape(width, height)
    elseif GetShapeFromVariant(formVariant) == FORM.CIRCLE then
        shapeInstance.physicsObject.shape = love.physics.newCircleShape(height)
    end
    shapeInstance.physicsObject.fixture = love.physics.newFixture(shapeInstance.physicsObject.body, shapeInstance.physicsObject.shape)

    setmetatable(shapeInstance, shape)
    return shapeInstance
end

shape.update = function()

end

return shape
