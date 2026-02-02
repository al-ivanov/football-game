local Wall = Class{ __includes = Entity}

function Wall:init(cx, cy, w, h)
    self.id = 'wall'
    
    Entity.init(self, cx - w / 2, cy - h / 2, w, h)
    world:add(self, self:getRect())
end

return Wall