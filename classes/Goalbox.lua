local Goalbox = Class{ __includes = Entity }

function Goalbox:init(x, y, w, h, num)
    self.id = 'goalbox'
    self.num = num
    
    Entity.init(self, x, y, w, h)
    world:add(self, self:getRect())
    
    self.filter = function(item, other)
        if other.id == 'ball' or other.id == 'player' then
            return 'cross'
        end

        return 'slide'
    end
end

function Goalbox:update(dt)
    world:check(self, self.x, self.y, self.filter)
end

return Goalbox