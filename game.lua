local game = {}
game.__index = game

---comment
---@param maxRoundCount number
---@param placedShapes table
---@return table
game.new = function( maxRoundCount, placedShapes)
    local gameInstance = {}
    gameInstance.score = 0
    gameInstance.maxRoundCount = maxRoundCount
    gameInstance.currentRound = 1
    gameInstance.placedShapes = placedShapes
    gameInstance.world = love.physics.newWorld(0,0)
    setmetatable(gameInstance, game)
    return gameInstance
end

return game
