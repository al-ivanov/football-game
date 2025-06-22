local gameScreen = {}

-- game vars
local p1 = Player(world, 300, 300, assets.sprites.player, colors.aqua)
local p2 = Player(world, 500, 300, assets.sprites.player, colors.orange)

function gameScreen:enter()
    world:add({},0,0,10,10)
end

function gameScreen:update(dt)
    local dx, dy = 0, 0
    if (lk.isDown('w')) then dy = dy - 1 end
    if (lk.isDown('s')) then dy = dy + 1 end
    if (lk.isDown('a')) then dx = dx - 1 end
    if (lk.isDown('d')) then dx = dx + 1 end
    
    if (dx ~= 0 or dy ~= 0) then
        local rss = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
        p1:move(dx / rss, dy / rss)
    end
end

function gameScreen:draw()
    push:start()

    lg.print('Game Screen', 0, 0)
    
    p1:draw()
    p2:draw()
    
    push:finish()
end

function gameScreen:keypressed(k)
    if (k == 'space') then
        -- p1.action
    end
    
    if (k == 'enter') then
        -- p2.action
    end
end

return gameScreen