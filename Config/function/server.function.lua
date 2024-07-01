Functions = {}

Functions.GeneratePlate = function()
    local plate = randomString(Default.plateLetters) .. ' ' .. randomNumber(Default.plateNumbers)

    while not Quries.isPlateAvailable(plate) do
        plate = randomString(Default.plateLetters) .. ' ' .. randomNumber(Default.plateNumbers)
    end

    return string.upper(plate)
end