local r = { windowScale = 0.8, maxWindowHeight = 0, backgroundWidth = 0, backgroundHeight = 0, backgroundScale = 1.5 }
local shape = require('shape')
local round = require('round')
local game = require('game').new(4, {})
local gameFinished = false
local maxVolumeMusic = 0.4
ShapeIdentifier = 0

local function getRandomVariant()
    local randomNumber = love.math.random(VARIANT_COUNT)

    for index, value in pairs(FORM_VARIANTS) do
        if (value.id == randomNumber) then
            return FORM_VARIANTS[index]
        end
    end
end

local function generateShapes(amount, world)
    local shapes = {}
    for i = 1, amount, 1 do
        local newShape = shape.new(getRandomVariant(), world)
        table.insert(shapes, newShape)
    end

    return shapes
end

function r:init()
    --Set screen to max size
    Background = love.graphics.newImage("assets/Spielfeld.jpg")
    ScorePlate = love.graphics.newImage("assets/Score.png")

    Clipboard0 = love.graphics.newImage("assets/Clipboard3000.png")
    Clipboard3000 = love.graphics.newImage("assets/Clipboard5000.png")
    Clipboard5000 = love.graphics.newImage("assets/Clipboard6000.png")
    Clipboard6000 = love.graphics.newImage("assets/Clipboard10000.png")

    r.backgroundWidth = Background:getWidth()
    r.backgroundHeight = Background:getHeight()
    local camConf = require 'cam'
    camConf.setupCam(r.maxWindowHeight, r.backgroundHeight, r.backgroundScale)
    Cam:lookAt(r.backgroundWidth * r.backgroundScale / 2, r.backgroundHeight * r.backgroundScale / 2)
    local scale = r.maxWindowHeight * r.windowScale / r.backgroundHeight / r.backgroundScale
    Cam:zoom(scale)
    camConf.adjustCamToWindow(Cam, false)


    ---@diagnostic disable-next-line: need-check-nil
    game.rounds = round.new(generateShapes(7, game.world))
end

function r:keypressed(key)
    if key == 'f' then
        local camConfig = require 'cam'
        love.window.setFullscreen(camConfig.adjustCamToWindow(Cam))
    end
end

function r:endRound()
    local shapeInstanceToCalc = nil
    --Choose shape that has points left to score
    for _, shapeInstance in ipairs(game.placedShapes) do
        if shapeInstance.scoreCalcLeft ~= 0 then
            shapeInstanceToCalc = shapeInstance
        end
    end

    --Continue counting score of chosen shape
    if shapeInstanceToCalc ~= nil then
        --Remove score from shape over time
        game.score = game.score + shapeInstanceToCalc:subScore()
    else
        --If no shape is chosen, choose new shape to count
        for _, shapeInstance in ipairs(game.placedShapes) do
            if not shapeInstance.scoreCalculated then
                --This is next shape that needs to be calculated
                shapeInstance:addScoreToCount()
                break
            end
        end
    end

    local finished = true
    for _, shapeInstance in ipairs(game.placedShapes) do
        if not shapeInstance.scoreCalculated then
            finished = false
        end
    end

    if finished == true then
        for _, shapeInstance in ipairs(game.placedShapes) do
            shapeInstance.scoreCalculated = false
        end
        game.currentRound = game.currentRound + 1
        if game.currentRound > game.maxRoundCount then
            gameFinished = true
        else
            game.rounds = round.new(generateShapes(7, game.world))
        end
    end
end

function r:initGame()
    game.score = 0
    gameFinished = false
    game.currentRound = 1
    for index, shapeToDestroy in ipairs(game.placedShapes) do
        shapeToDestroy:destroyShape()
        game.placedShapes[index] = nil
    end
    game.rounds = round.new(generateShapes(7, game.world))
end

local function music(dt)
    if love.audio.getActiveSourceCount() == 0 then
	Music.main.main:play()
	Music.main.main:setLooping(true)
	Music.main.badge:play()
	Music.main.badge:setVolume(0)
	Music.main.badge:setLooping(true)
	Music.main.suspect:play()
	Music.main.suspect:setVolume(0)
	Music.main.suspect:setLooping(true)
	Music.main.item:play()
	Music.main.item:setVolume(0)
	Music.main.item:setLooping(true)
    end

    local hoveredShape = nil
    for _,value in ipairs(game.rounds.providedShapes) do
	if value.isActive or value.hintTimeCounter > 0 then
	    hoveredShape = value
	    break
	end
    end

    if hoveredShape == nil then
	for _,value in ipairs(game.placedShapes) do
	    if  value.hintTimeCounter > 0 then
		hoveredShape = value
		break
	    end
	end
    end

    if hoveredShape == nil then
	if Music.main.badgeLevel > 0 then
	    Music.main.badgeLevel = Music.main.badgeLevel - dt
	end
	if Music.main.suspectLevel > 0 then
	    Music.main.suspectLevel = Music.main.suspectLevel - dt
	end
	if Music.main.itemLevel > 0 then
	    Music.main.itemLevel = Music.main.itemLevel - dt
	end
    else
	if hoveredShape.formVariant == FORM_VARIANTS.policeBadge then
	    Music.main.badgeLevel = Music.main.badgeLevel + dt
	elseif hoveredShape.formVariant == FORM_VARIANTS.acolyte
	    or hoveredShape.formVariant == FORM_VARIANTS.cultist
	    or hoveredShape.formVariant == FORM_VARIANTS.cultAmulet then
	    Music.main.suspectLevel = Music.main.suspectLevel + dt
	else
	    Music.main.itemLevel = Music.main.itemLevel + dt
	end
    end

    if Music.main.suspectLevel < 0 then
	Music.main.suspectLevel = 0
    elseif Music.main.suspectLevel > maxVolumeMusic then
	Music.main.suspectLevel = maxVolumeMusic
    end

    if Music.main.badgeLevel < 0 then
	Music.main.badgeLevel = 0
    elseif Music.main.badgeLevel > maxVolumeMusic then
	Music.main.badgeLevel = maxVolumeMusic
    end

    if Music.main.itemLevel < 0 then
	Music.main.itemLevel = 0
    elseif Music.main.itemLevel > maxVolumeMusic then
	Music.main.itemLevel = maxVolumeMusic
    end

    Music.main.suspect:setVolume(Music.main.suspectLevel)
    Music.main.badge:setVolume(Music.main.badgeLevel)
    Music.main.item:setVolume(Music.main.itemLevel)
end


function r:update(dt)

    music(dt)
    if gameFinished == true then
        if love.mouse.isDown(1) then
            r:initGame()
        end

        return
    end

    --Update status und position of shapes
    --Update placed shapes
    for _, value in ipairs(game.placedShapes) do
        value:updateStatus(dt)
        value:updatePos()
    end
    if #(game.rounds.providedShapes) == 0 then
        self:endRound()
    else
        --Update provided shapes
        local activeShape = nil
        for _, value in ipairs(game.rounds.providedShapes) do
            if value.isActive then
                if (value:updateStatus(dt)) then
                    activeShape = value
                end
            end
        end

        --Only one should be the active shape
        if not activeShape then
            for _, value in ipairs(game.rounds.providedShapes) do
                if (value:updateStatus(dt)) then
                    break
                end
            end
        end

        for index, value in ipairs(game.rounds.providedShapes) do
            value:updatePos(index, r.backgroundWidth * r.backgroundScale, r.backgroundHeight * r.backgroundScale)
        end

        --Move provided shapes into placed shapes
        local elemtToSwitch = 0
        for key, val in ipairs(game.rounds.providedShapes) do
            if val.wasDropped == true then
                elemtToSwitch = key
            end
        end
        table.insert(game.placedShapes, game.rounds.providedShapes[elemtToSwitch])
        table.remove(game.rounds.providedShapes, elemtToSwitch)

        --Combine places shapes
        if activeShape ~= nil then activeShape:removeConnections() end
        for _, val in ipairs(game.placedShapes) do
            if activeShape ~= nil then activeShape:addConnection(val) end
            val:removeConnections()
            for _, valIn in ipairs(game.placedShapes) do
                if val ~= valIn then
                    val:addConnection(valIn)
                end
            end
        end
    end

    game.world:update(dt)
end

local function drawRewardBoard()
    local boardToDraw = nil
    if game.score >= 6000 then
	boardToDraw = Clipboard6000
    elseif game.score >= 5000 then
	boardToDraw = Clipboard5000
    elseif game.score >= 3000 then
	boardToDraw = Clipboard3000
    else
	boardToDraw = Clipboard0
    end
    love.graphics.draw(boardToDraw, 1120, 600, 0, 2.5, 2.5)
end

function r:draw()
    Cam:attach()
    love.graphics.draw(Background, 0, 0, 0, r.backgroundScale, r.backgroundScale)

    if gameFinished then
        love.graphics.draw(ScorePlate, r.backgroundWidth * r.backgroundScale / 2 - 650,
            r.backgroundHeight * r.backgroundScale / 2 - 600, 0, 4, 4)
        love.graphics.print("Score: " .. game.score, r.backgroundWidth * r.backgroundScale / 2 - 280,
            r.backgroundHeight * r.backgroundScale / 2 - 400, 0, 2, 2)
	    drawRewardBoard()
    else
        for _, shapeInstance in ipairs(game.rounds.providedShapes) do
            shapeInstance:draw()
        end
        for _, shapeInstance in ipairs(game.placedShapes) do
            shapeInstance:draw()
        end
	love.graphics.draw(ScorePlate, r.backgroundWidth * r.backgroundScale - 650, -10, 0, 2.2, 1.3)
	love.graphics.print("Score: " .. game.score, r.backgroundWidth * r.backgroundScale - 440, 50, 0, 1, 1)
	love.graphics.print("Round "..game.currentRound.."/"..game.maxRoundCount, 80 , 50, 0, 1.5, 1.5)
    end
    if #(game.rounds.providedShapes) == 0 then
        for _, shapeInstance in ipairs(game.placedShapes) do
            if shapeInstance.scoreCalcLeft ~= 0 then
                shapeInstance:drawScore(r.backgroundWidth * r.backgroundScale)
            end
        end
    end

    if not gameFinished then
	for _, shapeInstance in ipairs(game.rounds.providedShapes) do
	    shapeInstance:drawHint()
	end
	for _, shapeInstance in ipairs(game.placedShapes) do
	    shapeInstance:drawHint()
	end
    end
    Cam:detach()
    --Draw score
end

function r:enter(previous)
    local camConfig = require 'cam'
    camConfig.setupCam(r.maxWindowHeight, r.backgroundHeight, r.backgroundScale)
    Cam:lookAt(r.backgroundWidth * r.backgroundScale / 2, r.backgroundHeight * r.backgroundScale / 2)
    local scale = r.maxWindowHeight * r.windowScale / r.backgroundHeight / r.backgroundScale
    Cam:zoom(scale)
    camConfig.adjustCamToWindow(Cam, false)
    if  Music.intro:isPlaying() then
	Music.intro:setLooping(false)
    end
end

return r
