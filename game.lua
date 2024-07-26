local game = {}
game.__index = game

---comment
---@param score number
---@param rounds table
---@param maxRoundCount number
---@param currentRound number
---@param placedShapes table
---@return table
game.new = function(score, rounds, maxRoundCount, currentRound, placedShapes)
    local gameInstance = {}
    gameInstance.score = score
    gameInstance.rounds = rounds
    gameInstance.maxRoundCount = maxRoundCount
    gameInstance.currentRound = currentRound
    gameInstance.placedShapes = placedShapes
    setmetatable(gameInstance, game)
    return gameInstance
end

return game
