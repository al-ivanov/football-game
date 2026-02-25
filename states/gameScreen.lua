local gameScreen = {}

-- animation
local trophy = assets.sprites.trophy
local spritesheet = assets.sprites.spritesheet
local g = anim8.newGrid(32, 32, spritesheet:getWidth(), spritesheet:getHeight())
local plAnims = {
                anim8.newAnimation(g('1-2', 1), 0.2),
                anim8.newAnimation(g('3-4', 1), 0.1)
                }

-- game vars
local walls = {
    Wall(-20, 225, 40, 450),
    Wall(820, 225, 40, 450),
    Wall(400, -20, 800, 40),
    Wall(400, 470, 800, 40),

    Wall(32 * 7.5, 32 * 4, 32, 64), --TL
    Wall(32 * 7.5, 32 * 10, 32, 64), --BL
    Wall(32 * 17.5, 32 * 4, 32, 64), --TR
    Wall(32 * 17.5, 32 * 10, 32, 64), --BR
}

local goals = {
    Goal(7, 225, 14, 128, 2, colors.aqua),
    Goal(793, 225, 14, 128, 1, colors.orange)
}

local balls = {
    Ball(400-24, 225-24, assets.sprites.ball),
    Ball(400-24, 125-24, assets.sprites.ball),
    Ball(400-24, 325-24, assets.sprites.ball),
}

local ballLocs = {
                    {400-24, 225-24},
                    {400-24, 125-24},
                    {400-24, 325-24},
                    }

local goalboxes = {
                Goalbox(16, 5 * 32, 48, 128),
                Goalbox(gameW - 64, 5 * 32, 48, 128)
}

local p1 = Player(0, 0, spritesheet, plAnims, colors.aqua, 'step1')
local p2 = Player(0, 0, spritesheet, plAnims, colors.orange, 'step2')

local maxScore = 5
local scores = {0, 0}
local gameEnd = false

--timeout vars
local maxIdleTime = 20
local timeIdleStart = 0
local timeIdle = 0
local countingIdle = false


for i,ball in ipairs(balls) do
    ball.velVec.x, ball.velVec.y = 0, 0
    local newLoc = ballLocs[i]
    world:update( ball, newLoc[1], newLoc[2])
    ball.pos.x, ball.pos.y = newLoc[1], newLoc[2]
end

function gameScreen:reset()
    screen:setShake(10)
    TEsound.play(exp3)
    TEsound.volume('bgm', maxVolome)
    scores[1], scores[2] = 0, 0
    gameEnd = false
    for i,ball in ipairs(balls) do
        ball.velVec.x, ball.velVec.y = 0, 0
        local newLoc = ballLocs[i]
        world:update(ball, newLoc[1], newLoc[2])
        ball.pos.x, ball.pos.y =  newLoc[1], newLoc[2]
    end
    
    p1:teleport(224, 208)
    p1.facing = 1
    
    p2:teleport(544, 208)
    p2.facing = -1

    --timeout vars
    countingIdle = false
    timeIdleStart = 0
    timeIdle = 0
end

function gameScreen:enter()
    lg.setFont(fontBig)
    self.reset()
end

function gameScreen:update(dt)
    Timer.update(dt)
    TEsound.cleanup()

    local anyInputPressed = false
    if scores[1] >= maxScore or scores[2] >= maxScore then
        gameEnd = true
    end

    if gameEnd then 
        rcanim:update(dt) 
    end
    
    local dx, dy = 0, 0
    screen:update(dt)
    
    -- p1 input
    p1input:update()
    --movement
    local ix, iy = p1input:get('move')
    if iy ~= 0 or ix ~= 0 then
        anyInputPressed = true
    end
    if (iy < 0) then dy = dy - 1 end
    if (iy > 0) then dy = dy + 1 end
    if (ix < 0) then dx = dx - 1 end
    if (ix > 0) then dx = dx + 1 end
    
    p1:update(dt, dx, dy)

    --keypresses
    if not gameEnd and p1input:pressed('action') then
        anyInputPressed = true
        p1:action(balls)
    end

    if not gameEnd and p1input:pressed('reset') and gameEnd then
        anyInputPressed = true
        self:reset()
    end

    if p1.pos.x < -p1.w or p1.pos.x > gameW or p1.pos.y < -p1.h or p1.pos.y > gameH then
        p1:teleport(224, 208)
    end
    
    -- p2 input
    p2input:update()
    --movement
    dx, dy = 0, 0
    ix, iy = 0, 0
    ix, iy = p2input:get('move')
    if iy ~= 0 or ix ~= 0 then
        anyInputPressed = true
    end
    if (iy < 0) then dy = dy - 1 end
    if (iy > 0) then dy = dy + 1 end
    if (ix < 0) then dx = dx - 1 end
    if (ix > 0) then dx = dx + 1 end

    p2:update(dt, dx, dy)

    --keypresses
    if p2input:pressed('action') then
        anyInputPressed = true
        p2:action(balls)
    end

    if p2input:pressed('reset') and gameEnd then
        anyInputPressed = true
        self:reset()
    end

    if p2.pos.x < -p2.w or p2.pos.x > gameW or p2.pos.y < -p2.h or p2.pos.y > gameH then
        p2:teleport(544, 208)
    end

    if not anyInputPressed then
        if not countingIdleTime then
            countingIdleTime = true
            timeIdleStart = lt.getTime()
        else
            timeIdle = lt.getTime() - timeIdleStart
        end
    else
        countingIdleTime = false
    end
    
    -- update balls
    for i,ball in ipairs(balls) do
        ball:update(dt, p1, p2)
        if ball.pos.x < -ball.w or ball.pos.x > gameW or ball.pos.y < -ball.h or ball.pos.y > gameH then
            ball:teleport(ball.startPos.x + ball.w / 2, ball.startPos.y + ball.h / 2)
        end
    end

    -- update goals
    for i,goal in ipairs(goals) do
        goal:update(dt, scores)
    end

    for i,goalbox in ipairs(goalboxes) do
        goalbox:update(dt)
    end
end

function gameScreen:draw()
    push:start()
    
    effect(function()
    
    screen:apply()
    
    lg.draw(assets.sprites.field, 0, 0)
    
    -- draw balls
    for i,ball in ipairs(balls) do
        ball:draw()
    end
    
    for i,goal in ipairs(goals) do
            goal:draw()
        end
    
    -- draw player
    p1:draw()
    p2:draw()
    
    -- draw scores
    if not gameEnd then
        lg.setColor(colors.aqua)
        lg.printf(scores[1] .. '/' .. maxScore, 20, 20, gameW, 'left')
        lg.setColor(colors.orange)
        lg.printf(scores[2] .. '/' .. maxScore, -20, 20, gameW, 'right')
    -- game over stuff
    else
        -- trophy
        local winX, winY = p1.pos.x, p1.pos.y
        if scores[2] >= maxScore then
            winX, winY = p2.pos.x, p2.pos.y
        end
        
        lg.setColor(colors.white)
        lg.draw(trophy, winX - 8, winY - 55)

        -- button animation
        rcanim:draw(csheet, 400 - 96 - 290, 320)
        rcanim:draw(csheet, 400 - 96 + 290, 320)

        lg.setColor(colors.black)
        lg.printf('GAME', 20, 20, gameW, 'left')
        lg.printf('OVER', -20, 20, gameW, 'right')
    end

    if countingIdleTime and timeIdle > maxIdleTime - 6 then 
        lg.setColor(0, 0, 0, 0.9)
        lg.rectangle('fill', 100, 180, 600, 100)
        lg.setColor(1, 1, 1, 0.9)
        lg.printf('RESET IN ' .. math.floor(maxIdleTime - timeIdle), 0, 200, gameW, 'center')
        
        if timeIdle > maxIdleTime then
            gamestate.switch(startScreen)
        end
    end
    
    end)
    
    push:finish()
end

return gameScreen