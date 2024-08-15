---@class formVariant
---@field name string Name of the shape
---@field iconImage love.Image Icon image
---@field hintImage love.Image Hint displayed when hovering
---@field connectionLimit integer Max connections that can be formed
---@field reach integer Max reach for connection to be formed
---@field bodyRadius integer Radius of shape
---@field imgScale number Scale image (Default 1)
---@field shiftX integer Shift image to the left
---@field shiftY integer Shift image up
---@field score fun(shape: shape): integer
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

---Set new score function
---@param fun function Function with parameter 'shape'
function formVariant:setScoreFunction(fun)
    self.score = fun
end

---Call score function
---@param shape shape
---@return integer score
function formVariant:getScore(shape)
    return formVariant.score(shape) + self.score(shape)
end

---Scale and shift icon image
---@param scale number Scale image (Default 1)
---@param shiftX integer Shift to the left
---@param shiftY integer Shift up
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

---@param variantName form_variant_names
---@return boolean isVariant
function formVariant:isVariant(variantName)
    return variantName == self.name
end

setmetatable(formVariant,
{__call = function()
    return formVariant:new()
end})

return formVariant
