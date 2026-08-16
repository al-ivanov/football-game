local baton = require 'libs/baton'

local function makePlayerInput(bindings, joystick)
    return baton.new{
        controls = bindings,
        pairs = {
            move = {'left', 'right', 'up', 'down'},
        },
        joystick = joystick,
    }
end

local Input = {}

function Input.create(joysticks)
    joysticks = joysticks or {}

    Input.p1 = makePlayerInput({
        left = {'key:a', 'axis:leftx-', 'button:dpleft'},
        right = {'key:d', 'axis:leftx+', 'button:dpright'},
        up = {'key:w', 'axis:lefty-', 'button:dpup'},
        down = {'key:s', 'axis:lefty+', 'button:dpdown'},
        action = {'key:space', 'button:a'},
        reset = {'key:r', 'button:b'},
    }, joysticks[1])

    Input.p2 = makePlayerInput({
        left = {'key:left', 'axis:leftx-', 'button:dpleft'},
        right = {'key:right', 'axis:leftx+', 'button:dpright'},
        up = {'key:up', 'axis:lefty-', 'button:dpup'},
        down = {'key:down', 'axis:lefty+', 'button:dpdown'},
        action = {'key:return', 'button:a'},
        reset = {'key:r', 'button:b'},
    }, joysticks[2])

    return Input.p1, Input.p2
end

return Input
