local vector = require 'lib.vector'

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
local shape = {}
shape.__index = shape
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
