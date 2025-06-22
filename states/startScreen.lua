local startScreen = {}

function startScreen:enter()

end

function startScreen:draw()
    push:start()
    
    lg.print('Start Screen', 0, 0)
    
    push:finish()
end

function startScreen:keypressed(k)
    gamestate.switch(gameScreen)
end

return startScreen