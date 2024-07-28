if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
    local lldebugger = require "lldebugger"
    lldebugger.start()
    local run = love.run
    function love.run(...)
        local f = lldebugger.call(run, false, ...)
        return function(...) return lldebugger.call(f, false, ...) end
    end
end

KEYS = { LSHIFT = 'lshift', W = 'w', A = 'a', S = 's', D = 'd', ESC = 'escape' }
DEBUG = true
Gamestate = require 'lib.gamestate'

function love.load()
    require('formVariants')
    if DEBUG then
        io.stdout:setvbuf("no")
    end
    love.window.setMode(0, 0)
    local maxWindowWidth = love.graphics.getWidth()
    local maxWindowHeight = maxWindowWidth * 9 / 16
    local windowScale = 0.8
    love.window.setMode(maxWindowWidth * windowScale, maxWindowHeight * windowScale)
    love.graphics.setDefaultFilter("nearest", "nearest")

    TitleScreen = require('titleScreen')
    MainGame = require('mainGame')
    TitleScreen.windowScale = windowScale
    TitleScreen.maxWindowHeight = maxWindowHeight
    Gamestate.registerEvents()
    Gamestate.switch(TitleScreen)
end

function love.keypressed(key)
    if key == KEYS.ESC then
        love.event.quit(0)
    end
end
