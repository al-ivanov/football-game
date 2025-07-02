local Goal = Class{ __includes = Entity }

function Goal:init(cx, cy, w, h, side)
    self.id = 'goal'
    self.side = side

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
        
        if otherObj.id == 'ball' and otherObj.inGoal == false then
            scores[self.side] = scores[self.side] + 1
            otherObj.inGoal = true
            otherObj.velVec = otherObj.velVec:normalized() * -launchStr / 2
        end
    end
end

function Goal:draw()
    lg.setColor(colors.red[1], colors.red[2], colors.red[3], 0.5)
    lg.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
end

return Goal