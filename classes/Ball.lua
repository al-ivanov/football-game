local Ball = Class{ __includes = Entity }

function Ball:init(cx, cy, sprite)
    self.id = 'ball'
    self.sprite = sprite
    self.velVec = vec(0, 0)
    self.isHold = 0
    self.friction = 0.1

    Entity.init(self, cx - sprite:getWidth() / 2, cy - sprite:getHeight() / 2, sprite:getWidth(), sprite:getHeight())

    -- collision
    world:add(self, self:getRect())

    self.filter = nil
end

function Ball:update(dt)
    local actualX, actualY, cols, len = world:move(self, self.pos.x + self.velVec.x, self.pos.y + self.velVec.y)
    if self.isHold == 0 then
        -- decelerate
        if self.velVec:len() ~= 0 then
            self.velVec = self.velVec * 0.97
        end

        -- if magnitude is < some val, set it to 0,0
        if self.velVec:len() <  0.5 then
            self.velVec.x, self.velVec.y = 0, 0
        end


        -- bounce on walls
        for i=1, len do
            local col = cols[i]
            local otherObj = col.other
            if otherObj.id == 'wall' or otherObj.id == 'player' then
                -- bounce
                if col.normal.x == 0 then
                    self.velVec.y = self.velVec.y * - 1
                else 
                    self.velVec.x = self.velVec.x * - 1
                end
                if self.velVec:len() > 5 then
                    exp3:play()
                end
            elseif otherObj.id == 'ball' then
                --trade
                --[[local tx, ty = otherObj.velVec.x, otherObj.velVec.y
                otherObj.velVec.x, otherObj.velVec.y = self.velVec.x, self.velVec.y
                self.velVec.x, self.velVec.y = tx, ty]]
                local sumVec = self.velVec + otherObj.velVec
                self.velVec.x, self.velVec.y = sumVec.x * -0.3, sumVec.y * -0.3
                otherObj.velVec.x, otherObj.velVec.y = sumVec.x * 0.8, sumVec.y * 0.8
            end
        end
    end -- if ball is active

    self.pos.x, self.pos.y = actualX, actualY
end

function Ball:draw()
    lg.draw(self.sprite, self.pos.x, self.pos.y)
    if debug then
        if self.isHold == 0 then
            lg.setColor(colors.green[1], colors.green[2], colors.green[3], 0.8)
        elseif self.isHold == 1 then
            lg.setColor(colors.blue[1], colors.blue[2], colors.blue[3], 0.8)
        end
        lg.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
    end
end


return Ball