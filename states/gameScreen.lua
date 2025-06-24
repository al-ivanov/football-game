local gameScreen = {}

-- animation
local spritesheet = assets.sprites.spritesheet
local g = anim8.newGrid(32, 32, spritesheet:getWidth(), spritesheet:getHeight())
local plAnims = {
                anim8.newAnimation(g('1-2', 1), 0.2),
                anim8.newAnimation(g('3-4', 1), 0.2)
                }

-- game vars
local arena = nil
local balls = {Ball(400, 200, assets.sprites.baseball)}

local p1 = Player(300, 300, spritesheet, plAnims, colors.aqua)
local p2 = Player(500, 300, spritesheet, plAnims, colors.orange)

function gameScreen:enter()
    --sti.new('assets/maps/map1.lua', { 'bump' })
    lg.setBackgroundColor(1, 1, 1)
end

function gameScreen:update(dt)
    local dx, dy = 0, 0
    
    -- p1 input
    if (lk.isDown('w')) then dy = dy - 1 end
    if (lk.isDown('s')) then dy = dy + 1 end
    if (lk.isDown('a')) then dx = dx - 1 end
    if (lk.isDown('d')) then dx = dx + 1 end
    
    p1:update(dt, dx, dy)
    
    -- p2 input

    dx, dy = 0, 0
    if (lk.isDown('up')) then dy = dy - 1 end
    if (lk.isDown('down')) then dy = dy + 1 end
    if (lk.isDown('left')) then dx = dx - 1 end
    if (lk.isDown('right')) then dx = dx + 1 end
    
    p2:update(dt, dx, dy)
    
    -- update balls
    for i,ball in ipairs(balls) do
        ball:update(dt)
    end
end

function gameScreen:draw()
    push:start()
    lg.rectangle('fill', 0, 0, gameW, gameH)
    p1:draw()
    p2:draw()
    
    -- draw balls
    for i,ball in ipairs(balls) do
        ball:draw()
    end
    
    push:finish()
end

function gameScreen:keypressed(k)
    if (k == 'space') then
        p1:action(balls)
    end
    
    if (k == 'return') then
        p2:action(balls)
    end
end

return gameScreen