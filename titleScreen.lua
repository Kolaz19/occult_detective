local r = {
    windowScale = 0.8,
    maxWindowHeight = 0,
    backgroundWidth = 0,
    backgroundHeight = 0,
    backgroundScale = 1.5,
    resumeButton = {
        img = {},
        x = 0,
        y = 0,
        isHovered = false,
        isDisplayed = false
    },
    startButton = {
        img = {},
        x = 0,
        y = 0,
        isHovered = false
    },
    exitButton = {
        img = {},
        x = 0,
        y = 0,
        isHovered = false
    },
}


local function setHoverState(button, mouseX, mouseY)
    if (mouseX >= button.x and mouseX <= button.x + button.img:getWidth()) and
        (mouseY >= button.y and mouseY <= button.y + button.img:getHeight()) then
        button.isHovered = true
    else
        button.isHovered = false
    end
end

function r:init()
    TitleScreenBackground = love.graphics.newImage("assets/Spielfeld.png")
    r.backgroundWidth = TitleScreenBackground:getWidth()
    r.backgroundHeight = TitleScreenBackground:getHeight()

    r.resumeButton.img = love.graphics.newImage("assets/PatroneV2.png")
    r.resumeButton.x = TitleScreenBackground:getWidth() / 2
    r.resumeButton.y = TitleScreenBackground:getHeight() / 2

    r.startButton.img = love.graphics.newImage("assets/Notiz1.png")
    r.startButton.x = TitleScreenBackground:getWidth() / 2
    r.startButton.y = TitleScreenBackground:getHeight() / 2 + 350

    r.exitButton.img = love.graphics.newImage("assets/ZeitungV2.png")
    r.exitButton.x = TitleScreenBackground:getWidth() / 2
    r.exitButton.y = TitleScreenBackground:getHeight() / 2 + 750

    local camConfig = require('cam')

    camConfig.setupCam(r.maxWindowHeight, r.backgroundHeight, r.backgroundScale)
    Cam:lookAt(r.backgroundWidth * r.backgroundScale / 2, r.backgroundHeight * r.backgroundScale / 2)
    local scale = r.maxWindowHeight * r.windowScale / r.backgroundHeight / r.backgroundScale
    Cam:zoom(scale)
    camConfig.adjustCamToWindow(Cam, false)
end

function r:update(dt)
    local x, y = Cam:worldCoords(love.mouse.getPosition())

    setHoverState(r.startButton, x, y)
    setHoverState(r.exitButton, x, y)

    if r.resumeButton.isDisplayed then
        setHoverState(r.resumeButton, x, y)
    end

    if r.resumeButton.isHovered and love.mouse.isDown(1) then
        Gamestate.switch(MainGame)
    end

    if r.startButton.isHovered and love.mouse.isDown(1) then
        Gamestate.switch(MainGame)
    end

    if r.exitButton.isHovered and love.mouse.isDown(1) then
        love.event.quit(0)
    end
end

function r:keypressed(key)
    if key == 'f' then
        local camConfig = require 'cam'
        love.window.setFullscreen(camConfig.adjustCamToWindow(Cam))
    end
end

function r:draw()
    Cam:attach()
    love.graphics.draw(TitleScreenBackground, 0, 0, 0, r.backgroundScale, r.backgroundScale)

    if r.startButton.isHovered then
        -- hover effect
        love.graphics.draw(r.startButton.img, r.startButton.x, r.startButton.y, 0, 1, 1)
        love.graphics.print('blubStart', 50, 50, 0, 3.0, 3.0)
    else
        love.graphics.draw(r.startButton.img, r.startButton.x, r.startButton.y, 0, 1, 1)
    end
    if r.exitButton.isHovered then
        -- hover effect
        love.graphics.draw(r.exitButton.img, r.exitButton.x, r.exitButton.y, 0, 1, 1)
        love.graphics.print('blubExit', 50, 50, 0, 3.0, 3.0)
    else
        love.graphics.draw(r.exitButton.img, r.exitButton.x, r.exitButton.y, 0, 1, 1)
    end

    Cam:detach()
end

function r:enter()
    if love.audio.getActiveSourceCount() == 0 then
        Music.intro:play()
        Music.intro:setLooping(true)
    end
end

return r
