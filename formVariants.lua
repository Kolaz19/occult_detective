FORM = { circle = 'CIRCLE', square = 'SQUARE', triangle = 'TRIANGLE' }
FORM_VARIANTS = {
	circleOne = {
		id = 1,
		form = FORM.circle,
		connectionLimit = 4,
		reach = 40,
		radius = 15
	},
	circleTwo = {
		id = 2,
		form = FORM.circle,
		connectionLimit = 4,
		reach = 40,
		radius = 15
	},
	circleThree = {
		id = 3,
		form = FORM.circle,
		connectionLimit = 4,
		reach = 40,
		radius = 15
	},
	squareOne = {
		id = 4,
		form = FORM.square,
		connectionLimit = 4,
		reach = 40,
		height = 30,
		width = 30
	},
	squareTwo = {
		id = 5,
		form = FORM.square,
		connectionLimit = 4,
		reach = 40,
		height = 30,
		width = 30
	},
	squareThree = {
		id = 6,
		form = FORM.square,
		connectionLimit = 4,
		reach = 40,
		height = 30,
		width = 30
	},
	triangleOne = {
		id = 7,
		form = FORM.triangle,
		connectionLimit = 4,
		reach = 40,
		height = 30,
		width = 30
	},
	triangleTwo = {
		id = 8,
		form = FORM.triangle,
		connectionLimit = 4,
		reach = 40,
		height = 30,
		width = 30
	},
	triangleThree = {
		id = 9,
		form = FORM.triangle,
		connectionLimit = 4,
		reach = 40,
		height = 30,
		width = 30
	}
}

VARIANT_COUNT = 0
for _ in pairs(FORM_VARIANTS) do VARIANT_COUNT = VARIANT_COUNT + 1 end
