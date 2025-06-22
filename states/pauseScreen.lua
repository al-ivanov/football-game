local pauseScreen = {}

function pauseScreen:enter(from)
    self.from = from
end

function pauseScreen:draw()
    push:start()

    self.from:draw()
    
    lg.setColor(0, 0, 1)
    lg.rectangle('fill', 0, 0, gameW, gameH)
    lg.setColor(1, 1, 1)
    
    lg.print('Pause Screen', 0, 0)
    
    push:finish()
end

function pauseScreen:keypressed(k)
    if (k == 'p') then
        return gamestate.pop()
    end
end

return pauseScreen