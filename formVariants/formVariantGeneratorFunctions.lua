local formVariant = require 'formVariant'
require 'formVariantPoolNames'
local generatorFunctions = {}
generatorFunctions.generatedRef = {}

generatorFunctions[FORM_VARIANT_POOL_NAMES.basic.acolyte] = function()
    local new = formVariant:new(4,
				100,
				35,
				'assets/Acolyte2V2.png',
				'assets/NotizAcolyte.png')
    new:setImageParameters(1.0, 75, 90)
    return new
end

generatorFunctions[FORM_VARIANT_POOL_NAMES.basic.cultist] = function()
    local new = formVariant:new(2, 100, 35, 'assets/KultistV2.png', 'assets/NotizCultist.png')
    new:setImageParameters(1.0, 75, 90)
    new:setScoreFunction(
	function(shape)
	    -- + 30 pro Medallie
	    local score = 0

	    for _, connectedShape in ipairs(shape.connections) do
		    if (connectedShape.formVariant == FORM_VARIANTS.cultAmulet) then
			    score = score + 30
		    end
	    end

	    return score
	end
    )
    return new
end

generatorFunctions[FORM_VARIANT_POOL_NAMES.basic.newsPaperTopHalf] = function()
    local new = formVariant:new(2, 150, 35, 'assets/Zeitung1V2.png', 'assets/NotizNewspaperTopHalf.png')
    new:setImageParameters(1.0, 60, 70)
    return new
end

generatorFunctions[FORM_VARIANT_POOL_NAMES.basic.newsPaperBottomHalf] = function()
    local new = formVariant:new(2, 150, 35, 'assets/Zeitung_2V2.png', 'assets/NotizNewspaperTopHalf.png')
    new:setImageParameters(1.0, 60, 70)
    return new
end

generatorFunctions[FORM_VARIANT_POOL_NAMES.basic.policeBadge] = function()
    local new = formVariant:new(3, 150, 35, 'assets/Badge.png', 'assets/NotizPoliceBadge.png')
    new:setImageParameters(1.25, 70, 70)
    return new
end

generatorFunctions[FORM_VARIANT_POOL_NAMES.basic.audioTape] = function()
    local new = formVariant:new(3, 150, 35, 'assets/KassetteV2.png', 'assets/NotizAudioCassette.png')
    new:setImageParameters(1.25, 70, 70)
    return new
end

generatorFunctions[FORM_VARIANT_POOL_NAMES.basic.shotgunShell] = function()
    local new = formVariant:new(2, 150, 35, 'assets/PatroneV2.png', 'assets/NotizShotgunShell.png')
    new:setImageParameters(1.3, 80, 80)
    return new
end

generatorFunctions[FORM_VARIANT_POOL_NAMES.basic.cultAmulet] = function()
    local new = formVariant:new(1, 150, 35, 'assets/MedaillonV2.png', 'assets/NotizAmulette.png')
    new:setImageParameters(1.2, 70, 70)
    return new
end

return generatorFunctions
