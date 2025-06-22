local startScreen = {}

function startScreen:enter()

end

function startScreen:draw()
    push:start()
    
    lg.print('Telekinessball', 0, 0)

    lg.print('Press any button', 0, 200)
    
    push:finish()
end

function startScreen:keypressed(k)
    gamestate.switch(gameScreen)
end

return startScreen