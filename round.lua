local round = {}
round.__index = round

---comment
---@param providedShapes table
---@return table
round.new = function(providedShapes)
    local roundInstance = {}
    roundInstance.providedShapes = providedShapes
    setmetatable(roundInstance, round)
    return roundInstance
end


return round
