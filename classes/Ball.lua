local Ball = Class{ __includes = Entity }

local FREE_OPACITY = 0.6
local HELD_OPACITY = 0.8

function Ball:init(cx, cy, sprite)
    self.id = 'ball'
    self.sprite = sprite
    self.velVec = vec(0, 0)
    self.status = 0 -- 0 free, 1 held
    self.auraColor = colors.white
    self.auraRad = 35
    self.opacity = FREE_OPACITY

    self.startPos = {x = cx, y = cy}

    Entity.init(self, cx, cy, sprite:getWidth(), sprite:getHeight())
    world:add(self, self:getRect())

    self.filter = function(item, other)
        if other.id == 'goal' or other.id == 'goalbox' then
            return 'cross'
        end
        return 'slide'
    end
end

function Ball:teleport(x, y)
    world:update(self, x, y)
    self.pos.x, self.pos.y = x, y
end

function Ball:release()
    self.status = 0
    self.auraColor = colors.white
    self.opacity = FREE_OPACITY
end

function Ball:hold(color)
    self.velVec.x, self.velVec.y = 0, 0
    self.status = 1
    self.auraColor = color
    self.opacity = HELD_OPACITY
end

function Ball:resetTo(x, y)
    self.velVec.x, self.velVec.y = 0, 0
    self:release()
    self:teleport(x, y)
end

function Ball:update(dt, p1, p2)
    local actualX, actualY, cols, len = world:move(
        self,
        self.pos.x + self.velVec.x,
        self.pos.y + self.velVec.y,
        self.filter
    )

    if self.status == 0 then
        local nearPlayer =
            (p1:getCenter() - self:getCenter()):len() < telekinesisRadius
            or (p2:getCenter() - self:getCenter()):len() < telekinesisRadius
        self.auraRad = nearPlayer and 50 or 35

        if self.velVec:len() ~= 0 then
            self.velVec = self.velVec * 0.97
        end

        if self.velVec:len() < 0.5 then
            self.velVec.x, self.velVec.y = 0, 0
        end

        for i = 1, len do
            local col = cols[i]
            local otherObj = col.other
            if otherObj.id == 'wall' or otherObj.id == 'player' then
                if col.normal.x == 0 then
                    self.velVec.y = self.velVec.y * -0.9
                else
                    self.velVec.x = self.velVec.x * -0.9
                end
                if self.velVec:len() > 8 then
                    TEsound.play(hit1)
                end
            elseif otherObj.id == 'ball' then
                local sumVec = self.velVec + otherObj.velVec
                self.velVec.x, self.velVec.y = sumVec.x * -0.8, sumVec.y * -0.8
                otherObj.velVec.x, otherObj.velVec.y = sumVec.x * 0.8, sumVec.y * 0.8
            end
        end
    end

    self.pos.x, self.pos.y = actualX, actualY
end

function Ball:draw()
    lg.setColor(self.auraColor[1], self.auraColor[2], self.auraColor[3], self.opacity)
    lg.circle('fill', self.pos.x + self.w / 2, self.pos.y + self.h / 2, self.auraRad + lm.random(-1, 1))

    lg.setColor(colors.white)
    lg.draw(
        self.sprite,
        self.pos.x + self.w / 2,
        self.pos.y + self.h / 2,
        self.velVec:len() % (2 * math.pi),
        1,
        1,
        self.w / 2,
        self.h / 2
    )
end

function Ball:enterFromSide()
    local low, high = 60, 120
    local newY = 370

    if lm.random() > 0.5 then
        low, high = low + 180, high + 180
        newY = 30
    end

    local newAngle = lm.random(low, high)
    self:teleport(376, newY)
    self.velVec = vec.fromPolar(math.rad(newAngle)) * 3
end

return Ball
