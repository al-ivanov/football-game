local gameScreen = {}

-- game vars
local arena = nil
local balls = {Ball(world, 400, 200, assets.sprites.baseball)}

local p1 = Player(world, 300, 300, assets.sprites.player, colors.aqua)
local p2 = Player(world, 500, 300, assets.sprites.player, colors.orange)

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
    
    -- update balls
    for i,ball in ipairs(balls) do
        ball:update()
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
    
    if (k == 'enter') then
        p2:action(balls)
    end
end

return gameScreen