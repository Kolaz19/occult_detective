local level = {}
level.__index = level

level.new = function(maxRoundCount, rounds, world)
    local gameInstance = {}
    gameInstance.score = 0 gameInstance.maxRoundCount = maxRoundCount gameInstance.currentRound = 1
    gameInstance.placedShapes = {}
    gameInstance.rounds = rounds
    love.physics.setMeter(30)
    love.graphics.setLineStyle("smooth")
    love.graphics.setLineWidth(3)
    gameInstance.world = love.physics.newWorld(0, 0)
    setmetatable(gameInstance, level)
    return gameInstance
end

return level
