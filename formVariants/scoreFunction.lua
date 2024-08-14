require 'formVariants.formVariantPoolNames'

local scoreFunctions = {}

---@param shape shape
local function isVariant(shape,variantName)
    return shape.formVariant.name == variantName
end

---@param shape shape
scoreFunctions[FORM_VARIANT_POOL_NAMES.basic.cultist] = function(shape)
    -- + 30 pro Medallie
    local score = 0

    for _, connectedShape in ipairs(shape.connections) do
	if (connectedShape:isVariant(FORM_VARIANT_POOL_NAMES.basic.cultAmulet)) then
	    score = score + 30
	end
    end
    return score
end

---@param shape shape
scoreFunctions[FORM_VARIANT_POOL_NAMES.basic.newsPaperTopHalf] = function(shape)
    local score = 0

    for _, connectedShape in ipairs(shape.connections) do
	if (connectedShape:isVariant(FORM_VARIANT_POOL_NAMES.basic.newsPaperBottomHalf)) then
	    score = score + 150
	end
    end

    -- malus: newspaper is standing alone
    if (#(shape.connections) == 0) then
	score = score - 50
    end

    return score
end

---@param shape shape
scoreFunctions[FORM_VARIANT_POOL_NAMES.basic.newsPaperBottomHalf] = function(shape)
    local score = 0
    -- malus: newspaper is standing alone
    if (#(shape.connections) == 0) then
	score = score - 50
    end

    return score
end

scoreFunctions[FORM_VARIANT_POOL_NAMES.basic.policeBadge] = function(shape)
    -- pro cultist + 100
    -- pro acolyte + 50
    local score = 0
    for _, connectedShape in ipairs(shape.connections) do
	if (connectedShape:isVariant(FORM_VARIANT_POOL_NAMES.basic.cultist)) then
		score = score + 100
	end
	if (connectedShape:isVariant(FORM_VARIANT_POOL_NAMES.basic.acolyte )) then
		score = score + 50
	end
    end

    return score
end

scoreFunctions[FORM_VARIANT_POOL_NAMES.basic.audioTape] = function(shape)
    -- je ganze Zeitung + 150
    local score = 0
    local newspaperShapes = {}

    for _, connectedShape in ipairs(shape.connections) do
	if (connectedShape:isVariant(FORM_VARIANT_POOL_NAMES.basic.newsPaperBottomHalf) or
	    connectedShape:isVariant(FORM_VARIANT_POOL_NAMES.basic.newsPaperTopHalf)) then
	    table.insert(newspaperShapes, connectedShape)
	end
    end

    for _, newspaperHalf in ipairs(newspaperShapes) do
	if (#(newspaperHalf.connections) > 1) then
	    for _, newspaperHalfConnectedShape in ipairs(newspaperHalf.connections) do
		if (newspaperHalf:isVariant(FORM_VARIANT_POOL_NAMES.basic.newsPaperBottomHalf) and
		    newspaperHalfConnectedShape:isVariant(FORM_VARIANT_POOL_NAMES.basic.newsPaperTopHalf)) then
		    score = score + 150
		elseif (newspaperHalf:isVariant(FORM_VARIANT_POOL_NAMES.basic.newsPaperTopHalf) and
			newspaperHalfConnectedShape:isVariant(FORM_VARIANT_POOL_NAMES.basic.newsPaperBottomHalf)) then
		    score = score + 150
		end
	    end
	end
    end
    return score
end

scoreFunctions[FORM_VARIANT_POOL_NAMES.basic.shotgunShell] = function(shape)
    -- je acolyte + 100
    local score = 0
    for _, connectedShape in ipairs(shape.connections) do
	if (connectedShape:isVariant(FORM_VARIANT_POOL_NAMES.basic.acolyte)) then
	    score = score + 100
	end
    end

    return score
end

scoreFunctions[FORM_VARIANT_POOL_NAMES.basic.cultAmulet] = function(shape)
    -- je cultist + 200
    local score = 0

    for _, connectedShape in ipairs(shape.connections) do
	if (connectedShape:isVariant(FORM_VARIANT_POOL_NAMES.basic.cultist)) then
	    score = score + 200
	end
    end

    return score
end

return scoreFunctions
