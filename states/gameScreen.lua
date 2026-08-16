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
                Goalbox(16, 3 * 32, 4 * 32 - 16, 8 * 32, 1),
                Goalbox(gameW - 4 * 32, 3 * 32, 4 * 32 - 16, 8 * 32, 2)
}

local p1 = Player(0, 0, spritesheet, plAnims, 1, colors.aqua, 'step1')
local p2 = Player(0, 0, spritesheet, plAnims, 2, colors.orange, 'step2')

local spawnPoints = {
    [1] = {x = 224, y = 208, facing = 1},
    [2] = {x = 544, y = 208, facing = -1},
}

local playerControls = {
    {player = p1, input = p1input},
    {player = p2, input = p2input},
}

local maxScore = 5
local scores = {0, 0}
local gameEnd = false

--timeout vars
local maxIdleTime = 20
local timeIdleStart = 0
local timeIdle = 0
local countingIdle = false
local winner = 1


for i,ball in ipairs(balls) do
    ball.velVec.x, ball.velVec.y = 0, 0
    local newLoc = ballLocs[i]
    world:update( ball, newLoc[1], newLoc[2])
    ball.pos.x, ball.pos.y = newLoc[1], newLoc[2]
end

local function resetPlayer(player)
    local spawn = spawnPoints[player.num]
    player.grabbedBalls = {}
    player.ringRadius = telekinesisRadius
    player:teleport(spawn.x, spawn.y)
    player.facing = spawn.facing
end

local function handlePlayerInput(player, input, dt, onReset)
    input:update()

    local dx, dy = 0, 0
    local ix, iy = input:get('move')
    local inputPressed = ix ~= 0 or iy ~= 0

    if iy < 0 then dy = dy - 1 end
    if iy > 0 then dy = dy + 1 end
    if ix < 0 then dx = dx - 1 end
    if ix > 0 then dx = dx + 1 end

    player:update(dt, dx, dy)

    if input:pressed('action') then
        inputPressed = true
        player:action(balls)
    end

    if input:pressed('reset') and gameEnd then
        inputPressed = true
        onReset()
    end

    if player.pos.x < -player.w or player.pos.x > gameW
        or player.pos.y < -player.h or player.pos.y > gameH then
        local spawn = spawnPoints[player.num]
        player:teleport(spawn.x, spawn.y)
    end

    return inputPressed
end

function gameScreen:reset()
    screen:setShake(10)
    TEsound.play(exp3)
    TEsound.volume('bgm', volumeState)
    scores[1], scores[2] = 0, 0
    gameEnd = false
    for i,ball in ipairs(balls) do
        ball.velVec.x, ball.velVec.y = 0, 0
        ball.status = 0
        ball.auraColor = colors.white
        ball.opacity = 0.6
        local newLoc = ballLocs[i]
        world:update(ball, newLoc[1], newLoc[2])
        ball.pos.x, ball.pos.y =  newLoc[1], newLoc[2]
    end

    for _, control in ipairs(playerControls) do
        resetPlayer(control.player)
    end

    --timeout vars
    countingIdle = false
    timeIdleStart = 0
    timeIdle = 0
end

function gameScreen:enter()
    lg.setFont(fontBig)
    self:reset()
end

function gameScreen:update(dt)
    Timer.update(dt)
    TEsound.cleanup()

    local anyInputPressed = false
    if not gameEnd and (scores[1] >= maxScore or scores[2] >= maxScore) then
        gameEnd = true
        if scores[1] >= maxScore then winner = 1 
        else winner = 2 end
    end

    if gameEnd then 
        rcanim:update(dt) 
    end

    screen:update(dt)

    local function onReset()
        self:reset()
    end

    for _, control in ipairs(playerControls) do
        if handlePlayerInput(control.player, control.input, dt, onReset) then
            anyInputPressed = true
        end
    end

    if not anyInputPressed then
        if not countingIdle then
            countingIdle = true
            timeIdleStart = lt.getTime()
        else
            timeIdle = lt.getTime() - timeIdleStart
        end
    else
        countingIdle = false
        timeIdle = 0
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
        if winner == 2 then
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

    if countingIdle and timeIdle > maxIdleTime - 6 then 
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