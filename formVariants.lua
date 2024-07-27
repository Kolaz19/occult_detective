FORM = { circle = 'CIRCLE', square = 'SQUARE', triangle = 'TRIANGLE' }
FORM_VARIANTS = { circle = { 1, 2, 3 }, square = { 4, 5, 6 }, triangle = { 7, 8, 9 } }

function GetShapeFromVariant(num)
    for form, val in pairs(FORM_VARIANTS) do
	--print(form)
	for _, number in ipairs(val) do
	    if number == num then
		return FORM[form]
	    end
	end
    end
end
