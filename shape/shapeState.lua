---@class shapeState
---@field updateState fun(shape: shape): shapeState
---@field update fun(shape: shape)
---@field enter fun(shape: shape)
---@field hintTimeCounter integer
local shapeState = {}
shapeState.hintTimeCounter = 0
shapeState.__index = shapeState

---@param updateState fun(shape: shape): shapeState
---@param update fun(shape: shape)
---@param enter fun(shape: shape)
---@return shapeState
function shapeState:new(updateState, update, enter)
    local new = setmetatable({},self)
    new.updateState = updateState
    new.update = update
    new.enter = enter
    return new
end

return shapeState
