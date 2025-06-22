local Player = Class{ __includes = Entity }

function Player:init(world, x, y, sprite, color)
    -- visual
    self.id = 'player'
    self.sprite = sprite
    self.color = color
    
    -- technical
    self.spd = 7
    self.grabbedBalls = {}
    
    Entity.init(self, world, x, y, sprite:getWidth(), sprite:getHeight())
    
    -- collision
    self.world:add(self, self:getRect()) 
    self.filter = function(item, other)
        if (other.id == 'player') then
            return 'cross'
        end
        
        return 'slide'
    end
end

function Player:update(dt, dx, dy)
    local actualX, actualY, cols, len = self.world:move(self, self.pos.x + dx * self.spd, 
                                            self.pos.y + dy * self.spd, self.filter)
    
    -- if isGrabbing, attempt to move all grabbed balls with you
    
    self.pos.x, self.pos.y = actualX, actualY
end

function Player:launchAll()
    -- for all grabbed balls, get self.pos - other.pos. Set ball velocityVector to that. Remove them from grabbed balls
end

function Player:action(balls)
    if (#self.grabbedBalls > 0) then
        self:launchAll()
    else
        -- check thru all balls and see if they're in range. If so, set their vel vec to 0 and push them all into grabbedBalls
    end
end

function Player:draw()
    -- telekinesis field
    lg.setColor(self.color[1], self.color[2], self.color[3], 0.5)
    lg.circle('fill', self.pos.x + self.w / 2, self.pos.y + self.h / 2, telekinesisRadius)
    
    -- character sprite
    lg.setColor(self.color)
    lg.draw(self.sprite, self.pos.x, self.pos.y)
    
    lg.setColor(colors.white)
end

return Player