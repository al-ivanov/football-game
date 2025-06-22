local gameScreen = {}

-- game vars
local arena = nil
local balls = {}

local p1 = Player(world, 300, 300, assets.sprites.player, colors.aqua)
local p2 = Player(world, 500, 300, assets.sprites.player, colors.orange)
local ball1 = Ball(world, 400, 200, assets.sprites.baseball)

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
    
    if (dx ~= 0 or dy ~= 0) then
        local rss = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
        p1:update(dt, dx / rss, dy / rss)
    end
    
    -- p2 input
    
    -- update balls
    ball1:update()
end

function gameScreen:draw()
    push:start()
    lg.rectangle('fill', 0, 0, gameW, gameH)
    p1:draw()
    p2:draw()
    
    -- draw balls
    ball1:draw()
    
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