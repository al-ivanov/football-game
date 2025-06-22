local Player = Class{ __includes = Entity }

function Player:init(world, x, y, sprite, color)
    self.id = 'player'
    self.sprite = sprite
    self.color = color
    
    self.spd = 7
    self.invinc = false
    self.isGrabbing = false
    self.grabbedEnemies = {}
    
    Entity.init(self, world, x, y, sprite:getWidth(), sprite:getHeight())
    self.world:add(self, self:getRect())
    
    self.filter = function(item, other)
        if (other.id == 'enemy' or other.id == 'projectile'
                or other.id == 'player') then
            return 'cross'
        end
        
        return 'slide'
    end
end

function Player:move(dx, dy)
    self.x, self.y = self.world:move(self, self.x + dx * self.spd, 
                                            self.y + dy * self.spd, self.filter)
end

function Player:draw()
    lg.setColor(self.color[1], self.color[2], self.color[3], 0.5)
    lg.circle('fill', self.x + self.w / 2, self.y + self.h / 2, telekinesisRadius)
    
    lg.setColor(self.color)
    lg.draw(self.sprite, self.x, self.y)
    
    lg.setColor(colors.white)
end

return Player