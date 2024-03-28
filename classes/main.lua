local xclasses = require('xclasses')
local default = xclasses.default

local carClass = xclasses.create('Car', {
    brand = default('string');
    topSpeed = default('string');
    engaged = false;
    fullName = function(carClass, car)
        return car.brand..car.name
    end,
    engage = function(carClass, car)
        if car.engaged then
            return false, print('car '..car:fullName()..' already engaged')
        else
            car.engaged = true
            return true, print('car '..car:fullName()..' engaged')
        end
    end;
    disengage = function(carClass, car)
        if car.engaged then
            car.engaged = false
            return true, print('car '..car:fullName()..' disengaged')
        else
            return false, print('car '..car:fullName()..' already disengaged')
        end
    end;
    __init = function(carClass, newCar, name, brand)
        newCar.name = name
        newCar.brand = brand
    end
})

local volks = carClass('beetle', 'volkswagen')

print(volks.engaged)
volks:engage()
print(volks.engaged)