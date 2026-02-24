local Goal = Class{ __includes = Entity }

function Goal:init(cx, cy, w, h, side, color)
    self.id = 'goal'
    self.side = side
    self.color = color
    
    self.psystem = lg.newParticleSystem(assets.sprites.ring)
    self.psystem:setParticleLifetime(0.5, 1.5)
    self.psystem:setEmissionRate(1)
    self.psystem:setSizeVariation(1)
    
    self.psystem:setColors(self.color[1], 
                            self.color[2], 
                            self.color[3], 1,
                            self.color[1], 
                            self.color[2], 
                            self.color[3], 0) 
    
    self.psystem:setSpeed(-260, 225)
    if self.side == 2 then
        self.psystem:setSpeed(225, 260)
    end
    self.psystem:setSpread(math.rad(160))
    self.psystem:pause()

    Entity.init(self, cx - w / 2, cy - h / 2, w, h)
    world:add(self, self:getRect())
    
    self.filter = function(item, other)
        if other.id == 'ball' then
            return 'cross'
        end
        
        return 'slide'
    end
end

function Goal:update(dt, scores)
    local aX, aY, cols, len = world:check(self, self.x, self.y, self.filter)
    
    for i=1,len do
        local col = cols[i]
        local otherObj = col.other
        
        if otherObj.id == 'ball' and otherObj.status == 0 then
            scores[self.side] = scores[self.side] + 1
            otherObj:enterFromSide()
            exp3:play()
            self.psystem:start()
            self.psystem:emit(30)
            self.psystem:pause()
        end
    end

    self.psystem:update(dt)
end

function Goal:draw()
    lg.setColor(self.color[1], self.color[2], self.color[3], 0.8)
    lg.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)

    lg.setColor(colors.white)
    lg.draw(self.psystem, self.pos.x, self.pos.y + self.h / 2)
end

return Goal