---@class formVariant
local formVariant = {}
formVariant.__index = formVariant

formVariant.name = nil
formVariant.iconImage = nil
formVariant.hintImage = nil
formVariant.connectionLimit = nil
formVariant.reach = nil
formVariant.bodyRadius = nil
formVariant.imgScale = 1
formVariant.shiftX = 0
formVariant.shiftY = 0
---@diagnostic disable-next-line: unused-local
formVariant.score = function(shape) return 0 end

function formVariant:setScoreFunction(fun)
    formVariant.score = fun
end

function formVariant:getScore(shape)
    return formVariant.score(shape) + self.score(shape)
end

function formVariant:setImageParameters(scale, shiftX, shiftY)
    self.imgScale = scale
    self.shiftX = shiftX
    self.shiftY = shiftY
end

function formVariant:new(connectionLimit, reach, bodyRadius, iconImagePath, hintImagePath)
    local new = setmetatable({},self)
    new.connectionLimit = connectionLimit
    new.reach = reach
    new.bodyRadius = bodyRadius
    new.iconImage = love.graphics.newImage(iconImagePath)
    new.hintImage = love.graphics.newImage(hintImagePath)
    return new
end

setmetatable(formVariant,
{__call = function()
    return formVariant:new()
end})

return formVariant
