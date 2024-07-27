local r = { windowScale = 0.8, maxWindowHeight = 0 }
local shape = require('shape')
local round = require('round')
local game = require('game').new(1000, {})
ShapeIdentifier = 0

local function getRandomVariant()
    local randomNumber = love.math.random(VARIANT_COUNT)

    for index, value in pairs(FORM_VARIANTS) do
        if (value.id == randomNumber) then
            return FORM_VARIANTS[index]
        end
    end
end

local function generateShapes(amount, world)
    local shapes = {}
    for i = 1, amount, 1 do
        local newShape = shape.new(getRandomVariant(), world)
        table.insert(shapes, newShape)
    end

    return shapes
end

function r:init()
    --Set screen to max size
    Cam = require('cam').setupCam(r.maxWindowHeight, r.windowScale)
    Cam:lookAt(0, 0)
    Cam:zoom(0.2)

    FirstShape = shape.new(FORM_VARIANTS.circleOne, game.world)
    SecondShape = shape.new(FORM_VARIANTS.circleOne, game.world)

    local initialShape = shape.new(FORM_VARIANTS.circleOne, game.world)
    table.insert(game.placedShapes, initialShape)

    ---@diagnostic disable-next-line: need-check-nil
    game.rounds = round.new(generateShapes(7, game.world))

    --[[
    local sti = require('lib.STI')
    Map = sti("assets/maps/dungeon.lua")
    --]]
end

function r:keypressed(key, scancode, isrepeat)
    if key == 'f' then
        local camConfig = require 'cam'
        love.window.setFullscreen(camConfig.adjustCamToWindow(Cam))
    end
    if key == 's' then
        SecondShape.physicsObject.body:applyLinearImpulse(-4, -4)
    end
end

function r:update(dt)
    --Map:update(dt)
    local camConfig = require 'cam'
    camConfig:moveCamWithMouse()

    local oneActive = false
    for _, value in ipairs(game.rounds.providedShapes) do
	if value.isActive then
	    if (value:updateStatus()) then
		oneActive = true
	    end
        end
    end

    if not oneActive then
	for _, value in ipairs(game.rounds.providedShapes) do
	    if (value:updateStatus()) then
		break
	    end
	end
    end

    for index, value in ipairs(game.rounds.providedShapes) do
        value:updatePos(index)
    end
    game.world:update(dt)
end

function r:draw()
    Cam:attach()
    love.graphics.rectangle("line", 0, 0, 50, 50)
    for _,shapeInstance in ipairs(game.rounds.providedShapes) do
	love.graphics.circle("fill",
	    shapeInstance.physicsObject.body:getX(),
	    shapeInstance.physicsObject.body:getY(),
	    shapeInstance.physicsObject.shape:getRadius())
    end
    Cam:detach()
end

function r:enter(previous)
end

return r
