local vec = require 'lib.vector'
local r = {
    fullscreen = false,
    --later defined
    maxWindowHeight = 0,
    windowScale = 0.8,
    vecLastFrame = vec.new(0, 0)
}

---Setup cam
---@param maxWindowHeight number
---@param windowScale number
---@return table Camera
function r.setupCam(maxWindowHeight, windowScale)
    --We want to show 14 tiles horizontally
    --local scaleY = maxWindowHeight * windowScale / (r.tileSize * r.amountTilesShownX)
    local camera = require 'lib.camera'
    local cam = camera(0, 0)
    cam:zoomTo(1)
    r.maxWindowHeight = maxWindowHeight
    --[[
    local shiftX = windowWidth / scaleY / 2
    local shiftY = (30 - 16  + (16/2)) * 16
    --Cam:lookAt(shiftX, (16 * 16)/2)
    Cam:lookAt(shiftX, shiftY)
    --]]
    return cam
end

---Adjust cam to window size
---so that the same ratio is kept
---@return boolean r.fullscreen Game is fullscreen
function r:adjustCamToWindow()
    r.fullscreen = not r.fullscreen
    --local scale = r.maxWindowHeight / ( r.maxWindowHeight - r.maxWindowHeight * r.windowScale )

    local scale = 0
    if not r.fullscreen then
        scale = 0
	self:zoomTo(1 + scale)
    end
    return r.fullscreen
end

---Poll mouse position and move cam
function r:moveCamWithMouse()
    if love.mouse.isDown(2) then
        if self.vecLastFrame.x == 0 and self.vecLastFrame.y == 0 then
            self.vecLastFrame.x = love.mouse.getX()
            self.vecLastFrame.y = love.mouse.getY()
        else
            local mousePos = vec.new(love.mouse.getX(), love.mouse.getY())
            local diff = self.vecLastFrame - mousePos
            self.vecLastFrame.x = love.mouse.getX()
            self.vecLastFrame.y = love.mouse.getY()

            -- We have to extract the zoom from the vector to move the camera 1:1
            Cam:move(diff.x / Cam.scale, diff.y / Cam.scale)
        end
    else
        self.vecLastFrame.x = 0
        self.vecLastFrame.y = 0
    end
end

return r
