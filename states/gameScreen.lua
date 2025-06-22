local gameScreen = {}

function gameScreen:enter()

end

function gameScreen:draw()
    push:start()

    lg.print('Game Screen', 0, 0)
    
    push:finish()
end

function gameScreen:keypressed(k)

end

return gameScreen