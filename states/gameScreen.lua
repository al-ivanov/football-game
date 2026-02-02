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
    Wall(-5, 225, 10, 450),
    Wall(805, 225, 10, 450),
    Wall(400, -5, 800, 10),
    Wall(400, 455, 800, 10),
}

local goals = {
    Goal(10, 225, 10, 128, 2),
    Goal(790, 225, 10, 128, 1)
}

local maxScore = 5

local scores = {0, 0}

local balls = {
    Ball(400 - 24, 225 - 24, assets.sprites.baseball),
    Ball(380 - 24, 125 - 24, assets.sprites.baseball),
    Ball(460 - 24, 125 - 24, assets.sprites.baseball),
    Ball(340 - 24, 325 - 24, assets.sprites.baseball),
    Ball(460 - 24, 325 - 24, assets.sprites.baseball),
}

local ballLocs = {
    {400 - 24, 225 - 24},
    {380 - 24, 125 - 24},
    {460 - 24, 125 - 24},
    {340 - 24, 325 - 24},
    {460 - 24, 325 - 24},
}

local p1 = Player(0, 0, spritesheet, plAnims, colors.aqua, step3)
local p2 = Player(0, 0, spritesheet, plAnims, colors.orange, step4)

local gameEnd = false

for i,ball in ipairs(balls) do
    ball.velVec.x, ball.velVec.y = 0, 0
    local newLoc = ballLocs[i]
    world:update( ball, newLoc[1], newLoc[2])
    ball.pos.x, ball.pos.y = newLoc[1], newLoc[2]
end

function gameScreen:reset()
    screen:setShake(10)
    exp3:play()
    scores[1], scores[2] = 0, 0
    gameEnd = false
    for i,ball in ipairs(balls) do
        ball.velVec.x, ball.velVec.y = 0, 0
        local newLoc = ballLocs[i]
        world:update(ball, newLoc[1], newLoc[2])
        ball.pos.x, ball.pos.y =  newLoc[1], newLoc[2]
    end
    
    world:update(p1, 224, 6.5 * 32)
    p1.pos.x, p1.pos.y = 224, 6.5 * 32
    p1.facing = 1
    
    world:update(p2, 17 * 32, 6.5 * 32)
    p2.pos.x, p2.pos.y = 17 * 32, 6.5 * 32
    p2.facing = -1
end

function gameScreen:enter()
    self.reset()
end

function gameScreen:update(dt)
    if scores[1] >= 10 or scores[2] >= 10 then
        gameEnd = true
    end
    
    local dx, dy = 0, 0
    screen:update(dt)
    
    -- p1 input
    -- keyboard
    if (lk.isDown('w')) then dy = dy - 1 end
    if (lk.isDown('s')) then dy = dy + 1 end
    if (lk.isDown('a')) then dx = dx - 1 end
    if (lk.isDown('d')) then dx = dx + 1 end
    
    -- joystick
    
    p1:update(dt, dx, dy)
    
    -- p2 input
    -- keyboard
    dx, dy = 0, 0
    if (lk.isDown('up')) then dy = dy - 1 end
    if (lk.isDown('down')) then dy = dy + 1 end
    if (lk.isDown('left')) then dx = dx - 1 end
    if (lk.isDown('right')) then dx = dx + 1 end

    -- joystick
    
    p2:update(dt, dx, dy)
    
    -- update balls
    for i,ball in ipairs(balls) do
        ball:update(dt, p1, p2)
    end

    -- update goals
    for i,goal in ipairs(goals) do
        goal:update(dt, scores)
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
    lg.setColor(colors.white)
    lg.printf(scores[1] .. '/10      ' .. scores[2] .. '/10', 0, 28, gameW, 'center')
    
    if gameEnd then 
        local winX, winY = p1.pos.x, p1.pos.y
        if scores[2] >= 10 then
            winX, winY = p2.pos.x, p2.pos.y
        end
        
        lg.draw(trophy, winX - 8, winY - 55)
    end
    
    end)
    
    push:finish()
end

function gameScreen:keypressed(k)
    if k == 'r' then
        self:reset()
    end
    if k == 'space' then
        if gameEnd then
            self:reset()
        else
            p1:action(balls)
        end
    end
    
    if k == 'return' then
        if gameEnd then
            self:reset()
        else
            p2:action(balls)
        end
    end
end

return gameScreen