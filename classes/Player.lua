local Player = Class{ __includes = Entity }

function Player:init(cx, cy, sheet, anims, color, walkSnd)
    -- visual
    self.id = 'player'
    self.sheet = sheet
    self.anims = anims
    self.curAnim = anims[1]
    self.color = color
    self.walkSnd = walkSnd
    self.walkSndPlaying = false
    self.facing = 1
    self.inGoal = false
    self.radius = telekinesisRadius
    self.ringRadius = telekinesisRadius
    self.opacity = 0.5
    
    -- technical
    self.spd = 4
    self.grabbedBalls = {}
    
    Entity.init(self, cx - 16, cy - 16, 32, 32)
    
    -- collision
    world:add(self, self:getRect()) 
    self.filter = function(item, other)
        if (other.id == 'player') then
            return 'cross'
        end
        
        return 'slide'
    end
end

function Player:update(dt, dx, dy)
    -- non-zero movement
    if dx ~= 0 or dy ~= 0 then
        local rss = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
        dx, dy = dx / rss, dy  / rss
        
        self.curAnim = self.anims[2]
        if not self.walkSndPlaying then 
            self.walkSnd:play() 
            self.walkSndPlaying = true
        end
    else
        self.curAnim = self.anims[1]
        if self.walkSndPlaying then 
            self.walkSnd:pause()
            self.walkSndPlaying = false
        end
    end
    
    if dx < 0 then
        self.facing = -1
    elseif dx > 0 then
        self.facing = 1
    end

    local actualX, actualY, cols, len = world:move(self, self.pos.x + dx * self.spd, 
                                            self.pos.y + dy * self.spd, self.filter)

    -- collisions
    for i=1,len do
        local otherObj = cols[i].other

        -- kick active ball
        if otherObj.id == 'ball' and otherObj.status == 0 then
            otherObj.velVec = (otherObj.pos - self.pos):normalized() * kickStr
        end
    end
    
    -- if isGrabbing, attempt to move all grabbed balls with you
    for i,ball in ipairs(self.grabbedBalls) do
        if (self:getCenter() - ball:getCenter()):len() < telekinesisRadius then
            ball.velVec = vec(dx * self.spd, dy * self.spd)
        else
            ball.velVec = (self:getCenter() - ball:getCenter()):normalized() * 12
        end
    end
    
    self.pos.x, self.pos.y = actualX, actualY
    
    -- animation
    self.curAnim:update(dt)
end

function Player:launchAll()
    for i = #self.grabbedBalls, 1, -1 do
        local ball = self.grabbedBalls[i]
        ball.velVec = (ball:getCenter() - self:getCenter()):normalized() * launchStr
        ball.status = 0
        ball.auraColor = colors.white
        ball.opacity = 0.6
        table.remove(self.grabbedBalls, i)
    end
    
    exp8:play()
    screen:setShake(20)
    self.ringRadius = telekinesisRadius
end

function Player:grabBalls(balls)
    local ballGrabbed = false
    for i,ball in ipairs(balls) do
        if ball.status == 0 and (ball:getCenter() - self:getCenter()):len() < telekinesisRadius then
            ball.velVec.x, ball.velVec.y = 0, 0
            ball.status = 1
            ball.auraColor = self.color
            ball.opacity = 0.8
            table.insert(self.grabbedBalls, ball)
            ballGrabbed = true
        end
    end
    
    pow3:play()
    
    if ballGrabbed then 
        self.ringRadius = smlTelekinesisRadius
    else
        Timer.tween(0.3, self, {ringRadius = 10}, 'out-quad', 
                    function() self.ringRadius = telekinesisRadius end)
    end
end

function Player:action(balls)
    if #self.grabbedBalls > 0 then
        self:launchAll()
    else
        self:grabBalls(balls)
    end
end

function Player:draw()
    self.radius = telekinesisRadius
    self.opacity = 0.5
    if #self.grabbedBalls > 0 then 
        self.radius = smlTelekinesisRadius
        self.opacity = 0.8
    end

    -- telekinesis field
    lg.setColor(self.color[1], self.color[2], self.color[3], self.opacity)
    lg.circle('fill', self.pos.x + self.w / 2, self.pos.y + self.h / 2, self.radius + lm.random(-2, 2))
    
    -- telekinesis ringRadius
    lg.setColor(self.color[1] - 0.3, self.color[2] - 0.3, self.color[3] - 0.3, 1)
    lg.circle('line', self.pos.x + self.w / 2, self.pos.y + self.h / 2, self.ringRadius + lm.random(-2, 2))
    
    -- character sprite
    lg.setColor(self.color)
    self.curAnim:draw(self.sheet, self.pos.x + self.w / 2, self.pos.y, 0, self.facing, 1, self.w / 2)
    
    lg.setColor(colors.white)
end

function Player:teleport(x, y)
    world:update(self, x, y)
    self.pos.x, self.pos.y = x, y
end

return Player