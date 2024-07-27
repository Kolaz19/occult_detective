local game = {}
game.__index = game

---comment
---@param maxRoundCount number
---@param rounds table All rounds of game
---@return table
game.new = function( maxRoundCount, rounds)
    local gameInstance = {}
    gameInstance.score = 0
    gameInstance.maxRoundCount = maxRoundCount
    gameInstance.currentRound = 1
    gameInstance.placedShapes = {}
    gameInstance.rounds = rounds
    love.physics.setMeter(30)
    love.graphics.setLineStyle("smooth")
    love.graphics.setLineWidth(3)
    gameInstance.world = love.physics.newWorld(0,0)
    setmetatable(gameInstance, game)
    return gameInstance
end

return game
