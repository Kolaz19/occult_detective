local r = { windowScale = 0.8, maxWindowHeight = 0 }
local shape = require('shape')
local round = require('round')
local game = require('game'):new(1000, 20)

function r:init()
    --Set screen to max size
    Cam = require('cam').setupCam(r.maxWindowHeight, r.windowScale)
    Cam:lookAt(0, 0)
    Cam:zoom(1.2)

    FirstShape = shape.new("123", FORM_VARIANTS.circle[1],4,50,30,50, 0,0,40,game.world)
    SecondShape = shape.new("123", FORM_VARIANTS.circle[1],4,50,30,50, 50,50,40,game.world)
    --local providedShapes = { { shape.new(1, {}) } }

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
	SecondShape.physicsObject.body:applyLinearImpulse(-4,-4)
    end
end

function r:update(dt)
    --Map:update(dt)
    local camConfig = require 'cam'
    camConfig:moveCamWithMouse()
    game.world:update(dt)
end

function r:draw()
    Cam:attach()
    love.graphics.rectangle("line", 0, 0, 50, 50)
    love.graphics.circle("fill",

    FirstShape.physicsObject.body:getX(),
    FirstShape.physicsObject.body:getY(),
    FirstShape.physicsObject.shape:getRadius())

    love.graphics.circle("fill",
    SecondShape.physicsObject.body:getX(),
    SecondShape.physicsObject.body:getY(),
    SecondShape.physicsObject.shape:getRadius())

    Cam:detach()
end

function r:enter(previous)
end

return r
