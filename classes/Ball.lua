local Ball = Class{ __includes = Entity }

function Ball:init(world, x, y, sprite)
    self.id = 'ball'
    self.sprite = sprite
    self.velVec = vec(0, 0)
    self.isHold = 0
    self.friction = 0.1

    Entity.init(self, world, x, y, sprite:getWidth(), sprite:getHeight())

    self.world:add(self, self:getRect())

    self.filter = nil
end

function Ball:update()
    if (self.isHold == 0) then
        local actualX, actualY, cols, len = world:move(self, self.pos.x + self.velVec.x, self.pos.y + self.velVec.y)

        for i=1, len do
            local otherObj = cols[i].otherObj
            if otherObj.id == 'player' then
                
            end
        end

        self.pos.x, self.pos.y = actualX, actualY
    end
end

function Ball:draw()
    lg.draw(self.sprite, self.pos.x, self.pos.y)
end


return Ball