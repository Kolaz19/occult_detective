local r = { windowScale = 0.8, maxWindowHeight = 0 }

function r:init()
    --Set screen to max size
    Cam = require('cam').setupCam(r.maxWindowHeight, r.windowScale)
    Cam:lookAt(10*16,30*16)
    Cam:zoom(0.8)

    local sti = require('lib.STI')
    Map = sti("assets/maps/dungeon.lua")

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
end

function r:draw()
    Cam:attach()
    Cam:detach()
end

function r:enter(previous)
end

return r
