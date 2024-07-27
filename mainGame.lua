local r = { windowScale = 0.8, maxWindowHeight = 0 }
local shape = require('shape')
local round = require('round')
local game = require('game').new(1000, {})
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

local function getRandomGameBonus()
    local randomNumber = love.math.random(BONUS_COUNT)

    for index, value in pairs(GAME_BONUSES) do
        if (value.id == randomNumber) then
            return GAME_BONUSES[index]
        end
    end
end

local function calculateRoundScore()
    local score = 0
    for index, value in ipairs(game.placedShapes) do
        score = shape + value.score
    end
    return score
end

function r:init()
    --Set screen to max size
    Cam = require('cam').setupCam(r.maxWindowHeight, r.windowScale)
    Cam:lookAt(0, 0)
    --Cam:zoom(0.2)

    --local initialShape = shape.new(FORM_VARIANTS.polaroidPerson, game.world)
    --table.insert(game.placedShapes, initialShape)

    ---@diagnostic disable-next-line: need-check-nil
    game.rounds = round.new(generateShapes(7, game.world))

    --[[
    local sti = require('lib.STI')
    Map = sti("assets/maps/dungeon.lua")
    --]]
end

function r:keypressed(key, scancode, isrepeat)
    if key == 'f' then
        local camConfig = require 'cam'
        love.window.setFullscreen(camConfig.adjustCamToWindow(Cam))
    end
end

function r:update(dt)
    --Map:update(dt)
    local camConfig = require 'cam'
    camConfig:moveCamWithMouse()

    --Update status und position of shapes
    --Update placed shapes
    for _, value in ipairs(game.placedShapes) do
	value:updatePos()
    end
    --Update provided shapes
    local activeShape = nil
    for _, value in ipairs(game.rounds.providedShapes) do
        if value.isActive then
            if (value:updateStatus()) then
                activeShape = value
            end
        end
    end

    --Only one should be the active shape
    if not activeShape then
        for _, value in ipairs(game.rounds.providedShapes) do
            if (value:updateStatus()) then
                break
            end
        end
    end

    for index, value in ipairs(game.rounds.providedShapes) do
        value:updatePos(index)
    end

    --Move provided shapes into placed shapes
    local elemtToSwitch = 0
    for key, val in ipairs(game.rounds.providedShapes) do
	if val.wasDropped == true then
	    elemtToSwitch = key
	end
    end
    table.insert(game.placedShapes,game.rounds.providedShapes[elemtToSwitch])
    table.remove(game.rounds.providedShapes,elemtToSwitch)

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


    game.world:update(dt)
end

function r:draw()
    Cam:attach()
    love.graphics.rectangle("line", 0, 0, 50, 50)
    for _, shapeInstance in ipairs(game.rounds.providedShapes) do
        shapeInstance:draw()
    end
    for _, shapeInstance in ipairs(game.placedShapes) do
        shapeInstance:draw()
    end
    Cam:detach()
end

function r:enter(previous)
end

return r
