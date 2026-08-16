local Player = Class{ __includes = Entity }

function Player:init(cx, cy, sheet, anims, num, color, sndTag)
    self.id = 'player'
    self.sheet = sheet
    -- Clone so players do not share animation timers.
    self.anims = {}
    for i, anim in ipairs(anims) do
        self.anims[i] = anim:clone()
    end
    self.curAnim = self.anims[1]
    self.num = num
    self.color = color
    self.sndTag = sndTag
    self.walkSndPlaying = false
    self.facing = 1
    self.radius = telekinesisRadius
    self.ringRadius = telekinesisRadius
    self.opacity = 0.5
    self.spd = Config.playerSpeed
    self.grabbedBalls = {}

    Entity.init(self, cx - 16, cy - 16, 32, 32)
    world:add(self, self:getRect())

    self.filter = function(item, other)
        if other.id == 'goalbox' and other.num == self.num then
            return 'cross'
        end
        return 'slide'
    end
end

function Player:dropBall(ball, index)
    ball:release()
    table.remove(self.grabbedBalls, index)
    if #self.grabbedBalls == 0 then
        self.ringRadius = telekinesisRadius
    end
end

function Player:update(dt, dx, dy)
    if dx ~= 0 or dy ~= 0 then
        local rss = math.sqrt(dx * dx + dy * dy)
        dx, dy = dx / rss, dy / rss

        self.curAnim = self.anims[2]
        if not self.walkSndPlaying then
            TEsound.volume(self.sndTag, 1)
            self.walkSndPlaying = true
        end
    else
        self.curAnim = self.anims[1]
        if self.walkSndPlaying then
            TEsound.volume(self.sndTag, 0)
            self.walkSndPlaying = false
        end
    end

    if dx < 0 then
        self.facing = -1
    elseif dx > 0 then
        self.facing = 1
    end

    local actualX, actualY, cols, len = world:move(
        self,
        self.pos.x + dx * self.spd,
        self.pos.y + dy * self.spd,
        self.filter
    )

    for i = 1, len do
        local otherObj = cols[i].other
        if otherObj.id == 'ball' and otherObj.status == 0 then
            otherObj.velVec = (otherObj.pos - self.pos):normalized() * kickStr
        end
    end

    for i = #self.grabbedBalls, 1, -1 do
        local ball = self.grabbedBalls[i]
        if (self:getCenter() - ball:getCenter()):len() < telekinesisRadius then
            ball.velVec = vec(dx * self.spd, dy * self.spd)
        else
            self:dropBall(ball, i)
        end
    end

    self.pos.x, self.pos.y = actualX, actualY
    self.curAnim:update(dt)
end

function Player:launchAll()
    for i = #self.grabbedBalls, 1, -1 do
        local ball = self.grabbedBalls[i]
        ball.velVec = (ball:getCenter() - self:getCenter()):normalized() * launchStr
        ball:release()
        table.remove(self.grabbedBalls, i)
    end

    TEsound.play(exp8)
    screen:setShake(20)
    self.ringRadius = telekinesisRadius
end

function Player:grabBalls(balls)
    local ballGrabbed = false
    for _, ball in ipairs(balls) do
        if ball.status == 0 and (ball:getCenter() - self:getCenter()):len() < telekinesisRadius then
            ball:hold(self.color)
            table.insert(self.grabbedBalls, ball)
            ballGrabbed = true
        end
    end

    TEsound.play(pow3, 'pow3')
    TEsound.volume('pow3', 0.5)

    if ballGrabbed then
        self.ringRadius = smlTelekinesisRadius
    else
        Timer.tween(0.3, self, {ringRadius = 10}, 'out-quad', function()
            self.ringRadius = telekinesisRadius
        end)
    end
end

function Player:action(balls)
    if #self.grabbedBalls > 0 then
        self:launchAll()
    else
        self:grabBalls(balls)
    end
end

function Player:clearGrab()
    self.grabbedBalls = {}
    self.ringRadius = telekinesisRadius
end

function Player:draw()
    self.radius = telekinesisRadius
    self.opacity = 0.5
    if #self.grabbedBalls > 0 then
        self.radius = smlTelekinesisRadius
        self.opacity = 0.8
    end

    lg.setColor(self.color[1], self.color[2], self.color[3], self.opacity)
    lg.circle('fill', self.pos.x + self.w / 2, self.pos.y + self.h / 2, self.radius + lm.random(-2, 2))

    lg.setColor(self.color[1] - 0.3, self.color[2] - 0.3, self.color[3] - 0.3, 1)
    lg.circle('line', self.pos.x + self.w / 2, self.pos.y + self.h / 2, self.ringRadius + lm.random(-2, 2))

    lg.setColor(self.color)
    self.curAnim:draw(self.sheet, self.pos.x + self.w / 2, self.pos.y, 0, self.facing, 1, self.w / 2)
    lg.setColor(colors.white)
end

function Player:teleport(x, y)
    world:update(self, x, y)
    self.pos.x, self.pos.y = x, y
end

return Player
