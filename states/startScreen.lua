local startScreen = {}

local clText = {{
    colors.orange,
    'T', colors.aqua,
    'e', colors.orange,
    'l', colors.aqua,
    'e', colors.orange,
    'k', colors.aqua,
    'i', colors.orange,
    'n', colors.aqua,
    'e', colors.orange,
    's', colors.aqua,
    's', colors.orange,
    'b', colors.aqua,
    'a', colors.orange,
    'l', colors.aqua,
    'l'
},
{
    colors.aqua,
    'T', colors.orange,
    'e', colors.aqua,
    'l', colors.orange,
    'e', colors.aqua,
    'k', colors.orange,
    'i', colors.aqua,
    'n', colors.orange,
    'e', colors.aqua,
    's', colors.orange,
    's', colors.aqua,
    'b', colors.orange,
    'a', colors.aqua,
    'l', colors.orange,
    'l'
}
}

local clTextIndex = 1
local switchColorTimer  = 0

function startScreen:enter()
    switchColorTimer = lt.getTime()
    -- bgm:setVolume(0.05)
end


function startScreen:enter()

end

function startScreen:update(dt)
    Timer.update(dt)
    canim:update(dt)
    p1input:update()
    p2input:update()

    if p1input:pressed('action') or p2input:pressed('action') then
        gamestate.switch(gameScreen)
    end

    if lt.getTime() - switchColorTimer > 0.5 then
        clTextIndex =  (clTextIndex % 2) + 1
        switchColorTimer = lt.getTime()
    end

end

function startScreen:draw()
    push:start()

    effect(function ()
        lg.setColor(colors.white)
        lg.draw(assets.sprites.field, 0, 0)
        canim:draw(csheet, 400 - 96 - 290, 320)
        canim:draw(csheet, 400 - 96 + 290, 320)

        lg.setFont(fontTitle)
        lg.printf(clText[clTextIndex], 0, 180, gameW, 'center')

        lg.setColor(colors.white)

    end)
    
    push:finish()
end



return startScreen