local Goalbox = Class{ __includes = Entity }

function Goalbox:init(x, y, w, h)
    self.id = 'goalbox'
    
    Entity.init(self, x, y, w, h)
    world:add(self, self:getRect())
    
    self.filter = function(item, other)
        
        return 'slide'
    end
end

function Goalbox:update(dt)

end

return Goalbox