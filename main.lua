-- love shorthands
lg = love.graphics
lw = love.window
lk = love.keyboard
la = love.audio
le = love.event
lm = love.math
lj = love.joystick

-- general libraries
vec = require 'libs/vector'
colors = require 'libs/colors'

-- collision
bump = require 'libs/bump'
world = bump.newWorld()
moonshine = require '/libs/moonshine'
effect = moonshine(moonshine.effects.crt).chain(moonshine.effects.scanlines)
effect.scanlines.opacity = 0.2

-- resolution
push = require 'libs/push'
gameW, gameH = 800, 450
local windowW, windowH = lw.getDesktopDimensions()
push:setupScreen(gameW, gameH, windowW * 0.7, windowH * 0.7)
lg.setDefaultFilter('nearest', 'nearest')

-- assets
assets = require('libs/cargo').init('assets')

anim8 = require 'libs/anim8'
screen = require 'libs/shack'
screen:setDimensions(push:getDimensions())
fontBig = assets.fonts.Graph35pix(64)
fontMed = assets.fonts.Graph35pix(32)
fontSmall = assets.fonts.Graph35pix(16)
csheet = assets.sprites.controllersheet
cg = anim8.newGrid(192, 108, csheet:getWidth(), csheet:getHeight())
canim = anim8.newAnimation(cg('1-2', 1), 0.2)

--audio
require 'libs/slam'
bgm = la.newSource('assets/audio/SwingJeDing.ogg', 'stream')
bgm:setLooping(true)
bgm:setVolume(0.3)
bgm:play()

exp3 = la.newSource('assets/audio/exp3.ogg', 'static')
exp8 = la.newSource('assets/audio/exp8.ogg', 'static')
pow3 = la.newSource('assets/audio/pow3.ogg', 'static')
hit1 = la.newSource('assets/audio/hit1.wav', 'static')

step3 = la.newSource('assets/audio/stairs3.ogg', 'static')
step3:setVolume(0.5)
step3:setLooping(true)

step4 = la.newSource('assets/audio/stairs4.ogg', 'static')
step4:setVolume(0.5)
step4:setLooping(true)

-- joystick input library
baton = require 'libs/baton'
p1input = baton.new{
    controls = {
        left = {'key:a', 'axis:leftx-', 'button:dpleft'},
        right = {'key:d', 'axis:leftx+', 'button:dpright'},
        up = {'key:w', 'axis:lefty-', 'button:dpup'},
        down = {'key:s', 'axis:lefty+', 'button:dpdown'},
        action = {'key:space', 'button:a'},
        reset = {'key:r', 'button:start'},
    },
    pairs = {
        move = {'left', 'right', 'up', 'down'},
    },
    joystick = lj.getJoysticks()[1]
}

p2input = baton.new{
    controls = {
        left = {'key:left', 'axis:leftx-', 'button:dpleft'},
        right = {'key:right', 'axis:leftx+', 'button:dpright'},
        up = {'key:up', 'axis:lefty-', 'button:dpup'},
        down = {'key:down', 'axis:lefty+', 'button:dpdown'},
        action = {'key:return', 'button:a'},
        reset = {'key:r', 'button:start'},
    },
    pairs = {
        move = {'left', 'right', 'up', 'down'},
    },
    joystick = lj.getJoysticks()[2]
}



-- classes
Class = require 'libs/class'
Entity = require 'classes/Entity'
Player = require 'classes/Player'
Ball = require 'classes/Ball'
Wall = require 'classes/Wall'
Goal = require 'classes/Goal'

-- states
gamestate = require 'libs/gamestate'
startScreen = require 'states.startScreen'
gameScreen = require 'states.gameScreen'

-- game vars
telekinesisRadius = 80
kickStr = 2
launchStr = 45
ejectStr = 30
debug = false

function love.load()
    lw.setTitle('Telekinessball')
    
    lg.setFont(fontBig)
    
    gamestate.registerEvents()
    gamestate.switch(startScreen)
end

function love.keypressed(k)
    if k == 'f' then
        push:switchFullscreen()
    elseif k == 'q' or k == 'escape' then
        le.quit()
    elseif k == 'm' then
    
    end
end