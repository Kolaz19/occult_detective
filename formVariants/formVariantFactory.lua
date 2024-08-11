local formVariantFactory = {created = {}}
local scoreFunctions = require 'scoreFunction'
scoreFunctions.createdObjectsRef = formVariantFactory.created

local formVariantGeneratorFunctions = require 'formVariantGeneratorFunctions'

--If variant is not in created table,
--create it with formVariantGeneratorFunctions-function
setmetatable(formVariantFactory.created,
{ __index = function(self, _k)
    --Create object
    local generatorFunction = formVariantGeneratorFunctions[_k]
    if generatorFunction == nil then
	print('No generator function for '.._k)
	love.event.quit()
	return
    end
    self[_k] = generatorFunction()
    self[_k].name = _k

    --Set score function when defined
    local scoreFunction = scoreFunctions[_k]
    if scoreFunction ~= nil then
	self[_k].setScoreFunction(scoreFunction)
    end
    return self[_k]
end})

