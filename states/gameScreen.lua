local gameScreen = {}

local trophy = assets.sprites.trophy
local spritesheet = assets.sprites.spritesheet
local grid = anim8.newGrid(32, 32, spritesheet:getWidth(), spritesheet:getHeight())
local plAnims = {
    anim8.newAnimation(grid('1-2', 1), 0.2),
    anim8.newAnimation(grid('3-4', 1), 0.1),
}

local walls = {
    Wall(-20, 225, 40, 450),
    Wall(820, 225, 40, 450),
    Wall(400, -20, 800, 40),
    Wall(400, 470, 800, 40),
    Wall(32 * 7.5, 32 * 4, 32, 64),
    Wall(32 * 7.5, 32 * 10, 32, 64),
    Wall(32 * 17.5, 32 * 4, 32, 64),
    Wall(32 * 17.5, 32 * 10, 32, 64),
}

local goals = {
    Goal(7, 225, 14, 128, 2, colors.aqua),
    Goal(793, 225, 14, 128, 1, colors.orange),
}

local ballSpawns = Config.ballSpawns
local balls = {}
for i, loc in ipairs(ballSpawns) do
    balls[i] = Ball(loc[1], loc[2], assets.sprites.ball)
end

local goalboxes = {
    Goalbox(16, 3 * 32, 4 * 32 - 16, 8 * 32, 1),
    Goalbox(gameW - 4 * 32, 3 * 32, 4 * 32 - 16, 8 * 32, 2),
}

local p1 = Player(0, 0, spritesheet, plAnims, 1, colors.aqua, 'step1')
local p2 = Player(0, 0, spritesheet, plAnims, 2, colors.orange, 'step2')

local spawnPoints = Config.spawnPoints
local playerControls = {
    {player = p1, input = p1input},
    {player = p2, input = p2input},
}

local maxScore = Config.maxScore
local maxIdleTime = Config.maxIdleTime
local scores = {0, 0}
local gameEnd = false
local timeIdleStart = 0
local timeIdle = 0
local countingIdle = false
local winner = 1

local function resetPlayer(player)
    local spawn = spawnPoints[player.num]
    player:clearGrab()
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
    TEsound.volume('bgm', Audio.volumeState)
    scores[1], scores[2] = 0, 0
    gameEnd = false

    for i, ball in ipairs(balls) do
        local loc = ballSpawns[i]
        ball:resetTo(loc[1], loc[2])
    end

    for _, control in ipairs(playerControls) do
        resetPlayer(control.player)
    end

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
        winner = scores[1] >= maxScore and 1 or 2
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

    for _, ball in ipairs(balls) do
        ball:update(dt, p1, p2)
        if ball.pos.x < -ball.w or ball.pos.x > gameW
            or ball.pos.y < -ball.h or ball.pos.y > gameH then
            ball:teleport(ball.startPos.x, ball.startPos.y)
        end
    end

    for _, goal in ipairs(goals) do
        goal:update(dt, scores)
    end
end

function gameScreen:draw()
    push:start()

    effect(function()
        screen:apply()
        lg.draw(assets.sprites.field, 0, 0)

        for _, ball in ipairs(balls) do
            ball:draw()
        end

        for _, goal in ipairs(goals) do
            goal:draw()
        end

        p1:draw()
        p2:draw()

        if not gameEnd then
            lg.setColor(colors.aqua)
            lg.printf(scores[1] .. '/' .. maxScore, 20, 20, gameW, 'left')
            lg.setColor(colors.orange)
            lg.printf(scores[2] .. '/' .. maxScore, -20, 20, gameW, 'right')
        else
            local winPlayer = winner == 1 and p1 or p2
            lg.setColor(colors.white)
            lg.draw(trophy, winPlayer.pos.x - 8, winPlayer.pos.y - 55)

            rcanim:draw(csheet, 400 - 96 - 290, 320)
            rcanim:draw(csheet, 400 - 96 + 290, 320)

            lg.setColor(colors.black)
            lg.printf('GAME', 20, 20, gameW, 'left')
            lg.printf('OVER', -20, 20, gameW, 'right')
        end

        if countingIdle and timeIdle > maxIdleTime - Config.idleWarnLead then
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
