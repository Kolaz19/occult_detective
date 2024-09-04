local vector = require 'lib.vector'
require 'shape.globalShapeStates'

---@class shape
---@field connections table
---@field formVariant formVariant
---@field isPlaced boolean
---@field isActive boolean
---@field height integer
---@field width integer
---@field pos table
---@field wasDropped boolean
---@field hintTimeCounter number
---@field scoreCalculated boolean
---@field scoreCalcLeft integer
---@field currentState shapeState
---@field roundIndex integer
local shape = {}
shape.__index = shape
--Seconds until popup shows
local hintCounterLimit = 0.3

function shape:new(formVariant, world, roundIndex)
    local new = setmetatable({}, shape)

    new.formVariant = formVariant
    new.isPlaced = false
    new.isActive = false
    new.height = formVariant.bodyRadius * 2
    new.width = 0
    new.pos = vector.new(0, 0)
    new.wasDropped = false
    new.connections = {}
    new.hintTimeCounter = 0
    new.scoreCalculated = false
    new.scoreCalcLeft = 0
    new:initPhysics(world)
    new.roundIndex = roundIndex
    new.currentState = ShapeStates.PROVIDED
    new.currentState.enter(new)

    return new
end

function shape:initPhysics(world)
    self.physicsObject = {
        body = love.physics.newBody(world, self.pos.x, self.pos.y, "dynamic"),
    }

    self.physicsObject.shape = love.physics.newCircleShape(self.height)
    self.physicsObject.fixture = love.physics.newFixture(self.physicsObject.body, self.physicsObject.shape)
    self.physicsObject.fixture:setSensor(true)
end

function shape:isVariant(variantName)
    return self.formVariant:isVariant(variantName)
end

function shape:addConnection(partner)
    --Check if partner is shape or partner was already added
    if self == partner then return end
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

function shape:isMouseInsideShape()
    local curMousePos = vector.new(Cam:worldCoords(love.mouse.getPosition()))
    local distance = self.pos:dist(curMousePos)

    if distance < self.physicsObject.shape:getRadius() then
        return true
    else
        return false
    end
end

function shape:destroyShape()
    self.physicsObject.body:destroy()
end

function shape:addScoreToCount()
    self.scoreCalcLeft = self.formVariant:getScore(self)
    if self.scoreCalcLeft == 0 then
        self.scoreCalculated = true
    end
end

function shape:subScore(fast)
    local modifier = 0
    if fast == true then
	modifier = 1
    end

    if self.scoreCalcLeft > 0 then
        self.scoreCalcLeft = self.scoreCalcLeft - 1 - modifier
	if self.scoreCalcLeft == 0 then
	    self.scoreCalculated = true
	    return 1 + modifier
	elseif self.scoreCalcLeft < 0 then
	    self.scoreCalcLeft = 0
	    self.scoreCalculated = true
	    return 1
	end
	return 1 + modifier
    elseif self.scoreCalcLeft < 0 then
        self.scoreCalcLeft = self.scoreCalcLeft + 1 + modifier
        if self.scoreCalcLeft == 0 then
	    self.scoreCalculated = true
	    return -1 - modifier
	elseif self.scoreCalcLeft > 0 then
	    self.scoreCalcLeft = 0
	    self.scoreCalculated = true
	    return -1
	end
	return -1 - modifier
    end
end


function shape:update(dt)
    if not love.mouse.isDown(1) and self:isMouseInsideShape() then
        if self.hintTimeCounter < hintCounterLimit then
            self.hintTimeCounter = self.hintTimeCounter + dt
        end
    else
	--Active state does also set timer to 0
        self.hintTimeCounter = 0
    end

    local newState = self.currentState.updateState(self)
    if newState ~= self.currentState then
	newState.enter(self)
    end
    self.currentState = newState
    self.currentState.update(self)
    self.pos.x, self.pos.y = self.physicsObject.body:getPosition()
end

function shape:draw()
    self.currentState.draw(self)
end

function shape:drawLines()
    for _, con in ipairs(self.connections) do
	if con.currentState == ShapeStates.PLACED then
	    love.graphics.setColor(love.math.colorFromBytes(153, 0, 0))
	else
	    love.graphics.setColor(love.math.colorFromBytes(0, 204, 0))
	end
        love.graphics.line(self.pos.x, self.pos.y, con.pos.x, con.pos.y)
        love.graphics.setColor(1, 1, 1)
    end
end

function shape:drawHint()
    if self.hintTimeCounter >= hintCounterLimit and self.scoreCalcLeft == 0 then
        love.graphics.draw(self.formVariant.hintImage, 1900, 160, 0, 3, 3)
    end
end

function shape:drawScore(backgroundSize)
    if self.scoreCalcLeft > 0 then
        love.graphics.setColor(love.math.colorFromBytes(0, 255, 0))
    elseif self.scoreCalcLeft < 0 then
        love.graphics.setColor(love.math.colorFromBytes(255, 0, 0))
    else
	return
    end
---@diagnostic disable-next-line: param-type-mismatch
    love.graphics.print(self.scoreCalcLeft, backgroundSize - 315, 120, 0, 2, 2)
    love.graphics.setColor(1, 1, 1)
end

return shape
