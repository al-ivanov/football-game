Config = require 'config'

-- love shorthands used across the project
lg = love.graphics
lw = love.window
le = love.event
lm = love.math
lj = love.joystick
lt = love.timer

-- libraries
vec = require 'libs/vector'
colors = require 'libs/colors'
Timer = require 'libs/timer'
Class = require 'libs/class'
bump = require 'libs/bump'
anim8 = require 'libs/anim8'
push = require 'libs/push'
moonshine = require '/libs/moonshine'

world = bump.newWorld()

effect = moonshine(moonshine.effects.scanlines).chain(moonshine.effects.crt)
effect.scanlines.opacity = 0.2

gameW, gameH = Config.gameW, Config.gameH
local windowW, windowH = lw.getDesktopDimensions()
push:setupScreen(gameW, gameH, windowW * Config.windowScale, windowH * Config.windowScale)
lg.setDefaultFilter('nearest', 'nearest')

assets = require('libs/cargo').init('assets')

screen = require 'libs/shack'
screen:setDimensions(push:getDimensions())

fontBig = assets.fonts.Graph35pix(64)
fontTitle = lg.newFont('assets/fonts/FFFFORWA.ttf', 64)

csheet = assets.sprites.controllersheet
local controllerGrid = anim8.newGrid(192, 108, csheet:getWidth(), csheet:getHeight())
canim = anim8.newAnimation(controllerGrid('1-2', 1), 0.2)
rcanim = anim8.newAnimation(controllerGrid(1, 1, 3, 1), 0.2)

Audio = require 'audio'
Audio.init(Config.maxVolume)
-- Keep legacy sound globals for existing call sites during the refactor.
exp3, exp8, pow3, hit1 = Audio.exp3, Audio.exp8, Audio.pow3, Audio.hit1
volumeState = Audio.volumeState

local Input = require 'input'
p1input, p2input = Input.create(lj.getJoysticks())

-- gameplay constants still referenced as globals by entities
telekinesisRadius = Config.telekinesisRadius
smlTelekinesisRadius = Config.smlTelekinesisRadius
kickStr = Config.kickStr
launchStr = Config.launchStr

Entity = require 'classes/Entity'
Player = require 'classes/Player'
Ball = require 'classes/Ball'
Wall = require 'classes/Wall'
Goal = require 'classes/Goal'
Goalbox = require 'classes/Goalbox'

gamestate = require 'libs/gamestate'
startScreen = require 'states.startScreen'
gameScreen = require 'states.gameScreen'

function love.load()
    lw.setTitle(Config.title)
    lg.setFont(fontBig)
    lg.setLineWidth(3)

    gamestate.registerEvents()
    gamestate.switch(startScreen)
end

function love.keypressed(k)
    if k == 'f' then
        push:switchFullscreen()
    elseif k == 'q' or k == 'escape' then
        le.quit()
    elseif k == 'm' then
        Audio.toggleMute()
        volumeState = Audio.volumeState
    end
end
