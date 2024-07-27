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
    shapeInstance.connections = {}
    shapeInstance.wasDropped = false

    shapeInstance.scoreCalculated = false
    shapeInstance.scoreCalcLeft = 0

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
    self.pos.x = Cam.x + 160 - love.graphics.getWidth() / 2
    self.pos.y = Cam.y - 120 + love.graphics.getHeight() / 2
    --Offset based on index
    self.pos.x = self.pos.x + (150 * (index - 1))
    self.physicsObject.body:setPosition(self.pos.x, self.pos.y)
end

local function isUnderThresholdScreen(self)
    local curMousePos = vector.new(Cam:worldCoords(love.mouse.getPosition()))
    if curMousePos.y > Cam.y + 250 then
        return true
    else
        return false
    end
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
        if isUnderThresholdScreen(self) then
            self.physicsObject.fixture:setSensor(true)
            --we also have to remove connection in connected shape
            for key, val in ipairs(self.connections) do
                for keyIn, valIn in ipairs(val.connections) do
                    if valIn == self then
                        table.remove(val.connections, keyIn)
                    end
                end
                self.connections[key] = nil
            end
        else
            self.isPlaced = true
            self.physicsObject.fixture:setSensor(false)
            self.wasDropped = true
        end
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

function shape:removeConnections()
    for index, val in ipairs(self.connections) do
        if self.pos:dist(val.pos) > (self.formVariant.reach + val.formVariant.reach) then
            table.remove(self.connections, index)
            break
        end
    end
end

function shape:addConnection(partner)
    for _, val in ipairs(self.connections) do
        if partner == val then
            return
        end
    end

    --Connection limit
    if self.formVariant.connectionLimit <= #(self.connections)
        or partner.formVariant.connectionLimit <= #(partner.connections) then
        return
    end

    --Add when distance is right
    if self.pos:dist(partner.pos) < (self.formVariant.reach + partner.formVariant.reach) then
        table.insert(self.connections, partner)
        table.insert(partner.connections, self)
    end
end

function shape:addScoreToCount()
    self.scoreCalcLeft = self.formVariant.score(self)
    if self.scoreCalcLeft == 0 then
        self.scoreCalculated = true
    end
end

function shape:subScore()
    if self.scoreCalcLeft > 0 then
        self.scoreCalcLeft = self.scoreCalcLeft - 1
        if self.scoreCalcLeft == 0 then self.scoreCalculated = true end
        return 1
    elseif self.scoreCalcLeft < 0 then
        self.scoreCalcLeft = self.scoreCalcLeft + 1
        if self.scoreCalcLeft == 0 then self.scoreCalculated = true end
        return -1
    else
    end
end

function shape:drawScore()
    if self.scoreCalcLeft > 0 then
        love.graphics.setColor(love.math.colorFromBytes(0, 255, 0))
    else
        love.graphics.setColor(love.math.colorFromBytes(255, 0, 0))
    end
    love.graphics.print(self.scoreCalcLeft, 1875, 60, 0, 3, 3)
    love.graphics.setColor(1, 1, 1)
end

function shape:draw()
    if self.scoreCalcLeft > 0 then
        --love.graphics.setColor(love.math.colorFromBytes(229,255,204))
        love.graphics.setColor(love.math.colorFromBytes(102, 255, 102))
    elseif self.scoreCalcLeft < 0 then
        --love.graphics.setColor(love.math.colorFromBytes(255,204,204))
        love.graphics.setColor(love.math.colorFromBytes(255, 102, 102))
    end
    love.graphics.draw(self.formVariant.img, self.pos.x - self.formVariant.shiftX, self.pos.y - self.formVariant.shiftY,
        0, 0.3, 0.3)
    love.graphics.setColor(1, 1, 1)
    --[[
    love.graphics.circle("fill",
    self.physicsObject.body:getX(),
    self.physicsObject.body:getY(),
    self.physicsObject.shape:getRadius())
    --]]
    for _, con in ipairs(self.connections) do
        if con.isActive or self.isActive then
            love.graphics.setColor(love.math.colorFromBytes(255, 0, 255))
        end
        love.graphics.line(self.pos.x, self.pos.y, con.pos.x, con.pos.y)
        love.graphics.setColor(1, 1, 1)
    end
end

return shape
