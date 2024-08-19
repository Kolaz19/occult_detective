local round = {}
round.__index = round


round.new = function(pools, numberOfShapes, world)
    local shape = require('shape')
    local shapeFactory = require 'formVariants.formVariantFactory'
    local variants = shapeFactory.getRandomVariants(pools, numberOfShapes)
    round.providedShapes = {}
    for _,val in ipairs(variants) do
	table.insert(round.providedShapes,shape.new(val,world))
    end
end

function round:update(dt)
    local activeShape = nil
    --Update provided Shapes
    for _, shape in ipairs(self.providedShapes) do
	if shape.isActive then
	    if (shape:updateStatus(dt)) then
		activeShape = shape
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

end
