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
        lg.rectangle('fill', 0, 0, gameW, gameH)
        canim:draw(csheet, 304, 200)
        
        lg.setColor(colors.black)
        lg.setFont(fontBig)
        lg.printf('Telekinessball', 0, 100, gameW, 'center')
        -- lg.print('Press any button', 0, 200)eqwe

        
    end)
    
    push:finish()
end

function startScreen:keypressed(k)
    -- gamestate.switch(gameScreen)
end

return startScreen