FORM_VARIANTS = {
	acolyte = {
		id = 1,
		connectionLimit = 4,
		reach = 100,
		radius = 30,
		shiftX = 60,
		shiftY = 60,
		score = function()
			return 0
		end,
		img = love.graphics.newImage("assets/PolaroidV2.png")
	},
	cultist = {
		id = 2,
		connectionLimit = 2,
		reach = 100,
		radius = 30,
		shiftX = 60,
		shiftY = 60,
		score = function()
			-- + 30 pro Medallie
			return 0
		end,
		img = love.graphics.newImage("assets/PolaroidV2.png")
	},
	newspaperTopHalf = {
		id = 3,
		connectionLimit = 2,
		reach = 150,
		radius = 30,
		shiftX = 50,
		shiftY = 60,
		score = function(shape)
			local scoreModifier = 0

			for _, connectedShape in ipairs(shape.connections) do
				if (connectedShape.formVariant == FORM_VARIANTS.newspaperBottomHalf) then
					scoreModifier = scoreModifier + 150
				end
			end

			-- malus: newspaper is standing alone
			if (#(shape.connections) == 0) then
				scoreModifier = scoreModifier - 50
			end

			return scoreModifier
		end,
		img = love.graphics.newImage("assets/ZeitungV2.png")
	},
	newspaperBottomHalf = {
		id = 4,
		connectionLimit = 2,
		reach = 150,
		radius = 30,
		shiftX = 50,
		shiftY = 60,
		score = function(shape)
			local scoreModifier = 0

			-- malus: newspaper is standing alone
			if (#(shape.connections) == 0) then
				scoreModifier = scoreModifier - 50
			end

			return scoreModifier
		end,
		img = love.graphics.newImage("assets/ZeitungV2.png")
	},
	policeBadge = {
		id = 5,
		connectionLimit = 3,
		reach = 150,
		radius = 30,
		shiftX = 50,
		shiftY = 60,
		score = function(shape)
			-- pro cultist + 100
			-- pro acolyte + 50
			return 0
		end,
		img = love.graphics.newImage("assets/ZeitungV2.png")
	},
	audioTape = {
		id = 6,
		connectionLimit = 1,
		reach = 150,
		radius = 30,
		shiftX = 50,
		shiftY = 60,
		score = function(shape)
			-- je ganze Zeitung + 150
			return 0
		end,
		img = love.graphics.newImage("assets/ZeitungV2.png")
	},
	shotgunShell = {
		id = 7,
		connectionLimit = 2,
		reach = 150,
		radius = 30,
		shiftX = 50,
		shiftY = 60,
		score = function(shape)
			-- je acolyte + 100
			return 0
		end,
		img = love.graphics.newImage("assets/ZeitungV2.png")
	},
	cultAmulet = {
		id = 8,
		connectionLimit = 1,
		reach = 150,
		radius = 30,
		shiftX = 50,
		shiftY = 60,
		score = function(shape)
			-- je cultist + 200
			return 0
		end,
		img = love.graphics.newImage("assets/ZeitungV2.png")
	}
}

VARIANT_COUNT = 0
for _ in pairs(FORM_VARIANTS) do VARIANT_COUNT = VARIANT_COUNT + 1 end
