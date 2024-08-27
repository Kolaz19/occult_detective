local vector = require 'lib.vector'
local states = require 'shape.globalShapeStates'

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
local shape = {}
shape.__index = shape
shape.currentState = ShapeStates.PROVIDED
shape.connections = {}
shape.formVariant = nil
shape.pos = vector.new(0, 0)
--Seconds until popup shows
local hintCounterLimit = 0.3

function shape:new(formVariant, world)
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

function shape:update()
    local newState = self.currentState.updateState(self)
    if newState ~= self.currentState then
	newState.enter(self)
    end
    self.currentState = newState
    self.currentState.update(self)
end

function shape:draw()
    self.currentState.draw(self)
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
