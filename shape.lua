require 'formVariants.formVariant'
---@class shape
---@field connections table
---@field formVariant formVariant
local shape = {}
shape.connections = {}
local vector = require 'lib.vector'
shape.__index = shape
--Seconds until popup shows
local hintCounterLimit = 0.3

function shape:initPhysics(world)
    self.physicsObject = {
        body = love.physics.newBody(world, self.pos.x, self.pos.y, "dynamic"),
    }

    self.physicsObject.shape = love.physics.newCircleShape(self.height)
    self.physicsObject.fixture = love.physics.newFixture(self.physicsObject.body, self.physicsObject.shape)
    self.physicsObject.fixture:setSensor(true)
end

---@param formVariant formVariant
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
    shapeInstance.height = formVariant.bodyRadius * 2
    shapeInstance.width = 0
    shapeInstance.pos = vector.new(0, 0)
    shapeInstance.wasDropped = false
    shapeInstance.connections = {}

    shapeInstance.hintTimeCounter = 0

    shapeInstance.scoreCalculated = false
    shapeInstance.scoreCalcLeft = 0

    shapeInstance:initPhysics(world)

    return shapeInstance
end



local function followMouse(self)
    local curMousePos = vector.new(Cam:worldCoords(love.mouse.getPosition()))
    self.physicsObject.body:setPosition(curMousePos.x, curMousePos.y)
end

function shape:isVariant(variantName)
    return self.formVariant:isVariant(variantName)
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

local function setPositionForProvided(self, index, backgroundWidth, backgroundHeight)
    --Calculate base position
    self.pos.x = (Cam.x + 1900 - backgroundWidth) / 2
    self.pos.y = (Cam.y + 500 + backgroundHeight) / 2
    --Offset based on index
    self.pos.x = self.pos.x + (200 * (index - 1))
    self.physicsObject.body:setPosition(self.pos.x, self.pos.y)
end

local function isUnderThresholdScreen(self)
    local curMousePos = vector.new(Cam:worldCoords(love.mouse.getPosition()))
    if curMousePos.y > Cam.y + 500 then
        return true
    else
        return false
    end
end

function shape:updateStatus(dt)
    if not love.mouse.isDown(1) and isMouseInsideShape(self) then
        if self.hintTimeCounter < hintCounterLimit then
            self.hintTimeCounter = self.hintTimeCounter + dt
        end
    else
        self.hintTimeCounter = 0
    end

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
	    Music.pin:play()
            self.isPlaced = true
            self.physicsObject.fixture:setSensor(false)
            self.wasDropped = true
        end
        return self.isActive
    end
end

---@param index integer Index in placedTiles table
function shape:updatePos(index, backgroundWidth, backgroundHeight)
    self.pos.x, self.pos.y = self.physicsObject.body:getPosition()
    if self.isPlaced then return end

    if self.isActive then
        followMouse(self)
    else
        setPositionForProvided(self, index, backgroundWidth, backgroundHeight)
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

function shape:drawScore(backgroundSize)
    if self.scoreCalcLeft > 0 then
        love.graphics.setColor(love.math.colorFromBytes(0, 255, 0))
    else
        love.graphics.setColor(love.math.colorFromBytes(255, 0, 0))
    end
    love.graphics.print(self.scoreCalcLeft, backgroundSize - 315, 120, 0, 2, 2)
    love.graphics.setColor(1, 1, 1)
end

function shape:drawHint()
    if self.hintTimeCounter >= hintCounterLimit then
        love.graphics.draw(self.formVariant.hintImage, 1900, 160, 0, 3, 3)
    end
end

function shape:destroyShape()
    self.physicsObject.body:destroy()
end

function shape:draw()
    local scaleImg = 0.3
    local scaleShift = 0
    if self.scoreCalcLeft > 0 then
        love.graphics.setColor(love.math.colorFromBytes(102, 255, 102))
    elseif self.scoreCalcLeft < 0 then
        love.graphics.setColor(love.math.colorFromBytes(255, 102, 102))
    elseif self.hintTimeCounter > 0 then
        --Highlight object when mouse hovered
        love.graphics.setColor(love.math.colorFromBytes(255, 255, 153))
    end

    if self.isActive == true then
        scaleImg = 0.35
        scaleShift = 10
    end

    love.graphics.draw(self.formVariant.iconImage,
        self.pos.x - self.formVariant.shiftX - scaleShift,
        self.pos.y - self.formVariant.shiftY - scaleShift,
        0,
        self.formVariant.imgScale * scaleImg,
        self.formVariant.imgScale * scaleImg)
    love.graphics.setColor(1, 1, 1)

    --[[
    love.graphics.circle("fill",
        self.physicsObject.body:getX(),
        self.physicsObject.body:getY(),
        self.physicsObject.shape:getRadius())
	--]]

    for _, con in ipairs(self.connections) do
        if con.isActive or self.isActive then
            --love.graphics.setColor(love.math.colorFromBytes(0, 204, 0))
	else
            love.graphics.setColor(love.math.colorFromBytes(153, 0, 0))
        end
        love.graphics.line(self.pos.x, self.pos.y, con.pos.x, con.pos.y)
        love.graphics.setColor(1, 1, 1)
    end
end

return shape
