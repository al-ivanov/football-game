local startScreen = {}

local testSystem = lg.newParticleSystem(assets.sprites.ring)
testSystem:setParticleLifetime(1, 3)
testSystem:setEmissionRate(1)
testSystem:setSizeVariation(1)
testSystem:setColors(1, 0, 0, 1, 1, 0, 0, 0)
testSystem:setSpeed(-250, -200)
testSystem:setSpread(math.rad(160))
testSystem:pause()

function startScreen:enter()

end

function startScreen:update(dt)
    canim:update(dt)
    p1input:update()
    p2input:update()

    if p1input:pressed('action') or p2input:pressed('action') then
        gamestate.switch(gameScreen)
    end

    testSystem:update(dt)
end

function startScreen:draw()
    push:start()

    effect(function ()
        lg.setColor(colors.white)
        lg.draw(assets.sprites.field, 0, 0)
        -- canim:draw(csheet, 304, 200)
        lg.draw(testSystem, 400, 200)
        
        lg.setColor(colors.black)
        lg.setFont(fontBig)
        lg.printf('Telekinessball', 0, 100, gameW, 'center')
        -- lg.print('Press any button', 0, 200)

        lg.setColor(colors.white)

    end)
    
    push:finish()
end

function startScreen:keypressed(k)
    if k == 'a' then
        testSystem:start()
        testSystem:emit(30)
        testSystem:pause()
    end
end

return startScreen