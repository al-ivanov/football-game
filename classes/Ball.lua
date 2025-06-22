local Ball = Class{ __includes = Entity }

function Ball:init(world, x, y, sprite)
    self.id = 'ball'
    self.sprite = sprite
    self.velVec = vec(0, 0)
    self.isHold = 0
    self.friction = 0.1

    Entity.init(self, world, x, y, sprite:getWidth(), sprite:getHeight())

    self.world:add(self, self:getRect())
    self.debugColor = colors.green

    self.filter = nil
end

function Ball:update()
    if (self.isHold == 0) then
        local actualX, actualY, cols, len = world:move(self, self.pos.x + self.velVec.x, self.pos.y + self.velVec.y)

        if self.velVec:len() ~= 0 then
            self.velVec = self.velVec * 0.9
        end

        -- if magnitude is < some val, set it to 0,0
        if self.velVec:len() <  0.1 then
            self.velVec.x, self.velVec.y = 0, 0
        end

        for i=1, len do
            local otherObj = cols[i].other
            if otherObj.id == 'wall' then
                -- bounce 
            end
        end

        self.pos.x, self.pos.y = actualX, actualY
    end
end

function Ball:draw()
    lg.draw(self.sprite, self.pos.x, self.pos.y)
    if debug then
        lg.setColor(self.debugColor[1], self.debugColor[2], self.debugColor[3], 0.8)
        lg.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
    end
end


return Ball