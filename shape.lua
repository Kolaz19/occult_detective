local shape = {}
shape.__index = shape

---comment
---@param id string
---@param form string
---@param isPlaced boolean
---@param connectionLimit number
---@param connections table
---@param variant table
---@param reach number
---@param height number
---@param width number
---@param x number
---@param y number
---@param score number
---@param world table physics world
---@return table
shape.new = function(id, form, isPlaced, connectionLimit, connections, variant, reach, height, width, x, y, score, world)
    local shapeInstance = {}
    shapeInstance.id = id
    shapeInstance.form = form
    shapeInstance.isPlaced = isPlaced
    shapeInstance.connectionLimit = connectionLimit
    shapeInstance.connections = connections
    shapeInstance.variant = variant
    shapeInstance.reach = reach
    shapeInstance.height = height
    shapeInstance.width = width
    shapeInstance.x = x
    shapeInstance.y = y
    shapeInstance.score = score

    shapeInstance.physicsObject = {
	body = love.physics.newBody(world,x,y, "dynamic"),
    }
    if form == FORM.SQUARE then
	shapeInstance.physicsObject.shape = love.physics.newRectangleShape(width, height)
    elseif form == FORM.CIRCLE then
	shapeInstance.physicsObject.shape = love.physics.newCircleShape(height)
    end
    shapeInstance.physicsObject.fixture(shapeInstance.physicsObject.body, shapeInstance.physicsObject.shape)

    setmetatable(shapeInstance, shape)
    return shapeInstance
end

return shape
