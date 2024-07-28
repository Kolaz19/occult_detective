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
Music = {
    intro = love.audio.newSource("assets/GameJamIntro.mp3", "static"),
    main = {
	main = love.audio.newSource("assets/GameJamMainLoop.mp3","static"),
	badge = love.audio.newSource("assets/PoliceBadgeLoop.mp3","static"),
	badgeLevel = 0.0,
	--TEST
	suspect = love.audio.newSource("assets/GameJamMainLoop.mp3","static"),
	suspectLevel = 0.0
    },
    mainGame = false
}
Cam = require('cam').initCam()

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
    TitleScreen.windowScale = windowScale
    TitleScreen.maxWindowHeight = maxWindowHeight
    MainGame = require('mainGame')
    MainGame.windowScale = windowScale
    MainGame.maxWindowHeight = maxWindowHeight
    Gamestate.registerEvents()
    Gamestate.switch(TitleScreen)
end

function love.keypressed(key)
    if Gamestate.current() ~= TitleScreen and key == KEYS.ESC then
        Gamestate.switch(TitleScreen)
    end
end
