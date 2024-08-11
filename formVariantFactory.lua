local formVariant = require 'formVariantRef'
local formVariantFactory = {created = {}}

---@enum form_variant_names
FORM_VARIANT_POOL_NAMES = {
   basic = {
       acolyte = 'aco',
       cultist = 'cultist',
       newsPaperTopHalf = 'newspaperTop',
       newsPaperBottomHalf = 'newspaperBottom',
       policeBadge = 'police',
       audioTape = 'tape',
       shotgunShell = 'shell',
       cultAmulet = 'amulet',
   }
}

local formVariantGeneratorFunctions = {}

--Initialize variant pools
for pool,_ in pairs(FORM_VARIANT_POOL_NAMES) do
    formVariantGeneratorFunctions[pool] = {}
    formVariantFactory.created[pool] = {}
    --If variant is not in created table,
    --create it with formVariantGeneratorFunctions-function
    setmetatable(formVariantFactory.created[pool],
    { __index = function(self, _k)
	local addressedPool
	--First get the pool the variant(_k) should be in
	for key,val in pairs(formVariantFactory.created) do
	    if self == val then addressedPool = key end
	end
	--Create object
	local generatorFunction = formVariantGeneratorFunctions[addressedPool][_k]
	if generatorFunction == nil then
	    print('No generator function for '.._k)
	    love.event.quit()
	    return
	end
	self[_k] = generatorFunction()
	return self[_k]
    end})
end

formVariantGeneratorFunctions.basic[FORM_VARIANT_POOL_NAMES.basic.acolyte] = function()
    local new = formVariant:new(4, 100, 35, 'assets/Acolyte2V2.png', 'assets/NotizAcolyte.png')
    new:setImageParameters(1.0, 75, 90)
    return new
end

formVariantGeneratorFunctions.basic[FORM_VARIANT_POOL_NAMES.basic.cultist] = function()
    local new = formVariant:new(2, 100, 35, 'assets/KultistV2.png', 'assets/NotizCultist.png')
    new:setImageParameters(1.0, 75, 90)
    return new
end

formVariantGeneratorFunctions.basic[FORM_VARIANT_POOL_NAMES.basic.newsPaperTopHalf] = function()
    local new = formVariant:new(2, 150, 35, 'assets/Zeitung1V2.png', 'assets/NotizNewspaperTopHalf.png')
    new:setImageParameters(1.0, 60, 70)
    return new
end

formVariantGeneratorFunctions.basic[FORM_VARIANT_POOL_NAMES.basic.newsPaperBottomHalf] = function()
    local new = formVariant:new(2, 150, 35, 'assets/Zeitung_2V2.png', 'assets/NotizNewspaperTopHalf.png')
    new:setImageParameters(1.0, 60, 70)
    return new
end

formVariantGeneratorFunctions.basic[FORM_VARIANT_POOL_NAMES.basic.policeBadge] = function()
    local new = formVariant:new(3, 150, 35, 'assets/Badge.png', 'assets/NotizPoliceBadge.png')
    new:setImageParameters(1.25, 70, 70)
    return new
end

formVariantGeneratorFunctions.basic[FORM_VARIANT_POOL_NAMES.basic.audioTape] = function()
    local new = formVariant:new(3, 150, 35, 'assets/KassetteV2.png', 'assets/NotizAudioCassette.png')
    new:setImageParameters(1.25, 70, 70)
    return new
end

formVariantGeneratorFunctions.basic[FORM_VARIANT_POOL_NAMES.basic.shotgunShell] = function()
    local new = formVariant:new(2, 150, 35, 'assets/PatroneV2.png', 'assets/NotizShotgunShell.png')
    new:setImageParameters(1.3, 80, 80)
    return new
end

formVariantGeneratorFunctions.basic[FORM_VARIANT_POOL_NAMES.basic.cultAmulet] = function()
    local new = formVariant:new(1, 150, 35, 'assets/MedaillonV2.png', 'assets/NotizAmulette.png')
    new:setImageParameters(1.2, 70, 70)
    return new
end
