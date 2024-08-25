---@class shapeState
---@field updateState fun(shape: shape): shapeState
---@field update fun(shape: shape)
---@field enter fun(shape: shape)
---@field draw fun(shape: shape)
---@field hintTimeCounter integer
local shapeState = {}
shapeState.hintTimeCounter = 0
shapeState.__index = shapeState

---@param updateState fun(shape: shape): shapeState
---@param update fun(shape: shape)
---@param enter fun(shape: shape)
---@param draw fun(shape: shape)
---@return shapeState
function shapeState:new(updateState, update, enter, draw)
    local new = setmetatable({},self)
    new.updateState = updateState
    new.update = update
    new.enter = enter
    new.draw = draw
    return new
end

return shapeState
