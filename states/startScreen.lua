local startScreen = {}


function startScreen:enter()

end

function startScreen:update(dt)
    canim:update(dt)
    p1input:update()
    p2input:update()

    if p1input:pressed('action') or p2input:pressed('action') then
        gamestate.switch(gameScreen)
    end

end

function startScreen:draw()
    push:start()

    effect(function ()
        lg.setColor(colors.white)
        lg.draw(assets.sprites.field, 0, 0)
        canim:draw(csheet, 304, 200)
        
        lg.setColor(colors.black)
        lg.setFont(fontBig)
        lg.printf('Telekinessball', 0, 100, gameW, 'center')
        -- lg.print('Press any button', 0, 200)

        lg.setColor(colors.white)

    end)
    
    push:finish()
end

function startScreen:keypressed(k)

end

return startScreen