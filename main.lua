-- love shorthands
lg = love.graphics
lw = love.window
lk = love.keyboard
la = love.audio
le = love.event
lm = love.math
lj = love.joystick
lt = love.timer
ls = love.sound

-- general libraries
vec = require 'libs/vector'
colors = require 'libs/colors'
Timer = require "libs/timer"

-- collision
bump = require 'libs/bump'
world = bump.newWorld()
moonshine = require '/libs/moonshine'
effect = moonshine(moonshine.effects.scanlines).chain(moonshine.effects.crt)
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
fontSmall = assets.fonts.Graph35pix(24)
fontTitle = assets.fonts.FFFFORWA(64)
csheet = assets.sprites.controllersheet
cg = anim8.newGrid(192, 108, csheet:getWidth(), csheet:getHeight())
canim = anim8.newAnimation(cg('1-2', 1), 0.2)
canim2 = anim8.newAnimation(cg('1-2', 1), 0.2)
rcanim = anim8.newAnimation(cg(1,1, 3,1), 0.2)

local maxVolome = 0.3
--audio
require 'libs/tesound'

-- music: https://roccow.bandcamp.com/track/swingjeding
bgmSnd = ls.newSoundData('assets/audio/roccow.ogg')
TEsound.playLooping(bgmSnd, 'bgm')
TEsound.volume('bgm', maxVolome)

--sfx
exp3 = ls.newSoundData('assets/audio/exp3.ogg')
exp8 = ls.newSoundData('assets/audio/exp8.ogg')
pow3 = ls.newSoundData('assets/audio/pow3.ogg')
hit1 = ls.newSoundData('assets/audio/hit1.ogg')

step1 = ls.newSoundData('assets/audio/stairs3.ogg')
step2 = ls.newSoundData('assets/audio/stairs4.ogg')

TEsound.playLooping(step1, 'step1')
TEsound.playLooping(step2, 'step2')

TEsound.volume('step1', 0)
TEsound.volume('step2', 0)

-- joystick input library
baton = require 'libs/baton'
p1input = baton.new{
    controls = {
        left = {'key:a', 'axis:leftx-', 'button:dpleft'},
        right = {'key:d', 'axis:leftx+', 'button:dpright'},
        up = {'key:w', 'axis:lefty-', 'button:dpup'},
        down = {'key:s', 'axis:lefty+', 'button:dpdown'},
        action = {'key:space', 'button:a'},
        reset = {'key:r', 'button:b'}
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
        reset = {'key:r', 'button:b'}
    },
    pairs = {
        move = {'left', 'right', 'up', 'down'},
    },
    joystick = lj.getJoysticks()[2]
}

-- game vars
telekinesisRadius = 80
smlTelekinesisRadius = 50
kickStr = 2
launchStr = 45
ejectStr = 30
volumeState = 1
debug = false

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


function love.load()
    lw.setTitle('Telekinessball')

    -- push:switchFullscreen()
    
    lg.setFont(fontBig)

    love.graphics.setLineWidth( 3 )
    
    gamestate.registerEvents()
    gamestate.switch(startScreen)
end

function love.keypressed(k)
    if k == 'f' then
        push:switchFullscreen()
    elseif k == 'q' or k == 'escape' then
        le.quit()
    elseif k == 'm' then
        if volumeState == maxVolome then
            volumeState = 0
        else
            volumeState = maxVolome
        end
        TEsound.volume('bgm', volumeState)
    end
end