FORM_VARIANTS = {
	acolyte = {
		id = 1,
		connectionLimit = 4,
		reach = 100,
		radius = 30,
		scale = 1.0,
		shiftX = 60,
		shiftY = 60,
		score = function()
			return 0
		end,
		img = love.graphics.newImage("assets/PolaroidV2.png"),
		hint = love.graphics.newImage("assets/Notiz1.png")
	},
	cultist = {
		id = 2,
		connectionLimit = 2,
		reach = 100,
		radius = 30,
		scale = 1.0,
		shiftX = 60,
		shiftY = 60,
		score = function(shape)
			-- + 30 pro Medallie
			local score = 0

			for _, connectedShape in ipairs(shape.connections) do
				if (connectedShape.formVariant == FORM_VARIANTS.cultAmulet) then
					score = score + 30
				end
			end

			return score
		end,
		img = love.graphics.newImage("assets/PolaroidV2.png"),
		hint = love.graphics.newImage("assets/Notiz1.png")
	},
	newspaperTopHalf = {
		id = 3,
		connectionLimit = 2,
		reach = 150,
		radius = 30,
		scale = 1.0,
		shiftX = 50,
		shiftY = 60,
		score = function(shape)
			local score = 0

			for _, connectedShape in ipairs(shape.connections) do
				if (connectedShape.formVariant == FORM_VARIANTS.newspaperBottomHalf) then
					score = score + 150
				end
			end

			-- malus: newspaper is standing alone
			if (#(shape.connections) == 0) then
				score = score - 50
			end

			return score
		end,
		img = love.graphics.newImage("assets/ZeitungV2.png"),
		hint = love.graphics.newImage("assets/Notiz1.png")
	},
	newspaperBottomHalf = {
		id = 4,
		connectionLimit = 2,
		reach = 150,
		radius = 30,
		scale = 1.0,
		shiftX = 50,
		shiftY = 60,
		score = function(shape)
			local score = 0

			-- malus: newspaper is standing alone
			if (#(shape.connections) == 0) then
				score = score - 50
			end

			return score
		end,
		img = love.graphics.newImage("assets/ZeitungV2.png"),
		hint = love.graphics.newImage("assets/Notiz1.png")
	},
	policeBadge = {
		id = 5,
		connectionLimit = 3,
		reach = 150,
		radius = 30,
		scale = 1.15,
		shiftX = 70,
		shiftY = 70,
		score = function(shape)
			-- pro cultist + 100
			-- pro acolyte + 50
			local score = 0

			for _, connectedShape in ipairs(shape.connections) do
				if (connectedShape.formVariant == FORM_VARIANTS.cultist) then
					score = score + 100
				end
				if (connectedShape.formVariant == FORM_VARIANTS.acolyte) then
					score = score + 50
				end
			end

			return score
		end,
		img = love.graphics.newImage("assets/Badge.png"),
		hint = love.graphics.newImage("assets/Notiz1.png")
	},
	audioTape = {
		id = 6,
		connectionLimit = 1,
		reach = 150,
		radius = 30,
		scale = 1.0,
		shiftX = 50,
		shiftY = 60,
		score = function(shape)
			-- je ganze Zeitung + 150
			local score = 0
			local newspaperShapes = {}

			for _, connectedShape in ipairs(shape.connections) do
				if (connectedShape.formVariant == FORM_VARIANTS.newspaperBottomHalf or
						connectedShape.formVariant == FORM_VARIANTS.newspaperTopHalf) then
					table.insert(newspaperShapes, connectedShape)
				end
			end

			for _, newspaperHalf in ipairs(newspaperShapes) do
				if (#(newspaperHalf.connections) > 1) then
					for __, newspaperHalfConnectedShape in ipairs(newspaperHalf.connections) do
						if (newspaperHalf.formVariant == FORM_VARIANTS.newspaperBottomHalf and
								newspaperHalfConnectedShape.formVariant == FORM_VARIANTS.newspaperTopHalf) then
							score = score + 150
						elseif (newspaperHalf.formVariant == FORM_VARIANTS.newspaperTopHalf and
								newspaperHalfConnectedShape.formVariant == FORM_VARIANTS.newspaperBottomHalf) then
							score = score + 150
						end
					end
				end
			end

			return score
		end,
		img = love.graphics.newImage("assets/ZeitungV2.png"),
		hint = love.graphics.newImage("assets/Notiz1.png")
	},
	shotgunShell = {
		id = 7,
		connectionLimit = 2,
		reach = 150,
		radius = 30,
		scale = 1.0,
		shiftX = 60,
		shiftY = 60,
		score = function(shape)
			-- je acolyte + 100
			local score = 0

			for _, connectedShape in ipairs(shape.connections) do
				if (connectedShape.formVariant == FORM_VARIANTS.acolyte) then
					score = score + 100
				end
			end

			return score
		end,
		img = love.graphics.newImage("assets/PatroneV2.png"),
		hint = love.graphics.newImage("assets/Notiz1.png")
	},
	cultAmulet = {
		id = 8,
		connectionLimit = 1,
		reach = 150,
		radius = 30,
		scale = 1.15,
		shiftX = 70,
		shiftY = 70,
		score = function(shape)
			-- je cultist + 200
			local score = 0

			for _, connectedShape in ipairs(shape.connections) do
				if (connectedShape.formVariant == FORM_VARIANTS.cultist) then
					score = score + 200
				end
			end

			return score
		end,
		img = love.graphics.newImage("assets/MedaillonV2.png"),
		hint = love.graphics.newImage("assets/Notiz1.png")
	}
}

VARIANT_COUNT = 0
for _ in pairs(FORM_VARIANTS) do VARIANT_COUNT = VARIANT_COUNT + 1 end
