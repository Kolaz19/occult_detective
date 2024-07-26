local r = { windowScale = 0.8, maxWindowHeight = 0 }

function r:init()
    --Set screen to max size
    Cam = require('cam').setupCam(r.maxWindowHeight, r.windowScale)
    Cam:lookAt(0,0)
    Cam:zoom(0.8)

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


local function registerCamMovement()

end

function r:update(dt)
    --Map:update(dt)
    local camConfig = require 'cam'
    camConfig:moveCamWithMouse()
end

function r:draw()
    Cam:attach()
	love.graphics.rectangle("line", 0,0,90,90)
    Cam:detach()
end

function r:enter(previous)
end

return r
