FORM_VARIANTS = {
	polaroidPerson = {
		id = 1,
		connectionLimit = 4,
		reach = 40,
		radius = 30,
		shiftX = 60,
		shiftY = 60,
		img = love.graphics.newImage("assets/PolaroidV2.png")
	},
	newspaperCult = {
		id = 2,
		connectionLimit = 4,
		reach = 40,
		radius = 30,
		shiftX = 50,
		shiftY = 60,
		img = love.graphics.newImage("assets/ZeitungV2.png")
	},
	--[[
	circleThree = {
		id = 3,
		connectionLimit = 4,
		reach = 40,
		radius = 15
	},
	squareOne = {
		id = 4,
		connectionLimit = 4,
		reach = 40,
		radius = 15
	},
	squareTwo = {
		id = 5,
		connectionLimit = 4,
		reach = 40,
		radius = 15
	},
	squareThree = {
		id = 6,
		connectionLimit = 4,
		reach = 40,
		radius = 15
	},
	triangleOne = {
		id = 7,
		connectionLimit = 4,
		reach = 40,
		radius = 15
	},
	triangleTwo = {
		id = 8,
		connectionLimit = 4,
		reach = 40,
		radius = 15
	},
	triangleThree = {
		id = 9,
		connectionLimit = 4,
		reach = 40,
		radius = 15
	}
	--]]
}

VARIANT_COUNT = 0
for _ in pairs(FORM_VARIANTS) do VARIANT_COUNT = VARIANT_COUNT + 1 end
