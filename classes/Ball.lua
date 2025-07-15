local Ball = Class{ __includes = Entity }

function Ball:init(cx, cy, sprite)
    self.id = 'ball'
    self.sprite = sprite
    self.velVec = vec(0, 0)
    self.isHold = 0
    self.auraColor = colors.white
    self.auraRad = 35
    self.inGoal = false

    Entity.init(self, cx - sprite:getWidth() / 2, cy - sprite:getHeight() / 2, sprite:getWidth(), sprite:getHeight())

    -- collision
    world:add(self, self:getRect())

    self.filter = function (item, other)
        if other.id == 'goal' then
            return 'cross'
        end

        return 'slide'
    end

    self.filter = nil
end

function Ball:update(dt, p1, p2)
    local actualX, actualY, cols, len = world:move(self, self.pos.x + self.velVec.x, self.pos.y + self.velVec.y, self.filter)
    if self.isHold == 0 then
        if (p1:getCenter() - self:getCenter()):len() < telekinesisRadius or (p2:getCenter() - self:getCenter()):len() < telekinesisRadius then
            self.auraRad = 50
        else
            self.auraRad = 30
        end

        -- decelerate
        if self.velVec:len() ~= 0 then
            self.velVec = self.velVec * 0.97
        end

        -- if magnitude is < some val, set it to 0,0
        if self.velVec:len() <  0.5 then
            self.velVec.x, self.velVec.y = 0, 0
        end


        -- collision
        local notInGoal = true
        for i=1, len do
            local col = cols[i]
            local otherObj = col.other
            if otherObj.id == 'wall' or otherObj.id == 'player' then
                -- bounce
                if col.normal.x == 0 then
                    self.velVec.y = self.velVec.y * - 0.75
                else 
                    self.velVec.x = self.velVec.x * - 0.75
                end
                if self.velVec:len() > 10 then
                    hit1:play()
                end
            elseif otherObj.id == 'ball' then
                -- ball x ball collision
                local sumVec = self.velVec + otherObj.velVec
                self.velVec.x, self.velVec.y = sumVec.x * -0.5, sumVec.y * -0.5
                otherObj.velVec.x, otherObj.velVec.y = sumVec.x * 0.8, sumVec.y * 0.8
            elseif otherObj.id == 'goal' then
                notInGoal = false
            end
        end --for all collisions
        if notInGoal then
            self.inGoal = false
        end
    end -- if ball is active

    self.pos.x, self.pos.y = actualX, actualY
end

function Ball:draw()
    -- lg.draw(self.sprite, self.pos.x, self.pos.y)
    lg.setColor(self.auraColor[1], self.auraColor[2], self.auraColor[3], 0.7)
    lg.circle('fill', self.pos.x + self.w / 2, self.pos.y + self.h / 2, self.auraRad + lm.random(-1, 1))

    lg.setColor(colors.white)
    lg.draw(self.sprite, self.pos.x + self.w / 2, self.pos.y + self.h / 2, self.velVec:len() % (2 * math.pi), 1, 1, self.w / 2, self.h / 2)
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