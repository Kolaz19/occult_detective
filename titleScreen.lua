local r = {
    windowScale = 0.8,
    maxWindowHeight = 0,
    backgroundWidth = 0,
    backgroundHeight = 0,
    backgroundScale = 1.5,
    buttonScale = 1.2,
    hoverScale = 1.2,
    hoverShift = 30,
    resumeButton = {
        img = {},
        x = 1950,
        y = 600,
        isHovered = false
    },
    startButton = {
        img = {},
        x = 1200,
        y = 450,
        isHovered = false
    },
    exitButton = {
        img = {},
        x = 1400,
        y = 850,
        isHovered = false
    },
}


local function setHoverState(button, mouseX, mouseY)
    if (mouseX >= button.x and mouseX <= button.x + button.img:getWidth() * r.buttonScale) and
        (mouseY >= button.y and mouseY <= button.y + button.img:getHeight() * r.buttonScale) then
        button.isHovered = true
    else
        button.isHovered = false
    end
end

function r:init()
    TitleScreenBackground = love.graphics.newImage("assets/Titlescreen.jpg")
    r.backgroundWidth = TitleScreenBackground:getWidth()
    r.backgroundHeight = TitleScreenBackground:getHeight()

    r.resumeButton.img = love.graphics.newImage("assets/Resume.png")
    r.startButton.img = love.graphics.newImage("assets/NEW Game.png")
    r.exitButton.img = love.graphics.newImage("assets/Exit.png")

    local camConfig = require('cam')

    camConfig.setupCam(r.maxWindowHeight, r.backgroundHeight, r.backgroundScale)
    Cam:lookAt(r.backgroundWidth * r.backgroundScale / 2, r.backgroundHeight * r.backgroundScale / 2)
    local scale = r.maxWindowHeight * r.windowScale / r.backgroundHeight / r.backgroundScale
    Cam:zoom(scale)
    camConfig.adjustCamToWindow(Cam, false)
end

function r:update(dt)
    if love.audio.getActiveSourceCount() == 0 then
        Music.intro:play()
        Music.intro:setLooping(true)
    end
    local x, y = Cam:worldCoords(love.mouse.getPosition())

    setHoverState(r.startButton, x, y)
    setHoverState(r.exitButton, x, y)

    if Background ~= nil then
        setHoverState(r.resumeButton, x, y)
    end

    if r.resumeButton.isHovered and love.mouse.isDown(1) and Background ~= nil then
        Gamestate.switch(MainGame)
    end

    if r.startButton.isHovered and love.mouse.isDown(1) then
	MainGame:initGame()
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
        love.graphics.draw(r.startButton.img, r.startButton.x - r.hoverShift, r.startButton.y - r.hoverShift, 0, 1 * r.buttonScale * r.hoverScale, 1 * r.buttonScale * r.hoverScale)
    else
        love.graphics.draw(r.startButton.img, r.startButton.x, r.startButton.y, 0, 1 * r.buttonScale, 1 * r.buttonScale)
    end

    if r.exitButton.isHovered then
        -- hover effect
        love.graphics.draw(r.exitButton.img, r.exitButton.x - r.hoverShift, r.exitButton.y - r.hoverShift, 0, 1 * r.buttonScale * r.buttonScale, 1 * r.buttonScale * r.hoverScale)
    else
        love.graphics.draw(r.exitButton.img, r.exitButton.x, r.exitButton.y, 0, 1 * r.buttonScale, 1 * r.buttonScale)
    end

    if r.resumeButton.isHovered then
        -- hover effect
        love.graphics.draw(r.resumeButton.img, r.resumeButton.x - r.hoverShift, r.resumeButton.y - r.hoverShift, 0, 1 * r.buttonScale * r.hoverScale, 1 * r.buttonScale * r.hoverScale)
    elseif Background ~= nil then
        love.graphics.draw(r.resumeButton.img, r.resumeButton.x, r.resumeButton.y, 0, 1 * r.buttonScale, 1 * r.buttonScale)
    end
    Cam:detach()
end

function r:enter()
    local camConfig = require 'cam'
    camConfig.setupCam(r.maxWindowHeight, r.backgroundHeight, r.backgroundScale)
    Cam:lookAt(r.backgroundWidth * r.backgroundScale / 2, r.backgroundHeight * r.backgroundScale / 2)
    local scale = r.maxWindowHeight * r.windowScale / r.backgroundHeight / r.backgroundScale
    Cam:zoom(scale)
    camConfig.adjustCamToWindow(Cam, false)
    if love.audio.getActiveSourceCount() == 0 then
        Music.intro:play()
        Music.intro:setLooping(true)
    end
end

return r
