local r = {
    fullscreen = false,
    tileSize = 16,
    amountTilesShownX = 14,
    --later defined
    windowScale = 0,
    maxWindowHeight = 0
}

---Setup cam
---@param maxWindowHeight number
---@param windowScale number
---@return table Camera
function r.setupCam(maxWindowHeight, windowScale)
    --We want to show 14 tiles horizontally
    r.windowScale = windowScale
    local scaleY = maxWindowHeight * windowScale / (r.tileSize * r.amountTilesShownX)
    local camera = require 'lib.camera'
    local cam = camera(0,0)
    cam:zoom(scaleY)
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
---@param cam table
---@return boolean r.fullscreen Game is fullscreen
function r.adjustCamToWindow(cam)
    r.fullscreen = not r.fullscreen
    local height = r.maxWindowHeight
    if not r.fullscreen then
	height = r.maxWindowHeight * r.windowScale
    end
    local scaleY = height / (r.tileSize * r.amountTilesShownX)
    cam:zoomTo(1*scaleY)
    return r.fullscreen
end

return r
