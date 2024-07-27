GAME_BONUSES = {
    -- alleinstehende Person ohne Verbindungen
    isolatedPerson = {
        id = 1,
        name = 'isolated Person',
        successShapeIds = {},
        scorePerSuccess = 250,
        modifier = function(placedShapes)
            local scoreModifier = 0
            for _, placedShape in ipairs(placedShapes) do
                if (placedShape.formVariant == FORM_VARIANTS.polaroidPerson and #(placedShape.connections) == 0) then
                    scoreModifier = scoreModifier + GAME_BONUSES.isolatedPerson.scorePerSuccess
                    table.insert(GAME_BONUSES.isolatedPerson.successShapeIds, { placedShape.id })
                end
            end

            return scoreModifier
        end
    },

    -- exakt drei Personen, alle miteinander verbunden, nur eine Verbindung nach außen (non Person)
    threeSuspects = {
        id = 2,
        name = 'three suspects',
        successShapeIds = {},
        scorePerSuccess = 400,
        modifier = function(placedShapes)
            local scoreModifier = 0
            local polaroidPersons = {}
            local skipPersons = {}

            for _, placedShape in ipairs(placedShapes) do
                for __, skipPersonId in ipairs(skipPersons) do
                    if (placedShape.id == skipPersonId) then
                        break
                    end
                end
                if (placedShape.formVariant == FORM_VARIANTS.polaroidPerson and #(placedShape.connections) >= 2) then
                    table.insert(polaroidPersons, placedShape)
                end


                if (placedShape.formVariant == FORM_VARIANTS.polaroidPerson and #(placedShape.connections) == 0) then
                    scoreModifier = scoreModifier + GAME_BONUSES.isolatedPerson.scorePerSuccess
                end
            end

            return scoreModifier
        end
    },

    -- Person + Zeitung Top + Zeitung Bottom
    narrowingNoose = {
        id = 3,
        name = 'with the back to the wall',
        successShapeIds = {},
        scorePerSuccess = 0,
        mofifier = function()
            return 0
        end,
    },

    -- exakt zwei Personen sind nur über eine in der Mitte verbunden, aber nicht direkt
    manInTheMiddle = {
        id = 4,
        name = 'man in the middle',
        successShapeIds = {},
        scorePerSuccess = 0,
        mofifier = function()
            return 0
        end,
    }
}

BONUS_COUNT = 0
for _ in pairs(GAME_BONUSES) do BONUS_COUNT = BONUS_COUNT + 1 end
