local startScreen = {}

function startScreen:enter()

end

function startScreen:draw()
    push:start()

    effect(function ()
        lg.setColor(colors.white)
        lg.rectangle('fill', 0, 0, gameW, gameH)
        
        lg.setColor(colors.black)
        lg.setFont(fontBig)
        lg.printf('Telekinessball', 0, 100, gameW, 'center')
        -- lg.print('Press any button', 0, 200)
        
        
    end)
    
    push:finish()
end

function startScreen:keypressed(k)
    gamestate.switch(gameScreen)
end

return startScreen