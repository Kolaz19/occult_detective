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

function formVariantFactory.getRandomVariants(pools,amount)
    local variants = {}
    local indexCounter = 1
    local amountOfVariants = 0
    --Count all available variants in given pools
    for _,pool in ipairs(pools) do
	for _,_ in pairs(FORM_VARIANT_POOL_NAMES[pool]) do
	    amountOfVariants = amountOfVariants + 1
	end
    end

    --Get random variant amount times
    for cur = 1, amount do
	indexCounter = 1
	local randomIndex = love.math.random(amountOfVariants)
	for _,pool in ipairs(pools) do
	    for _,variant in pairs(FORM_VARIANT_POOL_NAMES[pool]) do
		if indexCounter == randomIndex then
		    --This will either get created variant 
		    --or create it per metamethod
		    variants[cur] = formVariantFactory.created[variant]
		end
		indexCounter = indexCounter + 1
	    end
	end
    end
    return variants
end

return formVariantFactory
