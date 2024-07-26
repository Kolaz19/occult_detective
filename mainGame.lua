local r = { windowScale = 0.8, maxWindowHeight = 0 }
local shape = require('shape')
local round = require('round')
local game = require('game'):new(1000, 20)

function r:init()
    --Set screen to max size
    Cam = require('cam').setupCam(r.maxWindowHeight, r.windowScale)
    Cam:lookAt(0, 0)
    Cam:zoom(0.8)

    local firstShape = shape.new("123", FORM_VARIANTS.square[1],4,50,50,50, 0,0,40,game.world)
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
end

function r:update(dt)
    --Map:update(dt)
    local camConfig = require 'cam'
    camConfig:moveCamWithMouse()
    game.world:update(dt)
end

function r:draw()
    Cam:attach()
    love.graphics.rectangle("line", 0, 0, 90, 90)
    Cam:detach()
end

function r:enter(previous)
end

return r
